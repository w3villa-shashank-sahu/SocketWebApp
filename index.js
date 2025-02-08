const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const axios = require("axios");

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
    cors: {
        origin: "*",
    },
});

const GROQ_API_KEY = "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";
const GROQ_ENDPOINT = "https://api.groq.com/openai/v1/chat/completions";

const users = {}; // Stores connected users for direct messaging

io.on("connection", (socket) => {
    console.log("User connected:", socket.id);
    users[socket.id] = socket.id; // Store user's socket ID

    // USER CHAT (Direct Chat Between Users)
    socket.on("user_send_message", (data) => {
        const { message, to } = data;

        if (to && users[to]) {
            // Send message only to the target user (excluding the sender)
            io.to(users[to]).emit("receive_message", { message, sender: socket.id });
        } else {
            // Broadcast to all users except the sender
            socket.broadcast.emit("receive_message", { message, sender: socket.id });
        }
    });

    // AI CHAT (Communicate with Groq)
    socket.on("bot_send_message", async (data) => {
        const userMessage = data.message;
        console.log("User to AI:", userMessage);

        try {
            const response = await axios.post(
                GROQ_ENDPOINT,
                {
                    model: "llama-3.3-70b-versatile",
                    messages: [{ role: "user", content: userMessage }],
                },
                {
                    headers: {
                        "Content-Type": "application/json",
                        Authorization: `Bearer ${GROQ_API_KEY}`,
                    },
                }
            );

            const botResponse = response.data.choices[0].message.content;
            console.log("AI Response:", botResponse);

            // Send AI response back to user
            socket.emit("bot-receive_message", { message: botResponse, sender: "AI" });
        } catch (error) {
            console.error("Error communicating with Groq:", error.message);
            socket.emit("bot-receive_message", { message: "AI error: Unable to respond.", sender: "AI" });
        }
    });

    // Handle user disconnection
    socket.on("disconnect", () => {
        console.log("User disconnected:", socket.id);
        delete users[socket.id];
    });
});

server.listen(3000, () => {
    console.log("Server is running on port 3000");
});

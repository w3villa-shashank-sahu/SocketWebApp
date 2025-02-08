# Socket Application (Flutter Frontend & NodeJS Backend)

This repository contains a simple socket application built with Flutter for the frontend and NodeJS for the backend.  It demonstrates basic real-time communication between a mobile app and a server.

## Overview

This application showcases how to establish a socket connection between a Flutter app and a NodeJS server.  The `main.dart` file handles the client-side (Flutter) logic, while `index.js` manages the server-side (NodeJS) operations.


### `main.dart` (Flutter Frontend)

This file contains the Flutter code responsible for:

* Establishing a socket connection to the NodeJS server.
* Sending messages to the server.
* Receiving messages from the server.
* Updating the UI based on received messages.

### `index.js` (NodeJS Backend)

This file contains the NodeJS code that:

* Creates a WebSocket server.
* Handles client connections.
* Broadcasts messages received from clients to all connected clients.

## Setup and Installation

### Prerequisites

Before running this application, ensure you have the following installed:

* **Flutter SDK:**  Follow the instructions on the official Flutter website ([https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)) to install and configure Flutter on your development machine.
* **NodeJS and npm (or yarn):**  Download and install NodeJS from [https://nodejs.org/](https://nodejs.org/). npm (Node Package Manager) usually comes bundled with NodeJS. Alternatively, you can use yarn ([https://yarnpkg.com/](https://yarnpkg.com/)).
* **A code editor:**  VS Code, Android Studio, IntelliJ IDEA, or any other editor you prefer.

### Installation Steps

1. **Clone the repository:**

   ```bash
   git clone [https://github.com/YOUR_USERNAME/YOUR_REPOSITORY_NAME.git]
   cd socket-app
   
2. **Backend Setup (NodeJS):**

   ```Bash
   create an empty project
   cd..  // Navigate back to the root of your project
   npm init
   npm install cors express socket.io axios
   node index.js // Start the server
   ```


3. **Frontend Setup (Flutter):**

   ```Bash
   craete a new project
   cd .. // Navigate back to the root of your project
   replace your default main.dart with the main.dart you just downloaded
   flutter pub add socket_io_client
   flutter pub get  // Install Flutter dependencies
   flutter run -d chrome  // Run the Flutter app on chrome
   ```

### Usage
Start the NodeJS server in one terminal.
Run the Flutter app.
The app should connect to the server. You should be able to send and receive messages between the app and any other connected clients.

### Video Demonstration

**A working preview video is also present along with code**


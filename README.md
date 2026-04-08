# Sleek React To-Do Application

A modern, highly interactive frontend-only To-Do application featuring a sleek dark-mode aesthetic with glassmorphism elements. The application tracks tasks in your browser's local storage so data persists across reloads.

## 🚀 Tech Stack

This project was built with a modern frontend stack to ensure high performance and an excellent developer experience:

- **React** (v18) - Core UI library used to build interactive components and handle application state effectively.
- **Vite** (v6) - Lightning fast build tool and development server used to scaffold and bundle the project.
- **Vanilla CSS** - Completely custom styling featuring CSS variables, flexbox, micro-animations, and SVG icons. No UI frameworks were used, giving us full control over the premium look and feel.
- **Local Storage API** - Native browser API leveraged to persist tasks entirely on the client side without needing a backend server.

## 🛠️ Getting Started

### Local Development

1. Install dependencies:
   ```bash
   npm install
   ```
2. Start the development server:
   ```bash
   npm run dev
   ```
3. Open `http://localhost:5173` in your browser.

### Docker Deployment

This application includes a multi-stage Dockerfile that builds the static Vite application and serves it via a lightweight Nginx web server.

1. Build the Docker image:
   ```bash
   docker build -t react-todo-app .
   ```
2. Run the Docker container:
   ```bash
   docker run -d -p 8080:80 react-todo-app
   ```
3. Open `http://localhost:8080` in your browser.

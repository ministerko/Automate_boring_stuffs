#!/bin/bash

# Function to read user input for the project name
get_project_name() {
  read -p "Enter project name (default: my-react-app): " PROJECT_NAME
  PROJECT_NAME=${PROJECT_NAME:-my-react-app}  # Default value
}

# Get the project name
get_project_name

# Create a new Vite project with TypeScript template
echo "Creating a new Vite project with TypeScript..."
npm create vite@latest "$PROJECT_NAME" -- --template react-ts

# Navigate into the project directory
cd "$PROJECT_NAME" || exit

# Install dependencies
echo "Installing dependencies..."
npm install

# Install Tailwind CSS and its peer dependencies
echo "Installing Tailwind CSS..."
npm install -D tailwindcss postcss autoprefixer

# Initialize Tailwind CSS
npx tailwindcss init -p

# Configure Tailwind to remove unused styles in production
echo "Configuring Tailwind CSS..."
cat <<EOT >> tailwind.config.js
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOT

# Add Tailwind directives to the main CSS file
echo "Adding Tailwind directives..."
cat <<EOT >> src/index.css
@tailwind base;
@tailwind components;
@tailwind utilities;
EOT

# Inform user of completion
echo "React project with Vite, Tailwind CSS, and TypeScript initialized successfully!"
echo "Navigate to the project directory and run 'npm run dev' to start the development server."

# End of script

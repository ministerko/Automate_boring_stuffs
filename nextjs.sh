#!/bin/bash

# Function to read user input for the project name
get_project_name() {
  read -p "Enter project name (default: my-nextjs-app): " PROJECT_NAME
  PROJECT_NAME=${PROJECT_NAME:-my-nextjs-app}  # Default value
}

# Function to check if npm is installed
check_npm() {
  if ! command -v npm &> /dev/null; then
    echo "npm is not installed. Please install Node.js and npm first."
    exit 1
  fi
}

# Function to check if directory already exists
check_directory() {
  if [ -d "$PROJECT_NAME" ]; then
    echo "Directory $PROJECT_NAME already exists. Please choose a different name."
    exit 1
  fi
}

# Main setup process
echo "🚀 Next.js Project Setup Script"
echo "------------------------------"

# Check prerequisites
check_npm

# Get the project name
get_project_name

# Check if directory exists
check_directory

# Create Next.js project with TypeScript
echo "📦 Creating new Next.js project with TypeScript..."
npx create-next-app@latest "$PROJECT_NAME" \
  --typescript \
  --tailwind \
  --eslint \
  --app \
  --src-dir \
  --import-alias "@/*"

# Navigate into project directory
cd "$PROJECT_NAME" || exit

# Install additional recommended dependencies
echo "📚 Installing additional dependencies..."
npm install class-variance-authority clsx tailwind-merge lucide-react

# Create a components directory
echo "🏗️ Setting up project structure..."
mkdir -p src/components/ui

# Create a basic button component
echo "🎨 Creating basic UI components..."
cat <<EOT > src/components/ui/button.tsx
import { cn } from "@/lib/utils"
import { ButtonHTMLAttributes, forwardRef } from "react"

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'default' | 'outline' | 'ghost'
}

const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant = 'default', ...props }, ref) => {
    return (
      <button
        className={cn(
          'inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors',
          'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2',
          'disabled:opacity-50 disabled:pointer-events-none',
          {
            'bg-slate-900 text-white hover:bg-slate-800': variant === 'default',
            'border border-slate-200 hover:bg-slate-100': variant === 'outline',
            'hover:bg-slate-100': variant === 'ghost',
          },
          className
        )}
        ref={ref}
        {...props}
      />
    )
  }
)
Button.displayName = 'Button'

export { Button }
EOT

# Create utils file for className merging
echo "🛠️ Creating utility functions..."
mkdir -p src/lib
cat <<EOT > src/lib/utils.ts
import { type ClassValue, clsx } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
EOT

# Update tailwind.config.js with extended configuration
echo "⚙️ Updating Tailwind configuration..."
cat <<EOT > tailwind.config.ts
import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
    },
  },
  plugins: [],
}
export default config
EOT

# Create a sample page to demonstrate the components
echo "📝 Creating sample page..."
cat <<EOT > src/app/page.tsx
import { Button } from '@/components/ui/button'

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24 gap-4">
      <h1 className="text-4xl font-bold">Welcome to your Next.js App</h1>
      <div className="flex gap-4">
        <Button>Default Button</Button>
        <Button variant="outline">Outline Button</Button>
        <Button variant="ghost">Ghost Button</Button>
      </div>
    </main>
  )
}
EOT

# Final setup steps
echo "🧹 Running final setup steps..."
npm run lint

# Display success message
echo "✨ Next.js project setup complete! ✨"
echo "To get started:"
echo "1. cd $PROJECT_NAME"
echo "2. npm run dev"
echo "3. Open http://localhost:3000 in your browser"
echo ""
echo "Happy coding! 🎉"

# End of script
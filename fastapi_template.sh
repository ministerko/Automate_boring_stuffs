#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if required commands are installed
for cmd in python3 pip git; do
    if ! command_exists $cmd; then
        echo "Error: $cmd is not installed. Please install it and try again."
        exit 1
    fi
done

# Get project name from user input
read -p "Enter your project name: " project_name

# Create project directory
mkdir "$project_name"
cd "$project_name"

# Initialize git repository
git init

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install FastAPI and dependencies
pip install fastapi[all] uvicorn[standard] sqlalchemy alembic pytest

# Create project structure
mkdir app tests
touch app/__init__.py app/main.py app/models.py app/schemas.py app/database.py
touch tests/__init__.py tests/test_main.py
touch .gitignore README.md requirements.txt

# Create main.py content
cat > app/main.py << EOL
from fastapi import FastAPI

app = FastAPI(title="$project_name", description="A spicy FastAPI project")

@app.get("/")
async def root():
    return {"message": "Welcome to $project_name!"}
EOL

# Create requirements.txt
pip freeze > requirements.txt

# Create .gitignore
cat > .gitignore << EOL
venv/
__pycache__/
*.pyc
.pytest_cache/
.coverage
EOL

# Create README.md
cat > README.md << EOL
# $project_name

A spicy FastAPI project template.

## Setup

1. Clone the repository
2. Create a virtual environment: \`python3 -m venv venv\`
3. Activate the virtual environment: \`source venv/bin/activate\`
4. Install dependencies: \`pip install -r requirements.txt\`
5. Run the server: \`uvicorn app.main:app --reload\`

## Testing

Run tests with pytest: \`pytest\`
EOL

# Add some spice: Custom middleware
cat >> app/main.py << EOL

from fastapi import Request
import time

@app.middleware("http")
async def add_process_time_header(request: Request, call_next):
    start_time = time.time()
    response = await call_next(request)
    process_time = time.time() - start_time
    response.headers["X-Process-Time"] = str(process_time)
    return response
EOL

echo "FastAPI project '$project_name' has been created with extra spice! 🌶️"
echo "To get started, run the following commands:"
echo "cd $project_name"
echo "source venv/bin/activate"
echo "uvicorn app.main:app --reload"
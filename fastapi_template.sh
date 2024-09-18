#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if required commands (python3, pip, git) are installed
for cmd in python3 pip git; do
    if ! command_exists "$cmd"; then
        echo "Error: Required command '$cmd' is not installed. Please install it to proceed."
        exit 1
    fi
done

# Get the project name from user input
read -p "Enter the name of your project: " project_name

# Create project directory and navigate into it
mkdir -p "$project_name" && cd "$project_name"

# Initialize Git repository
git init

# Create virtual environment and activate it
python3 -m venv venv
source venv/bin/activate

# Install FastAPI and essential dependencies
pip install fastapi[all] uvicorn[standard] sqlalchemy alembic pytest

# Create core project structure with support for multiple route files
mkdir -p app/routers app/models app/schemas app/database tests
touch app/{__init__.py,main.py,dependencies.py}
touch app/routers/{__init__.py,items.py,users.py}
touch app/models/{__init__.py,items.py,users.py}
touch app/schemas/{__init__.py,items.py,users.py}
touch app/database.py
touch tests/{__init__.py,test_main.py}
touch .gitignore README.md requirements.txt

# Populate main.py with a modular FastAPI setup, importing routes
cat > app/main.py << EOL
from fastapi import FastAPI
from app.routers import items, users

app = FastAPI(
    title="$project_name", 
    description="A scalable FastAPI project with modular routes."
)

# Include route modules from routers directory
app.include_router(items.router, prefix="/items", tags=["Items"])
app.include_router(users.router, prefix="/users", tags=["Users"])

@app.get("/")
async def read_root():
    return {"message": "Welcome to the $project_name API!"}
EOL

# Create modular route for 'items' in app/routers/items.py
cat > app/routers/items.py << EOL
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def read_items():
    return [{"item_id": 1, "name": "Item One"}, {"item_id": 2, "name": "Item Two"}]
EOL

# Create modular route for 'users' in app/routers/users.py
cat > app/routers/users.py << EOL
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def read_users():
    return [{"user_id": 1, "username": "user_one"}, {"user_id": 2, "username": "user_two"}]
EOL

# Populate requirements.txt with installed packages
pip freeze > requirements.txt

# Create .gitignore to exclude unnecessary files from version control
cat > .gitignore << EOL
venv/
__pycache__/
*.pyc
.pytest_cache/
.coverage
EOL

# Create a detailed README.md
cat > README.md << EOL
# $project_name

A scalable FastAPI project with support for multiple route files and modular architecture.

## Setup Instructions

1. Clone the repository to your local machine.
2. Create a virtual environment and activate it:
    \`python3 -m venv venv\`
    \`source venv/bin/activate\`
3. Install dependencies:
    \`pip install -r requirements.txt\`
4. Start the development server:
    \`uvicorn app.main:app --reload\`

## Project Structure

\`\`\`
$project_name/
├── app/
│   ├── routers/
│   │   ├── items.py
│   │   ├── users.py
│   ├── models/
│   ├── schemas/
│   ├── database.py
│   ├── dependencies.py
│   ├── main.py
├── tests/
├── .gitignore
├── README.md
├── requirements.txt
└── venv/
\`\`\`

## Testing

Run tests using:
\`pytest\`
EOL

# Final message indicating project creation
echo "Scalable FastAPI project '$project_name' has been successfully created with modular routes!"
echo "To begin, execute the following commands:"
echo "cd $project_name"
echo "source venv/bin/activate"
echo "uvicorn app.main:app --reload"


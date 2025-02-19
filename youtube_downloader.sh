#!/bin/bash

# Function to check if yt-dlp is installed
check_yt_dlp() {
    if ! command -v yt-dlp &> /dev/null; then
        echo "yt-dlp is not installed. Installing..."
        # Install yt-dlp (for Debian/Ubuntu, use apt; adjust for your package manager)
        if command -v apt &> /dev/null; then
            sudo apt update
            sudo apt install -y yt-dlp
        elif command -v brew &> /dev/null; then
            brew install yt-dlp
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y yt-dlp
        elif command -v pacman &> /dev/null; then
            sudo pacman -S yt-dlp
        else
            echo "Unsupported package manager. Please install yt-dlp manually."
            exit 1
        fi
    fi
}

# Function to display the quality options
show_quality_options() {
    echo "Select video quality:"
    echo "1. 144p"
    echo "2. 240p"
    echo "3. 360p"
    echo "4. 480p"
    echo "5. 720p"
    echo "6. 1080p"
    echo "7. Best Available"
}

# Check for yt-dlp installation
check_yt_dlp

# Prompt for YouTube link
read -p "Enter the YouTube video link: " youtube_link

# Show quality options and prompt for selection
show_quality_options
read -p "Enter the number corresponding to your quality preference: " quality_choice

# Determine the format string based on quality selection
case $quality_choice in
    1) format="bestvideo[height<=144]+bestaudio" ;;
    2) format="bestvideo[height<=240]+bestaudio" ;;
    3) format="bestvideo[height<=360]+bestaudio" ;;
    4) format="bestvideo[height<=480]+bestaudio" ;;
    5) format="bestvideo[height<=720]+bestaudio" ;;
    6) format="bestvideo[height<=1080]+bestaudio" ;;
    7) format="bestvideo+bestaudio" ;;
    *) echo "Invalid choice. Exiting." ; exit 1 ;;
esac

# Execute the yt-dlp command
echo "Downloading video..."
yt-dlp -f "$format" "$youtube_link"

echo "Download complete!"

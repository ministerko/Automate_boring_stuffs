#!/bin/bash

# Ensure yt-dlp is installed
if ! command -v yt-dlp &> /dev/null
then
    echo "yt-dlp is not installed. Please install it first."
    exit
fi

# Prompt user for YouTube URL if none provided
read -p "Enter the YouTube URL: " video_url

# Check if input is empty
if [ -z "$video_url" ]; then
    echo "No URL entered. Exiting..."
    exit 1
fi

# Download only audio in mp3 format
yt-dlp -f bestaudio --extract-audio --audio-format mp3 "$video_url"


#!/bin/bash

echo "Script execution started."

# Global parameters
TRANSPORT_PROTOCOL=${TRANSPORT:-tcp}
VIDEO_CODEC=${VIDEO_CODEC:-libx264}
FRAME_RATE=${FRAME_RATE:-30}
UNIFIED_USER=${USER:-username}
UNIFIED_PASS=${PASS:-password}

# Function to generate scaling filter options only if width and height are defined
get_scale_filter() {
    if [[ "$WIDTH" =~ ^[0-9]+$ && "$HEIGHT" =~ ^[0-9]+$ ]]; then
        echo "-vf scale=$WIDTH:$HEIGHT"
    else
        echo ""  # Return an empty string if width or height isn't a valid number
    fi
}

# Function to start a stream based on the requested path
start_stream_for_path() {
    local requested_path=$1
    local rtsp_server_url="localhost"
    local scale_filter=$(get_scale_filter)

    case "$requested_path" in
        "webcam")
            # Universal webcam path using /dev/video0
            ffmpeg -f v4l2 -framerate "$FRAME_RATE" -i /dev/video0 $scale_filter -c:v "$VIDEO_CODEC" -f rtsp -rtsp_transport "$TRANSPORT_PROTOCOL" \
                "rtsp://${UNIFIED_USER}:${UNIFIED_PASS}@${rtsp_server_url}:8554/webcam" &
            ;;
        "sample_video")
            # Static path for the included sample video
            ffmpeg -stream_loop -1 -re -i /sample/test1.mp4 $scale_filter -c:v "$VIDEO_CODEC" -f rtsp -rtsp_transport "$TRANSPORT_PROTOCOL" \
                "rtsp://${UNIFIED_USER}:${UNIFIED_PASS}@${rtsp_server_url}:8554/sample_video" &
            ;;
        *)
            # Handle video files from the mounted /videos directory
            if [[ -f "/videos/$requested_path.mp4" ]]; then
                ffmpeg -stream_loop -1 -re -i "/videos/$requested_path.mp4" $scale_filter -c:v "$VIDEO_CODEC" -f rtsp -rtsp_transport "$TRANSPORT_PROTOCOL" \
                    "rtsp://${UNIFIED_USER}:${UNIFIED_PASS}@${rtsp_server_url}:8554/$requested_path" &
            else
                echo "No handler for the requested path: $requested_path"
            fi
            ;;
    esac
}

# Check if the requested path is passed
if [ -z "$1" ]; then
    echo "No path was requested."
    exit 1
fi

# Retrieve the requested path passed by MediaMTX
requested_path=$1
echo "Requested path: $requested_path"

# Start the requested stream
start_stream_for_path "$requested_path"

# Wait for all background processes to finish
wait

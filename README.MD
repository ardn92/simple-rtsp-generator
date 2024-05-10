### RTSP Streaming Server Application

This application sets up an RTSP streaming server that can handle multiple types of media streams including live webcams, static videos, and dynamically accessed video files from a mounted directory. The server uses MediaMTX for RTSP streaming and FFmpeg for media handling and streaming execution.

### Features

- **Webcam Streaming**: Stream from the first webcam device detected by the system.
- **Sample Video Streaming**: Continuously stream a pre-loaded sample video.
- **Dynamic Video File Streaming**: Stream videos dynamically from a mounted directory, accessible via RTSP based on their filenames.

### Building and Running the Docker Container

You need Docker installed on your system to run this server. Here's how to set up and run the container in various configurations:

#### Build the Docker Image

- First, build your Docker image from the Dockerfile provided in your project directory:
  ```bash
  docker build -t rtsp-server .
  ```

#### Running the Container

Depending on what you want to stream, you can start the Docker container in several ways:

- **For Webcam Streaming**:
  ```bash
  docker run -d -p 8554:8554 --device /dev/video0 rtsp-server
  ```

- **For Streaming Mounted Video Files**:
  ```bash
  docker run -d -p 8554:8554 -v /path/to/your/videos:/videos rtsp-server
  ```

- **For Both Webcam and Video Files**:
  ```bash
  docker run -d -p 8554:8554 --device /dev/video0 -v /path/to/your/videos:/videos rtsp-server
  ```
  
    
## Running the Container with Custom Configurations

The container can be run with various configurations to suit your specific streaming needs. Below is a detailed breakdown of the configurable Docker run command:

```bash
docker run -d \
  -e USER=username \
  -e PASS=password \
  -e RTSP_SERVER_URL="localhost:8554" \
  -v /path/to/your/videos:/videos \
  -e WIDTH=1280 \
  -e HEIGHT=720 \
  -e TRANSPORT=udp \
  -e VIDEO_CODEC=libx265 \
  -e FRAME_RATE=24 \
  --device /dev/video0 \
  -p 8554:8554 \
  rtsp-server
```  

### Docker Run Command Configuration Options

| Option | Description | Format/Choices |
| ------ | ----------- | -------------- |
| `USER` | RTSP username for authentication | `username` (default) or any string |
| `PASS` | RTSP password for authentication | `password` (default) or any string |
| `RTSP_SERVER_URL` | URL and port for the RTSP server | `localhost:8554` or any valid IP:port |
| `WIDTH` | Width of the video stream | Pixel value, e.g., `1280` |
| `HEIGHT` | Height of the video stream | Pixel value, e.g., `720` |
| `TRANSPORT` | Transport protocol for RTSP | `tcp` (default), `udp` |
| `VIDEO_CODEC` | Codec used for video encoding | `libx264` (default), `libx265` |
| `FRAME_RATE` | Frame rate of the video stream | Number, e.g., `24` (default) |

### Testing Streams with FFplay

FFplay, part of the FFmpeg suite, is a simple and efficient media player that can be used to test the streams from this server. Below are commands to connect to different types of streams:

- **For Webcam Stream**:
  ```bash
  ffplay rtsp://username:password@localhost:8554/webcam
  ```

- **For Sample Video Stream**:
  ```bash
  ffplay rtsp://username:password@localhost:8554/sample_video
  ```

- **For a Specific Video File Stream**:
  Replace `video_filename` with the actual base name of the video file located in the `/videos` directory:
  ```bash
  ffplay rtsp://username:password@localhost:8554/video_filename
  ```
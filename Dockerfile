# Base Image
FROM debian:11.7-slim

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg wget tar bash && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y ca-certificates
# Download and install MediaMTX
RUN wget https://github.com/bluenviron/mediamtx/releases/download/v1.8.1/mediamtx_v1.8.1_linux_amd64.tar.gz && \
    tar -xzvf mediamtx_v1.8.1_linux_amd64.tar.gz && \
    mv mediamtx /usr/local/bin

# Copy custom scripts and config
COPY mediamtx.yml /mediamtx.yml
COPY entrypoint.sh /scripts/entrypoint.sh
COPY start_server.sh /scripts/start_server.sh
COPY sample/test1.mp4 /sample/test1.mp4

# Make the entrypoint script executable
RUN chmod +x /scripts/start_server.sh
RUN chmod +x /scripts/entrypoint.sh

# Expose the necessary RTSP port
EXPOSE 8554

VOLUME [ "/videos" ]

# Set the default entrypoint
ENTRYPOINT ["/scripts/start_server.sh"]
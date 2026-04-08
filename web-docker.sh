#!/bin/bash

# Change to the desired directory
SCRIPT_DIR=$(dirname "$(realpath "$0")")
cd "$SCRIPT_DIR" || { echo "Failed to change directory"; exit 1; }

export WEB_DOCKER_UID=$(id -u)
export WEB_DOCKER_GID=$(id -g)

# Switch-like condition using a case statement
case "$1" in
    up)
        echo "Server up..."
        docker compose up -d
        ;;
    down)
        echo "Server down..."
        docker compose down
        ;;
    build)
        echo "Server rebuild..."
        docker compose build
        ;;
    stats)
        echo "Check server stats..."
        docker compose stats
        ;;
    logs)
        echo "Check server logs..."
        docker compose logs
        ;;
    bash)
        echo "Open server bash..."
        docker exec -it php-apache-container bash
        ;;
    edit)
        echo "Edit server settings..."
        code .
        ;;
    *)
        echo "Invalid option: $1"
        echo "Valid options are:"
        echo "  up    - start server"
        echo "  down  - stop server"
        echo "  build - rebuild php-apache-container"
        echo "  stats - check server stats"
        echo "  logs  - check server logs"
        echo "  bash  - open php-apache-container bash"
        echo "  edit  - open server directory in VS Code"
        exit 2
        ;;
esac

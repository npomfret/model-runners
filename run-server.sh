#!/bin/bash
# Run Qwen3-32B server with proper process management
# Usage: ./run-server.sh start|stop|status|logs

PORT=${1:-11443}
PIDFILE="/tmp/qwen3-server-${PORT}.pid"
LOGFILE="/tmp/qwen3-server-${PORT}.log"

start_server() {
    if [ -f "$PIDFILE" ]; then
        PID=$(cat "$PIDFILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            echo "✓ Server already running on port $PORT (PID: $PID)"
            return 0
        fi
    fi

    echo "Starting Qwen3-32B server on port $PORT..."
    nohup uv run python -m vllm_mlx.server \
        --model mlx-community/Qwen3-32B-4bit \
        --host 0.0.0.0 \
        --port $PORT > "$LOGFILE" 2>&1 &

    PID=$!
    echo $PID > "$PIDFILE"

    # Wait for startup
    echo -n "Waiting for server to start."
    for i in {1..30}; do
        if curl -s http://localhost:$PORT/v1/models > /dev/null 2>&1; then
            echo " ✓"
            echo "Server running on http://0.0.0.0:$PORT (PID: $PID)"
            return 0
        fi
        echo -n "."
        sleep 1
    done

    echo " ✗"
    echo "Server failed to start. Check logs:"
    tail -20 "$LOGFILE"
    return 1
}

stop_server() {
    if [ -f "$PIDFILE" ]; then
        PID=$(cat "$PIDFILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            echo "Stopping server (PID: $PID)..."
            kill "$PID"
            sleep 2
            if ps -p "$PID" > /dev/null 2>&1; then
                echo "Force killing..."
                kill -9 "$PID"
            fi
            rm "$PIDFILE"
            echo "✓ Server stopped"
        else
            echo "PID file exists but process not running, cleaning up..."
            rm "$PIDFILE"
        fi
    else
        echo "Server not running (no PID file)"
    fi
}

status_server() {
    if [ -f "$PIDFILE" ]; then
        PID=$(cat "$PIDFILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            echo "✓ Server running (PID: $PID) on port $PORT"
            if curl -s http://localhost:$PORT/v1/models > /dev/null 2>&1; then
                echo "✓ Server responding"
                curl -s http://localhost:$PORT/v1/models | jq '.data[0].id'
            else
                echo "✗ Server not responding"
            fi
        else
            echo "✗ PID file exists but process not running"
            rm "$PIDFILE"
        fi
    else
        echo "✗ Server not running"
    fi
}

logs_server() {
    if [ -f "$LOGFILE" ]; then
        tail -f "$LOGFILE"
    else
        echo "No log file found"
    fi
}

case "${2:-start}" in
    start)
        start_server
        ;;
    stop)
        stop_server
        ;;
    status)
        status_server
        ;;
    logs)
        logs_server
        ;;
    restart)
        stop_server
        sleep 2
        start_server
        ;;
    *)
        echo "Usage: $0 [port] {start|stop|status|logs|restart}"
        echo "Default port: 11443"
        echo ""
        echo "Examples:"
        echo "  ./run-server.sh 11443 start"
        echo "  ./run-server.sh 11443 status"
        echo "  ./run-server.sh 11443 logs"
        echo "  ./run-server.sh 11443 stop"
        exit 1
        ;;
esac

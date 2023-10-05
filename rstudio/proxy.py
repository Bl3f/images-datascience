import socket
import threading

LOCAL_HOST = '0.0.0.0'
LOCAL_PORT = 5000

RSTUDIO_HOST = 'localhost'
RSTUDIO_PORT = 8787


def parse_http_headers(data):
    try:
        headers_raw = data.split(b'\r\n\r\n', 1)[0]
        headers = headers_raw.decode().split('\r\n')[1:]
        return dict(header.split(': ', 1) for header in headers)
    except:
        return {}


def forward_data(source_sock, target_sock):
    data = source_sock.recv(4096)
    if len(data) == 0:
        return

    # Parse and print HTTP headers
    if b'HTTP/1.1' in data or b'HTTP/1.0' in data:
        headers = parse_http_headers(data)

        if "X-ACCESS-TOKEN" in headers:
            with open('/.token', 'w') as f:
                f.write(headers["X-ACCESS-TOKEN"])

    target_sock.send(data)

    while True:
        data = source_sock.recv(4096)
        if len(data) == 0:
            break
        target_sock.send(data)


def handle_client(client_sock):
    backend_sock = socket.socket(socket.AF_INET, socket.TCP_NODELAY)
    try:
        backend_sock.connect((RSTUDIO_HOST, RSTUDIO_PORT))
    except socket.error:
        client_sock.close()
        return

    threading.Thread(target=forward_data, args=(client_sock, backend_sock)).start()
    threading.Thread(target=forward_data, args=(backend_sock, client_sock)).start()


def main():
    local_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    local_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    local_sock.bind((LOCAL_HOST, LOCAL_PORT))
    local_sock.listen(5)

    print(f"Proxy listening on {LOCAL_HOST}:{LOCAL_PORT}")

    while True:
        client_sock, _ = local_sock.accept()
        threading.Thread(target=handle_client, args=(client_sock,)).start()


if __name__ == "__main__":
    main()

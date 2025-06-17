from http.server import BaseHTTPRequestHandler, HTTPServer
import json

class MyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            html = """
            <html>
                <head><title>Home</title></head>
                <body>
                    <h1>Welcome!</h1>
                    <p>This is the home page.</p>
                    <a href="/about">About</a><br>
                    <a href="/api/info">API Info</a>
                </body>
            </html>
            """
            self.wfile.write(html.encode('utf-8'))

        elif self.path == '/about':
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            html = """
            <html>
                <head><title>About</title></head>
                <body>
                    <h1>About This App</h1>
                    <p>This app is a containerized Python web server running on Azure!</p>
                    <a href="/">Home</a>
                </body>
            </html>
            """
            self.wfile.write(html.encode('utf-8'))

        elif self.path == '/api/info':
            self.send_response(200)
            self.send_header("Content-type", "application/json")
            self.end_headers()
            data = {
                "app": "Simple Python Web App",
                "version": "1.0",
                "deployed_on": "Azure VM",
                "containerized": True
            }
            self.wfile.write(json.dumps(data).encode('utf-8'))

        else:
            self.send_error(404, "Page Not Found: {}".format(self.path))


if __name__ == "__main__":
    server_address = ('', 8080)
    httpd = HTTPServer(server_address, MyHandler)
    print("Starting server on port 8080...")
    httpd.serve_forever()

from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import RedirectResponse, HTMLResponse
import os, hashlib, time
from .ddb import put_mapping, get_mapping

app = FastAPI()

@app.get("/", response_class=HTMLResponse)
def root():
    return """
    <!DOCTYPE html>
    <html>
    <head>
        <title>URL Shortener</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                max-width: 600px;
                margin: 50px auto;
                padding: 20px;
            }
            h1 { color: #333; }
            input {
                width: 100%;
                padding: 10px;
                margin: 10px 0;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-sizing: border-box;
            }
            button {
                background: #007bff;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            button:hover { background: #0056b3; }
            #result {
                margin-top: 20px;
                padding: 15px;
                background: #f8f9fa;
                border-radius: 4px;
                display: none;
            }
            .short-url {
                color: #007bff;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <h1>🔗 URL Shortener</h1>
        <form id="shortenForm">
            <input type="url" id="urlInput" placeholder="Enter long URL (e.g., https://example.com)" required>
            <button type="submit">Shorten It!</button>
        </form>
        <div id="result"></div>

        <script>
            document.getElementById('shortenForm').onsubmit = async (e) => {
                e.preventDefault();
                const url = document.getElementById('urlInput').value;
                const resultDiv = document.getElementById('result');

                try {
                    const response = await fetch('/shorten', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({url: url})
                    });

                    if (!response.ok) throw new Error('Failed to shorten URL');

                    const data = await response.json();
                    const shortUrl = window.location.origin + '/' + data.short;

                    resultDiv.style.display = 'block';
                    resultDiv.innerHTML = `
                        <strong>Success! 🎉</strong><br><br>
                        Original: ${url}<br>
                        Short URL: <a href="${shortUrl}" class="short-url" target="_blank">${shortUrl}</a>
                        <button onclick="navigator.clipboard.writeText('${shortUrl}')">Copy</button>
                    `;
                } catch (error) {
                    resultDiv.style.display = 'block';
                    resultDiv.innerHTML = '<strong>Error:</strong> ' + error.message;
                }
            };
        </script>
    </body>
    </html>
    """


@app.get("/healthz")
def health():
    return {"status": "ok", "ts": int(time.time())}

@app.post("/shorten")
async def shorten(req: Request):
    body = await req.json()
    url = body.get("url")
    if not url:
        raise HTTPException(400, "url required")
    short = hashlib.sha256(url.encode()).hexdigest()[:8]
    put_mapping(short, url)
    return {"short": short, "url": url}

@app.get("/{short_id}")
def resolve(short_id: str):
    item = get_mapping(short_id)
    if not item:
        raise HTTPException(404, "not found")
    return RedirectResponse(item["url"])

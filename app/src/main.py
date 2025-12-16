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
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }

            .container {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                padding: 40px;
                max-width: 600px;
                width: 100%;
                animation: fadeIn 0.5s ease-in;
            }

            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }

            .header {
                text-align: center;
                margin-bottom: 30px;
            }

            .logo {
                font-size: 60px;
                margin-bottom: 10px;
                display: inline-block;
                animation: bounce 2s infinite;
            }

            @keyframes bounce {
                0%, 100% { transform: translateY(0); }
                50% { transform: translateY(-10px); }
            }

            h1 {
                color: #333;
                font-size: 32px;
                font-weight: 700;
                margin-bottom: 10px;
            }

            .subtitle {
                color: #666;
                font-size: 16px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            input {
                width: 100%;
                padding: 16px 20px;
                font-size: 16px;
                border: 2px solid #e0e0e0;
                border-radius: 12px;
                transition: all 0.3s ease;
                background: #f8f9fa;
            }

            input:focus {
                outline: none;
                border-color: #667eea;
                background: white;
                box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            }

            button {
                width: 100%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 16px;
                font-size: 18px;
                font-weight: 600;
                border: none;
                border-radius: 12px;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            }

            button:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
            }

            button:active {
                transform: translateY(0);
            }

            #result {
                margin-top: 30px;
                padding: 25px;
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                border-radius: 12px;
                display: none;
                animation: slideIn 0.3s ease-out;
                color: white;
            }

            #result.success {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            }

            #result.error {
                background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            }

            @keyframes slideIn {
                from { opacity: 0; transform: translateY(-10px); }
                to { opacity: 1; transform: translateY(0); }
            }

            .result-title {
                font-size: 20px;
                font-weight: 700;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .url-box {
                background: rgba(255, 255, 255, 0.2);
                padding: 15px;
                border-radius: 8px;
                margin: 10px 0;
                backdrop-filter: blur(10px);
                word-break: break-all;
            }

            .url-label {
                font-size: 12px;
                text-transform: uppercase;
                letter-spacing: 1px;
                opacity: 0.9;
                margin-bottom: 5px;
                font-weight: 600;
            }

            .url-content {
                font-size: 14px;
                line-height: 1.4;
            }

            .short-url {
                color: white;
                font-weight: 700;
                text-decoration: none;
                transition: opacity 0.3s;
            }

            .short-url:hover {
                opacity: 0.8;
            }

            .copy-btn {
                width: auto;
                margin-top: 15px;
                padding: 12px 24px;
                font-size: 14px;
                background: rgba(255, 255, 255, 0.3);
                backdrop-filter: blur(10px);
                border: 2px solid rgba(255, 255, 255, 0.5);
                box-shadow: none;
            }

            .copy-btn:hover {
                background: rgba(255, 255, 255, 0.4);
                transform: translateY(-1px);
            }

            .stats {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 15px;
                margin-top: 30px;
                padding-top: 30px;
                border-top: 2px solid #f0f0f0;
            }

            .stat-item {
                text-align: center;
                padding: 15px;
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                border-radius: 12px;
                color: white;
            }

            .stat-number {
                font-size: 24px;
                font-weight: 700;
                display: block;
            }

            .stat-label {
                font-size: 12px;
                opacity: 0.9;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-top: 5px;
            }

            @media (max-width: 600px) {
                .container {
                    padding: 30px 20px;
                }

                h1 {
                    font-size: 24px;
                }

                .logo {
                    font-size: 48px;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <div class="logo">🔗</div>
                <h1>URL Shortener</h1>
                <p class="subtitle">Transform long URLs into short, shareable links</p>
            </div>

            <form id="shortenForm">
                <div class="form-group">
                    <input
                        type="url"
                        id="urlInput"
                        placeholder="Paste your long URL here..."
                        required
                        autocomplete="off"
                    >
                </div>
                <button type="submit">✨ Shorten URL</button>
            </form>

            <div id="result"></div>

            <div class="stats">
                <div class="stat-item">
                    <span class="stat-number">⚡</span>
                    <span class="stat-label">Instant</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">🔒</span>
                    <span class="stat-label">Secure</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">♾️</span>
                    <span class="stat-label">Unlimited</span>
                </div>
            </div>
        </div>

        <script>
            document.getElementById('shortenForm').onsubmit = async (e) => {
                e.preventDefault();
                const url = document.getElementById('urlInput').value;
                const resultDiv = document.getElementById('result');
                const submitBtn = e.target.querySelector('button');

                // Loading state
                submitBtn.textContent = '⏳ Shortening...';
                submitBtn.disabled = true;

                try {
                    const response = await fetch('/shorten', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({url: url})
                    });

                    if (!response.ok) throw new Error('Failed to shorten URL');

                    const data = await response.json();
                    const shortUrl = window.location.origin + '/' + data.short;

                    resultDiv.className = 'success';
                    resultDiv.style.display = 'block';
                    resultDiv.innerHTML = `
                        <div class="result-title">🎉 Success!</div>

                        <div class="url-box">
                            <div class="url-label">Original URL</div>
                            <div class="url-content">${url}</div>
                        </div>

                        <div class="url-box">
                            <div class="url-label">Shortened URL</div>
                            <div class="url-content">
                                <a href="${shortUrl}" class="short-url" target="_blank">${shortUrl}</a>
                            </div>
                        </div>

                        <button class="copy-btn" onclick="copyToClipboard('${shortUrl}')">
                            📋 Copy to Clipboard
                        </button>
                    `;
                } catch (error) {
                    resultDiv.className = 'error';
                    resultDiv.style.display = 'block';
                    resultDiv.innerHTML = `
                        <div class="result-title">❌ Error</div>
                        <div class="url-box">
                            <div class="url-content">${error.message}</div>
                        </div>
                    `;
                } finally {
                    submitBtn.textContent = '✨ Shorten URL';
                    submitBtn.disabled = false;
                }
            };

            function copyToClipboard(text) {
                navigator.clipboard.writeText(text).then(() => {
                    const btn = event.target;
                    const originalText = btn.textContent;
                    btn.textContent = '✅ Copied!';
                    setTimeout(() => {
                        btn.textContent = originalText;
                    }, 2000);
                });
            }
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

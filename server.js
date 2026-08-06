const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 8080;
const WEB_DIR = path.join(__dirname, 'build', 'web');

const mimeTypes = {
    '.html': 'text/html',
    '.js': 'text/javascript',
    '.css': 'text/css',
    '.json': 'application/json',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.gif': 'image/gif',
    '.svg': 'image/svg+xml',
    '.wav': 'audio/wav',
    '.mp4': 'video/mp4',
    '.woff': 'application/font-woff',
    '.ttf': 'application/font-ttf',
    '.wasm': 'application/wasm'
};

const server = http.createServer((req, res) => {
    // API Endpoints
    if (req.url === '/api/v1/health') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        return res.end(JSON.stringify({ status: 'UP', service: 'NEXUSBUILD Web & API Gateway', timestamp: Date.now() }));
    }
    
    if (req.url === '/api/v1/materials/rates') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        return res.end(JSON.stringify({
            success: true,
            data: [
                { item: 'Cement (Portland Grade 53)', rate: '$6.50', unit: 'bag' },
                { item: 'TMT Steel Bars 12mm', rate: '$850.00', unit: 'tonne' },
                { item: 'Coarse Sand', rate: '$24.00', unit: 'm3' },
                { item: 'Red Bricks Class I', rate: '$0.35', unit: 'piece' }
            ]
        }));
    }

    // Static Web File Serving
    let filePath = path.join(WEB_DIR, req.url === '/' ? 'index.html' : req.url);

    if (!fs.existsSync(filePath) || fs.statSync(filePath).isDirectory()) {
        filePath = path.join(WEB_DIR, 'index.html');
    }

    const extname = String(path.extname(filePath)).toLowerCase();
    const contentType = mimeTypes[extname] || 'application/octet-stream';

    fs.readFile(filePath, (error, content) => {
        if (error) {
            res.writeHead(200, { 'Content-Type': 'text/html' });
            res.end(`
                <!DOCTYPE html>
                <html>
                <head>
                    <title>NEXUSBUILD - Construction Estimator</title>
                    <style>
                        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #0f172a; color: #f8fafc; text-align: center; padding: 50px; }
                        .card { background: #1e293b; max-width: 600px; margin: auto; padding: 40px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); }
                        h1 { color: #38bdf8; margin-bottom: 10px; }
                        p { color: #94a3b8; font-size: 16px; }
                        .status { background: #064e3b; color: #34d399; padding: 10px 20px; border-radius: 20px; display: inline-block; font-weight: bold; margin-top: 20px; }
                    </style>
                </head>
                <body>
                    <div class="card">
                        <h1>🏗️ NEXUSBUILD Core Web Application</h1>
                        <p>Professional Civil Engineering & Construction Estimator Platform</p>
                        <div class="status">● Server Online on http://localhost:${PORT}</div>
                        <p style="margin-top:25px; font-size: 14px;">API Endpoint Gateway Active at <code>http://localhost:${PORT}/api/v1/health</code></p>
                    </div>
                </body>
                </html>
            `);
        } else {
            res.writeHead(200, { 'Content-Type': contentType });
            res.end(content, 'utf-8');
        }
    });
});

server.listen(PORT, () => {
    console.log(`[NEXUSBUILD LOCALHOST SERVER] Successfully running on http://localhost:${PORT}`);
});

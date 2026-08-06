const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 8080;
const WEB_DIR = path.join(__dirname, 'build', 'web');

const mimeTypes = {
    '.html': 'text/html; charset=utf-8',
    '.js': 'application/javascript; charset=utf-8',
    '.mjs': 'application/javascript; charset=utf-8',
    '.css': 'text/css; charset=utf-8',
    '.json': 'application/json; charset=utf-8',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.gif': 'image/gif',
    '.svg': 'image/svg+xml',
    '.ico': 'image/x-icon',
    '.wav': 'audio/wav',
    '.mp4': 'video/mp4',
    '.woff': 'font/woff',
    '.woff2': 'font/woff2',
    '.ttf': 'font/ttf',
    '.otf': 'font/otf',
    '.wasm': 'application/wasm'
};

const server = http.createServer((req, res) => {
    // Enable CORS for development
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', '*');

    if (req.method === 'OPTIONS') {
        res.writeHead(204);
        return res.end();
    }

    const reqUrl = req.url.split('?')[0];

    // API Endpoints
    if (reqUrl === '/api/v1/health') {
        res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
        return res.end(JSON.stringify({ status: 'UP', service: 'NEXUSBUILD Web & API Gateway', timestamp: Date.now() }));
    }

    if (reqUrl === '/api/v1/materials/rates') {
        res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
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
    let safeUrl = reqUrl === '/' ? '/index.html' : reqUrl;
    let filePath = path.join(WEB_DIR, safeUrl);

    // Check if the requested file exists
    const hasExtension = path.extname(safeUrl).length > 0;

    if (!fs.existsSync(filePath) || fs.statSync(filePath).isDirectory()) {
        if (hasExtension) {
            // Asset/JS file missing - return 404 instead of returning index.html
            res.writeHead(404, { 'Content-Type': 'text/plain' });
            return res.end(`404 Not Found: ${safeUrl}`);
        }
        // SPA Route - fallback to index.html
        filePath = path.join(WEB_DIR, 'index.html');
    }

    const extname = String(path.extname(filePath)).toLowerCase();
    const contentType = mimeTypes[extname] || 'application/octet-stream';

    fs.readFile(filePath, (error, content) => {
        if (error) {
            res.writeHead(500, { 'Content-Type': 'text/plain' });
            res.end(`500 Internal Server Error: ${error.message}`);
        } else {
            res.writeHead(200, {
                'Content-Type': contentType,
                'Cache-Control': 'no-cache, no-store, must-revalidate'
            });
            res.end(content);
        }
    });
});

server.listen(PORT, () => {
    console.log(`[NEXUSBUILD LOCALHOST SERVER] Server active on http://localhost:${PORT}`);
});

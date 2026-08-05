/**
 * High-Performance HTTP Mock API Server for NEXUSBUILD Load Testing
 */
const http = require('http');

const PORT = process.env.PORT || 8080;

const server = http.createServer((req, res) => {
    // Add artificial variable latency (between 10ms and 150ms) to simulate database & compute workloads
    const simulatedLatency = Math.floor(Math.random() * 140) + 10;

    setTimeout(() => {
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('X-Powered-By', 'NEXUSBUILD-API-Gateway');

        if (req.url === '/api/v1/health') {
            res.statusCode = 200;
            res.end(JSON.stringify({ status: 'UP', service: 'NEXUSBUILD Core Backend', timestamp: Date.now() }));
        } else if (req.url === '/api/v1/materials/rates') {
            res.statusCode = 200;
            res.end(JSON.stringify({
                success: true,
                count: 4,
                data: [
                    { item: 'Cement (Portland Grade 53)', rate: '$6.50', unit: 'bag' },
                    { item: 'TMT Steel Bars 12mm', rate: '$850.00', unit: 'tonne' },
                    { item: 'Coarse Sand', rate: '$24.00', unit: 'm3' },
                    { item: 'Red Bricks Class I', rate: '$0.35', unit: 'piece' }
                ]
            }));
        } else if (req.url === '/api/v1/auth/login' && req.method === 'POST') {
            res.statusCode = 200;
            res.end(JSON.stringify({
                success: true,
                token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.nexusbuild_session_token_example',
                user: { id: 'usr_1001', role: 'Civil Engineer', email: 'engineer@nexusbuild.com' }
            }));
        } else if (req.url === '/api/v1/calculator/concrete' && req.method === 'POST') {
            res.statusCode = 200;
            res.end(JSON.stringify({
                success: true,
                concreteVolumeM3: 7.5,
                cementBags: 60,
                sandTonnes: 4.5,
                aggregateTonnes: 9.0
            }));
        } else {
            res.statusCode = 200;
            res.end(JSON.stringify({ success: true, message: 'NEXUSBUILD API Route Active' }));
        }
    }, simulatedLatency);
});

server.listen(PORT, () => {
    console.log(`[NEXUSBUILD MOCK API] Server listening on http://localhost:${PORT}`);
});

module.exports = server;

/**
 * ============================================================================
 * NEXUSBUILD - BASELINE / LOAD TESTING SUITE
 * ============================================================================
 * Specification:
 * - Virtual Concurrent Users: 100 VUs
 * - Test Execution Duration: 60 Seconds (1 Minute)
 * - Workload: High-concurrency HTTP API Requests
 * - Metrics Measured: Requests/sec (RPS), Min, Avg, Max, p95 Latency, Errors
 * ============================================================================
 */

const http = require('http');
const fs = require('fs');
const path = require('path');

// Test Config
const CONCURRENT_USERS = parseInt(process.env.VUS || '100', 10);
const DURATION_SECONDS = parseInt(process.env.DURATION || '60', 10);
const TARGET_HOST = process.env.TARGET_HOST || 'localhost';
const TARGET_PORT = parseInt(process.env.TARGET_PORT || '8080', 10);

const TARGET_ROUTES = [
    { path: '/api/v1/health', method: 'GET' },
    { path: '/api/v1/materials/rates', method: 'GET' },
    { path: '/api/v1/auth/login', method: 'POST', body: JSON.stringify({ email: 'engineer@nexusbuild.com', password: 'SecurePass123!' }) },
    { path: '/api/v1/calculator/concrete', method: 'POST', body: JSON.stringify({ length: 10, width: 5, thickness: 0.15, grade: 'M20' }) }
];

class BaselineLoadTester {
    constructor() {
        this.totalRequests = 0;
        this.successfulRequests = 0;
        this.failedRequests = 0;
        this.totalBytes = 0;
        this.latencies = [];
        this.startTime = 0;
        this.endTime = 0;
        this.isRunning = false;
        this.httpAgent = new http.Agent({ keepAlive: true, maxSockets: 200 });
    }

    async runSingleRequest(route) {
        return new Promise((resolve) => {
            const reqStart = process.hrtime();
            const options = {
                hostname: TARGET_HOST,
                port: TARGET_PORT,
                path: route.path,
                method: route.method,
                agent: this.httpAgent,
                headers: {
                    'Content-Type': 'application/json',
                    'User-Agent': 'NEXUSBUILD-LoadTest-VU/1.0',
                    'Connection': 'keep-alive'
                }
            };

            const req = http.request(options, (res) => {
                let bytes = 0;
                res.on('data', (chunk) => { bytes += chunk.length; });
                res.on('end', () => {
                    const diff = process.hrtime(reqStart);
                    const durationMs = (diff[0] * 1000) + (diff[1] / 1e6);
                    
                    this.totalRequests++;
                    this.totalBytes += bytes;
                    this.latencies.push(durationMs);

                    if (res.statusCode >= 200 && res.statusCode < 400) {
                        this.successfulRequests++;
                    } else {
                        this.failedRequests++;
                    }
                    resolve();
                });
            });

            req.on('error', () => {
                const diff = process.hrtime(reqStart);
                const durationMs = (diff[0] * 1000) + (diff[1] / 1e6);
                this.totalRequests++;
                this.failedRequests++;
                this.latencies.push(durationMs);
                resolve();
            });

            if (route.body) {
                req.write(route.body);
            }
            req.end();
        });
    }

    async virtualUserWorker(workerId, stopTime) {
        while (Date.now() < stopTime && this.isRunning) {
            const randomRoute = TARGET_ROUTES[Math.floor(Math.random() * TARGET_ROUTES.length)];
            await this.runSingleRequest(randomRoute);
        }
    }

    async executeLoadTest() {
        console.log(`\n======================================================================`);
        console.log(` NEXUSBUILD BASELINE / LOAD TESTING ENGINE `);
        console.log(`======================================================================`);
        console.log(`  - Target Server        : http://${TARGET_HOST}:${TARGET_PORT}`);
        console.log(`  - Virtual Users (VUs)  : ${CONCURRENT_USERS} Concurrent Connections`);
        console.log(`  - Test Duration        : ${DURATION_SECONDS} Seconds (1 Minute)`);
        console.log(`  - Target API Routes    : Health, Auth Login, Material Rates, Calculators`);
        console.log(`======================================================================\n`);
        console.log(`[LOAD TEST] Ramping up ${CONCURRENT_USERS} Virtual Users... Test in progress...\n`);

        this.isRunning = true;
        this.startTime = Date.now();
        const stopTime = this.startTime + (DURATION_SECONDS * 1000);

        // Progress Ticker every 5 seconds
        const ticker = setInterval(() => {
            const elapsedSec = Math.floor((Date.now() - this.startTime) / 1000);
            const currentRps = (this.totalRequests / (elapsedSec || 1)).toFixed(1);
            console.log(`  [Elapsed: ${String(elapsedSec).padStart(2, '0')}s / ${DURATION_SECONDS}s] Sent: ${this.totalRequests} reqs | Current Rate: ${currentRps} req/sec`);
        }, 5000);

        // Spawn 100 Concurrent Workers
        const workers = [];
        for (let i = 0; i < CONCURRENT_USERS; i++) {
            workers.push(this.virtualUserWorker(i, stopTime));
        }

        await Promise.all(workers);
        this.isRunning = false;
        clearInterval(ticker);
        this.endTime = Date.now();

        this.printSummaryReport();
    }

    printSummaryReport() {
        const totalDurationSec = (this.endTime - this.startTime) / 1000;
        const rps = (this.totalRequests / totalDurationSec).toFixed(2);
        
        // Calculate Latency Stats
        this.latencies.sort((a, b) => a - b);
        const count = this.latencies.length || 1;
        const minMs = this.latencies[0] ? this.latencies[0].toFixed(2) : 0;
        const maxMs = this.latencies[count - 1] ? this.latencies[count - 1].toFixed(2) : 0;
        const sumMs = this.latencies.reduce((acc, val) => acc + val, 0);
        const avgMs = (sumMs / count).toFixed(2);

        const p50 = this.latencies[Math.floor(count * 0.50)] ? this.latencies[Math.floor(count * 0.50)].toFixed(2) : 0;
        const p90 = this.latencies[Math.floor(count * 0.90)] ? this.latencies[Math.floor(count * 0.90)].toFixed(2) : 0;
        const p95 = this.latencies[Math.floor(count * 0.95)] ? this.latencies[Math.floor(count * 0.95)].toFixed(2) : 0;
        const p99 = this.latencies[Math.floor(count * 0.99)] ? this.latencies[Math.floor(count * 0.99)].toFixed(2) : 0;

        const throughputMB = (this.totalBytes / (1024 * 1024)).toFixed(2);
        const errorRatePct = ((this.failedRequests / (this.totalRequests || 1)) * 100).toFixed(2);

        console.log(`\n======================================================================`);
        console.log(` BASELINE / LOAD TEST SUMMARY REPORT RESULTS`);
        console.log(`======================================================================`);
        console.log(`  Concurrent Virtual Users (VUs) : ${CONCURRENT_USERS}`);
        console.log(`  Actual Test Duration           : ${totalDurationSec.toFixed(2)} seconds`);
        console.log(`  Total Requests Executed        : ${this.totalRequests} requests`);
        console.log(`  Successful Responses (2xx)     : ${this.successfulRequests}`);
        console.log(`  Failed Responses / Errors      : ${this.failedRequests} (${errorRatePct}%)`);
        console.log(`  Total Data Transferred         : ${throughputMB} MB`);
        console.log(`----------------------------------------------------------------------`);
        console.log(` ⚡ REQUESTS PER SECOND (RPS)`);
        console.log(`  - Average Throughput           : ${rps} req/sec`);
        console.log(`----------------------------------------------------------------------`);
        console.log(` ⏱️ RESPONSE TIME / LATENCY BREAKDOWN (ms)`);
        console.log(`  - Minimum (Fastest)            : ${minMs} ms`);
        console.log(`  - Average                      : ${avgMs} ms`);
        console.log(`  - Maximum (Slowest)            : ${maxMs} ms (${(maxMs / 1000).toFixed(2)} sec)`);
        console.log(`  - 50th Percentile (p50 Median) : ${p50} ms`);
        console.log(`  - 90th Percentile (p90)        : ${p90} ms`);
        console.log(`  - 95th Percentile (p95)        : ${p95} ms`);
        console.log(`  - 99th Percentile (p99 Tail)   : ${p99} ms`);
        console.log(`======================================================================\n`);

        // Export JSON Report
        const reportData = {
            metadata: {
                target: `http://${TARGET_HOST}:${TARGET_PORT}`,
                virtualUsers: CONCURRENT_USERS,
                durationSeconds: DURATION_SECONDS,
                timestamp: new Date().toISOString()
            },
            summary: {
                totalRequests: this.totalRequests,
                successfulRequests: this.successfulRequests,
                failedRequests: this.failedRequests,
                errorRatePercent: parseFloat(errorRatePct),
                requestsPerSecond: parseFloat(rps),
                throughputMB: parseFloat(throughputMB)
            },
            latencyMs: {
                min: parseFloat(minMs),
                average: parseFloat(avgMs),
                max: parseFloat(maxMs),
                p50: parseFloat(p50),
                p90: parseFloat(p90),
                p95: parseFloat(p95),
                p99: parseFloat(p99)
            }
        };

        const reportsDir = path.join(__dirname, 'reports');
        if (!fs.existsSync(reportsDir)) {
            fs.mkdirSync(reportsDir, { recursive: true });
        }
        const jsonPath = path.join(reportsDir, 'baseline_load_test_report.json');
        fs.writeFileSync(jsonPath, JSON.stringify(reportData, null, 2));
        console.log(`[REPORT EXPORT] Baseline load test summary saved to: ${jsonPath}\n`);
    }
}

// Standalone or Server Runner
if (require.main === module) {
    // Check if local mock server should be spawned automatically
    const mockServer = require('./mock-server');
    
    // Allow server 500ms to spin up, then start 100 VU load test
    setTimeout(async () => {
        const tester = new BaselineLoadTester();
        await tester.executeLoadTest();
        mockServer.close();
        process.exit(0);
    }, 500);
}

module.exports = BaselineLoadTester;

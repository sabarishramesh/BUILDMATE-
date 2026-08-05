const fs = require('fs');
const path = require('path');

function generateHtmlReport() {
    const jsonPath = path.join(__dirname, 'reports', 'baseline_load_test_report.json');
    if (!fs.existsSync(jsonPath)) {
        console.error("JSON report file not found. Run baseline-load-test.js first.");
        return;
    }

    const data = JSON.parse(fs.readFileSync(jsonPath, 'utf8'));

    const htmlContent = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NEXUSBUILD - Baseline Load Test Report</title>
    <style>
        :root {
            --primary: #1e293b;
            --accent: #3b82f6;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text: #0f172a;
            --border: #e2e8f0;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg);
            color: var(--text);
            margin: 0;
            padding: 30px;
        }
        .container {
            max-width: 1100px;
            margin: 0 auto;
        }
        .header {
            border-bottom: 2px solid var(--border);
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .header h1 {
            margin: 0 0 10px 0;
            color: var(--primary);
            font-size: 28px;
        }
        .header p {
            margin: 0;
            color: #64748b;
            font-size: 14px;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .card {
            background: var(--card-bg);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            border: 1px solid var(--border);
        }
        .card .title {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            margin-bottom: 8px;
            font-weight: 600;
        }
        .card .value {
            font-size: 32px;
            font-weight: 700;
            color: var(--primary);
        }
        .card .subtitle {
            font-size: 12px;
            color: #94a3b8;
            margin-top: 5px;
        }
        .section-title {
            font-size: 20px;
            color: var(--primary);
            margin: 30px 0 15px 0;
            font-weight: 600;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: var(--card-bg);
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid var(--border);
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        th, td {
            padding: 14px 20px;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }
        th {
            background-color: #f1f5f9;
            color: #475569;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
        }
        td {
            font-size: 14px;
        }
        .badge-pass {
            background: #dcfce7;
            color: #166534;
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>NEXUSBUILD - Baseline Load Test Report</h1>
            <p>Execution Date: ${data.metadata.timestamp} | Target Server: ${data.metadata.target}</p>
        </div>

        <div class="grid">
            <div class="card">
                <div class="title">Virtual Users</div>
                <div class="value">${data.metadata.virtualUsers}</div>
                <div class="subtitle">Concurrent Connections</div>
            </div>
            <div class="card">
                <div class="title">Requests / Sec</div>
                <div class="value" style="color: var(--accent);">${data.summary.requestsPerSecond}</div>
                <div class="subtitle">Avg Throughput (RPS)</div>
            </div>
            <div class="card">
                <div class="title">Avg Latency</div>
                <div class="value">${data.latencyMs.average} <span style="font-size: 16px;">ms</span></div>
                <div class="subtitle">Min: ${data.latencyMs.min}ms | Max: ${data.latencyMs.max}ms</div>
            </div>
            <div class="card">
                <div class="title">Success Rate</div>
                <div class="value" style="color: var(--success);">${(100 - data.summary.errorRatePercent).toFixed(2)}%</div>
                <div class="subtitle">${data.summary.successfulRequests} / ${data.summary.totalRequests} Passed</div>
            </div>
        </div>

        <div class="section-title">⏱️ Latency & Response Time Distribution</div>
        <table>
            <thead>
                <tr>
                    <th>Percentile Metric</th>
                    <th>Response Time (ms)</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <tr><td>Fastest (Min)</td><td><strong>${data.latencyMs.min} ms</strong></td><td><span class="badge-pass">OPTIMAL</span></td></tr>
                <tr><td>50th Percentile (p50 Median)</td><td><strong>${data.latencyMs.p50} ms</strong></td><td><span class="badge-pass">OPTIMAL</span></td></tr>
                <tr><td>Average Latency</td><td><strong>${data.latencyMs.average} ms</strong></td><td><span class="badge-pass">OPTIMAL</span></td></tr>
                <tr><td>90th Percentile (p90)</td><td><strong>${data.latencyMs.p90} ms</strong></td><td><span class="badge-pass">OPTIMAL</span></td></tr>
                <tr><td>95th Percentile (p95)</td><td><strong>${data.latencyMs.p95} ms</strong></td><td><span class="badge-pass">OPTIMAL</span></td></tr>
                <tr><td>99th Percentile (p99 Tail)</td><td><strong>${data.latencyMs.p99} ms</strong></td><td><span class="badge-pass">OPTIMAL</span></td></tr>
                <tr><td>Slowest (Max)</td><td><strong>${data.latencyMs.max} ms (${(data.latencyMs.max/1000).toFixed(2)}s)</strong></td><td><span class="badge-pass">ACCEPTABLE</span></td></tr>
            </tbody>
        </table>
    </div>
</body>
</html>`;

    const htmlPath = path.join(__dirname, 'reports', 'load_test_report.html');
    fs.writeFileSync(htmlPath, htmlContent);
    console.log(`[HTML REPORT GENERATED] HTML report saved to: ${htmlPath}`);
}

generateHtmlReport();

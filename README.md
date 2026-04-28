# FundScope v3 — CFA-Grade Indian Mutual Fund Analyzer

A full-stack web application for professional-level mutual fund research.  
**React 18 + Vite** frontend · **Express.js** backend · **SQLite** (Node 22 built-in) · **mfapi.in** for live data · **Google Gemini** for AI analysis.

---

## What's New in v3

- **Unrestricted search** — all 6,000+ AMFI funds, no filtering
- **Live NAV charts** — full history loaded directly from mfapi.in, all periods work
- **CFA Verdict engine** — every fund gets a quantitative Buy / Hold / Avoid with written rationale
- **Google Gemini AI** — free API, CFA Level 3 system prompt, fund-aware context
- **Real risk metrics** — Sharpe, Sortino, Max Drawdown, Beta calculated from actual NAV data
- **Premium design** — warm parchment palette, Instrument Serif + IBM Plex Mono typography

---

## Quick Start

### Requirements
- **Node.js 22+** (needed for built-in `node:sqlite`)
- npm 9+

### 1. Install
```bash
cd server  && npm install
cd ../client && npm install
```

### 2. Run (development)
```bash
# Terminal 1 — API server on :3001
cd server && node --experimental-sqlite index.js

# Terminal 2 — React dev on :5173
cd client && npm run dev
```

Open **http://localhost:5173**

The SQLite database is **auto-created and seeded** on first server start — no manual setup needed.

### 3. Production (single server)
```bash
cd client && npm run build
NODE_ENV=production node --experimental-sqlite server/index.js
# → http://localhost:3001
```

### 4. Docker
```bash
docker-compose up --build
# → http://localhost:3001
```

---

## AI Analyst Setup (Free, 60 seconds)

1. Go to **https://aistudio.google.com**
2. Click **"Get API Key"** → Create API key → copy it
3. In the app, click **✦ CFA Analyst** in the sidebar
4. Paste your key and save
5. Ask anything — e.g. *"Should I invest ₹10,000/month in this fund for 10 years?"*

The AI has full fund context: live returns, risk metrics, sector allocation, regulatory status, and the CFA verdict.

---

## Project Structure

```
fundscope/
├── README.md
├── Dockerfile
├── docker-compose.yml
│
├── server/
│   ├── index.js              Express server (port 3001)
│   ├── package.json
│   ├── .env.example
│   ├── db/
│   │   ├── init.js           Schema + seed (5 funds, full data)
│   │   └── connection.js     DB singleton (node:sqlite)
│   └── routes/
│       ├── funds.js          GET/POST/DELETE funds, watchlist, NAV
│       ├── market.js         Compare, indices, SIP projection
│       └── ai.js             Anthropic API proxy (optional)
│
└── client/
    ├── index.html
    ├── package.json
    ├── vite.config.js        Proxies /api → :3001
    └── src/
        ├── main.jsx
        ├── App.jsx
        ├── index.css         Design tokens (CSS variables)
        ├── services/api.js   mfapi.in + Gemini + server calls
        ├── context/
        │   └── FundContext.jsx  Global state + NAV/risk calculators
        └── components/
            ├── layout/
            │   ├── Shell.jsx         App wrapper + page router
            │   ├── Sidebar.jsx       Nav + watchlist
            │   ├── Topbar.jsx        Full-text search (all AMFI funds)
            │   └── AiPanel.jsx       Gemini AI slide-in page
            ├── charts/
            │   └── NavChart.jsx      Chart.js NAV chart (all periods)
            ├── ui/
            │   └── index.jsx         All shared components
            └── pages/
                ├── Overview.jsx      Dashboard + returns table
                ├── Performance.jsx   NAV chart + heatmap
                ├── Portfolio.jsx     Sector allocation + analytics
                ├── RiskMetrics.jsx   Sharpe/Sortino/Drawdown
                ├── SipCalculator.jsx SIP projector + goal planner
                ├── PeerCompare.jsx   Watchlist comparison
                ├── News.jsx          News + sentiment + regulatory
                └── Regulatory.jsx    SEBI compliance checker
```

---

## How It Works

### Data Flow
1. User searches → `mfapi.in/mf/search?q=...` → all 6000+ funds shown
2. User clicks fund → `mfapi.in/mf/{code}` → full NAV history fetched
3. App calculates returns (1M/3M/6M/1Y/3Y/5Y/10Y/SI) from NAV data client-side
4. Risk metrics (Sharpe, Sortino, MaxDD, Beta) estimated from daily NAV returns
5. CFA verdict derived from quantitative scoring of all metrics
6. All 8 analysis pages populate from this single data object

### CFA Verdict Engine
Every fund is scored 0–10 based on:
- Return profile (1Y, 3Y, 5Y vs benchmarks)
- Risk-adjusted performance (Sharpe ratio)
- Drawdown magnitude
- Regulatory status (SEBI issues = -3 points)

Score ≥ 8 → **Strong Buy** | Score 5.5–8 → **Hold** | Score < 5.5 → **Avoid**

### Search
The search calls `mfapi.in/mf/search` with zero post-filtering. All fund types (direct, regular, growth, dividend, IDCW) appear. Results show a "Direct Growth" badge when applicable but never hide other fund types.

---

## Environment Variables

Copy `server/.env.example` → `server/.env`:

```env
PORT=3001
NODE_ENV=development
CLIENT_URL=http://localhost:5173
DB_PATH=./db/fundscope.db        # optional override

# For server-side AI proxy (optional — app also supports direct Gemini calls)
ANTHROPIC_API_KEY=sk-ant-...
```

---

## API Reference

```
GET  /api/health
GET  /api/funds                      All funds in DB
GET  /api/funds/search?q=...         Live search via mfapi.in
GET  /api/funds/watchlist
POST /api/funds/watchlist/:code      Add to watchlist
DEL  /api/funds/watchlist/:code      Remove from watchlist
GET  /api/funds/:code                Full fund data (all tables)
GET  /api/funds/:code/nav            Refresh NAV from mfapi.in
GET  /api/market/compare?codes=...   Multi-fund comparison
GET  /api/market/indices             Market index data
GET  /api/market/sip-projection      SIP math
POST /api/ai/analyze                 Anthropic proxy (server-side key)
```

---

## Tech Stack

| Layer | Tech |
|---|---|
| Frontend | React 18, Vite 5, CSS Modules |
| Charts | Chart.js 4, react-chartjs-2 |
| Backend | Express.js 4, Node.js 22 |
| Database | SQLite via `node:sqlite` (Node 22 built-in — zero native deps) |
| Live data | mfapi.in (free, no API key) |
| AI | Google Gemini 1.5 Flash (free tier) |
| Deployment | Docker + docker-compose |

---

## License
MIT

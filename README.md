# 📄 Ping Monitor v1.1.8 (PowerShell)

**Ping Monitor** is a lightweight PowerShell script for real-time monitoring of multiple hosts.  
It logs latency, highlights issues, and provides a clean color-coded console view.

---

## ✨ Features

- ⏱ **Real-time monitoring**  
  - Runs on a configurable interval (default: 60s).  
  - Uses reliable trimmed-mean ping calculation.  

- 🌍 **Multiple hosts**  
  - Monitor Google, Cloudflare, Steam, Twitch, or your own endpoints.  
  - Configurable host list.  

- 📊 **Logging**  
  - Saves results to daily text logs in `Ping-Check/` folder.  
  - Color-coded output (Gray/White alternating, Yellow for slow, Red for failed).  

- 🖥 **Console display**  
  - Auto-syncs console buffer size.  
  - Updates PowerShell window title with error count.  

- 🔗 **Shared library**  
  - Uses `adomm.psfl.ps1` for utilities (buffer handling, repaint, timestamp, mute, etc.).  

---

## 📦 Installation

1. Copy `Ping-Monitor.ps1` and `adomm.psfl.ps1` into the same folder.  
2. Adjust your config section (hosts, timeout, etc.).  
3. Run from PowerShell:

```powershell
.\Ping-Monitor.ps1
```

---

## 🚀 Example Output

```
14:16:23 Ping Monitor v1.1.8 Initiated
14:16:24 Google:8  Steam:19  Twitch:7
14:16:24 Google:7  Steam:21  Twitch:8
```

---

## 📚 Configuration

- **Log Path**: `Ping-Check/Ping-Check-yyyy-MM-dd.txt`  
- **Hosts**: defined in script array  
- **Timeout**: default 60 seconds  
- **Ping Requests**: default 5 per host  

---

## 📜 Changelog (Condensed)

- **v1.1.8** — Load functions from config file; HTTPS enforced; `.Trim()` on IPs; stable release.  
- **v1.1.5** — Trimmed mean ping calculation; better fail handling.  
- **v1.1.4** — Public IP check every 30 cycles.  
- **v1.1.3** — Added Twitch, Discord swap option.  
- **v1.1.2** — Restart-safe logging.  
- **v1.1.1** — Initial stable baseline.  

---

## 👤 Author

**Mantas Adomavičius**  
MIT License

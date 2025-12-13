باشه داداش، می‌نویسمش دوباره **کامل و بدون هیچ حذفی**.
فرمتش Markdown هست تا دیپسیک مستقیم بخونه و پوسته بسازه. همه جزئیات سایت و خانه، APIها، پارامترها، فریمور و رفتار سیستم لحاظ شده.

---

````markdown
# LSkw eUABU MSx1 – Full Firmware API Specification

این فایل شامل تمامی APIها و جزئیات فریمور سایت و خانه است.  
تمامی موارد مطابق نیاز پروژه، صنعتی و حرفه‌ای طراحی شده‌اند.

---

## 1️⃣ Authentication & User Management

تمامی کاربران باید با hash رمز عبور وارد شوند.

| Endpoint | Method | Description | Notes |
|----------|--------|-------------|------|
| `/api/login` | POST | ورود کاربر به پنل | Hash کردن رمز، حداقل 10 کاراکتر |
| `/api/logout` | POST | خروج کاربر | پاک کردن session token |
| `/api/change_panel_password` | POST | تغییر رمز پنل | Hash روی NVS |
| `/api/change_ap_password` | POST | تغییر رمز AP | حداقل 8 کاراکتر |

**Parameters Example:**
```json
{
  "username": "admin",
  "password": "lsadmin"
}
````

**Default credentials:**

* AP: `lava0000`
* Panel: `lsadmin`

---

## 2️⃣ System Management

| Endpoint       | Method | Description       | Notes                                          |
| -------------- | ------ | ----------------- | ---------------------------------------------- |
| `/api/reboot`  | POST   | ریبوت برد         | فعال در هر دو فریمور (سایت و خانه)             |
| `/api/reset`   | POST   | ریست کامل         | پاک کردن همه کانفیگ و log، بازگردانی به دیفالت |
| `/api/backup`  | GET    | بکاپ گرفتن از پنل | فرمت `.lskwsxql`                               |
| `/api/restore` | POST   | بازگرداندن بکاپ   | شامل همه آپشن‌ها به جز hash رمزها              |

---

## 3️⃣ Network & Tunnel

### Tunnel / LMT Connection

| Endpoint                 | Method   | Description      | Notes                                          |
| ------------------------ | -------- | ---------------- | ---------------------------------------------- |
| `/api/tunnel/connect`    | POST     | اتصال TCP tunnel | پورت 2244، keepalive، reconnect، watchdog فعال |
| `/api/tunnel/disconnect` | POST     | قطع کانکشن       |                                                |
| `/api/tunnel/status`     | GET      | وضعیت اتصال TCP  | شامل active sessions و last activity           |
| `/api/tunnel/config`     | GET/POST | تنظیمات tunnel   | Multi-session 1–5، TCP passthrough             |

**Tunnel Config Example:**

```json
{
  "unit": "BBU",
  "ip": "169.254.2.3",
  "subnet": "255.255.0.0",
  "gateway": "169.254.2.2",
  "port": 2244,
  "sessions": 1
}
```

### WiFi / Ethernet

| Endpoint                     | Method   | Description             | Notes                                             |
| ---------------------------- | -------- | ----------------------- | ------------------------------------------------- |
| `/api/network/status`        | GET      | وضعیت WiFi و Ethernet   | شامل RSSI و link state                            |
| `/api/network/connect`       | POST     | اتصال به WiFi ذخیره شده | خانه + سایت                                       |
| `/api/network/scan`          | GET      | اسکن APهای اطراف        | نتایج ذخیره NVS، max 3 بار                        |
| `/api/network/softap/config` | GET/POST | تغییر رمز AP            | SSID ثابت: `LSkw eUABU MSx1`، رمز حداقل 8 کاراکتر |

---

## 4️⃣ LMT Unit Management (فقط سایت)

| Endpoint                | Method | Description                    | Notes                              |
| ----------------------- | ------ | ------------------------------ | ---------------------------------- |
| `/api/unit/select`      | POST   | انتخاب یونیت (BBU / DUS / DUW) | ذخیره NVS، کانکشن فعال بعد از boot |
| `/api/unit/status`      | GET    | وضعیت لینک یونیت               | IP، subnet، gateway و وضعیت اتصال  |
| `/api/unit/boot_switch` | POST   | سوئیچ سریع بین یونیت‌ها        | BBU → DUS → DUW                    |

---

## 5️⃣ Logging & Metrics

| Endpoint                 | Method | Description               | Notes                                                        |
| ------------------------ | ------ | ------------------------- | ------------------------------------------------------------ |
| `/api/logs`              | GET    | نمایش آخرین 50 خط log     | رنگ‌بندی: major = نارنجی، warn = زرد، minor = قرمز، ok = سبز |
| `/api/logs/clear`        | POST   | پاک کردن log              |                                                              |
| `/api/logs/autosave`     | POST   | فعال/غیرفعال              | ذخیره log برای review                                        |
| `/api/metrics/status`    | GET    | RAM، CPU، uptime، traffic | Graph / table                                                |
| `/api/metrics/wifi_rssi` | GET    | RSSI وای فای              | Graph                                                        |
| `/api/metrics/eth_speed` | GET    | سرعت اترنت                | Graph یا table                                               |

---

## 6️⃣ LED & Indicator Control

| Endpoint          | Method | Description    | Notes                                |
| ----------------- | ------ | -------------- | ------------------------------------ |
| `/api/led/status` | GET    | وضعیت LED 2    | پالس، چشمک، رنگ‌بندی                 |
| `/api/led/mode`   | POST   | تغییر حالت LED | Boot / Firmware up / Logged / Active |

**LED Behavior:**

* Boot: روشن شدن ۳ ثانیه (آبی)
* Firmware Loaded: چشمک سریع ۵ ثانیه (آبی)
* Logged In: پالس ۲ ثانیه (سرعت پالس بیشتر)
* Active Connection: پالس مطابق انتقال داده (ACT)

---

## 7️⃣ Security & Firewall

| Endpoint              | Method   | Description          | Notes                               |
| --------------------- | -------- | -------------------- | ----------------------------------- |
| `/api/firewall/rules` | GET/POST | تنظیم فایروال        | شامل allow/deny traffic TCP         |
| `/api/idle/config`    | GET/POST | تنظیمات idle timeout | فعال‌سازی خودکار کانکشن بعد از idle |

---

## 8️⃣ UI / Panel (سایت و خانه)

* Sidebar left، dashboard right
* Dark / Light mode (ذخیره preference در NVS)
* نمایش گراف RAM، CPU، Traffic، WiFi RSSI، Ethernet speed
* امکان تغییر رمز AP و پنل با حداقل طول تعیین‌شده
* پشتیبانی از login/logout، reboot/reset، backup/restore
* نمایش log با رنگ‌بندی و autosave
* مدیریت LMT unit (فقط سایت)
* LED 2 مطابق وضعیت سیستم و کانکشن
* Mobile & Desktop friendly

---

## Notes

* همه APIها **RESTful** و JSON هستند
* همه کانفیگ‌ها روی NVS ESP32 ذخیره می‌شوند
* Tunnel TCP فقط پورت 2244، Multi-session، keepalive + reconnect + watchdog
* Home firmware: فقط softAP + client tunnel، بدون LMT unit، UI مشابه سایت
* همه UI موبایل و دسکتاپ فرندلی، dark/light mode، sidebar left, dashboard right
* همه آپشن‌ها فول آپشن و مطابق نیاز پروژه صنعتی و حرفه‌ای هستند

```

---

اگه بخوای، قدم بعدی می‌تونیم **2️⃣ State Machine کامل Tunnel Engine** رو هم بسازیم تا رفتار واقعی کانکشن، LED، reconnect و watchdog دقیق مدل بشه.  

میخوای برم سر اون؟
```
عالی داداش 😎
پس می‌ریم سر **2️⃣ State Machine کامل Tunnel Engine**.

این مرحله قراره رفتار دقیق سیستم، کانکشن LMT، TCP tunnel، reconnect، watchdog، LED و همه وضعیت‌های فریمور سایت و خانه رو مدل کنه.

---

## LSkw eUABU MSx1 – Tunnel Engine State Machine

### 1️⃣ States Overview

| State Name          | Description                                   | Active Unit | Notes                                                    |
| ------------------- | --------------------------------------------- | ----------- | -------------------------------------------------------- |
| `BOOT`              | برد روشن شده، firmware شروع به بالا آمدن کرده | N/A         | LED 2 روشن 3 ثانیه، چشمک سریع بعد از load                |
| `INIT_NETWORK`      | اتصال به شبکه (Ethernet یا WiFi)              | Site/Home   | Scan APs (خانه: auto connect saved WiFi)                 |
| `IDLE`              | هیچ کانکشن فعالی نیست                         | Site/Home   | انتظار کاربر یا اتصال خودکار                             |
| `TUNNEL_CONNECTING` | برقراری کانکشن TCP tunnel به endpoint         | Site/Home   | پورت 2244، keepalive + watchdog                          |
| `TUNNEL_ACTIVE`     | کانکشن برقرار شده و فعال است                  | Site/Home   | داده‌ها در حال عبور، LED پالس با سرعت داده               |
| `TUNNEL_ERROR`      | خطای کانکشن یا timeout                        | Site/Home   | Reconnect خودکار، Log ثبت می‌شود                         |
| `UNIT_SWITCH`       | تغییر یونیت انتخابی (BBU / DUS / DUW)         | Site        | کانکشن جدید ساخته می‌شود، کانفیگ IP/Mask/GW اعمال می‌شود |
| `RESET`             | پاک کردن تمامی اطلاعات                        | Site/Home   | بازگشت به تنظیمات دیفالت، LED وضعیت ریست                 |

---

### 2️⃣ Transitions

| From State          | Event                    | To State            | Action                                       |
| ------------------- | ------------------------ | ------------------- | -------------------------------------------- |
| `BOOT`              | Firmware loaded          | `INIT_NETWORK`      | LED چشمک سریع، initialize NVS                |
| `INIT_NETWORK`      | Network connected        | `IDLE`              | نمایش RSSI / Ethernet link, store status     |
| `INIT_NETWORK`      | Network fail             | `TUNNEL_ERROR`      | Retry network after 5s                       |
| `IDLE`              | User selects unit (Site) | `UNIT_SWITCH`       | Load IP/Subnet/GW, apply tunnel config       |
| `IDLE`              | Auto tunnel enabled      | `TUNNEL_CONNECTING` | Open TCP tunnel port 2244                    |
| `TUNNEL_CONNECTING` | TCP handshake success    | `TUNNEL_ACTIVE`     | LED fast pulse → slower pulse                |
| `TUNNEL_CONNECTING` | TCP handshake fail       | `TUNNEL_ERROR`      | Retry after delay, increment attempt counter |
| `TUNNEL_ACTIVE`     | Tunnel disconnect        | `TUNNEL_ERROR`      | Watchdog trigger, attempt reconnect          |
| `TUNNEL_ERROR`      | Retry success            | `TUNNEL_ACTIVE`     | Log event, reset attempt counter             |
| `TUNNEL_ERROR`      | Max retries              | `IDLE`              | Notify user via panel                        |
| `UNIT_SWITCH`       | Switch complete          | `TUNNEL_CONNECTING` | Open tunnel with new unit config             |
| `RESET`             | Reset done               | `BOOT`              | Clear all NVS, restore default credentials   |

---

### 3️⃣ Watchdog & Keepalive

* **Watchdog**: نظارت بر TCP tunnel، اگر disconnect شد → `TUNNEL_ERROR`
* **Keepalive**: هر 30 ثانیه بسته heartbeat به endpoint → حفظ کانکشن زنده
* **Reconnect**: حداکثر 5 تلاش پشت سرهم قبل از بازگشت به IDLE

---

### 4️⃣ LED 2 Behavior

| State               | LED Action                        |
| ------------------- | --------------------------------- |
| `BOOT`              | روشن آبی 3s، سپس چشمک سریع 5s     |
| `IDLE`              | خاموش یا slow pulse               |
| `TUNNEL_CONNECTING` | چشمک سریع، نشانگر handshake       |
| `TUNNEL_ACTIVE`     | پالس با سرعت داده، نشانگر انتقال  |
| `TUNNEL_ERROR`      | چشمک نارنجی/قرمز، نشانگر خطا      |
| `UNIT_SWITCH`       | چشمک کوتاه آبی، نشانگر تغییر unit |
| `RESET`             | چشمک قرمز سریع، نشانگر reset      |

---

### 5️⃣ Auto Start Behavior

* خانه: اتصال به WiFi ذخیره‌شده خودکار → `TUNNEL_CONNECTING`
* سایت: اتصال خودکار به یونیت انتخاب شده و TCP tunnel → `TUNNEL_ACTIVE`
* همه eventها لاگ می‌شوند، قابل نمایش در پنل سایت و خانه

---

### 6️⃣ Logs & Metrics Integration

* هر تغییر state → log با رنگ‌بندی و severity
* Metrics: RAM, CPU, Traffic, RSSI, Ethernet speed → نمایش live در dashboard
* Clear & autosave log با حداکثر 50 خط → archive برای review

---

### 7️⃣ Multi-Session Handling

* حداکثر 5 session TCP tunnel قابل مدیریت
* Session ها configurable از طریق API پنل سایت
* هر session دارای watchdog، keepalive و reconnect مستقل

---

### 8️⃣ State Machine Diagram (Textual)

```text
[BOOT] --> INIT_NETWORK --> IDLE --> TUNNEL_CONNECTING --> TUNNEL_ACTIVE
   |                                |--> TUNNEL_ERROR --> IDLE
   |--> RESET ----------------------|
IDLE --> UNIT_SWITCH --> TUNNEL_CONNECTING
TUNNEL_ACTIVE --> TUNNEL_ERROR --> IDLE
```

---

### 9️⃣ Notes

* پورت TCP tunnel ثابت: 2244
* Multi-session فعال و configurable
* TCP passthrough فعال
* Auto reconnect + watchdog همه session ها
* LED و log کاملا synchronized با state
* همه stateها قابل مشاهده و کنترل از پنل سایت/خانه

---

داداش، اگه بخوای قدم بعدی می‌تونیم **3️⃣ پرامپت نهایی DeepSeek** رو بسازیم تا کد همه این APIها و State Machine آماده بشه.

میخوای بریم اون مرحله؟

# DeepSeek Prompt - LSkw eUABU MSx1 Tunnel Project
# Author: Moein
# Date: 2025-12-13
# Target: ESP32 + W5500 (Site & Home Firmwares)
# Objective: Full-featured industrial-grade remote LMT tunnel system with UI/UX

## 1. General Requirements

- Two separate firmwares: SITE (remote site) & HOME (local client)
- ESP32 + W5500 for tunneling Ethernet LMT connection
- TCP tunnel on port 2244 (keepalive, watchdog, reconnect)
- Multi-session: max 5 simultaneous connections, default 1 active
- TCP passthrough enabled
- Auto-start and auto-connect features
- LED 2 status indicator behavior
- Logs: max 50 lines live, auto-save, color-coded severity
- Backup & Restore (.lskwsxql) for panel configurations
- Dark/Light UI, responsive for desktop & mobile
- Dashboard metrics: RAM, CPU, Traffic, RSSI, Ethernet speed

## 2. Site Firmware – Detailed Features

### 2.1 Networking & Tunnel
- Boot → INIT_NETWORK → IDLE → TUNNEL_CONNECTING → TUNNEL_ACTIVE
- Auto-detect connected unit: BBU, DUS, DUW
- Load unit IP/Subnet/GW dynamically from panel
- Multi-session support, configurable from panel
- Keepalive heartbeat every 30s
- Watchdog triggers reconnect on disconnect

### 2.2 UI/UX
- Admin-style dashboard
- Left tab menu (custom scroll, no white bar)
- Right content area: configuration & live metrics
- RAM usage, CPU usage, STA traffic live updates
- Panel allows:
    - Change AP password (>=8 chars)
    - Change panel password (>=10 chars, hashed)
    - Reboot / Reset board
    - Backup / Restore configuration (except passwords)
    - Firewall & idle settings
    - Manual session control

### 2.3 Logs
- Max 50 lines, auto-clear, auto-save
- Color-coded:
    - Major: Orange
    - Warning: Yellow
    - Minor: Red
    - OK: Green
- Review saved logs in dedicated panel tab

### 2.4 LED 2 Behavior
- BOOT: blue 3s → fast blink 5s
- IDLE: slow pulse
- TUNNEL_CONNECTING: fast blink
- TUNNEL_ACTIVE: pulse speed proportional to data transfer
- TUNNEL_ERROR: red/orange blink
- UNIT_SWITCH: short blue blink
- RESET: fast red blink

### 2.5 Panel Settings
- Default AP SSID: LSkw eUABU MSx1 (immutable)
- Default AP password: lava0000
- Default Panel password: lsadmin
- Multi-unit boot switch (BBU/DUS/DUW) via BOOT button
- All user parameters saved in 4MB NVS memory
- Auto reconnect to last connected Ethernet/WiFi
- Live metrics & graphs for DBM, Ethernet speed
- OTA update support

## 3. Home Firmware – Detailed Features

### 3.1 Networking & Tunnel
- Auto-connect to saved WiFi network
- Connect to remote site tunnel (port 2244)
- Auto-start sessions with saved configuration
- Watchdog + keepalive same as site firmware
- LED 2: mirrors site firmware behavior for tunnel status

### 3.2 UI/UX
- Dashboard UI same as site firmware (dark/light, mobile & desktop)
- Limited options: view & connect sessions, basic metrics, logs
- Graphs for WiFi DBM and tunnel traffic
- Panel allows:
    - Change AP password (>=8 chars)
    - Change panel password (>=10 chars, hashed)
    - Reboot board
    - Backup/Restore config (.lskwsxql)
- Auto-login saved credentials
- Live metrics and logs synchronized with site sessions

### 3.3 Logs
- Same color-coded scheme
- Max 50 lines live, auto-save
- Review previous logs
- Downloadable .lskwlog

## 4. APIs & State Machine

- Provide JSON-based REST APIs for:
    - Session control (connect/disconnect/reboot/reset)
    - Unit selection (BBU/DUS/DUW)
    - Metrics readout (RAM, CPU, traffic, RSSI, Ethernet speed)
    - Panel configuration (AP/pass, panel password)
    - Logs retrieval & clear
- State Machine:
    - BOOT → INIT_NETWORK → IDLE → TUNNEL_CONNECTING → TUNNEL_ACTIVE
    - UNIT_SWITCH and RESET integrated
    - Watchdog triggers TUNNEL_ERROR → reconnect
- LED status reflects current state
- TCP tunnel: multi-session, port 2244, keepalive, reconnect, passthrough

## 5. Notes for DeepSeek

- All config files, panel settings, and session parameters must be readable, structured, pseudo-database style
- Backups (.lskwsxql) maintain full configuration excluding passwords
- UI must support mobile & desktop, light/dark mode saved per user
- Full control from site panel for monitoring and remote configuration
- Tunnel must work seamlessly through NAT, ISP, or mobile hotspot
- Ensure live updates of metrics and logs
- Session persistence and auto-reconnect mandatory
- All LED behaviors implemented precisely
- Ready for industrial-grade deployment

---

**End of Prompt – Ready to feed into DeepSeek for code generation**
# ESP32 + W5500 Remote LMT Tunnel Project

## Overview
This project establishes a remote connection from Ericsson equipment LMT port at a site to a home ESP32 development board using W5500 over WiFi and internet. It consists of **two firmware components**:

- **Site Firmware (Server)**: Runs on ESP32 + W5500 at the site.
- **Home Firmware (Client)**: Runs on ESP32 at home, connects to WiFi and receives tunneled LMT connection.

Both firmwares communicate over TCP port **2244** and use DHCP/Static IPs for connectivity.

---

## 1. Network Architecture

### Site Firmware
- Connects to Ericsson units (BBU, DUS, DUW) via LMT port.
- Unit IP/Subnet/Gateway examples:
  - **BBU**: 169.254.2.3 / 255.255.0.0 / 169.254.2.2
  - **DUS**: 169.254.1.11 / 255.255.255.0 / 169.254.1.10
  - **DUW**: 169.254.1.2 / 255.255.0.0 / 169.254.1.1
- ESP32 acts as **TCP passthrough**, forwards LMT traffic to Home ESP32.
- Supports **multi-session** (default 1, max 5, configurable).
- Implements **keepalive, watchdog, reconnect**.
- Auto-detects connection status of units.
- IP/Subnet/Gateway can be dynamically selected from panel.

### Home Firmware
- Connects to saved WiFi network automatically.
- Receives tunneled LMT traffic from Site firmware.
- Provides panel to configure and monitor remote connections.
- DHCP supported, can act as **Soft AP** for local laptop connection.
- Stores configuration persistently in NVS (4MB flash).
- Auto-connect on boot if previous session saved.

---

## 2. Panel / UI Design

### General
- Both firmwares use **web-based UI**, **mobile & desktop friendly**.
- Dark/Light mode with memory of user preference.
- Left-hand tabs for navigation.
- Right-hand main panel shows dashboard and configuration.
- UI mimics professional admin panel layout.
- Live metrics displayed:
  - RAM usage
  - CPU load
  - Network traffic (STA)
  - Graphical display for WiFi DBM and Ethernet speed
- LED behavior integrated:
  - Blue LED 2: 3s on at power-up
  - Boot loader: fast blink ~5s
  - Firmware active: slow pulse loop ~5s
  - After login: faster pulse ~2s
  - During active connection: ACT blink indicates data transfer

### Site Firmware Panel
- Full access to all configuration options.
- Unit selection (BBU, DUS, DUW).
- Auto-save and log color-coding:
  - Major: Orange
  - Warning: Yellow
  - Minor: Red
  - OK: Green
- Session logs: 50 lines max, auto-clear, downloadable as `.lskwlog`.
- Firewall, idle settings, port configuration, backup/restore, reboot/reset controls.
- AP password: min 8 characters.
- Panel password: min 10 characters, hashed in flash.
- Restore format: `.lskwsxql` (all panel settings except passwords).

### Home Firmware Panel
- Same UI layout as Site firmware, fewer options.
- Displays network status, live metrics, logs.
- Auto-connect to saved WiFi.
- Logs and graphs identical to Site firmware.
- Panel allows switching active unit via **BOOT button** (BBU → DUS → DUW).
- Saves unit and connection parameters to NVS.

---

## 3. Connection & Tunnel Management

- TCP port **2244** used for LMT tunnel.
- TCP passthrough used for forwarding LMT traffic.
- Keepalive and reconnect implemented for persistent connection.
- Multi-session: configurable up to 5.
- Automatic detection of active units.
- Tunnel supports DHCP and static IP configuration.
- Both firmwares handle NAT/firewall transparently.
- Home ESP32 can act as **endpoint MoShell**:
  - Maps 192.168.4.1 to the respective Ericsson unit IP (e.g., 169.254.2.3) in tunnel.

---

## 4. Logging & Monitoring

- Logs displayed in color-coded text.
- Auto-save logs for later review.
- Maximum 50 lines, then auto-clear.
- Graphical representation for signal strength (DBM) and Ethernet speed.
- Downloadable logs for offline analysis.

---

## 5. Security

- AP password min 8 characters, panel password min 10 characters.
- Passwords hashed and stored in flash.
- Backup/Restore encrypted in `.lskwsxql` format.
- TLS/SSL optional for web panel (can be implemented later).

---

## 6. Firmware Behavior Summary

### Site
- Auto-detect LMT units.
- Forward traffic over TCP tunnel to Home ESP32.
- Logs and dashboard live updates.
- LED indications for boot, active, and connection status.

### Home
- Auto-connect to saved WiFi.
- Listen on port 2244 for incoming LMT tunnel.
- Auto-reconnect on disconnect.
- Display dashboard with logs and metrics.
- Allow local Soft AP access for laptop.
- Boot button cycles active unit selection.

---

## 7. Default Credentials

- AP SSID: `LSkw eUABU MSx1` (cannot be changed)
- AP Password: `lava0000`
- Panel Password: `lsadmin`
- Restore and backup preserve these defaults unless changed by user.

---

## 8. File Formats

- Panel backup: `.lskwsxql`
- Log download: `.lskwlog`
- Persistent storage in flash NVS.

---

## 9. LED & Visual Feedback

- LED2 (Blue):
  - **Power-up**: On 3s
  - **Bootloader**: Fast blink 5s
  - **Firmware active**: Slow pulse 5s
  - **Post-login**: Faster pulse 2s
  - **Active connection**: Blink for data transfer

---

## 10. Notes & Considerations

- Firmware must be **industrial-grade**, stable, and persistent.
- All configuration must survive power cycles.
- TCP tunnel fully supports passthrough, keepalive, reconnect, watchdog.
- Both panels must be mobile-friendly, modern, with live metrics.
- User workflow streamlined for minimal interaction.
- All units selectable via panel or BOOT button with persisted settings.
- System must handle multi-session without conflicts.
- UI must show live RAM, traffic, and signal strength.

---
سلام DeepSeek!  

فایل Markdown پروژه ESP32 + W5500 که شامل جزئیات کامل دو فریمور (Site firmware و Home firmware) هست رو باز کن و تحلیل کن.  

وظایف تو:  

1️⃣ **تحلیل کامل فایل**  
- همه بخش‌ها شامل شبکه، پنل‌ها، TCP tunnel، LED، logs، backup/restore، credential ها و UI رو شناسایی کن.  
- مطمئن شو رفتار Site و Home firmware، DHCP، AP و اتصال به تجهیزات Ericsson و سایر تجهیزات مشخص شده کاملا پوشش داده شده.  

2️⃣ **ساختار و APIها**  
- برای هر فریمور یک ساختار دقیق API و کلاس‌ها پیشنهاد بده.  
- تمام بخش‌های فریمور شامل مدیریت کانکشن، وضعیت LED، logs، backup/restore، login/logout، dark/light mode، tabs و نمودارها رو پوشش بده.  

3️⃣ **State Machine TCP Tunnel**  
- یک state machine کامل برای tunnel TCP بساز، شامل eventها، transitions، reconnect و watchdog.  
- سناریوهای possible error و reconnect و keepalive هم لحاظ شود.  

4️⃣ **Skeleton کد و فایل‌ها**  
- برای هر فریمور یک scaffold از فایل‌ها و ماژول‌های اصلی بساز.  
- هر بخش را با کامنت مشخص کن (مثلا LED, logs, backup/restore, DHCP).  
- کد آماده اجرا نساز، فقط ساختار و skeleton برای توسعه‌دهنده.  

5️⃣ **امنیت و credential ها**  
- hash کردن پسورد پنل و AP را لحاظ کن.  
- ذخیره امن credential ها و نمایش صحیح در پنل.  

6️⃣ **سناریوی تست فرضی**  
- یک سناریوی فرضی شامل روشن شدن Site firmware، وصل شدن Home firmware، فعال شدن tunnel TCP، عملکرد LED و logs بساز.  
- بررسی کن که همه رفتارها مطابق نیاز پروژه باشند.  

⚠️ توجه: فعلا هیچ کدی ننویس، فقط ساختار، APIها، state machine و skeleton برای توسعه‌دهنده آماده کن.  

توجه DeepSeek:  
در طراحی UI هر دو فریمور (Site و Home) باید یک صفحه ورود مشترک به نام login_page.html وجود داشته باشد.  
ویژگی‌های این صفحه:  
- طراحی مدرن و شیک با قابلیت dark/light mode و ذخیره انتخاب کاربر.  
- سازگاری کامل با موبایل و دسکتاپ (responsive).  
- شامل فرم ورود username و password با اعتبارسنجی اولیه.  
- پس از ورود موفق، هدایت به پنل اصلی با tabs سمت چپ و بخش جزئیات و کانفیگ سمت راست.  
- نمایش مقدار رم مصرفی، حافظه استفاده شده و ترافیک لحظه‌ای در داشبورد اصلی.  
- هماهنگی با چراغ LED 2 روی ESP32 (پالس و چشمک) طبق رفتار login.  
- امکان تغییر پسورد AP و پنل از این صفحه.  


Project: LSkw_eUABU_MSx1 – Industrial TCP Tunnel System for Ericsson LMT equipment

Goal:
Build a dual firmware system using ESP32 + W5500:
1. Site Firmware (server side)
2. Home Firmware (client side)

Key Features:
- TCP Tunnel on port 2244 to forward MoShell traffic from Home to Site
- Multi-session (1-5 simultaneous connections)
- Keepalive, Watchdog, Auto-reconnect
- Shared web UI with login_page.html
- LED 2 behavior based on system state
- State Machine managing system states (BOOT, INIT_NETWORK, IDLE, TUNNEL_CONNECTING, TUNNEL_ACTIVE, TUNNEL_ERROR, UNIT_SWITCH, RESET)
- Backup/Restore functionality
- Logging and metrics

Project Structure:

LSkw_eUABU_MSx1/
├── common/                # Shared code
│   ├── include/
│   │   ├── auth_manager.h
│   │   ├── backup_restore.h
│   │   ├── led_controller.h
│   │   ├── log_manager.h
│   │   ├── nvs_manager.h
│   │   ├── state_machine.h
│   │   ├── tunnel_engine.h
│   │   ├── web_server.h
│   │   └── network_manager.h
│   └── src/
│       ├── auth_manager.cpp
│       ├── backup_restore.cpp
│       ├── led_controller.cpp
│       ├── log_manager.cpp
│       ├── nvs_manager.cpp
│       ├── state_machine.cpp
│       ├── tunnel_engine.cpp
│       ├── web_server.cpp
│       └── network_manager.cpp
├── site_firmware/
│   ├── include/site_main.h
│   ├── src/site_main.cpp
│   ├── src/site_network.cpp
│   └── web/ (UI site-specific if needed)
├── home_firmware/
│   ├── include/home_main.h
│   ├── src/home_main.cpp
│   ├── src/home_network.cpp
│   └── web/ (UI shared with site)
└── shared_web/
    ├── login_page.html
    ├── css/
    ├── js/
    └── images/

Module Overview:

1. nvs_manager: manage NVS storage for passwords, selected unit, tunnel sessions, UI mode, network config
2. auth_manager: user authentication, password hashing (SHA256+salt), session management
3. web_server: serve UI and API endpoints (JSON)
4. tunnel_engine: manage TCP tunnel, multi-session, keepalive, watchdog
5. state_machine: handle system states and transitions, interface with tunnel engine and LED
6. led_controller: control LED 2 based on state
7. log_manager: colored logging and auto-save
8. backup_restore: backup and restore settings
9. network_manager: handle Ethernet/WiFi connections

API Endpoints:

- Authentication: /api/login, /api/logout, /api/change_panel_password, /api/change_ap_password
- System: /api/reboot, /api/reset, /api/backup, /api/restore
- Network: /api/network/status, /api/network/connect, /api/network/scan, /api/network/softap/config
- Tunnel (Site only): /api/tunnel/connect, /api/tunnel/disconnect, /api/tunnel/status, /api/tunnel/config
- Unit Management (Site only): /api/unit/select, /api/unit/status, /api/unit/boot_switch
- Logs: /api/logs, /api/logs/clear, /api/logs/autosave
- Metrics: /api/metrics/status, /api/metrics/wifi_rssi, /api/metrics/eth_speed
- LED: /api/led/status, /api/led/mode

State Machine Overview:

States: BOOT → INIT_NETWORK → IDLE → TUNNEL_CONNECTING → TUNNEL_ACTIVE → TUNNEL_ERROR → UNIT_SWITCH → RESET → BOOT

Include events, transitions, and LED behavior for each state. Retry count max 5 with exponential backoff.

Instructions for Copilot:

1. Generate all header (.h) and source (.cpp) files for shared modules and firmware-specific modules with skeleton code, classes, and methods.
2. Include constructors, public methods, placeholders for private variables.
3. Include comments describing function purpose and expected interactions.
4. Maintain PlatformIO compatibility for ESP32.
5. Setup skeleton code for Backup/Restore, State Machine, Tunnel Engine, Web Server, Auth Manager, LED Controller, Log Manager, NVS Manager.
6. Include sample method signatures for API endpoints (JSON request/response).
7. Keep web UI files referenced but skeleton (login_page.html, dashboard.html, css/js folders).
8. Do not implement full logic, just skeleton with method names, comments, and class structure.
9. Make sure Site and Home firmware can compile independently using the shared common modules.
10. Include placeholders for unit selection and multi-session tunnel.

End of prompt.

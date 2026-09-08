# Waveshare ESP32-S3 Touch LCD 7 - ESPHome Projekt

Ein ESPHome-Projekt zur Integration des Waveshare ESP32-S3 Touch LCD 7 mit Home Assistant. Das Projekt bietet ein Touch-Interface zur Steuerung von Lichtern und anderen Geräten.

## 🛠️ Technische Details

- **Hardware**: Waveshare ESP32-S3 Touch LCD 7 (800x480 Pixel)
- **Software**: ESPHome (Version 2025.12.7)
- **Display-Framework**: LVGL (Light and Versatile Graphics Library)
- **Integration**: Home Assistant
- **Touch-Sensor**: GT911 Touchscreen
- **Display-Controller**: MIPI RGB (ESP32-S3-TOUCH-LCD-7-800X480)
- **Speicher**: 8 MB PSRAM

## 📁 Projektstruktur

```
waveshare-esp32-s3-touch-7/
├── main.yaml                         # ZENTRALE KONFIGURATION (orchestriert alles)
├── ARCHITECTURE.md                   # Architektur-Dokumentation
├── README.md                         # Diese Datei
├── design.md                         # Design-Richtlinien
│
├── entities/                         # Zentrale Entitäts-Definitionen
│   ├── entities.yaml                # Master - aggregiert alle Entitäten
│   ├── global_vars.yaml             # Globals, Numbers, Display-Logik
│   ├── scripts.yaml                 # Scripts (UI-Sync, Seiten-Navigation)
│   ├── thermostat.yaml              # Thermostat-Sensoren
│   ├── weather.yaml                 # Wetter-Sensoren
│   └── lights.yaml                  # Lichter + Binary-Sensoren
│
├── ui/                               # LVGL UI-Definition
│   ├── lvgl.yaml                    # LVGL-Core (on_idle, top_layer, Pages)
│   ├── header.yaml                  # Persistenter Header (WiFi-Status)
│   ├── footer_prev.yaml             # Footer-Button "Vorherige Seite"
│   ├── footer_center.yaml           # Footer Seitenname (mitte)
│   ├── footer_next.yaml             # Footer-Button "Nächste Seite"
│   └── resources.yaml               # Zeit, Fonts, Bilder, Uhrzeit-Update
│
├── pages/                            # UI-Seiten (LVGL)
│   ├── main_page.yaml               # Hauptseite (Thermostat & Wetter)
│   ├── light_page.yaml              # Lichtsteuerung
│   └── settings_page.yaml           # Einstellungen (Display-Brightness)
│
├── agent-context/                    # Anforderungs-Dokumentation
│   ├── footer.md                    # Footer-Anforderungen (Navigation)
│   ├── header.md                    # Header-Anforderungen (WiFi-Status)
│   └── display-timeout.md           # Display-Timeout-Konfiguration
│
├── common/                           # Gemeinsame Konfiguration
│   ├── secrets.yaml                 # Vertrauliche Daten (gitignore)
│   │   └── wifi_ssid, wifi_password, api_key, ...
│   └── wifi.yaml                    # WiFi-Konfiguration
│
├── waveshare/                        # Hardware-spezifische Konfiguration
│   ├── waveshare-esp32-s3-touch-lcd-7.yaml
│   └── waveshare-esp32-s3-touch-lcd-7-bl.yaml
│
├── fonts/                            # Benutzerdefinierte Schriftarten (TTF)
├── images/
│   └── main_bg.png                  # Hintergrundbild (RGB565)
├── templates/                        # Wiederverwendbare Templates (für Zukunft)
└── .esphome/                         # ESPHome Build-Output
```

## ✨ Hauptmerkmale

### 📊 Persistenter Header
- Durchgehende Leiste am oberen Rand (30 Pixel)
- Zeigt WiFi-Signalstärke an
- Sichtbar auf allen drei Seiten (Main, Light, Settings)

### 🧭 Persistenter Footer
- Navigation mit drei Buttons (Vorherige, Seitennummer, Nächste)
- Verbindung mit Seiten-Navigation
- Swipe-Gesten-Unterstützung (horizontal)

### 📱 Seiten-Navigation
- **Main Page**: Hauptdisplay (z. B. Überblick)
- **Light Page**: Lichtsteuerung mit Schiebereglern
- **Settings Page**: Konfigurationsoptionen

### 👆 Eingabe-Methoden
- **Touch-Buttons**: Navigation und Gerätesteuerung
- **Swipe-Gesten**: Links/Rechts zum Umschalten zwischen Seiten
- **Slider**: Kontinuierliche Helligkeitssteuerung

### ⏱️ Display-Management
- **Timeout**: Automatisches Dimmen/Ausschalten nach Inaktivität (konfigurierbar: 10-300 Sekunden)
- **Dim-Level**: Helligkeit beim Dimmen einstellen (0-100%)
- **Auto-Wake**: Automatisches Aufwachen durch Touch

## 🎨 Design-Elemente

- **Farbschema**: Anthrazit-Hintergrund (0x2B2B2B) mit grauen Elementen (0xAAAAAA)
- **Border**: 1px heller (0x404040)
- **Schriftarten**: Montserrat (16, 20, ...)
- **Hintergründe**: RGB565-Bilder aus `images/main_bg.png`

## 🔧 Konfiguration

### WiFi
Bearbeite `common/secrets.yaml`:
```yaml
wifi_ssid: "Dein SSID"
wifi_password: "Dein Passwort"
```

### Display-Timeout
- Timeout: 60 Sekunden (Standard)
- Dim-Level: 10% (Standard)
- Über Home Assistant anpassbar

### Fonts
TTF-Dateien in `fonts/` werden automatisch eingebunden. Neue Fonts:
```yaml
font:
  - file: "fonts/dein_font.ttf"
    id: my_font_24
    size: 24
```

## 🚀 Build & Flash

```bash
# Kompilieren und Flashen
esphome run main.yaml

# Nur Logs ansehen
esphome logs main.yaml

# OTA-Update
esphome run main.yaml --upload-certificate <cert>
```

## 📝 Wichtige Hinweise

- **Secrets**: `secrets.yaml` enthält vertrauliche Daten – nicht ins Repository pushen!
- **Indentation**: YAML nutzt 2 Leerzeichen (wichtig!)
- **Entity-IDs**: Nutze Variablen wie `${wz_tv_licht_id}` für einfache Verwaltung
- **LVGL**: Offizielle Dokumentation: https://esphome.io/cookbook/lvgl/

## 🔌 Integration mit Home Assistant

Das Projekt verbindet sich automatisch mit Home Assistant via ESPHome API:
- **Hostname**: `waveshare-test.local`
- **Port**: 6053 (API)
- **WiFi-Sensor**: Signalstärke wird aktualisiert

## 📄 Lizenz

Beachte die Lizenzen für verwendete Komponenten (LVGL, ESPHome, Fonts).

## 🐛 Troubleshooting

| Problem                | Lösung                                          |
|------------------------|-------------------------------------------------|
| Touch reagiert nicht   | GT911 Touchscreen prüfen, I2C-Adresse 0x5D      |
| Display bleibt schwarz | MIPI RGB Display prüfen, Backlight-Pin (GPIO16) |
| WiFi-Fehler            | secrets.yaml prüfen, Netzwerk prüfen            |
| Logs nicht sichtbar    | OTA oder COM-Port verbindung prüfen             |

---

**Zuletzt aktualisiert**: Januar 2026  
**ESPHome Version**: 2025.12.7

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
├── main.yaml                         # ZENTRALE KONFIGURATION (orchestriert alles, inkl. api + ota)
├── layout.json                       # UI-DEFINITION: Seiten, Widgets, HA-Entitäten (Single Source)
├── README.md                         # Diese Datei
│
├── tools/
│   └── generate_ui.py                # Generator: layout.json -> pages/*.yaml + entities/generated_*.yaml
│
├── widgets/                          # Widget-Templates (string.Template, ${platzhalter})
│   ├── background.tpl                # Hintergrundbild (jede Seite)
│   ├── light_card.tpl                # Licht-Karte: Kurzdruck ein/aus, Langdruck Details
│   ├── light_detail.tpl              # Licht-Popup: Helligkeit + Farbtemperatur
│   ├── toggle_card.tpl               # Toggle-Karte (switch.*, input_boolean.*)
│   ├── sensor_value.tpl              # Sensor-Karte: Name + Wert
│   ├── clock.tpl                     # Große Uhrzeit
│   ├── backlight_slider.tpl          # Display-Helligkeit (lokal, kein HA)
│   ├── number_slider.tpl             # Slider gebunden an ESPHome-Number
│   └── button_card.tpl               # Service-Button (Szenen, Scripts)
│
├── docs/                             # Dokumentation
│   ├── ARCHITECTURE.md               # Architektur-Dokumentation
│   ├── design.md                     # Design-Richtlinien
│   ├── ESP32-S3-Touch-LCD-7-Sch.pdf  # Schaltplan
│   └── backlight_GPIO16.jpg          # Backlight-Verdrahtung (GPIO16)
│
├── entities/                         # Zentrale Entitäts-Definitionen
│   ├── entities.yaml                 # Master - aggregiert alle Entitäten
│   ├── global_vars.yaml              # Globals, Numbers, Display-Logik
│   ├── scripts.yaml                  # Scripts (UI-Sync)
│   ├── generated_entities.yaml       # GENERIERT: HA-Sensoren + Widget-Sync (aus layout.json)
│   └── generated_navigation.yaml     # GENERIERT: change_page-Script (Seitenliste aus layout.json)
│
├── ui/                               # LVGL UI-Definition
│   ├── lvgl.yaml                     # LVGL-Core (on_idle, top_layer, Pages)
│   ├── header.yaml                   # Persistenter Header (WiFi-Status)
│   ├── footer_prev.yaml              # Footer-Button "Vorherige Seite"
│   ├── footer_center.yaml            # Footer Seitenname (mitte)
│   ├── footer_next.yaml              # Footer-Button "Nächste Seite"
│   └── resources.yaml                # Zeit, Fonts, Bilder, Uhrzeit-Update
│
├── pages/                            # UI-Seiten (LVGL) - GENERIERT, nicht manuell editieren!
│   ├── main_page.yaml                # Hauptseite (Uhr, Wetter, Thermostat)
│   ├── light_page.yaml               # Lichtsteuerung (7 Lichter als Karten)
│   └── settings_page.yaml            # Einstellungen (Helligkeit, Timeout)
│
├── agent-context/                    # Anforderungs-Dokumentation
│   ├── header.md                     # Header-Anforderungen (WiFi-Status)
│   ├── footer.md                     # Footer-Anforderungen (Navigation)
│   ├── page-structure.md             # Seitenstruktur & Navigation
│   ├── main-page.md                  # Hauptseite-Anforderungen
│   ├── light-page.md                 # Lichtseite-Anforderungen
│   ├── settings-page.md              # Einstellungsseite-Anforderungen
│   └── display-timeout.md            # Display-Timeout-Konfiguration
│
├── common/                           # Gemeinsame Konfiguration
│   ├── secrets.yaml                  # Vertrauliche Daten (gitignore)
│   │   └── wifi_ssid, wifi_password, fallback_password, ...
│   ├── wifi.yaml                     # WiFi + Captive Portal
│   ├── ble.yaml                      # BLE Tracker + Bluetooth Proxy
│   └── diagnostics.yaml              # Logger, WiFi-RSSI, Uptime, IP
│
├── waveshare/                        # Hardware-spezifische Konfiguration
│   ├── waveshare-esp32-s3-touch-lcd-7.yaml      # Basis: Display, Touch, PSRAM
│   └── waveshare-esp32-s3-touch-lcd-7-bl.yaml   # Wrapper: Basis + Backlight-Steuerung
│
├── fonts/                            # Benutzerdefinierte Schriftarten (TTF)
├── images/
│   └── main_bg.png                   # Hintergrundbild (RGB565)
├── templates/                        # Wiederverwendbare ESPHome-Templates (für Zukunft, .gitkeep)
└── .esphome/                         # ESPHome Build-Output
```

## 🧩 UI-Generator (layout.json)

Die gesamte UI wird **nicht mehr von Hand in YAML geschrieben**, sondern in [layout.json](layout.json) deklariert und per Generator erzeugt:

```bash
# 1. layout.json bearbeiten (Seiten, Widgets, Entitäten, Grid-Position)
# 2. YAML erzeugen
python tools/generate_ui.py
# 3. Validieren & flashen
esphome run main.yaml
```

**Beispiel** — ein neues Licht ist eine Zeile JSON:

```json
{"type": "light", "entity": "light.licht_flur", "key": "flur", "name": "Flur", "grid": [1, 3]}
```

Der Generator erzeugt daraus automatisch:
- die **Widget-Karte** (Label + Toggle + Helligkeits-Slider) in `pages/light_page.yaml`
- die **HA-Anbindung** in `entities/generated_entities.yaml` (`binary_sensor` für State → Toggle, `sensor` für Brightness → Slider, beidseitig synchronisiert)
- die **Swipe-Gesten-Aussparungen** für Slider-Bereiche

**Widget-Typen** (Templates in [widgets/](widgets/)): `light`, `toggle`, `sensor-value`, `button`, `clock`, `thermostat`, `cover`, `backlight-slider`, `number-slider`. Wird `type` weggelassen, leitet der Generator ihn aus der HA-Domain ab (`light.*` → `light`, `switch.*` → `toggle`, `sensor.*` → `sensor-value`, `cover.*` → `cover`, ...).

**Platzierung**: `grid: [spalte, zeile]` (optional + colspan/rowspan) statt Pixel-Koordinaten. Spaltenanzahl und Zeilenhöhe sind pro Seite konfigurierbar.

⚠️ **Generierte Dateien (`pages/*.yaml`, `entities/generated_*.yaml`) niemals manuell editieren** — Änderungen immer in `layout.json` vornehmen.

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
- **Main Page**: Thermostat (Kreis-Slider ohne Hintergrund-Ring), Uhr rechts oben, 2×3-Kachelmatrix (6 frei belegbare Sensor-Slots)
- **Light Page**: Licht-Kacheln in zwei Ebenen:
  - **Kurzdruck** (< 0,7 s): Licht ein/aus (Kachel leuchtet cyan bei „an")
  - **Langdruck** (≥ 0,7 s): Detail-Panel mit **Helligkeits-** und **Farbtemperatur-Slider** (2200–6500 K), schließbar über „X"
- **Rolladen Page**: Cover-Kacheln mit **Auf / Stop / Zu** und Positionsanzeige in %
- **Settings Page**: Konfigurationsoptionen

### 👆 Eingabe-Methoden
- **Touch-Buttons**: Navigation und Gerätesteuerung
- **Swipe-Gesten**: Links/Rechts zum Umschalten zwischen Seiten
- **Slider**: Kontinuierliche Helligkeitssteuerung

### ⏱️ Display-Management
- **Timeout**: Automatisches Dimmen/Ausschalten nach Inaktivität (konfigurierbar: 10-180 Sekunden)
- **Dim-Level**: Helligkeit beim Dimmen einstellen (0-100%)
- **Auto-Wake**: Automatisches Aufwachen durch Touch

## 🎨 Design-Elemente

- **Farbschema**: Dunkler Navy-Verlauf (0x07111F → 0x101F33) mit Karten in 0x101F33
- **Akzente**: Cyan (0x20B8E6) für aktive Werte, dezente Rahmen in 0x213955
- **Schriftarten**: Roboto (18, 20, 24, 48 und 96), inklusive Umlaute, ß und Gradzeichen
- **Navigation**: Schmaler Header und zentrierte, abgerundete Footer-Kapsel
- **Hintergrund**: LVGL-Verlauf; keine externe Hintergrundgrafik erforderlich

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

**Zuletzt aktualisiert**: Oktober 2026  
**ESPHome Version**: 2025.12.7

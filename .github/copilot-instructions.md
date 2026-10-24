# ESPHome Projekt: Waveshare ESP32-S3 Touch LCD 7

## Projektübersicht
Dieses Projekt konfiguriert einen ESP32-S3 Touch LCD 7 von Waveshare für die Integration mit Home Assistant. Es handelt sich um ein ESPHome-Projekt zur Steuerung von Lichtern und anderen Geräten über ein Touch-Display.

Das Projekt folgt einer **sauberen, modularen Architektur** mit Separation von Entitäten und UI-Seiten.

## Technische Details
- **Hardware**: Waveshare ESP32-S3 Touch LCD 7 (800x480px)
- **Software**: ESPHome (Version 2025.12.7)
- **Integration**: Home Assistant
- **Display-Framework**: LVGL (Light and Versatile Graphics Library)
- **Design-System**: "Frosted Glass" (Dunkle, halbtransparente Panels)
- **Touch-Sensor**: GT911 Touchscreen
- **PSRAM**: 8 MB
- **Dokumentation**: https://esphome.io/cookbook/lvgl/

## Projektstruktur (AKTUELL)

```
├── main.yaml                         # ✅ ZENTRALE ORCHESTRIERUNG (inkl. api + ota)
├── layout.json                       # 🎯 UI-DEFINITION (Seiten, Widgets, Entitäten, Grid)
├── tools/generate_ui.py              # Generator: layout.json -> pages/ + entities/generated_*
├── widgets/*.tpl                     # Widget-Templates (string.Template)
│
├── docs/
│   ├── ARCHITECTURE.md               # Detaillierte Architektur-Dokumentation
│   └── design.md                     # Design-Richtlinien
│
├── entities/                         # 🎯 ZENTRALE ENTITÄTS-DEFINITIONEN
│   ├── entities.yaml               # Master-Aggregation (via packages)
│   ├── global_vars.yaml            # Globals, Numbers, Display-Logik
│   ├── scripts.yaml                # Scripts (UI-Sync)
│   ├── generated_entities.yaml     # ⚙️ GENERIERT: HA-Sensoren + Widget-Sync
│   └── generated_navigation.yaml   # ⚙️ GENERIERT: change_page-Script
│
├── ui/                               # 🖼️ LVGL UI-DEFINITION
│   ├── lvgl.yaml                   # LVGL-Core (on_idle, top_layer, Pages)
│   ├── header.yaml                 # Persistenter Header (WiFi-Status)
│   ├── footer_prev.yaml            # Footer-Button "Vorherige Seite"
│   ├── footer_center.yaml          # Footer Seitenname (mitte)
│   ├── footer_next.yaml            # Footer-Button "Nächste Seite"
│   └── resources.yaml              # Zeit, Fonts, Bilder, Uhrzeit-Update
│
├── pages/                            # 🎨 UI-SEITEN (LVGL) - ⚙️ GENERIERT, nicht manuell editieren!
│   ├── main_page.yaml              # Hauptseite (Uhr, Wetter, Thermostat)
│   ├── light_page.yaml             # Lichtsteuerung (Licht-Karten)
│   └── settings_page.yaml          # Einstellungen (Display-Brightness)
│
├── agent-context/                    # 📋 ANFORDERUNGEN
│   ├── display-timeout.md          # Display-Timeout-Logik
│   ├── footer.md                   # Footer-Spezifikationen
│   ├── header.md                   # Header-Spezifikationen
│   ├── light-page.md               # Licht-Seite Spezifikation
│   ├── main-page.md                # Hauptseite Spezifikation
│   ├── page-structure.md           # Navigationsstruktur
│   └── settings-page.md            # Einstellungsseite Spezifikation
│
├── common/                           # ⚙️ GEMEINSAME KONFIGURATION
│   ├── secrets.yaml                # Vertrauliche Daten (gitignore)
│   ├── wifi.yaml                   # WiFi + Captive Portal
│   ├── ble.yaml                    # BLE Tracker + Bluetooth Proxy
│   └── diagnostics.yaml            # Logger, WiFi-RSSI, Uptime, IP
│
├── waveshare/                        # 🔧 HARDWARE-SPEZIFISCH
│   ├── waveshare-esp32-s3-touch-lcd-7.yaml      # Basis (Display, Touch, PSRAM)
│   └── waveshare-esp32-s3-touch-lcd-7-bl.yaml   # Wrapper: Basis + Backlight
│
├── fonts/                            # 🔤 Benutzerdefinierte Schriftarten
├── images/                           # 🖼️ Bilder (RGB565)
└── templates/                        # 📦 Wiederverwendbare ESPHome-Templates (für Zukunft, .gitkeep)
```

## Architektur-Prinzipien

### 1. **Separation of Concerns**
- **entities/**: NUR Sensoren, Numbers, Globals, Scripts (= Daten-Schicht)
- **pages/**: NUR UI-Widgets, Layout der Seiten (= Präsentations-Schicht)
- **ui/**: LVGL-Core, persistente Elemente (Header/Footer), Ressourcen
- **main.yaml**: Orchestrierung (= Koordinations-Schicht)

### 2. **Wiederverwendbarkeit**
- Sensoren in `entities/` sind auf allen Seiten verfügbar
- Lambdas mit Sensor-IDs referenzieren zentral definierte Entitäten
- Keine Duplikate von Sensoren oder Definitionen

### 3. **Wartbarkeit**
- Änderungen an Lichtern → `entities/lights.yaml`
- Neue Wetter-Sensoren → `entities/weather.yaml`
- UI-Updates → einzelne `pages/*.yaml`

### 4. **Cleancode-Prinzipien**
- Klare Namenskonventionen (Entitäten, Widgets)
- Konsistente YAML-Struktur (Einrückung, Kommentare)
- Vermeidung von Hardcoding (zentral definierte IDs)
- Dokumentation in YAML-Kommentaren
- Modulare Struktur mit !include
- code dubletten vermeiden (z.B. gleiche Sensoren in mehreren Dateien)
- unused code entfernen (z.B. nicht verwendete Sensoren oder Widgets)
## Häufige Aufgaben

### Neue Lichter hinzufügen
1. Eintrag in `layout.json` auf der Light-Seite ergänzen:
   `{"type": "light", "entity": "light.licht_x", "key": "x", "name": "Anzeigename", "grid": [col, row]}`
2. `python tools/generate_ui.py` ausführen
3. Kompilieren & testen

Der Generator erzeugt dabei automatisch Widget-Karte + HA-Sync (State → Toggle, Brightness → Slider).

### Neue Seite hinzufügen
1. Seiten-Objekt in `layout.json` ergänzen (id, title, widgets)
2. `python tools/generate_ui.py` ausführen (erzeugt Seite + aktualisiert `change_page`-Seitenliste)
3. In `ui/lvgl.yaml` unter `pages:` eintragen: `- !include ../pages/<id>_page.yaml`
4. Kompilieren & testen

### Sensoren von Home Assistant integrieren
1. `sensor-value`-Widget in `layout.json` ergänzen (entity, key, name, format)
2. Generator ausführen — die HA-Anbindung inkl. Label-Update wird automatisch erzeugt

### UI-Workflow (immer!)
1. `layout.json` bearbeiten (NIEMALS `pages/*.yaml` oder `entities/generated_*.yaml` direkt)
2. `python tools/generate_ui.py`
3. `esphome config main.yaml` zum Validieren

## Wichtige Konventionen

### Namensgebung
- **Entitäts-IDs**: `{component}_{location}_{attribute}`
  - Beispiele: `light_tv_brightness`, `thermostat_current_temp`
- **LVGL-Widget-IDs**: `{page}_{component}_{name}`
  - Beispiele: `main_page_thermostat_meter`, `light_page_tv_toggle`

### YAML-Struktur
- **Einrückung**: Immer 2 Leerzeichen (KEIN Tab!)
- **LVGL-Strukturen**: Absolute Koordinaten für Fixierung
- **Lambdas**: Mit `id(...)` auf zentral definierte Entitäten zugreifen
- **Comments**: Deutsch oder Englisch, aktuell halten

### Packages in main.yaml
```yaml
packages:
  wifi: !include common/wifi.yaml
  ble: !include common/ble.yaml
  diagnostics: !include common/diagnostics.yaml
  hardware: !include waveshare/waveshare-esp32-s3-touch-lcd-7-bl.yaml
  entities: !include entities/entities.yaml  # ← Alle Entitäten
  resources: !include ui/resources.yaml      # ← Zeit, Fonts, Bilder
  ui: !include ui/lvgl.yaml                  # ← LVGL-Core (Header/Footer/Pages)
```

## Anweisungen für Copilot

### ✅ DO's
- ✅ Verwende absolute Pfade bei Dateioperationen
- ✅ Teste Änderungen durch `esphome compile main.yaml`
- ✅ UI-Änderungen IMMER über `layout.json` + `python tools/generate_ui.py`
- ✅ Halte zentrale Definitionen in `entities/` (nicht in Pages!)
- ✅ Achte auf korrekte YAML-Einrückung (2 Leerzeichen)
- ✅ Dokumentiere Änderungen in YAML-Kommentaren
- ✅ Verwende Konventionen für Namensgebung
- ✅ Benutze !include für Modulisierung
- ✅ Teste Page-Navigation (Swipe, Footer-Buttons)

### ❌ DON'Ts
- ❌ Generierte Dateien manuell editieren (`pages/*.yaml`, `entities/generated_*.yaml`)
- ❌ Duplikate von Sensoren in mehreren Dateien
- ❌ Hardcoded Entity-IDs in Lambdas (zentral definiert?)
- ❌ Komplexe Logik in Pages (gehört in global_vars.yaml)
- ❌ Mixing von Daten- und Präsentations-Schicht
- ❌ Änderungen an waveshare-Hardware-Dateien (nur wenn nötig!)
- ❌ Tabs zur Einrückung verwenden

## Debugging & Troubleshooting

### Kompilierungs-Fehler
```bash
esphome compile main.yaml
```
- Lese Fehlermeldungen genau (Zeile, Datei)
- Prüfe YAML-Syntax (Einrückung, Doppelpunkte)
- Prüfe Sensor-IDs in Lambdas (existiert die ID?)

### Runtime-Fehler
- ESPHome Logs prüfen: `esphome logs main.yaml`
- WiFi-Verbindung testen
- Home Assistant Integration prüfen

### Widget nicht sichtbar
- Koordinaten prüfen (x, y, width, height)
- Z-Order prüfen (widgets-Reihenfolge)
- Farben prüfen (transparent? falsche Farbe?)

## Git-Workflow

### Commits
```bash
git add [modified files]
git commit -m "Beschreibung der Änderung"
git push
```

### Wichtige Regeln
- ✅ Committe regelmäßig
- ✅ Nutze aussagekräftige Commit-Messages
- ❌ Pushe NIEMALS `secrets.yaml`
- ❌ Ändere `.gitignore` nicht
- ✅ Review große Änderungen vor Push

## Notizen

- **ESPHome Docs**: https://esphome.io/
- **LVGL Cookbook**: https://esphome.io/cookbook/lvgl/
- **Home Assistant Docs**: https://www.home-assistant.io/
- **Projektdokumentation**: Siehe `docs/ARCHITECTURE.md` und `docs/design.md`
- Bei Fragen: Siehe `agent-context/` für detaillierte Spezifikationen

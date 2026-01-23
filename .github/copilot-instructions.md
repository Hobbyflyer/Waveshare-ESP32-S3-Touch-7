# ESPHome Projekt: Waveshare ESP32-S3 Touch LCD 7

## Projektübersicht
Dieses Projekt konfiguriert einen ESP32-S3 Touch LCD 7 von Waveshare für die Integration mit Home Assistant. Es handelt sich um ein ESPHome-Projekt zur Steuerung von Lichtern und anderen Geräten über ein Touch-Display.

Das Projekt folgt einer **sauberen, modularen Architektur** mit Separation von Entitäten und UI-Seiten.

## Technische Details
- **Hardware**: Waveshare ESP32-S3 Touch LCD 7 (800x480px)
- **Software**: ESPHome (Version 2025.12.7)
- **Integration**: Home Assistant
- **Display-Framework**: LVGL (Light and Versatile Graphics Library)
- **Touch-Sensor**: GT911 Touchscreen
- **PSRAM**: 8 MB
- **Dokumentation**: https://esphome.io/cookbook/lvgl/

## Projektstruktur (AKTUELL)

```
├── main.yaml                         # ✅ ZENTRALE ORCHESTRIERUNG
├── ARCHITECTURE.md                   # Detaillierte Architektur-Dokumentation
│
├── entities/                         # 🎯 ZENTRALE ENTITÄTS-DEFINITIONEN
│   ├── entities.yaml               # Master-Aggregation (via packages)
│   ├── global_vars.yaml            # Globals, Numbers, Display-Logik
│   ├── thermostat.yaml             # Thermostat-Sensoren
│   ├── weather.yaml                # Wetter-Sensoren
│   └── lights.yaml                 # Lichter + Binary-Sensoren
│
├── pages/                            # 🎨 UI-SEITEN (LVGL)
│   ├── main_page.yaml              # Hauptseite (Thermostat & Wetter)
│   ├── light_page.yaml             # Lichtsteuerung
│   └── settings_page.yaml          # Einstellungen (Display-Brightness)
│
├── agent-context/                    # 📋 ANFORDERUNGEN
│   ├── footer.md                   # Footer-Spezifikationen
│   ├── header.md                   # Header-Spezifikationen
│   └── display-timeout.md          # Display-Timeout-Logik
│
├── common/                           # ⚙️ GEMEINSAME KONFIGURATION
│   ├── secrets.yaml                # Vertrauliche Daten (gitignore)
│   └── wifi.yaml                   # WiFi-Konfiguration
│
├── waveshare/                        # 🔧 HARDWARE-SPEZIFISCH
│   ├── waveshare-esp32-s3-touch-lcd-7.yaml
│   └── waveshare-esp32-s3-touch-lcd-7-bl.yaml
│
├── fonts/                            # 🔤 Benutzerdefinierte Schriftarten
├── images/                           # 🖼️ Bilder (RGB565)
└── templates/                        # 📦 Wiederverwendbare Templates (für Zukunft)
```

## Architektur-Prinzipien

### 1. **Separation of Concerns**
- **entities/**: NUR Sensoren, Numbers, Globals (= Daten-Schicht)
- **pages/**: NUR UI-Widgets, Layout (= Präsentations-Schicht)
- **main.yaml**: Orchestrierung und globale Einstellungen (= Koordinations-Schicht)

### 2. **Wiederverwendbarkeit**
- Sensoren in `entities/` sind auf allen Seiten verfügbar
- Lambdas mit Sensor-IDs referenzieren zentral definierte Entitäten
- Keine Duplikate von Sensoren oder Definitionen

### 3. **Wartbarkeit**
- Änderungen an Lichtern → `entities/lights.yaml`
- Neue Wetter-Sensoren → `entities/weather.yaml`
- UI-Updates → einzelne `pages/*.yaml`

## Häufige Aufgaben

### Neue Lichter hinzufügen
1. Sensor in `entities/lights.yaml` hinzufügen (binary_sensor + sensor)
2. Widget in `pages/light_page.yaml` referenzieren
3. Kompilieren & testen

### Neue Seite hinzufügen
1. `pages/new_page.yaml` erstellen mit korrektem ID
2. In `main.yaml` unter `lvgl.pages:` eintragen
3. Navigation in Footer anpassen
4. Kompilieren & testen

### Sensoren von Home Assistant integrieren
1. In entsprechende `entities/` Datei hinzufügen
2. ID für Lambda-Zugriff definieren
3. In Pages via Lambda oder on_value referenzieren

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
  hardware: !include waveshare/waveshare-esp32-s3-touch-lcd-7-bl.yaml
  entities: !include entities/entities.yaml  # ← Alle Entitäten
```

## Anweisungen für Copilot

### ✅ DO's
- ✅ Verwende absolute Pfade bei Dateioperationen
- ✅ Teste Änderungen durch `esphome compile main.yaml`
- ✅ Halte zentrale Definitionen in `entities/` (nicht in Pages!)
- ✅ Achte auf korrekte YAML-Einrückung (2 Leerzeichen)
- ✅ Dokumentiere Änderungen in YAML-Kommentaren
- ✅ Verwende Konventionen für Namensgebung
- ✅ Benutze !include für Modulisierung
- ✅ Teste Page-Navigation (Swipe, Footer-Buttons)

### ❌ DON'Ts
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
- **Projektdokumentation**: Siehe ARCHITECTURE.md und design.md
- Bei Fragen: Siehe `agent-context/` für detaillierte Spezifikationen

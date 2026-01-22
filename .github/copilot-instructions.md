# ESPHome Projekt: Waveshare ESP32-S3 Touch LCD 7

## Projektübersicht
Dieses Projekt konfiguriert einen ESP32-S3 Touch LCD 7 von Waveshare für die Integration mit Home Assistant. Es handelt sich um ein ESPHome-Projekt zur Steuerung von Lichtern und anderen Geräten über ein Touch-Display.

## Technische Details
- **Hardware**: Waveshare ESP32-S3 Touch LCD 7
- **Software**: ESPHome (Version 2025.12.7)
- **Integration**: Home Assistant
- **Display**: LVGL-basiertes Touch-Interface
- **lvgl**: https://esphome.io/cookbook/lvgl/

## Projektstruktur
```
agent-context/
  - footer.md: Anforderungen und Spezifikationen für den persistenten Footer
common/
  - secrets.yaml: Vertrauliche Daten (WiFi, API-Keys, etc.)
  - wifi.yaml: WiFi-Konfiguration
templates/
  - slider_template.yaml: Vorlagen für Slider-Widgets
waveshare/
  - waveshare-esp32-s3-touch-lcd-7-bl.yaml: Basis-Konfiguration mit Backlight
  - waveshare-esp32-s3-touch-lcd-7.yaml: Basis-Konfiguration ohne Backlight
widgets/
  - tv_licht.yaml: Widget für TV-Lichtsteuerung
```

## Häufige Aufgaben
- Erstellung und Aktualisierung des Footers nach Spezifikationen in footer.md
- Vereinfachung von YAML-Templates
- Hinzufügen neuer Widgets für Lichtsteuerung
- Debugging von Sensor- und Display-Problemen
- Integration neuer Home Assistant Entities

## Wichtige Konfigurationen
- **Footer**: Persistenter top_layer mit drei Buttons (Home, Licht, Einstellungen) für Navigation
- **Substitutions**: Verwende Variablen wie `${wz_tv_licht_id}`, `${wz_tv_licht_entity}` für Entity-IDs
- **Binary Sensors**: Für Zustandserkennung von Lichtern
- **Sensors**: Für Brightness-Werte aus Home Assistant
- **LVGL Widgets**: Slider für manuelle Steuerung

## Anweisungen für Copilot
- Bei Änderungen an YAML-Dateien immer die Struktur beibehalten
- Verwende absolute Pfade bei Dateioperationen
- Teste Änderungen durch Kompilierung mit ESPHome
- Achte auf korrekte Einrückung in YAML (2 Leerzeichen)
- Bei Vereinfachungen Redundanzen reduzieren, aber Funktionalität erhalten
- halte Kommentare aktuell und relevant
- waveshare-esp32-s3 Dateien sollen nur die Hardware-spezifische Konfiguration enthalten
- seitenkonfigurationen und widgets sollen in separaten Dateien liegen

## Notizen
- Alle Änderungen sollten in Git committet werden
- Secrets in secrets.yaml nicht in Repository pushen
- Bei Problemen Logs in ESPHome prüfen
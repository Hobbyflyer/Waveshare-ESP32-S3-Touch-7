# Header-Anforderungen

## Übersicht
Der Header ist eine persistente, durchgehende Leiste am oberen Rand des Displays (800x480 Pixel). Er ist über alle drei Bildschirmseiten (Main, Light, Settings) sichtbar und zeigt Statusinformationen wie WiFi-Signal an.

## Layout
- **Position**: Oben am Display mit 3px Abstand zu allen Seiten (links, oben, rechts).
- **Höhe**: 30 Pixel.
- **Y-Position**: 3px.
- **Hintergrund**: Dunkles Anthrazit (0x2B2B2B), durchgehender Container.
- **Border**: 1px, leicht heller als Hintergrund (0x404040).
- **Breite**: 794px (800 - 6px Abstand).
- **Elemente**: 
  - Links: WiFi-Signal Label (x=10, align: LEFT_MID)

## Funktionale Anforderungen
- Header ist fixiert mit 3px Abstand zu den Seitenrändern (y=3).
- Header ist nicht verschiebbar (`scrollable: false`).
- **WiFi-Signal Label**: 
  - Position: Links im Header-Container (x=10, LEFT_MID).
  - Text: "WiFi: --" (wird über WiFi-Status aktualisiert).
  - Textfarbe: Grau (0xAAAAAA) für bessere Sichtbarkeit.
  - Schrift: montserrat_16.

## Technische Implementierung
- **Framework**: LVGL in ESPHome, als `top_layer` für Persistenz über Pages.
- **Container**: obj-Widget mit Anthrazit-Hintergrund (0x2B2B2B).
- **Positionierung**: Absolute Koordinaten (x=3, y=3, width=794, height=30).
- **Fixierung**: `scrollable: false` für Container.
- **Label**: WiFi-Signal wird im Container mit LEFT_MID Alignment platziert.

## Abhängigkeiten
- Integration mit WiFi-Komponente für Signal-Updates.
- Kompatibel mit Touchscreen (GT911) und Display (MIPI RGB).

## Testen
- Kompilierung mit ESPHome.
- Verifizierung der Fixierung (Header darf nicht verschiebbar sein).
- WiFi-Status Updates prüfen.

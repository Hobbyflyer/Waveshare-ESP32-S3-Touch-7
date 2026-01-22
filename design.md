# Design

Das Display (800x480 Pixel) soll über drei Bildschirmseiten verfügen. Alle Seiten nutzen einen persistenten Footer für Navigation (drei Buttons: Home, Licht, Einstellungen). Alle Devices werden über Home Assistant gesteuert.

## Architektur
- **Plattform:** ESPHome auf ESP32-S3 Waveshare Touch LCD 7.
- **UI-Framework:** LVGL für Widgets und Pages.
- **Struktur:** 3 Pages (main_page, light_page, settings_page) mit persistentem top_layer Footer.
- **Navigation:** Footer-Buttons für Page-Wechsel.
- **HA-Integration:** Sensoren und Actions für Entities (Lichter, Thermostat, Wetter). Live-Updates durch HA-Sensoren mit on_value-Lambdas für LVGL-Widgets.
- **Lokale Komponenten:** Template-Number für Display-Timeout (lokal gespeichert).
- **Updates:** Automatische Synchronisation aus HA (z.B. Temperatur-Änderungen über Sensor-Updates).
- **Performance:** Slider mit on_release, um HA-Overload zu vermeiden.
- **Modularisierung:** Substitutions in separaten Dateien (z.B. licht_substitutions.yaml) für Entities und IDs.

## Allgemeine Specs
- **Bildschirmgröße:** 800x480 Pixel (Waveshare ESP32-S3 Touch LCD 7).
- **Theme:** Dunkles Design mit blau-schwarzen Akzenten (Footer: 0x000022).
- **Navigation:** Footer mit 3 Buttons (gleichmäßig verteilt, 60px hoch).
- **Schriftarten:** Montserrat für Labels (Größen: 48 für Uhr, 24 für andere).
- **Icons:** MDI-Icons (z.B. Film: mdi:movie, Licht: mdi:lightbulb).
- **Fallback:** Bei HA-Verbindungsausfall: Offline-Status anzeigen.
- **Hintergrundbild** unter images main_bg.png

## Seite 1: Hauptseite (Thermostat & Wetter)
- **Layout:**
  - **Thermostat-Meter:** Links, 300x300 Pixel, zentriert im linken Bereich (x: 20, y: 80). Meter mit 240°-Bogen, Needle für Ist-Temperatur, Labels für Ist/Soll.
  - **Uhrzeit:** Oben rechts, große Schrift 48 Pixel (x: 600, y: 10).
  - **Wetter-Bereich:** Mitte rechts, 200x200 Pixel (x: 550, y: 100). Zeigt: Aktuelle Temperatur, Wetter-Icon, Luftfeuchtigkeit.
  - **Szenen-Buttons:** Rechts unten, 4 Buttons (150x50 Pixel each, vertikal gestapelt ab y: 320).
- **Inhalte:**
  - Thermostat: HA-Entity `climate.thermostat` (Ist/Soll aus `temperature` und `target_temperature`). Live-Updates über Sensoren.
  - Wetter: HA-Sensoren `sensor.weather_temperature`, `sensor.weather_humidity`, `sensor.weather_condition` (Icon aus MDI). Live-Updates über Sensoren.
  - Buttons: Filmzeit (mdi:movie), Spiele (mdi:gamepad), Reserve (mdi:star), Sleep (mdi:sleep).
- **Interaktionen:** Buttons lösen HA-Szenen aus (z.B. `scene.filmzeit`).
- **Live-Updates:** Labels und Icons aktualisieren sich automatisch bei HA-Änderungen via on_value-Lambdas.

## Seite 2: Lichtsteuerung
- **Layout:**
  - **Wohnbereich:** Oben links, Gruppe mit Label "Wohnbereich" (y: 20). 4 Spots: Jeder mit Toggle-Button (50x50), Slider für Helligkeit (150x20), Slider für Farbtemperatur (150x20).
  - **Schrank:** Mitte links, Gruppe mit 1 Spot.
  - **Essbereich:** Unten links, Toggle-Button und Helligkeit-Slider.
  - **TV-Bereich:** Rechts, Toggle-Button und Helligkeit-Slider für TV-Licht.
  - **Platzierung:** Gruppen vertikal gestapelt, Slider horizontal neben Buttons.
- **Inhalte:**
  - Wohnbereich: HA-Entities `light.licht_wand_rechts`, `light.licht_wand_mitte`, `light.licht_wand_links`, `light.licht_tuer` (brightness, color_temp).
  - Schrank: `light.licht_schrank_mitte`.
  - Essbereich: `light.licht_esstisch` (nur brightness).
  - TV: `light.licht_tv` (nur brightness).
- **Interaktionen:** Toggle: Ein/Aus; Slider: Brightness (0-255), Color Temp (2700-6500K) wo verfügbar.
- **Live-Updates:** Toggle-Buttons und Slider spiegeln HA-Zustand wider via Sensoren (brightness, state).

## Seite 3: Einstellungen
- **Layout:**
  - **Displayhelligkeit:** Mitte, großer Slider (400x50 Pixel, zentriert). Label "Helligkeit" darüber.
  - **Zusätzliche Optionen:** Unten: Button für "Sound an/aus", Label für Timeout (nicht implementiert).
- **Inhalte:**
  - Displayhelligkeit: Steuert `light.lcdbacklight_brightness` (0-100%).
  - Einstellbare abschaltzeit, default 22:00 und einschaltzeit 07:00
  - Timeout: Lokales Number `display_timeout` (45s initial, nicht steuerbar).
- **Interaktionen:** Slider aktualisiert HA-Entity direkt.

## HA-Entities und Sensor-Definitionen
Alle Sensoren sollen in eine zentralen Datei oder Ordner (widgets) nach typ definiert werden.  
- **Thermostat:** Sensoren für `climate.thermostat` (temperature, target_temperature) mit on_value-Updates für Meter und Labels.
- **Wetter:** Sensoren für `sensor.weather_temperature`, `sensor.weather_humidity`, `sensor.weather_condition` mit Updates für Labels und Icons.
- **Lichter:** Binary-Sensoren für state, Sensoren für brightness für alle Lichter in tv_licht.yaml: `light.licht_tv`, `light.licht_wand_rechts`, `light.licht_wand_mitte`, `light.licht_wand_links`, `light.licht_tuer`, `light.licht_schrank_mitte`, `light.licht_esstisch`. Updates für Toggle-Buttons und Slider.
- **Modularisierung:** Substitutions in licht_substitutions.yaml für Entity-IDs und Namen.

## Zusätzliche Anforderungen
- **Performance:** Slider mit `on_release` (nicht kontinuierlich) für HA-Updates.
- **Feedback:** Visuelles Feedback bei Touch (Button-Highlight).
- **Updates:** Automatische Updates aus HA (z.B. Temperatur-Änderungen) via Sensor-on_value-Lambdas.
- **Testen:** Jede Seite einzeln kompilieren und testen.
- **HA-Integration:** Vollständige Sensor-Definitionen für Live-Updates implementiert.
- **Antiburn:** Schutz vor einbrennen des Displays.
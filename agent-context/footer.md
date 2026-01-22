# Footer-Anforderungen

## Übersicht
Der Footer ist eine persistente, durchgehende Leiste am unteren Rand des Displays (800x480 Pixel), die Navigation ermöglicht. Er ist über alle drei Bildschirmseiten (Main, Light, Settings) sichtbar und enthält drei Buttons für die Navigation zwischen den Seiten.

## Layout
- **Position**: Unten am Display, durchgehende horizontale Leiste.
- **Höhe**: 60 Pixel.
- **Hintergrund**: Dunkles Design mit blau-schwarzen Akzenten (Footer: 0x000022).
- **Elemente**: Drei gleichmäßig verteilte Buttons (Home, Licht, Einstellungen).

## Funktionale 
- Footer ist fixiert und an den unteren Rand des Displays gebunden.
- **Home-Button**: Links, Button für Hauptseite mit Icon (z.B. mdi:home).
  - Aktion: Wechselt zur Hauptseite (Thermostat & Wetter).
  - Interaktion: Touch-Feedback (Button-Highlight).
- **Licht-Button**: Mitte, Button für Lichtsteuerung mit Icon (z.B. mdi:lightbulb).
  - Aktion: Wechselt zur Lichtsteuerungsseite.
  - Interaktion: Touch-Feedback (Button-Highlight).
- **Einstellungen-Button**: Rechts, Button für Einstellungen mit Icon (z.B. mdi:cog).
  - Aktion: Wechselt zur Einstellungsseite.
  - Interaktion: Touch-Feedback (Button-Highlight).

## Technische Implementierung
- **Framework**: LVGL in ESPHome, als `top_layer` für Persistenz über Pages.
- **Navigation**: Button-Klicks für direkten Page-Wechsel.
- **Zustandsverwaltung**: Globaler Index für aktuelle Seite (0=Main, 1=Light, 2=Settings), aktualisiert bei Navigation.
- **Performance**: Buttons mit `on_click` (nicht kontinuierlich), um HA-Overload zu vermeiden.
- **Updates**: Buttons bleiben aktiv, aber aktueller Page wird visuell hervorgehoben (z.B. durch Farbe).

## Abhängigkeiten
- Integration mit LVGL-Pages (main_page, light_page, settings_page).
- Keine HA-Entities erforderlich (lokale Navigation).
- Kompatibel mit Touchscreen (GT911) und Display (MIPI RGB).

## Testen
- Kompilierung mit ESPHome.
- Verifizierung der Navigation (Buttons).
- Visuelles Feedback bei Touch.
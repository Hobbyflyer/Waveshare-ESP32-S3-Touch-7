# Footer-Anforderungen

## Übersicht
Der Footer ist eine persistente, durchgehende Leiste am unteren Rand des Displays (800x480 Pixel), die zyklische Navigation ermöglicht. Er ist über alle drei Bildschirmseiten (Main, Light, Settings) sichtbar und enthält zwei Navigations-Buttons (Vorherige/Nächste) sowie ein Seitennamen-Label in der Mitte.

## Layout
- **Position**: Unten am Display mit 3px Abstand zu allen Seiten (links, unten, rechts).
- **Höhe**: 40 Pixel.
- **Y-Position**: 437px (480 - 40 - 3).
- **Hintergrund**: Dunkles Anthrazit (0x2B2B2B) für Footer-Bereich und alle Elemente.
- **Aufteilung**: 15% Links (119px) | 70% Mitte (556px) | 15% Rechts (119px).
- **Elemente**: 
  - Links: Button "Vorherige Seite" (x=3, width=119, height=40)
  - Mitte: Seitennamen-Container mit Anthrazit-Hintergrund (x=122, width=556, height=40)
  - Rechts: Button "Nächste Seite" (x=678, width=119, height=40)
- **Schriftgröße**: montserrat_20 für Buttons und Label

## Funktionale Anforderungen
- Footer ist fixiert mit 3px Abstand zu den Seitenrändern (y=437).
- Alle Widgets sind nicht verschiebbar (`scrollable: false`).
- Alle Pages sind nicht scrollbar (`scrollable: false`).
- **Navigation-Buttons**: Zwei Buttons für Vorherige/Nächste Seite mit zyklischer Navigation.
  - **Vorherige Seite**: Links (x=3, y=437), 119x40px, Icon "<", Hintergrund: Anthrazit (0x2B2B2B), Schrift: montserrat_20.
  - **Nächste Seite**: Rechts (x=678, y=437), 119x40px, Icon ">", Hintergrund: Anthrazit (0x2B2B2B), Schrift: montserrat_20.
  - Aktion: Lambda-Funktion aktualisiert globalen Index und Seitennamen-Label.
  - Interaktion: Touch-Feedback (Button-Highlight).
- **Seitennamen-Container**: Mitte (x=122, y=437), 556x40px, zeigt aktuelle Seite ("Main", "Light", "Settings").
  - Container-Hintergrund: Dunkles Anthrazit (0x2B2B2B).
  - Border: 1px, leicht heller als Hintergrund (0x404040).
  - Label zentriert im Container mit Textfarbe Grau (0xAAAAAA), Schrift: montserrat_20.
  - Wird über Lambda-Funktionen aktualisiert (`lv_label_set_text`).

## Technische Implementierung
- **Framework**: LVGL in ESPHome, als `top_layer` für Persistenz über Pages.
- **Positionierung**: Absolute Koordinaten (x, y) statt relativer Positionierung für vollständige Fixierung.
- **Fixierung**: `scrollable: false` für alle Widgets verhindert Verschieben/Scrollen.
- **Navigation**: 
  - Button-Klicks triggern Lambda-Funktionen.
  - Lambda aktualisiert globalen Index (zyklisch: 0→1→2→0).
  - Label-Text wird via `lv_label_set_text(id(page_name_label), "Text")` aktualisiert.
  - LVGL Page-Wechsel via `lvgl.page.previous`/`lvgl.page.next`.
- **Zustandsverwaltung**: Global `current_page_index` (type: int, initial: 0).
- **Performance**: Buttons mit `on_click` (nicht kontinuierlich), um HA-Overload zu vermeiden.
- **Icons**: ASCII-Zeichen ("<", ">") statt Unicode/MDI wegen Zeichensatzproblemen.
- **Schriftart**: Montserrat (montserrat_24) für Buttons, montserrat_18 für Header.

## Abhängigkeiten
- Integration mit LVGL-Pages (main_page, light_page, settings_page).
- Keine HA-Entities erforderlich (lokale Navigation).
- Kompatibel mit Touchscreen (GT911) und Display (MIPI RGB).

## Testen
- Kompilierung mit ESPHome.
- Verifizierung der Navigation (Buttons).
- Visuelles Feedback bei Touch.
- Prüfung der Fixierung (Footer darf nicht verschiebbar sein).

## Bekannte Probleme & Lösungen
- **Problem**: Footer war verschiebbar.
  - **Lösung**: `scrollable: false` für alle Widgets + absolute Positionierung.
- **Problem**: Unicode-Pfeile (◀, ▶) wurden als Quadrate angezeigt.
  - **Lösung**: ASCII-Pfeile ("<", ">") verwenden.
- **Problem**: `id(label).set_text()` funktioniert nicht in Lambda.
  - **Lösung**: Native LVGL-API verwenden: `lv_label_set_text(id(label), "text")`.
- **Problem**: MDI-Schriftarten nicht in LVGL `fonts`-Sektion unterstützt.
  - **Lösung**: Standard-Schriftarten verwenden oder externe Font-Komponente nutzen.
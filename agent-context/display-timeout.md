# Display-Timeout und Dimm-Funktionalität

## Übersicht
Das Display kann nach einer einstellbaren Zeit automatisch gedimmt oder ausgeschaltet werden, um Energie zu sparen und Einbrennen zu verhindern. Bei Touch wird das Display automatisch auf die ursprüngliche Helligkeit zurückgesetzt.

## Funktionale Anforderungen
- **Timeout**: Nach konfigurierbarer Zeit ohne Touch-Aktivität wird das Display gedimmt oder ausgeschaltet.
- **Dimm-Level**: Konfigurierbare Helligkeit (0-100%), auf die das Display reduziert wird.
  - 0% = Display ausschalten
  - >0% = Display dimmen auf gewählten Prozentsatz
- **Aufwachen**: Bei Touch-Ereignis wird Display auf ursprüngliche Helligkeit zurückgesetzt.
- **Helligkeit-Speicherung**: Vor Dimmen/Ausschalten wird aktuelle Helligkeit gespeichert.

## Technische Implementierung
- **Globals**:
  - `last_touch_time` (unsigned long): Zeitstempel der letzten Touch-Aktivität
  - `display_active` (bool): Status ob Display aktiv oder gedimmt/aus
  - `original_brightness` (float): Gespeicherte Helligkeit vor Dimmen
- **Number-Entities** (in Home Assistant steuerbar):
  - `display_timeout`: Timeout in Sekunden (10-300s, Standard: 60s)
  - `display_dim_level`: Dimm-Level in Prozent (0-100%, Standard: 10%)
- **LVGL on_idle**: Nutzt natives LVGL-Event für Inaktivitätserkennung
  - Lambda prüft ob Display aktiv ist
  - Bei Timeout: Speichert Helligkeit und dimmt/schaltet aus
- **Touchscreen on_touch**: 
  - Bei Touch: Prüft ob Display inaktiv ist
  - Falls ja: Stellt ursprüngliche Helligkeit wieder her
  - Aktualisiert `last_touch_time` für Timeout-Reset

## Konfiguration in test.yaml
```yaml
globals:
  - id: last_touch_time
    type: unsigned long
    initial_value: '0'
  - id: display_active
    type: bool
    initial_value: 'true'
  - id: original_brightness
    type: float
    initial_value: '0.8'

number:
  - platform: template
    name: "Display Timeout"
    id: display_timeout
    optimistic: true
    min_value: 10
    max_value: 300
    step: 10
    initial_value: 60
    unit_of_measurement: "s"
    restore_value: true
  - platform: template
    name: "Display Dim Level"
    id: display_dim_level
    optimistic: true
    min_value: 0
    max_value: 100
    step: 5
    initial_value: 10
    unit_of_measurement: "%"
    restore_value: true

lvgl:
  on_idle:
    timeout: !lambda "return id(display_timeout).state * 1000;"
    then:
      - lambda: |-
          if (id(display_active)) {
            id(display_active) = false;
            id(original_brightness) = id(lcdbacklight_brightness).current_values.get_brightness();
            
            float dim_level = id(display_dim_level).state / 100.0;
            if (dim_level == 0) {
              auto call = id(lcdbacklight_brightness).turn_off();
              call.perform();
            } else {
              auto call = id(lcdbacklight_brightness).turn_on();
              call.set_brightness(dim_level);
              call.perform();
            }
          }
```

## Konfiguration in waveshare-esp32-s3-touch-lcd-7.yaml
```yaml
touchscreen:
  platform: gt911
  id: waveshare_touch
  on_touch:
    - lambda: |-
        if (!id(display_active)) {
          id(display_active) = true;
          auto call = id(lcdbacklight_brightness).turn_on();
          call.set_brightness(id(original_brightness));
          call.perform();
        }
        id(last_touch_time) = millis();
```

## Home Assistant Integration
- **Entities**: Zwei Number-Entities erscheinen in Home Assistant
  - "Display Timeout": Einstellbar für gewünschte Timeout-Dauer
  - "Display Dim Level": Einstellbar für gewünschte Dimm-Helligkeit
- **Restore**: Beide Werte werden gespeichert und nach Neustart wiederhergestellt

## Abhängigkeiten
- Backlight-Komponente: `lcdbacklight_brightness` (aus waveshare-esp32-s3-touch-lcd-7-bl.yaml)
- Touchscreen-Komponente: GT911
- LVGL-Framework für on_idle-Event
- Home Assistant API für Number-Entities

## Testen
- Kompilierung mit ESPHome.
- Timeout-Funktion testen: Nach eingestellter Zeit sollte Display dimmen/ausgehen.
- Aufwachen testen: Bei Touch sollte Display auf ursprüngliche Helligkeit zurückkehren.
- Einstellungen in Home Assistant anpassen und Verhalten prüfen.

## Vorteile
- **Energiesparen**: Reduziert Stromverbrauch bei Nichtbenutzung.
- **Einbrenn-Schutz**: Verhindert Einbrennen statischer Inhalte.
- **Flexibel**: Über Home Assistant jederzeit anpassbar.
- **Benutzerfreundlich**: Automatisches Aufwachen bei Berührung.

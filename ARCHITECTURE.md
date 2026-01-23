# Architektur-Vorschlag: Entitäten und Seitenstruktur

## Übersicht

Das Projekt wird in folgende logische Einheiten aufgeteilt:

1. **entities/** - Zentrale Definition aller Home Assistant Entitäten
2. **pages/** - Implementierung einzelner Seiten (UI + lokale Logik)
3. **common/** - Gemeinsame Konfiguration (WiFi, Secrets)
4. **templates/** - Wiederverwendbare Konfigurationsvorlagen
5. **main.yaml** - Zentrale Konfiguration, die alles orchestriert

---

## Architektur-Struktur

## Architektur-Struktur (IMPLEMENTIERT)

```
waveshare-esp32-s3-touch-7/
├── main.yaml                         # ✅ ZENTRALE KONFIGURATION - orchestriert alles
├── README.md
├── design.md
├── ARCHITECTURE.md                   # Diese Datei
│
├── entities/                         # ✅ Zentrale Entitäts-Definitionen
│   ├── entities.yaml                # Master-Datei für alle Entitäten (aggregiert via packages)
│   ├── thermostat.yaml              # Thermostat-Sensoren
│   ├── weather.yaml                 # Wetter-Sensoren
│   ├── lights.yaml                  # Lichter + Binary Sensoren
│   └── global_vars.yaml             # Globale Variablen & Numbers
│
├── pages/                            # ✅ UI-Seiten (LVGL)
│   ├── main_page.yaml               # Hauptseite (Thermostat & Wetter)
│   ├── light_page.yaml              # Lichtsteuerung
│   └── settings_page.yaml           # Einstellungen
│
├── templates/                        # Wiederverwendbare Templates (für Zukunft)
│   └── (leer - für zukünftige Templates)
│
├── agent-context/
│   ├── footer.md                    # Footer-Anforderungen
│   ├── header.md                    # Header-Anforderungen
│   └── display-timeout.md           # Display-Timeout-Konfiguration
│
├── common/
│   ├── secrets.yaml                 # WiFi, API-Keys (gitignore)
│   └── wifi.yaml                    # WiFi-Konfiguration
│
├── waveshare/
│   ├── waveshare-esp32-s3-touch-lcd-7-bl.yaml
│   └── waveshare-esp32-s3-touch-lcd-7.yaml
│
├── fonts/                            # TTF/OTF Schriftarten
├── images/                           # Bilder (RGB565)
└── .esphome/                         # Build-Output (gitignore)

OBSOLET/GELÖSCHT:
  ❌ test.yaml → Ersetzt durch main.yaml
  ❌ pages/header.yaml → Inline in main.yaml (top_layer)
  ❌ pages/footer.yaml → Inline in main.yaml (top_layer)
```

---

## Datei-Inhalte und Verantwortlichkeiten

### 1. main.yaml (IMPLEMENTIERT) ✅

**Verantwortung**: Zentrale Orchestrierung aller Komponenten  
**Größe**: ~150 Zeilen

```yaml
packages:
  wifi: !include common/wifi.yaml
  hardware: !include waveshare/waveshare-esp32-s3-touch-lcd-7-bl.yaml
  entities: !include entities/entities.yaml

esphome:
  name: "waveshare-test"
  friendly_name: "Display_1"

time:
  - platform: homeassistant

# Globale LVGL-Konfiguration mit inline Header/Footer
lvgl:
  on_idle: ...  # Display Timeout-Logik
  top_layer:
    widgets:
      - obj: ...  # Header (WiFi-Label)
      - button: ... # Footer-Navigation (Prev)
      - obj: ...  # Footer-Center (Page-Name)
      - button: ... # Footer-Navigation (Next)
  pages:
    - !include pages/main_page.yaml
    - !include pages/light_page.yaml
    - !include pages/settings_page.yaml
```

---

### 2. entities/entities.yaml (IMPLEMENTIERT) ✅

**Verantwortung**: Master-Aggregation aller Entitäten  
**Struktur**: Package-basiert

```yaml
packages:
  global_vars: !include global_vars.yaml
  thermostat: !include thermostat.yaml
  weather: !include weather.yaml
  lights: !include lights.yaml
```

---

### 3. entities/global_vars.yaml (IMPLEMENTIERT) ✅

**Verantwortung**: Globale Variablen, Numbers und Display-Logik

```yaml
globals:
  - id: current_page_index (int)
  - id: last_touch_time (unsigned long)
  - id: display_active (bool)
  - id: original_brightness (float)

number:
  - display_timeout (10-300s, default 60s)
  - display_dim_level (0-100%, default 10%)

interval:
  - 1s check: Display-Timeout-Logik (dimmen/ausschalten)
```

---

### 4. entities/thermostat.yaml (IMPLEMENTIERT) ✅

**Verantwortung**: Thermostat-Sensoren  
**Entitäten**: 2 Sensoren

```yaml
sensor:
  - thermostat_current_temp (climate.thermostat → current_temperature)
  - thermostat_target_temp (climate.thermostat → target_temperature)
```

---

### 5. entities/weather.yaml (IMPLEMENTIERT) ✅

**Verantwortung**: Wetter-Sensoren  
**Entitäten**: 3 Sensoren

```yaml
sensor:
  - weather_temperature (sensor.weather_temperature)
  - weather_humidity (sensor.weather_humidity)
  - weather_condition (sensor.weather_condition)
```

---

### 6. entities/lights.yaml (IMPLEMENTIERT) ✅

**Verantwortung**: Lichter-Sensoren und Binary-Sensoren  
**Entitäten**: 7 Binary-Sensoren (Status) + 7 Sensoren (Helligkeit)

```yaml
binary_sensor:
  - light_tv_state, light_wand_rechts_state, ...

sensor:
  - light_tv_brightness, light_wand_rechts_brightness, ...
```

---

### 7. pages/ (IMPLEMENTIERT) ✅

**Verantwortung**: UI-Seiten (LVGL-Struktur)

#### main_page.yaml
```yaml
id: main_page
scrollable: false
on_gesture: ... # Swipe-Navigation
widgets:
  - image: ... # Hintergrundbild
  # TODO: Thermostat-Meter
  # TODO: Wetter-Bereich
  # TODO: Szenen-Buttons
```

#### light_page.yaml
```yaml
id: light_page
scrollable: false
on_gesture: ... # Swipe-Navigation
widgets:
  - image: ... # Hintergrundbild
  # TODO: Wohnbereich-Lichter
  # TODO: Schrank-Licht
  # TODO: Essbereich-Licht
  # TODO: TV-Licht
```

#### settings_page.yaml
```yaml
id: settings_page
scrollable: false
on_gesture: ... # Swipe-Navigation
widgets:
  - image: ... # Hintergrundbild
  # TODO: Display-Helligkeit Slider
  # TODO: Sound Toggle
  # TODO: Timeout-Einstellungen
```
    optimistic: true
    min_value: 0
    max_value: 100
    step: 5
    initial_value: 10
    unit_of_measurement: "%"
    icon: mdi:brightness-6
    restore_value: true

interval:
  - interval: 1s
    then:
      - lambda: |-
          # Display-Timeout-Logik
          ...
```

---

### 4. entities/thermostat.yaml

**Verantwortung**: Thermostat-bezogene Sensoren

```yaml
sensor:
  # Aktuelle Temperatur vom Thermostat
  - platform: homeassistant
    entity_id: climate.thermostat
    attribute: current_temperature
    id: thermostat_current_temp
    on_value:
      - lambda: |-
          // Update LVGL Meter und Label
          lv_meter_set_value(id(thermostat_meter), ..., x.state);

  # Soll-Temperatur vom Thermostat
  - platform: homeassistant
    entity_id: climate.thermostat
    attribute: target_temperature
    id: thermostat_target_temp
    on_value:
      - lambda: |-
          // Update LVGL Label
          ...
```

---

### 5. entities/weather.yaml

**Verantwortung**: Wetter-Sensoren

```yaml
sensor:
  - platform: homeassistant
    entity_id: sensor.weather_temperature
    id: weather_temperature
    on_value:
      - lambda: |-
          lv_label_set_text_fmt(id(weather_temp_label), "%.1f°C", x.state);

  - platform: homeassistant
    entity_id: sensor.weather_humidity
    id: weather_humidity
    on_value:
      - lambda: |-
          lv_label_set_text_fmt(id(weather_humidity_label), "%.0f%%", x.state);

  - platform: homeassistant
    entity_id: sensor.weather_condition
    id: weather_condition
    on_value:
      - lambda: |-
          // Update Icon basierend auf Zustand
          std::string condition = x.state;
          if (condition == "sunny") {
            lv_label_set_text(id(weather_icon), "☀️");
          } else if (condition == "cloudy") {
            lv_label_set_text(id(weather_icon), "☁️");
          }
```

---

### 6. entities/lights.yaml

**Verantwortung**: Lichter-Sensoren und Binary Sensoren

```yaml
binary_sensor:
  # TV-Licht Status
  - platform: homeassistant
    entity_id: light.licht_tv
    id: light_tv_state
    on_state:
      - if:
          condition: binary_sensor.is_on
          then:
            - lambda: |-
                lv_obj_add_state(id(light_tv_toggle), LV_STATE_CHECKED);
          else:
            - lambda: |-
                lv_obj_clear_state(id(light_tv_toggle), LV_STATE_CHECKED);

  # Weitere Lichter...
  - platform: homeassistant
    entity_id: light.licht_wand_rechts
    id: light_wand_rechts_state

sensor:
  # TV-Licht Helligkeit
  - platform: homeassistant
    entity_id: light.licht_tv
    attribute: brightness
    id: light_tv_brightness
    on_value:
      - lambda: |-
          int brightness_percent = (x.state / 255.0) * 100;
          lv_slider_set_value(id(light_tv_slider), brightness_percent, LV_ANIM_OFF);

  # Weitere Helligkeits-Sensoren...
```

---

### 7. pages/header.yaml

**Verantwortung**: Persistenter Header mit WiFi-Status

```yaml
widgets:
  - obj:
      x: 3
      y: 3
      width: 794
      height: 30
      scrollable: false
      bg_color: 0x2B2B2B
      border_width: 1
      border_color: 0x404040
      widgets:
        - label:
            id: wifi_signal_label
            align: LEFT_MID
            x: 10
            text_font: montserrat_16
            text_color: 0xAAAAAA
            text: "WiFi: --"
```

---

### 8. pages/footer.yaml

**Verantwortung**: Persistente Navigation (aus footer.md)

```yaml
widgets:
  - button:  # Vorheriger Screen (links)
      id: nav_prev_button
      x: 3
      y: 437
      width: 119
      height: 40
      scrollable: false
      bg_color: 0x2B2B2B
      border_width: 1
      border_color: 0x404040
      radius: 5
      widgets:
        - label:
            align: CENTER
            text: "<"
            text_font: montserrat_20
      on_click:
        - lambda: |-
            id(current_page_index) = (id(current_page_index) - 1 + 3) % 3;
            // Update Label...
        - lvgl.page.previous:
  # ... Rest der Footer-Buttons
```

---

### 9. pages/main_page.yaml

**Verantwortung**: Hauptseite UI-Struktur (inkludiert lokale Widgets)

```yaml
- id: main_page
  scrollable: false
  on_gesture: ...
  widgets:
    - image:
        align: CENTER
        src: main_background
        width: 800
        height: 480
    
    # Thermostat-Meter
    - meter:
        id: thermostat_meter
        x: 20
        y: 80
        width: 300
        height: 300
        # ...
    
    # Wetter-Bereich
    - obj:
        x: 550
        y: 100
        width: 200
        height: 200
        widgets:
          - label:
              id: weather_temp_label
              text: "20°C"
          # ... weitere Wetter-Widgets
    
    # Szenen-Buttons
    - button:
        id: scene_filmzeit
        # ...
```

---

### 10. pages/light_page.yaml

**Verantwortung**: Lichtsteuerungs-UI

```yaml
- id: light_page
  scrollable: false
  on_gesture: ...
  widgets:
    - image:
        align: CENTER
        src: main_background
        width: 800
        height: 480
    
    # Licht-Gruppen mit Schiebereglern
    - obj:  # Wohnbereich-Gruppe
        x: 20
        y: 50
        width: 350
        height: 350
        widgets:
          # TV-Licht
          - button:
              id: light_tv_toggle
              x: 10
              y: 10
              width: 50
              height: 50
              on_click:
                - homeassistant.service:
                    service: light.toggle
                    data:
                      entity_id: light.licht_tv
          
          - slider:
              id: light_tv_slider
              x: 70
              y: 10
              width: 150
              height: 20
              min_value: 0
              max_value: 100
              on_release:
                - homeassistant.service:
                    service: light.turn_on
                    data:
                      entity_id: light.licht_tv
                      brightness: !lambda "return (x * 255 / 100);"
          
          # Weitere Lichter...
```

---

### 11. pages/settings_page.yaml

**Verantwortung**: Einstellungs-UI

```yaml
- id: settings_page
  scrollable: false
  on_gesture: ...
  widgets:
    - image:
        align: CENTER
        src: main_background
        width: 800
        height: 480
    
    # Display-Helligkeit Slider
    - label:
        x: 200
        y: 100
        text: "Displayhelligkeit"
        text_font: montserrat_20
    
    - slider:
        id: brightness_slider
        x: 200
        y: 150
        width: 400
        height: 50
        min_value: 0
        max_value: 100
        on_release:
          - homeassistant.service:
              service: light.turn_on
              data:
                entity_id: light.lcdbacklight_brightness
                brightness: !lambda "return (x * 255 / 100);"
```

---

## Migrations-Strategie

### ✅ Phase 1: Vorbereitung (ABGESCHLOSSEN)
- ✅ Ordnerstruktur erstellt: `entities/`, `pages/`

### ✅ Phase 2: Entitäten-Separation (ABGESCHLOSSEN)
- ✅ `entities/global_vars.yaml` - Globals + Numbers
- ✅ `entities/thermostat.yaml` - Thermostat-Sensoren
- ✅ `entities/weather.yaml` - Wetter-Sensoren
- ✅ `entities/lights.yaml` - Lichter + Binary-Sensoren
- ✅ `entities/entities.yaml` - Master-Include

### ✅ Phase 3: UI-Separation (ABGESCHLOSSEN)
- ✅ `pages/main_page.yaml` - Hauptseite
- ✅ `pages/light_page.yaml` - Lichtsteuerung
- ✅ `pages/settings_page.yaml` - Einstellungen
- ✅ Header und Footer inline in `main.yaml` (top_layer)

### ✅ Phase 4: Main-Konsolidierung (ABGESCHLOSSEN)
- ✅ `main.yaml` erstellt mit allen Packages
- ✅ ESPHome kompilierbar ✅
- ✅ `test.yaml` gelöscht
- ✅ `pages/header.yaml` gelöscht
- ✅ `pages/footer.yaml` gelöscht

---

## Vorteile dieser Architektur (ERREICHT)

✅ **Sauberkeit**: Jede Entität zentral, einmalig definiert  
✅ **Wartbarkeit**: Änderungen an Lichtern → eine Datei  
✅ **Skalierbarkeit**: Neue Seiten/Entitäten leicht hinzufügbar  
✅ **Lesbarkeit**: Klare Verantwortlichkeiten  
✅ **Wiederverwendung**: Sensoren automatisch überall verfügbar  
✅ **Git-freundlich**: Minimale Konflikte bei Collaboration  
✅ **Kompilierbar**: Erste erfolgreiche Kompilierung ✅  

---

## Nächste Schritte (OPTIONAL)

Die Seiten haben noch `TODO`-Platzhalter für:

### main_page.yaml
- [ ] Thermostat-Meter (Meter-Widget mit Needle für Ist/Soll-Temperatur)
- [ ] Wetter-Bereich (Icons, Temperatur, Luftfeuchtigkeit)
- [ ] Szenen-Buttons (Filmzeit, Spiele, Reserve, Sleep)

### light_page.yaml
- [ ] Wohnbereich-Lichter: 4 Spots mit Toggle-Button + Helligkeit-Slider
- [ ] Schrank-Licht
- [ ] Essbereich-Licht
- [ ] TV-Licht

### settings_page.yaml
- [ ] Display-Helligkeit Slider
- [ ] Sound Toggle
- [ ] Timeout-Einstellungen

---

## Implementierungs-Reihenfolge (ABGESCHLOSSEN)

1. ✅ Analyse (aktueller Stand)
2. ✅ Entitäten separieren (entities/)
3. ✅ Seiten separieren (pages/)
4. ✅ main.yaml konsolidieren
5. ✅ Testen & Kompilieren
6. ✅ Obsolete Dateien löschen
7. ✅ Dokumentation aktualisieren

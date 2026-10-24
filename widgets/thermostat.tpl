# Thermostat: Kreis-Slider (Arc) fuer Soll-Temperatur, Ist-Temperatur in der Mitte
- arc:
    id: ${page}_page_${key}_arc
    x: ${arc_x}
    y: ${arc_y}
    width: ${arc_size}
    height: ${arc_size}
    min_value: ${min}
    max_value: ${max}
    value: 21
    start_angle: 135
    end_angle: 45
    arc_width: 14
    bg_opa: 0%
    indicator:
      arc_width: 14
      bg_color: 0x20b8e6
      bg_opa: 90%
    knob:
      bg_color: 0xFFFFFF
    on_value:
      then:
        - lambda: |-
            lv_label_set_text_fmt(id(${page}_page_${key}_target_value), "Soll: %.0f °C", x);
    on_release:
      then:
        - homeassistant.service:
            service: climate.set_temperature
            data:
              entity_id: ${entity}
              temperature: !lambda 'return x;'
- label:
    id: ${page}_page_${key}_current_caption
    x: ${arc_x}
    y: ${caption_y}
    width: ${arc_size}
    height: 24
    text: "Ist"
    text_align: CENTER
    text_font: roboto_european_core_18
    text_color: 0x8297ad
- label:
    id: ${page}_page_${key}_current_value
    x: ${arc_x}
    y: ${current_y}
    width: ${arc_size}
    height: 60
    text: "--"
    text_align: CENTER
    text_font: roboto_european_core_48
    text_color: 0xf4f8fc
- label:
    id: ${page}_page_${key}_target_value
    x: ${arc_x}
    y: ${target_y}
    width: ${arc_size}
    height: 28
    text: "Soll: -- °C"
    text_align: CENTER
    text_font: roboto_european_core_20
    text_color: 0x20b8e6

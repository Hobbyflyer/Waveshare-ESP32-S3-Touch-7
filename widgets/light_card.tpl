# ${name} (${entity}) - Kurzdruck: ein/aus | Langdruck (0,7s): Detail-Ebene
- button:
    id: ${page}_page_${key}_toggle
    x: ${x}
    y: ${y}
    width: ${w}
    height: ${h}
    bg_color: 0x101f33
    bg_opa: 80%
    border_width: 1
    border_color: 0x213955
    border_side: INTERNAL
    radius: 12
    checked:
      bg_color: 0x16445a
      bg_opa: 100%
      border_color: 0x20b8e6
    widgets:
      - label:
          align: CENTER
          text: "${name}"
          text_font: roboto_european_core_20
          text_color: 0xf4f8fc
    on_press:
      then:
        - lambda: 'id(touch_press_start) = millis();'
    on_release:
      then:
        - if:
            condition:
              # >= 0,7s gedrueckt -> Detail-Ebene oeffnen, sonst togglen
              lambda: 'return (millis() - id(touch_press_start)) >= 700;'
            then:
              - lambda: 'lv_obj_clear_flag(id(${page}_page_${key}_detail), LV_OBJ_FLAG_HIDDEN);'
            else:
              - homeassistant.service:
                  service: light.toggle
                  data:
                    entity_id: ${entity}

# Detail-Ebene ${name}: Helligkeit + Farbtemperatur
# WICHTIG: Wird vom Generator als LETZTES Widget der Seite erzeugt (Z-Order ganz oben)
- obj:
    id: ${page}_page_${key}_detail
    hidden: true
    x: 100
    y: 110
    width: 600
    height: 250
    scrollable: false
    bg_color: 0x0b1828
    bg_opa: 100%
    border_width: 1
    border_color: 0x213955
    border_side: INTERNAL
    radius: 16
    widgets:
      - label:
          x: 16
          y: 12
          text: "${name}"
          text_font: roboto_european_core
          text_color: 0xf4f8fc
      - button:
          id: ${page}_page_${key}_detail_close
          x: 544
          y: 10
          width: 40
          height: 36
          bg_color: 0x101f33
          radius: 8
          widgets:
            - label:
                align: CENTER
                text: "X"
                text_font: roboto_european_core_20
                text_color: 0xf4f8fc
          on_click:
            then:
              - lambda: 'lv_obj_add_flag(id(${page}_page_${key}_detail), LV_OBJ_FLAG_HIDDEN);'
      - label:
          x: 20
          y: 64
          text: "Helligkeit"
          text_font: roboto_european_core_18
          text_color: 0x8297ad
      - slider:
          id: ${page}_page_${key}_brightness
          x: 20
          y: 92
          width: 560
          height: 18
          min_value: 0
          max_value: 255
          bg_color: 0x0b1828
          bg_opa: 60%
          border_width: 1
          border_color: 0x213955
          border_side: INTERNAL
          indicator:
            bg_color: 0x20b8e6
            bg_opa: 90%
          knob:
            bg_color: 0xFFFFFF
          on_release:
            then:
              - homeassistant.service:
                  service: light.turn_on
                  data:
                    entity_id: ${entity}
                    brightness: !lambda 'return (int)x;'
      - label:
          x: 20
          y: 140
          text: "Farbtemperatur (2200-6500 K)"
          text_font: roboto_european_core_18
          text_color: 0x8297ad
      - slider:
          id: ${page}_page_${key}_color_temp
          x: 20
          y: 168
          width: 560
          height: 18
          min_value: 2200
          max_value: 6500
          bg_color: 0x0b1828
          bg_opa: 60%
          border_width: 1
          border_color: 0x213955
          border_side: INTERNAL
          indicator:
            bg_color: 0xffd700
            bg_opa: 90%
          knob:
            bg_color: 0xFFFFFF
          on_release:
            then:
              - homeassistant.service:
                  service: light.turn_on
                  data:
                    entity_id: ${entity}
                    color_temp_kelvin: !lambda 'return (int)x;'

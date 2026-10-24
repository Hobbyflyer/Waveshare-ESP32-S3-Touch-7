# ${name} (${entity}) - Rolladen: Auf/Stop/Zu + Positionsanzeige
- obj:
    id: ${page}_page_${key}_panel
    x: ${x}
    y: ${y}
    width: ${w}
    height: ${h}
    scrollable: false
    bg_color: 0x101f33
    bg_opa: 80%
    border_width: 1
    border_color: 0x213955
    border_side: INTERNAL
    radius: 12
- label:
    id: ${page}_page_${key}_label
    x: ${label_x}
    y: ${label_y}
    text: "${name}"
    text_font: roboto_european_core_18
    text_color: 0xf4f8fc
- label:
    id: ${page}_page_${key}_position_value
    x: ${pos_x}
    y: ${label_y}
    width: 70
    height: 24
    text: "-- %"
    text_align: RIGHT
    text_font: roboto_european_core_18
    text_color: 0x20b8e6
- button:
    id: ${page}_page_${key}_up
    x: ${btn_x}
    y: ${btn_y}
    width: ${btn_w}
    height: 26
    bg_color: 0x0b1828
    bg_opa: 80%
    border_width: 1
    border_color: 0x213955
    border_side: INTERNAL
    radius: 8
    widgets:
      - label:
          align: CENTER
          text: "Auf"
          text_font: roboto_european_core_18
          text_color: 0x20b8e6
    on_click:
      then:
        - homeassistant.service:
            service: cover.open_cover
            data:
              entity_id: ${entity}
- button:
    id: ${page}_page_${key}_stop
    x: ${stop_x}
    y: ${btn_y}
    width: ${btn_w}
    height: 26
    bg_color: 0x0b1828
    bg_opa: 80%
    border_width: 1
    border_color: 0x213955
    border_side: INTERNAL
    radius: 8
    widgets:
      - label:
          align: CENTER
          text: "Stop"
          text_font: roboto_european_core_18
          text_color: 0xf4f8fc
    on_click:
      then:
        - homeassistant.service:
            service: cover.stop_cover
            data:
              entity_id: ${entity}
- button:
    id: ${page}_page_${key}_down
    x: ${down_x}
    y: ${btn_y}
    width: ${btn_w}
    height: 26
    bg_color: 0x0b1828
    bg_opa: 80%
    border_width: 1
    border_color: 0x213955
    border_side: INTERNAL
    radius: 8
    widgets:
      - label:
          align: CENTER
          text: "Zu"
          text_font: roboto_european_core_18
          text_color: 0x20b8e6
    on_click:
      then:
        - homeassistant.service:
            service: cover.close_cover
            data:
              entity_id: ${entity}

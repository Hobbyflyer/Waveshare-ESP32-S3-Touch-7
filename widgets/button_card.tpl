# ${name} -> ${service}
- button:
    id: ${page}_page_${key}_button
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
    radius: 10
    widgets:
      - label:
          align: CENTER
          text: "${name}"
          text_font: roboto_european_core
          text_color: 0x20b8e6
    on_click:
      then:
        - homeassistant.service:
            service: ${service}
${service_data_block}

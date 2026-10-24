# ${name} (${entity})
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
    text_font: roboto_european_core_20
    text_color: 0xf4f8fc
- switch:
    id: ${page}_page_${key}_toggle
    x: ${switch_x}
    y: ${switch_y}
    width: 48
    height: 24
    bg_color: 0x0b1828
    bg_opa: 80%
    border_width: 1
    border_color: 0x213955
    border_side: INTERNAL
    checked:
      bg_color: 0x20b8e6
      bg_opa: 90%
    on_value:
      then:
        - homeassistant.service:
            service: !lambda 'return x ? "${domain}.turn_on" : "${domain}.turn_off";'
            data:
              entity_id: ${entity}

# ${name} (gebunden an number:${bind})
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
- slider:
    id: ${page}_page_${key}_slider
    x: ${slider_x}
    y: ${slider_y}
    width: ${slider_w}
    height: 16
    min_value: ${min}
    max_value: ${max}
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
    on_value:
      then:
        - lambda: |-
            id(${bind}).publish_state(x);
            lv_label_set_text_fmt(id(${page}_page_${key}_value), "%d ${unit}", (int)x);
- label:
    id: ${page}_page_${key}_value
    x: ${label_x}
    y: ${value_y}
    width: 200
    height: 26
    text: "- ${unit}"
    text_font: roboto_european_core_18
    text_color: 0x20b8e6

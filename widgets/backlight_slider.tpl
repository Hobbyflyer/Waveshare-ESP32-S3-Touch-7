# ${name} (lokales Backlight, kein HA-Call)
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
    min_value: 10
    max_value: 255
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
    on_value:
      then:
        - lambda: |-
            auto call = id(lcdbacklight_brightness).turn_on();
            call.set_brightness(x / 255.0);
            call.perform();

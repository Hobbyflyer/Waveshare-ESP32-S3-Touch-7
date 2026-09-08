# Header Specifications

## Overview
A persistent top status bar visible across all pages.
Defined in `ui/header.yaml`, included in the `top_layer` of `ui/lvgl.yaml`.

## Layout (Frosted Glass Style)
- **Container**: `obj`
  - **Position**: x=10, y=10
  - **Size**: 780x40 px
  - **Style**: Dark blue (`0x2a3f5f`), 1px internal border (`0x5599dd`), radius 10.
  - **Scrollable**: `false`

## Content
1.  **WiFi Signal Label** (`wifi_signal_label`)
    -   **Position**: Left (x=15, align: `LEFT_MID`)
    -   **Text**: "WiFi: --" (Updated via WiFi component events)
    -   **Color**: White (`0xf0f0f0`)

## Logic
-   **WiFi updates**: Handled in `common/wifi.yaml` (updates `wifi_signal_label` on connect/signal change).
-   **Time display**: Lives on the Main Page (`main_page_time_display`), not in the header.
    Updated every 1s via `interval` in `ui/resources.yaml`.

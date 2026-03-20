# Header Specifications

## Overview
A persistent top status bar visible across all pages.
Implemented as part of the `top_layer` in `main.yaml`.

## Layout (Frosted Glass Style)
- **Container**: `obj`
  - **Position**: x=10, y=10
  - **Size**: 780x40 px
  - **Style**: Dark blue (`0x2a3f5f`), 1px internal border (`0x5599dd`), radius 10.
  - **Scrollable**: `false`

## Content
1.  **WiFi Signal Label** (`wifi_signal_label`)
    -   **Position**: Left (x=15, align: `LEFT_MID`)
    -   **Text**: "WiFi: --" (Updated via lambda/interval)
    -   **Color**: White (`0xf0f0f0`)
2.  **Time Label** (`homeassistant_time_label`)
    -   **Position**: Right (x=-15, align: `RIGHT_MID`)
    -   **Text**: "--:--" (Updated via interval every 10s)
    -   **Color**: Cyan (`0x1ba1d1`)
    -   **Font**: `roboto_european_core`

## Logic
-   **Updates**:
    -   WiFi signal strength is updated periodically.
    -   Time is updated every 10 seconds via `interval` in `main.yaml`.

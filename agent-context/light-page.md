# Light Page (`light_page`)

## Usage
Control interface for smart lights organized by zones.

## Architecture
- **ID**: `light_page`
- **File**: `pages/light_page.yaml`
- **Design Theme**: Frosted Glass (panels with semi-transparent dark blue backgrounds).

## Widgets
### TV Light Panel
-   **Container**: `light_page_tv_panel` (Frosted Glass style).
-   **Label**: "TV-Licht".
-   **Toggle Switch**: `light_page_tv_toggle`.
    -   Controls `light.licht_tv` via HA service `light.turn_on/off`.
    -   Updates state based on interaction.
-   **Brightness Slider**: `light_page_tv_brightness`.
    -   Range: 0-255.
    -   Controls brightness of `light.licht_tv`.
    -   Updates on release and drag (optionally).

## Planned Widgets (TODO)
-   **Living Room Area**: 4 Spots group.
-   **Cabinet Light**
-   **Dining Area Light**

## Navigation Notes
-   **Swipe Protection**: Custom lambda in `on_gesture` prevents page swipes when interacting with sliders (checks touch coordinates).

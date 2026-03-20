# Settings Page (`settings_page`)

## Usage
System configuration and local device settings.

## Architecture
- **ID**: `settings_page`
- **File**: `pages/settings_page.yaml`
- **Design Theme**: Frosted Glass.

## Widgets
### Display Brightness
-   **Panel**: `settings_page_brightness_panel`.
-   **Slider**: `settings_page_brightness_slider`.
    -   Range: 10-255.
    -   Directly controls the local LCD backlight (`lcdbacklight_brightness`).

### Display Timeout
-   **Panel**: `settings_page_timeout_panel`.
-   **Slider**: `settings_page_timeout_slider`.
    -   Range: 10-180 seconds.
    -   Updates `display_timeout` number entity.
-   **Value Label**: `settings_page_timeout_value` (e.g., "60 s").
    -   Updates dynamically when slider moves.

## Dependencies
-   `entities/global_vars.yaml`: Defines `display_timeout`.
-   `waveshare-esp32-s3-touch-lcd-7-bl.yaml`: Defines `lcdbacklight_brightness`.

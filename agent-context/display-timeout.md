# Display Timeout & Dimming

## Overview
The display automatically dims or turns off after a period of inactivity to save power. Touching the screen restores the display.

## Implementation Details

### Configuration Entities
Defined in `entities/global_vars.yaml`:
-   **`display_timeout`**: Number entity (10-300s). Sets how long the screen stays active.
-   **`display_dim_level`**: Number entity (0-100%). Sets the brightness level when dimmed (0% = Off).
-   **`display_active`**: Boolean global. Tracks if the display is currently in Active state.
-   **`original_brightness`**: Float global. Stores the brightness level before dimming to restore it later.
-   **`last_touch_time`**: Timestamp of the last interaction (used for manual tracking if native idle isn't sufficient).

### Logic
**Idle Detection**:
-   **LVGL Native**: In `ui/lvgl.yaml` under `lvgl: on_idle`.
    -   Timeout is dynamically set from `id(display_timeout).state`.
    -   When triggered:
        1.  Saves current brightness to `original_brightness`.
        2.  Sets `display_active` to `false`.
        3.  Sets backlight to `display_dim_level`.
-   The 1s `interval` in `entities/global_vars.yaml` only syncs the brightness
    slider with external (HA) brightness changes — the manual timeout check was
    removed in favor of the native LVGL idle handling.

**Wake-up**:
-   Handled by the touchscreen `on_touch` handler in `waveshare/waveshare-esp32-s3-touch-lcd-7.yaml`.
-   Restores brightness from `original_brightness` or a default value.
-   Sets `display_active` to `true`.
-   Resets idle timer.

### Syncing
-   **Settings Page**: The timeout slider in `settings_page.yaml` updates the `display_timeout` entity.
-   **Boot / Reconnect**: The `sync_ui_state` script (`entities/scripts.yaml`) syncs the
    `display_timeout` and brightness values to the sliders. It is called from `on_boot`
    and `api.on_client_connected` in `main.yaml`.

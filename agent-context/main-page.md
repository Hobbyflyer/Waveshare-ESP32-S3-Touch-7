# Main Page (`main_page`)

## Usage
The central dashboard for the smart home controller.

## Architecture
- **ID**: `main_page`
- **File**: `pages/main_page.yaml`

## Widgets (Current State)
- **Background**: Full-screen image `main_background`.
- **Swipe Logic**: Standard navigation logic.

## Planned Widgets (TODO)
Based on placeholders and entity definitions:
1.  **Thermostat Control**:
    -   Display current temperature (`thermostat_current_temp`).
    -   Display target temperature (`thermostat_target_temp`).
    -   Controls to adjust target temperature.
2.  **Weather Display**:
    -   Current Temperature (`weather_temperature`).
    -   Humidity (`weather_humidity`).
    -   Condition (`weather_condition`).
3.  **Scene Buttons**:
    -   Quick actions for common scenes.

## Dependencies
- `entities/thermostat.yaml`: Provides sensor entities.
- `entities/weather.yaml`: Provides weather entities.

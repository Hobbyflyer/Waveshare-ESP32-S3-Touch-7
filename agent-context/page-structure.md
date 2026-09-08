# Page Structure & Navigation

## Overview
The UI consists of 3 horizontal pages that can be navigated via swipe or footer buttons.
The navigation is cyclical (Main ↔ Light ↔ Settings ↔ Main).

## Page List
1. **Main Page** (`main_page`) (Index 0)
   - Home screen with Thermostat, Weather, and Scene controls.
2. **Light Page** (`light_page`) (Index 1)
   - Detailed light controls for different room zones.
3. **Settings Page** (`settings_page`) (Index 2)
   - Configuration for Display brightness, timeout, and other system settings.

## Navigation Logic
- **State Tracking**: `current_page_index` (int, 0-2) in `global_vars.yaml` tracks the active page.
- **Swipe Gestures**:
  - **Left Swipe**: Move to Next Page (`(index + 1) % 3`).
  - **Right Swipe**: Move to Previous Page (`(index - 1 + 3) % 3`).
  - Implemented in `on_gesture` of each page YAML.
  - Exceptions: Initial check in `light_page` prevents swipe when touching sliders.
- **Footer Buttons**:
  - Buttons in the footer (top layer) execute the shared `change_page` script
    (`entities/scripts.yaml`) with `direction: -1` / `1`, which updates the index
    and the page name label. The actual page switch is done by `lvgl.page.previous` / `lvgl.page.next`.
- **Page Name Label**:
  - Updated centrally by the `change_page` script for footer navigation;
    swipe gestures still update it via inline lambdas in each page YAML.

## Common Elements
- **Header**: Top status bar (WiFi, Time).
- **Footer**: Bottom navigation bar.
- **Background**: Shared background image `main_background`.

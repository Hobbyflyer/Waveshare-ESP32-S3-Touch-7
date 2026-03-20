# Footer Specifications

## Overview
A persistent bottom navigation bar visible across all pages.
Implemented as part of the `top_layer` in `main.yaml`.

## Layout (Frosted Glass Style)
The footer is split into three distinct floating elements rather than a single continuous bar.

### 1. Previous Button
-   **Type**: `button`
-   **ID**: `nav_prev_button`
-   **Position**: x=10, y=430
-   **Size**: 80x40 px
-   **Style**: Dark blue (`0x2a3f5f`), radius 20.
-   **Content**: Label "<" (Cyan `0x1ba1d1`, Centered).
-   **Action**: 
    -   Updates `current_page_index` (cyclical decrement).
    -   Updates page name label.
    -   Triggers `lvgl.page.previous`.

### 2. Page Name Container
-   **Type**: `obj`
-   **Position**: x=100, y=430
-   **Size**: 600x40 px
-   **Style**: Dark blue (`0x2a3f5f`), radius 20.
-   **Content**: 
    -   **Label** (`page_name_label`): Displays current page name ("Main", "Light", "Settings").
    -   **Color**: White (`0xf0f0f0`), Centered.

### 3. Next Button
-   **Type**: `button`
-   **ID**: `nav_next_button`
-   **Position**: x=710, y=430
-   **Size**: 80x40 px
-   **Style**: Dark blue (`0x2a3f5f`), radius 20.
-   **Content**: Label ">" (Cyan `0x1ba1d1`, Centered).
-   **Action**: 
    -   Updates `current_page_index` (cyclical increment).
    -   Updates page name label.
    -   Triggers `lvgl.page.next`.

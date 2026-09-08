# Footer Specifications

## Overview
A persistent bottom navigation bar visible across all pages.
Defined as three widget files (`ui/footer_prev.yaml`, `ui/footer_center.yaml`, `ui/footer_next.yaml`),
included in the `top_layer` of `ui/lvgl.yaml`.

## Layout (Frosted Glass Style)
The footer is split into three distinct floating elements rather than a single continuous bar.

### 1. Previous Button (`ui/footer_prev.yaml`)
-   **Type**: `button`
-   **ID**: `nav_prev_button`
-   **Position**: x=10, y=430
-   **Size**: 80x40 px
-   **Style**: Dark blue (`0x2a3f5f`), radius 20.
-   **Content**: Label "<" (Cyan `0x1ba1d1`, Centered).
-   **Action**:
    -   Executes script `change_page` with `direction: -1` (updates `current_page_index` cyclically and the page name label).
    -   Triggers `lvgl.page.previous`.

### 2. Page Name Container (`ui/footer_center.yaml`)
-   **Type**: `obj`
-   **Position**: x=100, y=430
-   **Size**: 600x40 px
-   **Style**: Dark blue (`0x2a3f5f`), radius 20.
-   **Content**:
    -   **Label** (`page_name_label`): Displays current page name ("Main", "Light", "Settings").
    -   **Color**: White (`0xf0f0f0`), Centered.

### 3. Next Button (`ui/footer_next.yaml`)
-   **Type**: `button`
-   **ID**: `nav_next_button`
-   **Position**: x=710, y=430
-   **Size**: 80x40 px
-   **Style**: Dark blue (`0x2a3f5f`), radius 20.
-   **Content**: Label ">" (Cyan `0x1ba1d1`, Centered).
-   **Action**:
    -   Executes script `change_page` with `direction: 1` (updates `current_page_index` cyclically and the page name label).
    -   Triggers `lvgl.page.next`.

## Shared Logic
Page index tracking and label updates are centralized in the `change_page` script
(`entities/scripts.yaml`). Page names live in a single array there — adding a page
only requires extending the array and the `pages:` list in `ui/lvgl.yaml`.

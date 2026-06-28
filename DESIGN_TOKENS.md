# Design Tokens Reference

This document maps out the design tokens parsed from `references/DESIGN.md` and `references/tokens.json`.

---

## 1. Color Palette

The design system is nearly monochrome, featuring a stone-white canvas, near-black typography/borders, and a single cobalt accent for critical actions.

| Token Name | Hex Value | Flutter Color Code | Description & Usage |
| :--- | :--- | :--- | :--- |
| **Paper Stone** | `#f5f5f4` | `Color(0xFFF5F5F4)` | Base page canvas (Surface 0) |
| **Chalk** | `#e6e3e2` | `Color(0xFFE6E3E2)` | Supporting surface / bands (Surface 1) |
| **Ink Black** | `#111111` | `Color(0xFF111111)` | Primary headings, body text, icons |
| **Graphite** | `#222222` | `Color(0xFF222222)` | Secondary headings, titles |
| **Fog Gray** | `#78716b` | `Color(0xFF78716B)` | Muted helper text, tertiary labels |
| **Smoke** | `#646464` | `Color(0xFF646464)` | Secondary icons, disabled UI |
| **Ice Line** | `#d1dee8` | `Color(0xFFD1DEE8)` | Hairline borders, card outlines |
| **Ash** | `#d7d3d1` | `Color(0xFFD7D3D1)` | Link underlines, light dividers |
| **Charcoal Block**| `#45403c` | `Color(0xFF45403C)` | Dark neutral button fill (Surface 3) |
| **Pure White** | `#ffffff` | `Color(0xFFFFFFFF)` | Inverse text, card surfaces (Surface 2) |
| **Cobalt Stamp** | `#165dfb` | `Color(0xFF165DFB)` | Violet/blue accent, primary CTAs |

---

## 2. Typography

The sole brand display and text family is **Figtree**. **Inter** is used purely as a utility fallback.

### Figtree Configuration & Scaling

* **Letter-Spacing Rules:**
  * Displays / Large Headlines ($Size \ge 35\text{px}$): Negative tracking (scales with size).
  * Body & Captions ($Size < 21\text{px}$): Normal tracking.

| Role | Size | Line Height | Letter Spacing (em) | Font Weight | Mapped Style |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Caption** | 14px | 1.43 | Normal | 400 (Regular) | `caption` |
| **Body** | 16px | 1.50 | Normal | 400 (Regular) | `body` |
| **Body LG** | 18px | 1.50 | Normal | 500 (Medium) | `body-lg` |
| **Subheading**| 21px | 1.50 | Normal | 500 (Medium) | `subheading` |
| **Heading SM**| 35px | 1.25 | -0.016em (-0.56px) | 500 (Medium) | `heading-sm` |
| **Heading** | 45px | 1.25 | -0.014em (-0.63px) | 600 (SemiBold) | `heading` |
| **Display** | 58px | 1.10 | -0.016em (-0.93px) | 600 (SemiBold) | `display` |

---

## 3. Spacing System

| Spacing Token | Pixel Value | usage |
| :--- | :--- | :--- |
| `--spacing-6` | 6px | Tight margins |
| `--spacing-10`| 10px | Small inner padding |
| `--spacing-11`| 11px | Small inner padding |
| `--spacing-12`| 12px | Compact item gaps |
| `--spacing-20`| 20px | Card & container padding |
| `--spacing-22`| 22px | Button padding / content separation |
| `--spacing-30`| 30px | Moderate section spacing |
| `--spacing-40`| 40px | Section gaps |
| `--spacing-43`| 43px | Section gaps |
| `--spacing-50`| 50px | Large section gaps |
| `--spacing-56`| 56px | Wide layout padding |
| `--spacing-57`| 57px | Wide layout padding |
| `--spacing-58`| 58px | Wide layout padding |
| `--spacing-80`| 80px | Extra wide section spacing |
| `--spacing-100`| 100px | Hero padding |
| `--spacing-140`| 140px | Footer spacing |

---

## 4. Shapes & Borders

### Corner Radii

* **Cards / Buttons / Badges / Image Container:** `8.8px` (Signature corner radius)
* **Decorative / Large Surfaces:** `15px`
* **Brand Mark:** `120px` (Fully circular)

### Elevation

* **Shadows:** Strictly forbidden (`0` shadow).
* **Affordances:** Color shifts (Paper Stone vs Chalk vs White) and hairline `1px` Ice Line borders communicate layout division.

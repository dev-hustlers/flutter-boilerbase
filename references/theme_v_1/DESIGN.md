---
name: Lexicon Minimalist
colors:
  surface: '#f7f9ff'
  surface-dim: '#d7dae0'
  surface-bright: '#f7f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f1f4f9'
  surface-container: '#ebeef4'
  surface-container-high: '#e5e8ee'
  surface-container-highest: '#e0e3e8'
  on-surface: '#181c20'
  on-surface-variant: '#424753'
  inverse-surface: '#2d3135'
  inverse-on-surface: '#eef1f7'
  outline: '#737784'
  outline-variant: '#c2c6d5'
  surface-tint: '#105ac0'
  primary: '#003f8d'
  on-primary: '#ffffff'
  primary-container: '#0055bb'
  on-primary-container: '#bed1ff'
  inverse-primary: '#aec6ff'
  secondary: '#5c5f60'
  on-secondary: '#ffffff'
  secondary-container: '#e1e3e4'
  on-secondary-container: '#626566'
  tertiary: '#762900'
  on-tertiary: '#ffffff'
  tertiary-container: '#9c3a02'
  on-tertiary-container: '#ffc4ac'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d8e2ff'
  primary-fixed-dim: '#aec6ff'
  on-primary-fixed: '#001a42'
  on-primary-fixed-variant: '#004396'
  secondary-fixed: '#e1e3e4'
  secondary-fixed-dim: '#c5c7c8'
  on-secondary-fixed: '#191c1d'
  on-secondary-fixed-variant: '#454748'
  tertiary-fixed: '#ffdbcd'
  tertiary-fixed-dim: '#ffb597'
  on-tertiary-fixed: '#360f00'
  on-tertiary-fixed-variant: '#7e2c00'
  background: '#f7f9ff'
  on-background: '#181c20'
  surface-variant: '#e0e3e8'
typography:
  display-lg:
    fontFamily: Source Serif 4
    fontSize: 34px
    fontWeight: '700'
    lineHeight: 41px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: Source Serif 4
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Source Serif 4
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  title-sm:
    fontFamily: Inter
    fontSize: 17px
    fontWeight: '600'
    lineHeight: 22px
    letterSpacing: -0.01em
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
  meta-xs:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  unit: 4px
  stack-xs: 4px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 24px
  gutter: 16px
  margin-mobile: 16px
  margin-desktop: 32px
  max-width-content: 680px
---

## Brand & Style
The design system is centered on the pursuit of knowledge through clarity. It draws inspiration from editorial encyclopedic design—specifically the iOS Wikipedia app—prioritizing content density without sacrificing legibility. The personality is authoritative yet accessible, acting as a neutral vessel for diverse information.

The design style is a blend of **Minimalism** and **Modern Corporate**, utilizing a high-contrast typographic pairing to distinguish between "content" and "interface." The UI stays out of the way, using a "paper-white" primary surface and subtle tonal shifts to organize complex data. The emotional response should be one of focus, reliability, and academic rigor.

## Colors
The palette is strictly functional. We utilize a high-reflectance white for the main canvas to mimic digital paper. 

- **Primary:** A scholarly, deep blue reserved exclusively for interactive elements like links, primary buttons, and active states.
- **Secondary/Surface:** A very light grey used for card backgrounds and grouping elements to provide soft contrast against the white background.
- **Neutral:** A range of greys from nearly black for body text to mid-greys for secondary metadata.
- **Borders:** Extremely thin, light grey strokes are used to define boundaries in information-dense views.

## Typography
This design system employs a dual-font strategy. **Source Serif 4** provides an authoritative, editorial feel for content headers and article titles. **Inter** handles the functional UI, navigation, and dense body text, ensuring maximum legibility at small sizes.

Text hierarchy is strictly enforced:
- Use Serif for "On This Day," "Featured Article," and Section Headers.
- Use Sans-serif for all interactive labels, buttons, and system metadata.
- Maintain tight line-heights for labels but generous leading (1.5x) for long-form body text.

## Layout & Spacing
The layout follows a **Fixed-Fluid hybrid** model. On mobile, it uses a standard 16px side margin. On desktop, content is constrained to a 680px centered column to preserve optimal line length for reading, while UI chrome stretches to fill the viewport.

Spacing is tight and organized. We use a 4px base increment. Vertical rhythms should prioritize grouping related information closely (8px between a title and its summary) while using larger gaps (24px+) to separate distinct editorial sections.

## Elevation & Depth
Depth is communicated through **Tonal Layering** rather than shadows. 
- **Level 0 (Base):** Pure white (#FFFFFF) background.
- **Level 1 (Surface):** Light grey (#F8F9FA) containers.
- **Level 2 (Active/Pressed):** A slightly darker grey (#E5E7EB).

Avoid drop shadows entirely. Instead, use 1px hair-line borders to separate cards or sticky headers. If a modal or sheet is used, apply a dimming overlay to the background but keep the sheet itself flat with a crisp border.

## Shapes
The shape language is "Soft" yet disciplined. While standard cards use a 0.5rem (8px) radius to feel modern and mobile-friendly, interactive elements like inputs and buttons remain subtle. 

- **Cards:** 8px to 12px radius.
- **Buttons/Inputs:** 8px radius.
- **Images:** Should always have a subtle 4px to 8px radius or a 1px inner border to prevent "bleeding" into the white background.

## Components
- **Buttons:** Primary buttons are solid Blue with White text. Secondary buttons are ghost-style with Blue text and no border. 
- **Cards:** Use the secondary surface color (#F8F9FA) with no shadow. Cards should contain a 16px internal padding.
- **List Items:** Use 1px bottom borders. Include a chevron (SF Symbol style) for navigable rows. Metadata should be in `meta-xs` grey.
- **Chips:** Small, 4px rounded rectangles with a light grey fill and `label-caps` text for categories or tags.
- **Input Fields:** Flat white background with a 1px grey border. On focus, the border thickens or changes to the primary blue.
- **Search Bar:** A rounded-pill shape with a light grey fill, featuring a thin-stroke magnifying glass icon.
- **Icons:** Use thin-stroke (1pt or 1.5pt) weights. Icons are never filled unless they represent an "active" state in a bottom tab bar.
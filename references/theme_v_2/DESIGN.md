---
name: Lexicon Scholar
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
  on-surface-variant: '#434653'
  inverse-surface: '#2d3135'
  inverse-on-surface: '#eef1f7'
  outline: '#737784'
  outline-variant: '#c3c6d5'
  surface-tint: '#2259bf'
  primary: '#094cb2'
  on-primary: '#ffffff'
  primary-container: '#3366cc'
  on-primary-container: '#e7ebff'
  inverse-primary: '#b1c5ff'
  secondary: '#5e5e5e'
  on-secondary: '#ffffff'
  secondary-container: '#e1dfdf'
  on-secondary-container: '#626262'
  tertiary: '#505354'
  on-tertiary: '#ffffff'
  tertiary-container: '#696b6c'
  on-tertiary-container: '#ebeced'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d9e2ff'
  primary-fixed-dim: '#b1c5ff'
  on-primary-fixed: '#001946'
  on-primary-fixed-variant: '#00419d'
  secondary-fixed: '#e4e2e2'
  secondary-fixed-dim: '#c7c6c6'
  on-secondary-fixed: '#1b1c1c'
  on-secondary-fixed-variant: '#464747'
  tertiary-fixed: '#e1e3e4'
  tertiary-fixed-dim: '#c5c7c8'
  on-tertiary-fixed: '#191c1d'
  on-tertiary-fixed-variant: '#454748'
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
  body-lg:
    fontFamily: Hanken Grotesk
    fontSize: 17px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Hanken Grotesk
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: Hanken Grotesk
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Hanken Grotesk
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  container-padding: 1.25rem
  stack-gap-lg: 1.5rem
  stack-gap-md: 1rem
  stack-gap-sm: 0.5rem
  card-padding: 1.5rem
---

## Brand & Style

This design system embodies the intellectual rigor of a library combined with the effortless utility of modern mobile interfaces. It is designed for deep reading, knowledge discovery, and curation. The aesthetic is a refined hybrid of **Minimalism** and **Glassmorphism**, emphasizing high-quality typography and spatial clarity.

The visual narrative focuses on "Information as Art." By utilizing expansive whitespace, subtle depth through translucent layers, and a sophisticated serif-led hierarchy, the system creates a focused environment that reduces cognitive load while maintaining a premium, scholarly feel.

## Colors

The palette is rooted in a "Paper and Ink" philosophy. The primary background is not a stark white but a warm, book-like parchment (`#F5F1E8`) to reduce eye strain during long reading sessions. 

- **Primary:** A scholarly blue used sparingly for interactive elements, links, and primary actions.
- **Surface:** Uses high-transparency whites and off-whites to create the glass-morphic stacking effect.
- **Dark Mode:** Should transition to deep charcoals and blacks while maintaining the blue accent, ensuring that card borders remain subtle yet visible.

## Typography

The typography strategy balances traditional editorial authority with modern legibility. **Source Serif 4** is utilized for all "content" roles—headlines, article titles, and quotes—evoking a literary feel. **Hanken Grotesk** provides a clean, functional counterpoint for UI labels, navigation, and metadata.

Hierarchy is strictly enforced through scale and weight. Secondary information (e.g., "From English Wikipedia") should use a reduced opacity and smaller sans-serif size to ensure the serif titles remain the focal point.

## Layout & Spacing

This design system utilizes a **Fluid Grid** with generous safe areas. The layout philosophy is "Content First," allowing text blocks to breathe.

- **Margins:** Standard mobile horizontal padding is 20px (1.25rem).
- **Vertical Rhythm:** Content blocks are separated by wide gaps (24px) to distinguish between different "Today" cards and feed items.
- **Glass Overlays:** The top navigation and bottom tab bar occupy the full width but use backdrop filters to allow the content to scroll visually beneath them, maintaining a sense of place.

## Elevation & Depth

Depth is achieved through a combination of **Glassmorphism** and **Tonal Layering**.

- **Navigation Layers:** The top header and bottom navigation use a `saturate(180%) blur(20px)` backdrop filter with a semi-transparent background (`rgba(255, 255, 255, 0.8)`).
- **Cards:** Content cards sit on the base layer with a very subtle, large-radius shadow (0px 4px 20px rgba(0,0,0,0.04)) and a thin 1px border that is only slightly darker than the background.
- **Floating Elements:** Search bars and Floating Action Buttons (FABs) utilize a higher elevation with a more pronounced shadow to indicate their immediate interactability over the scrolling content.

## Shapes

The shape language is defined by organic, approachable curves. While cards use a standard **Rounded (0.5rem)** corner, primary interaction points—specifically search bars and the persistent navigation container—are **Pill-shaped (Full Radius)**. This contrast helps the user distinguish between passive content containers and active navigation tools.

## Components

### Navigation Bars
Top and bottom bars must feature a backdrop blur. The bottom navigation is a floating "pill" container that sits above the safe area, rather than being pinned to the bottom edge.

### Cards
Cards are the primary content vessel. They feature generous internal padding (24px), a subtle 1px border (`#E5E5E5`), and no heavy shadows. The title within the card is always Source Serif 4.

### Search Bar
A persistent, pill-shaped input field. It should include a search icon on the leading edge and a subtle "Search..." placeholder in Hanken Grotesk.

### Floating Action Buttons (FAB)
Circular or pill-shaped buttons (e.g., the Search/magnifying glass toggle) should be clearly separated from the bottom nav bar, appearing as a distinct floating layer to indicate secondary or global utility.

### Inputs & Chips
- **Chips:** Used for filtering (e.g., "All articles", "Reading lists"). These are pill-shaped with a light grey fill when inactive and a solid primary fill when active.
- **Lists:** Clean, borderless rows with high-contrast icons for "Saved," "History," and "Places."
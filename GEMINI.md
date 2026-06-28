# Engineering Rules & Constraints

## 1. Design System & Styling Strict Compliance
- YOU MUST ONLY use the design tokens (colors, spacing, radii, typography metadata) defined at this exact URL: https://styles.refero.design/style/409d92b9-00a8-4e21-a430-ab95ea48204f (or the local references folder at `references/`).
- Do not guess, hallucinate, or fallback to default Material 3 or Cupertino color schemes unless explicitly specified in the referenced tokens.

## 2. Typography & Fonts
- Hard constraint: Only use the specific fonts specified in the provided design system layout (Figtree).
- Generate or update `pubspec.yaml` to include these asset fonts, and place the corresponding font files in `assets/fonts/`.

## 3. Localization & Languages
- The app must strictly only support English via flutter_localizations.
- All hardcoded UI strings are forbidden; generate ARB files strictly for these permitted languages.

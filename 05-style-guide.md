# Task 5 — Style Guide: ParSU-LostAndFound

## 1. Color palette

| Color role | Hex code | Usage |
|---|---|---|
| Primary | `#76253F` | Main buttons, links, active navigation, headings |
| Background | `#F8F7F8` | Main page background |
| Text | `#20202A` | Headings, paragraphs, and form labels |
| Success | `#176A45` | Successful actions and approved-claim messages |
| Error | `#B42318` | Validation errors and rejected-action messages |

White (`#FFFFFF`) is used as a supporting neutral for cards, form fields, and text on the primary button.

### Accessibility check (WCAG AA)

- **Body text:** `#20202A` on `#F8F7F8` = **15.10:1** — **Pass**.
- **Primary button label:** `#FFFFFF` on `#76253F` = **9.97:1** — **Pass**.

Both exceed the WCAG AA minimum of **4.5:1** for normal-sized text. Ratios were calculated using the WCAG relative-luminance contrast formula.

## 2. Typography

- **Heading font:** Poppins, with Arial and sans-serif fallbacks.
- **Body font:** Inter, with Arial and sans-serif fallbacks.
- **Base font size:** 16px.
- **Headings:** Bold (700–800), with larger sizes for page titles.

## 3. UI components

| Component | Style |
|---|---|
| **Primary button** | Maroon `#76253F` background, white bold text, 12px rounded corners, comfortable padding; used for **Add Item** and **Save**. |
| **Secondary button** | White background, maroon text and border, 12px rounded corners; used for **Cancel** and **Back**. |
| **Text input / select / textarea** | White fill, thin light-grey border, 12px rounded corners, 12px padding, visible label above, and a clear focus outline. Required fields show `*`. |
| **Error message** | Red `#B42318` text immediately below the incorrect field, explaining what the user should fix (example: “Please choose a category.”). |

## 4. CSS custom properties

```css
:root {
  --color-primary: #76253F;
  --color-bg: #F8F7F8;
  --color-text: #20202A;
  --color-success: #176A45;
  --color-error: #B42318;

  --font-heading: "Poppins", Arial, sans-serif;
  --font-body: "Inter", Arial, sans-serif;
  --radius: 12px;
}

html { font-size: 16px; }
```


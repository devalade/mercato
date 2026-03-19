# Mercato Design System

## Overview

Mercato is a modern, professional inventory management system designed with a focus on clarity, efficiency, and user experience. This design system establishes the visual language and interaction patterns for the entire application.

## Design Principles

1. **Clarity First**: Information should be immediately scannable and understandable
2. **Efficiency**: Common actions should be accessible within 2 clicks
3. **Consistency**: Unified visual language across all pages
4. **Feedback**: Clear visual feedback for all user actions
5. **Accessibility**: WCAG 2.1 AA compliant design

## Color Palette

### Primary Colors
```
Primary:        #6366f1 (Indigo-500)
Primary Dark:   #4f46e5 (Indigo-600)
Primary Light:  #818cf8 (Indigo-400)
```

### Secondary Colors
```
Secondary:      #8b5cf6 (Violet-500)
Secondary Dark: #7c3aed (Violet-600)
```

### Semantic Colors
```
Success:        #22c55e (Green-500)
Success Light:  #dcfce7 (Green-100)
Info:           #3b82f6 (Blue-500)
Info Light:     #dbeafe (Blue-100)
Warning:        #f59e0b (Amber-500)
Warning Light:  #fef3c7 (Amber-100)
Error:          #ef4444 (Red-500)
Error Light:    #fee2e2 (Red-100)
```

### Neutral Colors
```
Gray-50:   #f9fafb  (Background)
Gray-100:  #f3f4f6  (Card Background)
Gray-200:  #e5e7eb  (Borders)
Gray-300:  #d1d5db  (Disabled)
Gray-400:  #9ca3af  (Placeholder)
Gray-500:  #6b7280  (Secondary Text)
Gray-600:  #4b5563  (Body Text)
Gray-700:  #374151  (Heading Text)
Gray-800:  #1f2937  (Dark Text)
Gray-900:  #111827  (Darker Text)
```

### Status Colors
```
En Stock:      #22c55e (Green)     - bg: rgba(34, 197, 94, 0.1)
Affecté:       #3b82f6 (Blue)      - bg: rgba(59, 130, 246, 0.1)
Hors Service:  #ef4444 (Red)       - bg: rgba(239, 68, 68, 0.1)
Expiré:        #f59e0b (Amber)     - bg: rgba(245, 158, 11, 0.1)
```

## Typography

### Font Family
```css
font-family: 'Inter', system-ui, -apple-system, sans-serif;
```

### Type Scale
```
Display:     2.25rem  (36px)  - font-bold    - Page titles
H1:          1.875rem (30px)  - font-bold    - Section headers
H2:          1.5rem   (24px)  - font-semibold - Card titles
H3:          1.25rem  (20px)  - font-semibold - Subsection titles
H4:          1.125rem (18px)  - font-medium   - List headers
Body:        1rem     (16px)  - font-normal   - Paragraphs
Small:       0.875rem (14px)  - font-normal   - Secondary text
XSmall:      0.75rem  (12px)  - font-medium   - Labels, badges
```

### Line Heights
```
Headings:  1.2
Body:      1.5
Small:     1.4
```

## Spacing System

### Base Unit: 4px
```
1:   4px
2:   8px
3:   12px
4:   16px
5:   20px
6:   24px
8:   32px
10:  40px
12:  48px
16:  64px
```

### Layout Spacing
```
Page Padding:     24px (1.5rem)
Card Padding:     20px (1.25rem)
Section Gap:      24px (1.5rem)
Component Gap:    16px (1rem)
Inner Gap:        12px (0.75rem)
```

## Components

### Buttons

#### Primary Button
```css
background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
color: white;
padding: 0.625rem 1.25rem;
border-radius: 0.5rem;
font-weight: 500;
box-shadow: 0 1px 3px rgba(99, 102, 241, 0.3);
transition: all 0.2s ease;
```

#### Secondary Button
```css
background: white;
border: 1px solid #e5e7eb;
color: #374151;
padding: 0.625rem 1.25rem;
border-radius: 0.5rem;
```

#### Ghost Button
```css
background: transparent;
color: inherit;
padding: 0.5rem;
border-radius: 0.375rem;
```

#### Button Sizes
```
Small:   padding: 0.375rem 0.75rem;  font-size: 0.875rem;
Medium:  padding: 0.625rem 1.25rem; font-size: 1rem;
Large:   padding: 0.875rem 1.5rem;  font-size: 1rem;
```

### Cards

#### Standard Card
```css
background: white;
border: 1px solid #e5e7eb;
border-radius: 0.75rem;
box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
transition: box-shadow 0.2s ease;
```

#### Hover State
```css
box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
transform: translateY(-1px);
```

#### Alert Card Variants
```css
/* Warning Alert */
border-left: 4px solid #f59e0b;
background: linear-gradient(to right, rgba(245, 158, 11, 0.05), white);

/* Error Alert */
border-left: 4px solid #ef4444;
background: linear-gradient(to right, rgba(239, 68, 68, 0.05), white);

/* Success Alert */
border-left: 4px solid #22c55e;
background: linear-gradient(to right, rgba(34, 197, 94, 0.05), white);
```

### Forms

#### Input Fields
```css
background: white;
border: 1px solid #e5e7eb;
border-radius: 0.5rem;
padding: 0.625rem 0.875rem;
font-size: 0.875rem;
transition: all 0.2s ease;

&:focus {
  border-color: #6366f1;
  box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
  outline: none;
}
```

#### Select Dropdowns
```css
/* Same as input fields */
appearance: none;
background-image: url("data:image/svg+xml,..."); /* Chevron icon */
background-position: right 0.75rem center;
```

#### Form Sections
```css
border-bottom: 1px solid #e5e7eb;
padding-bottom: 1.5rem;
margin-bottom: 1.5rem;

.section-title {
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #6b7280;
  margin-bottom: 1rem;
}
```

### Tables

#### Table Header
```css
background: #f9fafb;
font-weight: 600;
font-size: 0.75rem;
text-transform: uppercase;
letter-spacing: 0.05em;
color: #6b7280;
padding: 0.75rem 1rem;
```

#### Table Row
```css
border-bottom: 1px solid #e5e7eb;
padding: 1rem;
transition: background-color 0.15s ease;

&:hover {
  background-color: #f9fafb;
}
```

#### Action Buttons in Tables
```css
/* Compact icon buttons */
width: 2rem;
height: 2rem;
padding: 0;
border-radius: 0.375rem;
opacity: 0.7;

&:hover {
  opacity: 1;
  background-color: rgba(0, 0, 0, 0.05);
}
```

### Badges

#### Status Badges
```css
/* Base */
display: inline-flex;
align-items: center;
gap: 0.375rem;
padding: 0.375rem 0.75rem;
border-radius: 9999px;
font-size: 0.75rem;
font-weight: 600;

/* Variants */
&.badge-success { background: rgba(34, 197, 94, 0.1); color: #15803d; }
&.badge-info { background: rgba(59, 130, 246, 0.1); color: #1d4ed8; }
&.badge-warning { background: rgba(245, 158, 11, 0.1); color: #b45309; }
&.badge-error { background: rgba(239, 68, 68, 0.1); color: #b91c1c; }
```

### Navigation

#### Sidebar
```css
width: 280px;
background: white;
border-right: 1px solid #e5e7eb;
padding: 1.5rem;

/* Active Item */
background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(139, 92, 246, 0.1) 100%);
color: #4f46e5;
border-radius: 0.5rem;
font-weight: 500;
```

#### Top Navigation
```css
height: 64px;
background: white;
border-bottom: 1px solid #e5e7eb;
padding: 0 1.5rem;
position: sticky;
top: 0;
z-index: 30;
```

### Empty States

```css
display: flex;
flex-direction: column;
align-items: center;
justify-content: center;
padding: 4rem 2rem;
text-align: center;

.empty-icon {
  width: 5rem;
  height: 5rem;
  background: #f3f4f6;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 2rem;
  color: #9ca3af;
  margin-bottom: 1.5rem;
}

.empty-title {
  font-size: 1.125rem;
  font-weight: 600;
  color: #374151;
  margin-bottom: 0.5rem;
}

.empty-description {
  font-size: 0.875rem;
  color: #6b7280;
  margin-bottom: 1.5rem;
}
```

## Page Layouts

### Dashboard Layout
```
┌─────────────────────────────────────────────────────────────┐
│  Sidebar    │  Header (sticky)                              │
│  (280px)    │  - Breadcrumbs                                │
│             │  - Notifications                              │
│             │  - User menu                                  │
│             ├───────────────────────────────────────────────┤
│             │                                               │
│  Navigation │  Page Header                                  │
│  - Links    │  - Title + Actions                            │
│  - Sections │                                               │
│             │  Stats Grid (4 cols)                          │
│             │  ┌─────┬─────┬─────┬─────┐                    │
│             │  │Stat │Stat │Stat │Stat │                    │
│             │  └─────┴─────┴─────┴─────┘                    │
│             │                                               │
│             │  Alerts Section (if any)                      │
│             │                                               │
│             │  ┌──────────────────┬──────────────────┐      │
│             │  │  Category Chart  │  Recent Activity │      │
│             │  └──────────────────┴──────────────────┘      │
│             │                                               │
└─────────────────────────────────────────────────────────────┘
```

### List Page Layout
```
┌─────────────────────────────────────────────────────────────┐
│  Sidebar    │  Page Header                                  │
│             │  - Title + Subtitle + Actions                 │
│             │                                               │
│             │  Filter Bar                                   │
│             │  - Search | Category | Status | Actions       │
│             │                                               │
│             │  Data Table                                   │
│             │  ┌──────────────────────────────────────┐     │
│             │  │ Header Row                           │     │
│             │  ├──────────────────────────────────────┤     │
│             │  │ Data Row 1                           │     │
│             │  │ Data Row 2                           │     │
│             │  │ ...                                  │     │
│             │  └──────────────────────────────────────┘     │
│             │                                               │
│             │  Results Summary                              │
│             │  - Count | Pagination (if needed)             │
│             │                                               │
└─────────────────────────────────────────────────────────────┘
```

### Form Page Layout
```
┌─────────────────────────────────────────────────────────────┐
│  Sidebar    │  Page Header                                  │
│             │  - Title + Back Button                        │
│             │                                               │
│             │  Form Card (max-width: 768px)                 │
│             │  ┌──────────────────────────────────────┐     │
│             │  │ Section 1: Identification            │     │
│             │  │ - Reference                          │     │
│             │  │ - Designation                        │     │
│             │  ├──────────────────────────────────────┤     │
│             │  │ Section 2: Classification            │     │
│             │  │ - Category                           │     │
│             │  │ - Purchase Date                      │     │
│             │  ├──────────────────────────────────────┤     │
│             │  │ Section 3: Stock Management          │     │
│             │  │ - Quantity                           │     │
│             │  │ - Lifetime                           │     │
│             │  ├──────────────────────────────────────┤     │
│             │  │ Form Actions                         │     │
│             │  │ [Cancel]              [Save]         │     │
│             │  └──────────────────────────────────────┘     │
│             │                                               │
└─────────────────────────────────────────────────────────────┘
```

### Detail Page Layout
```
┌─────────────────────────────────────────────────────────────┐
│  Sidebar    │  Page Header                                  │
│             │  - Title + Actions (Edit, Delete)             │
│             │                                               │
│             │  Info Cards Grid (2 cols)                     │
│             │  ┌────────────────────┬────────────────────┐  │
│             │  │  General Info      │  Status Card       │  │
│             │  └────────────────────┴────────────────────┘  │
│             │                                               │
│             │  Quick Actions Bar                            │
│             │  [Stock Entry] [Assign] [Stock Exit]          │
│             │                                               │
│             │  History Timeline                             │
│             │  ┌──────────────────────────────────────┐     │
│             │  │ ○ Entry - Date - Details             │     │
│             │  │ ○ Assignment - Date - Details        │     │
│             │  │ ○ ...                                │     │
│             │  └──────────────────────────────────────┘     │
│             │                                               │
└─────────────────────────────────────────────────────────────┘
```

## Animations & Transitions

### Micro-interactions
```css
/* Button Hover */
transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
transform: translateY(-1px);
box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);

/* Card Hover */
transition: box-shadow 0.2s ease, transform 0.2s ease;
box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
transform: translateY(-2px);

/* Table Row Hover */
transition: background-color 0.15s ease;

/* Modal/Dialog */
transition: opacity 0.2s ease, transform 0.2s ease;
transform: scale(0.95);
opacity: 0;

&.open {
  transform: scale(1);
  opacity: 1;
}
```

### Loading States
```css
/* Skeleton Loading */
background: linear-gradient(
  90deg,
  #f3f4f6 25%,
  #e5e7eb 50%,
  #f3f4f6 75%
);
background-size: 200% 100%;
animation: shimmer 1.5s infinite;

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

## Responsive Breakpoints

```
Mobile:      < 640px   (sm)
Tablet:      640px+    (sm)
Small Desk:  768px+    (md)
Desktop:     1024px+   (lg)
Large:       1280px+   (xl)
Extra Large: 1536px+   (2xl)
```

### Responsive Behavior

#### Sidebar
- Desktop: Fixed, always visible (280px)
- Tablet/Mobile: Drawer, hidden by default

#### Stats Grid
- Desktop: 4 columns
- Tablet: 2 columns
- Mobile: 1 column

#### Tables
- Desktop: Full table with all columns
- Tablet: Horizontal scroll or column toggle
- Mobile: Card view (convert rows to cards)

#### Forms
- Desktop: 2-3 columns
- Mobile: Single column stacked

## Iconography

### Icon Sizes
```
XSmall:  12px - Inline with text
Small:   14px - Table actions
Medium:  16px - Buttons, inputs
Large:   20px - Navigation
XLarge:  24px - Page headers
2XLarge: 32px - Empty states
```

### Icon Usage Guidelines
- Use Font Awesome 6.x solid style
- Keep icons consistent within contexts
- Always pair with text for primary actions
- Use color to indicate state (success, error, warning)

## UX Improvements Recommendations

### 1. Dashboard Enhancements
- Add sparkline charts for trends
- Include quick action buttons in stat cards
- Show percentage changes (vs last week/month)
- Add "View All" links to recent activity

### 2. List View Improvements
- Add bulk actions (select multiple rows)
- Implement column sorting
- Add export functionality (CSV, PDF)
- Show filters as chips when active

### 3. Form Improvements
- Add inline validation with real-time feedback
- Implement autosave for long forms
- Add "Previous Values" comparison in edit mode
- Use stepper for multi-section forms

### 4. Detail Page Enhancements
- Add image/document uploads
- Include QR code generation
- Show relationship graphs (employee <-> materials)
- Add comments/notes section

### 5. Navigation Improvements
- Add keyboard shortcuts (e.g., Ctrl+K for search)
- Implement breadcrumbs with dropdown history
- Add recently viewed items
- Include global search

### 6. Feedback & Notifications
- Replace alert banners with toast notifications
- Add confirmation dialogs for destructive actions
- Show loading spinners for async operations
- Implement undo functionality where applicable

## Implementation Notes

### CSS Architecture
- Use Tailwind CSS utility classes
- Extend with custom CSS for complex components
- Maintain consistent class ordering

### Accessibility
- All interactive elements must be keyboard accessible
- Use ARIA labels where needed
- Maintain color contrast ratio of 4.5:1 minimum
- Support screen readers

### Performance
- Lazy load images and heavy components
- Use CSS transitions over JavaScript animations
- Implement virtual scrolling for large tables
- Cache static assets

## Design Tokens

```javascript
// tailwind.config.js extension
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eef2ff',
          100: '#e0e7ff',
          200: '#c7d2fe',
          300: '#a5b4fc',
          400: '#818cf8',
          500: '#6366f1',
          600: '#4f46e5',
          700: '#4338ca',
          800: '#3730a3',
          900: '#312e81',
        }
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
      boxShadow: {
        'card': '0 1px 3px rgba(0, 0, 0, 0.1)',
        'card-hover': '0 8px 25px rgba(0, 0, 0, 0.1)',
        'button': '0 1px 3px rgba(99, 102, 241, 0.3)',
      }
    }
  }
}
```

## File Structure

```
web/
├── css/
│   ├── custom.css           # Current custom styles
│   └── design-system.css    # New design tokens & utilities
├── js/
│   ├── main.js             # Current scripts
│   └── ui-components.js    # Interactive components
└── WEB-INF/
    └── views/
        ├── template.jsp
        ├── dashboard.jsp
        ├── login.jsp
        ├── materiels/
        │   ├── list.jsp
        │   ├── form.jsp
        │   └── detail.jsp
        └── employes/
            ├── list.jsp
            ├── form.jsp
            └── detail.jsp
```

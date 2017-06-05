# LANDING PAGE - CMS

- The landing page container will contain two container references:
  1) A header container that holds a maximum of ONE header module (REQUIRED).
  2) A rows container that can hold several types (MIN/MAX?) of row modules (REQUIRED).

- There are two high-level types of core 'row' modules for the rows container:
  1) A combination type, which can contain various combinations of smaller modules (e.g. small / medium / large) as defined further below.
  2) A single type, which can contain only one of two full-width large modules (e.g. copy block / email capture).

#### REMAINING TASKS
  - Implement Full-Width Editorial block (discuss w/ Dorothy).
  - Implement Full-Width Email block.
  - Add Email Capture option to `_HEADER--lg__md-sm2.erb`.
  - Add Text Size option to copy blocks.
  - Add Shoppable + Mini-Editorial block (`_ROW--sm3_mini` && `_ROW--mini_sm3`).
  - Correct block alignment issues.
  - Properly cache initial call.

## HEADER
  - FULL-WIDTH COPY BLOCK
    - Partial Name: `__HEADER--xl-text.erb`
  - LARGE || MEDIUM / SMALL * 2
    - Partial Name: `_HEADER--lg__md-sm2.erb`
  - FULL-WIDTH EDITORIAL
    - Partial Name: `_HEADER--xl-editorial.erb`

## ROW

- Combination Containers (add alignment options later, but duplicate flipped partials for now...):

  - LARGE || MEDIUM / SMALL * 2
    - Partial Name: `_ROW--lg__md-sm2.erb`
  - MEDIUM / SMALL * 2 || LARGE
    - Partial Name: `_ROW--md-sm2__lg.erb`

  - LARGE || SMALL * 4
  - LARGE || SMALL * 3
    - Partial Name: `_ROW--lg__sm4.erb`
  - SMALL * 4 || LARGE
  - SMALL * 3 || LARGE
    - Partial Name: `_ROW--sm4__lg.erb`

  - SMALL * 4
    - Partial Name: `_ROW--sm4.erb`

- Copy Container:
  - FULL-WIDTH COPY BLOCK
    - Partial Name: `_ROW--xl-text.erb`

- E-Mail Container:
  - FULL-WIDTH EMAIL BLOCK
    - Partial Name: `_ROW--xl-email.erb`

## SMALL
- Product (Image)
  - Partial Name: `_ITEM--sm.erb`

## MEDIUM
- Copy Block
  - Partial Name: `_ITEM--md-text.erb`

## LARGE
- Image Block?
  - Partial Name: `_ITEM--lg.erb`


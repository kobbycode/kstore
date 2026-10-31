# Kstore

Responsive, dependency-free shopping storefront based on the inspected reference flows, with original Kstore branding.

## Run locally

Requires Node.js 18+.

- Run: npm run dev
- Open: http://127.0.0.1:4173
- Syntax check: npm run check
- Static production files: dist/

No dependency installation or build step is required. The static files can also be served by any static host.

## Implemented demo flows

- Home merchandising, categories, official-store and brand filtering.
- Search suggestions with keyboard navigation, query URL state, price/category/brand filters, sorting, pagination and empty results.
- Product specifications, variants, unavailable options, size guide, image enlargement, seller following and purchase-linked reviews.
- Cart addition, quantity limits, totals, removal and save-for-later.
- Demo profile, saved items, address create/edit/default/delete, dependent region/city selection, pickup filtering and saved stations.
- Door/pickup checkout, required destination validation, WELCOME10 voucher, invalid-code feedback, payment selection and final acknowledgment.
- Demo order creation, details, reorder, cancellation, simulated delivery and return request.
- Vouchers, pending reviews, sellers, inbox empty state, newsletter preferences, help/policy pages and contact-form demo feedback.
- Responsive layouts and native dialog with focus wrapping, Escape dismissal and focus restoration.

## Boundaries

All application data lives in this browser's localStorage under kstore-v1. Sign-in is a demo identity form, not secure authentication. Products, availability, shipping fees, reviews and promotions are fixtures. Payment methods are selections only: no credentials are collected and no gateway is called. Orders, fulfillment, returns and refunds are simulations. Contact inquiries and newsletter confirmations are local UI feedback, not sent messages.

The inbox presents an empty state; a map is not required for the functional station list. This version does not include seller administration, real inventory reservation, payment webhooks, actual shipment tracking, or operational support messaging.

Before live commerce: add authenticated server persistence, ownership checks, catalog/inventory service, authoritative shipping/tax/promotion quotes, idempotent order creation, payment provider sandbox and verified webhooks, fulfillment integrations, production policies and monitoring.

## Verification

20 connected browser checks passed during development: variant add, quantity arithmetic, checkout sign-in, delivery gate, saved address, payment step, invalid/valid voucher, discount arithmetic, selected MTN method, acknowledgment gate, one order with empty cart, demo delivery, return request, pickup filters/persistence, unavailable sizes, dialog opening, wishlist, empty search and price sort. Local QA output is retained in qa-results.json (not deployed). A 390-pixel mobile view had matching viewport/document widths and no failed product images in the captured homepage.

Images use remote Unsplash photo URLs, with Google Fonts for typography. A live catalog should replace illustrative product photos and sample specifications with licensed accurate assets.

## Product gallery and logo update

Product galleries have thumbnail selection, previous/next navigation and an accessible viewport-filling dialog. The viewer supports 100–400% zoom, reset, wheel zoom, double-click, drag pan, pinch zoom, mobile swipe, keyboard arrows/Home/End/+/-/0, and optional browser fullscreen. Escape closes and restores focus. Size variants remain separate from image selection and have per-variant demo stock limits.

The phone and Bekia shoe use inspected reference image sets (3 and 7 photos). Other illustrative products have a full photo plus a labeled crop of that same photo; these are not claimed as different camera angles. Remote image loading has a viewer error/retry state.

Generated brand asset: dist/assets/kstore-logo.png. A matching simplified vector mark is used as favicon. The logo was generated with the built-in image-generation tool. The full prompt is retained in BRAND.md.

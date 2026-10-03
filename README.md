# Khayt — خيط · Fashion Store (portfolio demo)

A **fictional** fashion atelier built with **Flutter / Dart** to showcase front-end,
animation and UI skills. Nothing here is a real business: the brand, the people,
the reviews, the prices and the company details are invented, and **no real payment
is ever processed**.

> Designed and built by Muhammed Elhuseyin.

**Live demo:** <https://housinasaad-creator.github.io/khayt-fashion-store/>

## Highlights

- **A storefront that changes colour with the product** — the hero slideshow, the rail and
  every product page re-tint the whole site (background, accents, buttons, shadows) to the
  colour of the piece you are looking at.
- **Hanger-rail carousel** — products hang on a rail and swing like real garments,
  driven by scroll/drag momentum (pendulum physics).
- **Flip-card products** — pointer-following 3D tilt, and a hanging-tag flip that reveals
  details and a size picker.
- Fly-to-bag animation, photo zoom, kinetic hero text, marquee.
- **Full shopping flow** — shop (filter / search / sort), product pages, bag drawer + bag page,
  promo code, shipping & tax maths, checkout, order confirmation.
- **Simulated card payment** — Visa/Mastercard detection from the card number, Luhn check,
  expiry/CVC validation, fake processing step and a fake 3-D Secure code step.
  Nothing leaves the page.
- **Bilingual English / Arabic** with real RTL layout.
- **Responsive** — phone, tablet and desktop layouts.
- **Light on the browser** — photos only (no WebGL or 3D), and the animated strips pause
  themselves when they are off screen or idle.
- **Complete legal/info pages** — Privacy Policy, Terms of Service, Shipping & Returns,
  FAQ, About, Contact (all clearly marked as fictional).

## Try it

Demo values for the checkout:

| What | Value |
| --- | --- |
| Test cards | Visa `4242 4242 4242 4242` · Mastercard `5555 5555 5555 4444` |
| Expiry / CVC | any future date / any 3 digits |
| 3-D Secure code | any 6 digits |
| Promo code | `KHAYT10` (10 % off) |

Shipping is free over €120 (otherwise €9, express €14).
All prices are in euros and include VAT (19 %).

## Run the pre-built site

Double-click **`run-store.bat`** (needs Python), or from this folder:

```bash
python -m http.server 8080 --directory build/web
```

then open <http://localhost:8080>. Routing uses `#/…` URLs, so any static host works.

## Build from source

```bash
flutter pub get
flutter run -d chrome                                   # development
flutter build web --release --no-tree-shake-icons      # production -> build/web
```

Notes:

- `--no-tree-shake-icons` is only needed if the project path contains non-ASCII characters
  (this folder name does — the Flutter icon-font step fails on such paths otherwise).
- `flutter analyze` can also crash on non-ASCII paths; analyse from an ASCII-path copy.
- To host under a sub-path (e.g. GitHub Pages `/khayt/`), add `--base-href /khayt/`.
- There are no web-only plugins, so the same code can also be built for Android/iOS
  (mobile builds have not been tested yet).

## Structure

```
lib/
  main.dart                 app, routes, locale
  core/                     state (cart, accent colour, language), strings (EN/AR), navigation
  data/                     products, legal & info copy
  ui/theme.dart             colours, type, theme
  ui/widgets/               shell, hanger rail, product card, cart, fly-to-bag
  ui/screens/               home, shop, product, cart, checkout, order, info pages
assets/
  images/products/          product photos
```

## Credits & licences

- Product photographs are from [Unsplash](https://unsplash.com) (used under the Unsplash licence).
- Fonts via `google_fonts`: Playfair Display, Inter, Cairo (SIL Open Font Licence).
- Flutter — BSD-3-Clause.

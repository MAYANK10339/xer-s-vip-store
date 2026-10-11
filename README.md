# XER'S VIP STORE

A professional full-stack commerce starter with a responsive storefront and a separate admin console.

## Run locally

Requires Node.js 18+. From this folder run `npm install`, then `npm start`, and visit `http://localhost:3000`. Open `http://localhost:3000/admin.html` to administer the shop. For local demo only, admin login is `admin@xvip.xer` / `xvip@123`.

Before deployment, set `ADMIN_EMAIL`, `ADMIN_PASSWORD`, and a long random `JWT_SECRET` in the process environment. `.env.example` documents the settings; the server does not automatically parse `.env` files. Set variables in your shell or hosting provider.

## Features

The storefront includes a dark-blue liquid-glass UI, bottom navigation for Home / Ordered products / Profile, product search and category filters, product cards, cart add/remove, signup/sign-in, checkout with saved delivery address, and order history. The admin console provides summary metrics, product add/remove, image upload and hosted image URL options, order status management, account ban/unban, and INR wallet balance editing. Product image upload accepts JPEG, PNG, WebP, or GIF up to 5 MB. The image prompt helper prepares a copyable prompt for an external image generator; a generation API is not connected. Seed product records include remote product photography.

Orders are paid from the demo wallet balance. Users can add wallet money with the secret code configured as `WALLET_TOPUP_CODE` (default `xvip786`); admin can also edit balances. Orders are blocked when wallet balance is ₹0 or lower than the cart total. No real payment gateway is connected. Persistence is a local JSON file in `data/store.json`, intended only for a simple starter/demo; uploads are stored locally in `uploads/`.

## Production checklist

Before real commerce use, migrate to a transactional database; add payment processing, robust input validation, rate limiting, CSRF defenses, secure session handling and audit logs; use object storage and inspect uploaded files; configure backups, monitoring, HTTPS, and secret management. The wallet is an admin-managed balance field, not a payment or regulated stored-value system.

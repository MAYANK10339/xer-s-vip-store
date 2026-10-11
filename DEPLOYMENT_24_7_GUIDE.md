# 🚀 24/7 Cloud Server Deployment Guide (Free Hosting)

To keep **XER'S VIP STORE** and Admin Console online 24/7 even when your PC is turned off, you can deploy the backend to a free cloud hosting provider.

---

## Method 1: Render.com (Recommended - 100% Free & Fast)

1. **Create an account** on [Render.com](https://render.com) (free).
2. Click **New** -> **Web Service**.
3. Connect your GitHub repository containing this project (or upload the folder).
4. Configure the settings:
   - **Name**: `xers-vip-store`
   - **Environment**: `Node`
   - **Build Command**: `npm install`
   - **Start Command**: `node server.js`
   - **Instance Type**: `Free`
5. Click **Create Web Service**.
6. Render will give you a public URL like `https://xers-vip-store.onrender.com`.
   - **Customer Storefront**: `https://xers-vip-store.onrender.com/user.html`
   - **Admin Console**: `https://xers-vip-store.onrender.com/admin.html`

---

## Method 2: Railway.app (Zero-Config Deployment)

1. Go to [Railway.app](https://railway.app) and log in with GitHub.
2. Click **New Project** -> **Deploy from GitHub repo**.
3. Select this project repository.
4. Railway automatically detects `Node.js`, runs `npm install`, and executes `node server.js`.
5. Go to **Settings** -> **Generate Domain** to get your permanent public URL.

---

## Method 3: Docker Deployment

A `Dockerfile` is included in your project folder. You can deploy it to any VPS (DigitalOcean, AWS, Heroku, Fly.io):

```bash
docker build -t xers-vip-store .
docker run -p 3000:3000 xers-vip-store
```

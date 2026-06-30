# Frontend — WSO2 Identity Platform learning demo

A minimal React + Vite app that logs in via OIDC (Authorization Code + PKCE,
using `react-oidc-context`) against **WSO2 Identity Platform (Asgardeo)**,
then calls the Ballerina `social_media` API with the resulting access token.

This was built to learn https://wso2.com/identity-platform/docs hands-on.
It currently runs against Asgardeo (cloud); a local WSO2 Identity Server
also works since both speak standard OIDC — see "Using local WSO2 IS instead"
below.

## 1. Create an Asgardeo app (one-time)

1. Sign up at `https://console.asgardeo.io` and create an organization.
2. **Applications → New Application → React** (or "Single Page Application").
   Name it, set **Authorized redirect URL** to `http://localhost:3000`.
3. From the app's Guide/Info tab, copy the **Client ID** and confirm the
   **Base URL** (`https://api.asgardeo.io/t/<your-organization-name>`).
4. **User Management → Users → Add User** to create a test user — you can't
   sign in with the console admin account directly via the hosted login page.

## 2. Configure

```bash
cp .env.example .env
```

Fill in `.env`:

```
VITE_OIDC_AUTHORITY=https://api.asgardeo.io/t/<your-organization-name>/oauth2/token
VITE_OIDC_CLIENT_ID=<client ID from step 1>
VITE_OIDC_REDIRECT_URI=http://localhost:3000
VITE_API_BASE_URL=https://localhost:9090/social_media
```

All four variables are required — a missing `VITE_API_BASE_URL` is a real
bug we hit during setup: the API call silently targets the Vite dev server
itself instead of the backend, and you get
`Unexpected token '<', "<!doctype "` because it's parsing Vite's
`index.html` as JSON. If you see that error, check `.env` first.

Sanity-check the OIDC endpoint before running:
```bash
curl https://api.asgardeo.io/t/<your-organization-name>/oauth2/token/.well-known/openid-configuration
```
This should return JSON. No `-k`/cert flags needed — Asgardeo uses a
real, browser-trusted certificate.

## 3. Trust the backend's local cert (one-time, per browser)

The Ballerina backend (`backend/main.bal`) uses a self-signed TLS cert.
Browsers block `fetch` to untrusted certs silently, so open this once in a
new tab and click through the "not secure" warning before testing the app:

- `https://localhost:9090/social_media/users`

## 4. Run

```bash
npm install
npm run dev
```

Open `http://localhost:3000`, click **Log in with WSO2** — you'll be
redirected to Asgardeo's hosted login page, then back to the app once
authenticated with the test user from step 1.

## What to expect

- **Profile card** — ID token claims (`iss`, `sub`, `org_name`, `username`,
  etc.) — proof the OIDC flow worked.
- **Access token card** — the token sent as `Authorization: Bearer <token>`
  on API calls.
- **API card** — calls `GET /social_media/users` and
  `GET /social_media/users/{id}/posts`. **This currently returns 401.**
  The backend's `oauth2IntrospectionConfig` in `main.bal` introspects
  tokens against a **local WSO2 Identity Server**
  (`https://localhost:9445/oauth2/introspect`), but the access token here
  was issued by **Asgardeo** — different issuer, so introspection
  correctly rejects it. This is expected, and a real lesson about how
  OIDC issuers and introspection endpoints have to match.

  To make the API call actually succeed, pick one:
  - Point `main.bal`'s introspection config at Asgardeo's introspection
    endpoint (`https://api.asgardeo.io/t/<org>/oauth2/introspect`), using
    a Asgardeo machine-to-machine application's client ID/secret as the
    Basic-auth credentials, **or**
  - Register this app against your local WSO2 IS instead (see below) so
    both pieces trust the same issuer.

## Using local WSO2 IS instead

If you'd rather run everything locally against the same WSO2 Identity
Server your backend already expects:

1. In the IS Management Console (`https://localhost:9445/carbon`):
   **Main → Identity → Service Providers → Add**. Set Callback URL to
   `http://localhost:3000`, enable **Code** grant + **PKCE mandatory**.
2. Update `.env`:
   ```
   VITE_OIDC_AUTHORITY=https://localhost:9445/oauth2/token
   VITE_OIDC_CLIENT_ID=<Client ID from the Service Provider>
   ```
3. Trust the IS's self-signed cert too — open `https://localhost:9445`
   directly in a new tab once and accept the warning.

With this path, the access token's issuer matches what `main.bal`
introspects against, so the API call should succeed (200, not 401).

## Troubleshooting

- **`Unexpected token '<', "<!doctype "` from the API call** — `.env` is
  missing `VITE_API_BASE_URL` (or it's empty), so the fetch hits Vite's
  own dev server instead of the backend. Check `.env`, restart `npm run dev`.
- **401 from the API** — issuer mismatch between the IdP you logged into
  and the IdP `main.bal` introspects against. See above.
- **OIDC error: "Failed to fetch"** — usually only happens with the local
  WSO2 IS path: either nothing's running on that port, or the browser
  hasn't trusted its self-signed cert yet (open the IS URL directly first).
- **Redirect loop or "invalid redirect_uri"** — the Authorized redirect
  URL on the registered app must match `VITE_OIDC_REDIRECT_URI` exactly,
  including trailing slashes.
- Remember: Vite only reads `.env` at startup — restart `npm run dev`
  after any change.

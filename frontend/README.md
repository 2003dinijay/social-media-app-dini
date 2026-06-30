# Frontend — WSO2 Identity learning demo

A minimal React + Vite app that logs in via OIDC against your local WSO2
Identity Server, then calls your Ballerina `social_media` API with the
resulting access token.

## 1. Configure

```bash
cp .env.example .env
```

Fill in `.env` with the values from registering the Service Provider in WSO2
IS (see the chat guide, "Step 2"):

- `VITE_OIDC_AUTHORITY` — your IS issuer URL, e.g. `https://localhost:9445/oauth2/token`
- `VITE_OIDC_CLIENT_ID` — the Client ID from the Service Provider you registered
- `VITE_OIDC_REDIRECT_URI` — must exactly match the Callback URL you set, e.g. `http://localhost:3000`
- `VITE_API_BASE_URL` — your Ballerina backend, e.g. `https://localhost:9090/social_media`

## 2. Trust the local certs (one-time, per browser)

Both your WSO2 IS and your Ballerina backend likely use self-signed TLS
certs locally. Browsers block fetch/XHR to untrusted certs silently, so
before running the app, open each of these once in a new tab and click
through the "not secure" warning:

- `https://localhost:9445` (or whatever port your IS runs on)
- `https://localhost:9090/social_media/users`

## 3. Run

```bash
npm install
npm run dev
```

Open `http://localhost:3000`. Click **Log in with WSO2**, you'll be
redirected to the IS login page, then back to the app once authenticated.

## What to expect

- **Profile card** — shows the ID token claims (proof OIDC worked).
- **Access token card** — the token your API calls send as `Authorization: Bearer <token>`.
- **API card** — calls `GET /social_media/users` and `GET /social_media/users/{id}/posts`
  on your Ballerina backend. Your backend introspects the token against
  `https://localhost:9445/oauth2/introspect` before answering — if that
  call succeeds, you've completed the full OIDC + OAuth2 introspection loop.

## Troubleshooting

- **401 from the API** — the access token's issuer doesn't match what your
  backend's introspection endpoint trusts. Double check both point at the
  *same* WSO2 IS instance/port.
- **Network error / CORS** — usually the untrusted self-signed cert issue
  in step 2, or your Ballerina service isn't running (`bal run` from the
  project root).
- **Redirect loop or "invalid redirect_uri"** — the Callback URL on the
  Service Provider in WSO2 IS must match `VITE_OIDC_REDIRECT_URI` exactly,
  including trailing slashes.

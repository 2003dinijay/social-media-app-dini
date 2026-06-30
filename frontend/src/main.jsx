import React from "react";
import ReactDOM from "react-dom/client";
import { AuthProvider } from "react-oidc-context";
import App from "./App.jsx";
import "./index.css";

// This config is the React-side half of the OIDC Authorization Code + PKCE
// flow described in the learning guide:
//   1. authority  -> tells the SDK where to fetch the IdP's
//                     /.well-known/openid-configuration (issuer = your WSO2 IS)
//   2. client_id   -> identifies THIS app to the IdP (from Service Provider reg.)
//   3. redirect_uri-> where the IdP sends the user back after login
//   4. scope       -> "openid profile" asks for an ID token with basic claims
const oidcConfig = {
  authority: import.meta.env.VITE_OIDC_AUTHORITY,
  client_id: import.meta.env.VITE_OIDC_CLIENT_ID,
  redirect_uri: import.meta.env.VITE_OIDC_REDIRECT_URI,
  scope: "openid profile",
  // WSO2 IS is commonly run with a self-signed cert locally; the browser
  // will need you to accept that cert once (see README) before discovery
  // and token requests will succeed.
};

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <AuthProvider {...oidcConfig}>
      <App />
    </AuthProvider>
  </React.StrictMode>
);

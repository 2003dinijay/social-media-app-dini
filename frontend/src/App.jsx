import { useState } from "react";
import { useAuth } from "react-oidc-context";
import { getAllUsers, getPostsForUser } from "./api.js";

export default function App() {
  const auth = useAuth();
  const [users, setUsers] = useState(null);
  const [posts, setPosts] = useState(null);
  const [apiError, setApiError] = useState(null);
  const [userIdInput, setUserIdInput] = useState("1");

  if (auth.isLoading) {
    return <p>Loading identity provider configuration…</p>;
  }

  if (auth.error) {
    return <p className="error">OIDC error: {auth.error.message}</p>;
  }

  async function handleLoadUsers() {
    setApiError(null);
    setUsers(null);
    try {
      const data = await getAllUsers(auth.user.access_token);
      setUsers(data);
    } catch (err) {
      setApiError(err.message);
    }
  }

  async function handleLoadPosts() {
    setApiError(null);
    setPosts(null);
    try {
      const data = await getPostsForUser(userIdInput, auth.user.access_token);
      setPosts(data);
    } catch (err) {
      setApiError(err.message);
    }
  }

  return (
    <div>
      <h1>🐦 Social Media — WSO2 Identity Demo</h1>

      {!auth.isAuthenticated && (
        <div className="card">
          <p>You're not logged in.</p>
          <button onClick={() => auth.signinRedirect()}>Log in with WSO2</button>
        </div>
      )}

      {auth.isAuthenticated && (
        <>
          <div className="card">
            <h2>Logged in ✅</h2>
            <p>This data came from the ID token's claims — proof the OIDC flow worked.</p>
            <pre>{JSON.stringify(auth.user?.profile, null, 2)}</pre>
            <button onClick={() => auth.removeUser()}>Log out</button>
          </div>

          <div className="card">
            <h2>Access token (truncated)</h2>
            <p>This is what gets sent as a Bearer token to your Ballerina API:</p>
            <pre>{auth.user?.access_token?.slice(0, 60)}…</pre>
          </div>

          <div className="card">
            <h2>Call your social-media API</h2>
            <button onClick={handleLoadUsers}>GET /social_media/users</button>
            {users && <pre>{JSON.stringify(users, null, 2)}</pre>}

            <div style={{ marginTop: 12 }}>
              <input
                type="number"
                value={userIdInput}
                onChange={(e) => setUserIdInput(e.target.value)}
                style={{ width: 60, marginRight: 8 }}
              />
              <button onClick={handleLoadPosts}>GET posts for this user</button>
            </div>
            {posts && <pre>{JSON.stringify(posts, null, 2)}</pre>}

            {apiError && (
              <p className="error">
                {apiError}
                <br />
                If this is a network/cert error, open{" "}
                <code>{import.meta.env.VITE_API_BASE_URL}/users</code> directly in a new
                tab once and accept the self-signed certificate warning, then retry.
                <br />
                If this is a 401, the access token's issuer doesn't match what your
                backend's introspection endpoint expects — see the README.
              </p>
            )}
          </div>
        </>
      )}
    </div>
  );
}

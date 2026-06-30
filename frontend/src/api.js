const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

// Every call here attaches the access token issued by WSO2 IS as a Bearer
// token. Your Ballerina service (main.bal) takes that token and calls
// POST https://localhost:9445/oauth2/introspect to ask the IdP "is this
// still valid, and who is it for" before letting the request through.
async function callApi(path, accessToken) {
  const response = await fetch(`${API_BASE_URL}${path}`, {
    headers: {
      Authorization: `Bearer ${accessToken}`,
    },
  });

  if (!response.ok) {
    throw new Error(`API request failed: ${response.status} ${response.statusText}`);
  }

  return response.json();
}

export function getAllUsers(accessToken) {
  return callApi("/users", accessToken);
}

export function getPostsForUser(userId, accessToken) {
  return callApi(`/users/${userId}/posts`, accessToken);
}

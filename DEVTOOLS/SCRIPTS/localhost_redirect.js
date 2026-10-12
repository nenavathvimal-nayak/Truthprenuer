const http = require('http');

const PORT = 3000;
const TARGET_ORIGIN = 'https://truthprenuer.pages.dev';

const server = http.createServer((req, res) => {
  console.log(`[Localhost Redirector] Intercepted request: ${req.url}`);
  
  // HTML with JS ensures hash fragments (#access_token=... or #error=...) are preserved and forwarded
  res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
  res.end(`<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Redirecting to Truthprenuer...</title>
  <script>
    // Forward path, search params, and hash fragment to secure production domain
    const dest = "${TARGET_ORIGIN}" + window.location.pathname + window.location.search + window.location.hash;
    console.log("Redirecting to:", dest);
    window.location.replace(dest);
  </script>
  <noscript>
    <meta http-equiv="refresh" content="0;url=${TARGET_ORIGIN}">
  </noscript>
</head>
<body style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #07090E; color: #fff; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0;">
  <div style="text-align: center; max-width: 480px; padding: 24px;">
    <div style="width: 48px; height: 48px; margin: 0 auto 16px; border: 3px solid #3B82F6; border-top-color: transparent; border-radius: 50%; animation: spin 1s linear infinite;"></div>
    <h2 style="margin: 0 0 8px; font-size: 20px;">Forwarding to Truthprenuer...</h2>
    <p style="color: #94A3B8; font-size: 14px; margin: 0;">Connecting your secure authentication session to https://truthprenuer.pages.dev</p>
  </div>
  <style>
    @keyframes spin { to { transform: rotate(360deg); } }
  </style>
</body>
</html>`);
});

server.listen(PORT, '127.0.0.1', () => {
  console.log(`[Localhost Redirector] Active on http://127.0.0.1:${PORT} -> Forwarding to ${TARGET_ORIGIN}`);
});

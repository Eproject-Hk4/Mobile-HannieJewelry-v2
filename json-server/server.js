const jsonServer = require('json-server');
const server = jsonServer.create();
const path = require('path');
const router = jsonServer.router(path.join(__dirname, 'db.json'));
const middlewares = jsonServer.defaults();
const routes = require('./routes');

// Set default middlewares (logger, static, cors and no-cache)
server.use(middlewares);

// Parse JSON request body
server.use(jsonServer.bodyParser);

// Add custom routes
routes(server);

// Use default router for standard REST API routes
server.use(router);

// Start server
const PORT = 3800;
server.listen(PORT, () => {
  console.log(`JSON Server is running on http://localhost:${PORT}`);
  console.log(`For Android emulator, access via http://10.0.2.2:${PORT}`);
});

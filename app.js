const express = require('express');
const client = require('prom-client');
const app = express();
const post = require('./routes/post'); // Import any routes you need
const hoganMiddleware = require('hogan-middleware');
const path = require('path');

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'mustache');
app.engine('mustache', hoganMiddleware.__express);

const port = 8888;
const host = '0.0.0.0';

// Prometheus metric setup
const counter = new client.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
});

// Routes
app.use(post); // Use your post routes

app.get('/ping', (req, res) => {
  counter.inc();
  res.json({ message: 'pong' });
});
app.get('/metrics', async (req, res) => {
    res.set('Content-Type', client.register.contentType);
    res.end(await client.register.metrics());
  });
  
  app.use((req, res, next) => {
    res.status(404);
    res.send('<h1>Page not found</h1>');
  });
  
  app.listen(port, host, () => {
    console.log(`Node.js Server is running on host: ${host}, port: ${port}`);
  });
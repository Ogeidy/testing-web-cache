const express        = require('express');
const app            = express();

const port = 8888;
const path = 'C:\\nodejs\\testing-web-cache\\'

require('./app/routes')(app, path);

app.listen(port, () => {
  console.log('We are live on ' + port);
});
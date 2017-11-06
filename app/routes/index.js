const fileRoutes = require('./file_routes');
module.exports = function(app, path) {
  fileRoutes(app, path);
  // Тут, позже, будут и другие обработчики маршрутов 
};
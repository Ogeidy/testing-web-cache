const fs             = require("fs");
const crypto         = require('crypto');

module.exports = function(app, path) {
	
	app.get('/file/:name', (req, res) => {
		// const filePath = path + req.params.name;
		
		res.send(crypto.randomBytes(Math.trunc(Math.random() * 31000 + 1000)));
		
		// if (!fs.existsSync(filePath)) {
			// var wstream = fs.createWriteStream(filePath);
			// wstream.write(crypto.randomBytes(Math.trunc(Math.random() * 31000 + 1000)));
			// wstream.end();
		// }
			
		// var options = {
			// dotfiles: 'deny',
		// };

		// res.sendFile(filePath, options, (err) => {
			// if (err) {
				// console.log('Can\'t sent:', '\nMessage:', filePath, err.message);
				// res.send({'error':'An error has occurred'});
			// } else {
				// console.log('Sent:', filePath);
			// }
		// });
		
	});

};
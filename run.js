

var utils = require('./grip/utils/utils'),
	config = require('./config/config.json');
	config = require('./grip/utils/gen_config')(__dirname,config);

var scope = require('./grip/utils/scope.js')(config,utils);
	core = scope('Core');

core.init();


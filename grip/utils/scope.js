var config = require('../../config/config.json'),
	path = require('path');

var scope = function(config){
	var base_delimiter = '..',
		core_path = base_delimiter+config.core.base_dir,
		dependency = {
			'Core'   : require(path.normalize(core_path+'core')),
			'Sandbox': require(path.normalize(core_path+'sandbox')),
			'Events' : require(path.normalize(core_path+'events')),
			'Config' : config
		}; 
	return function(name){
		if (dependency[name]) {
			return dependency[name];
		} else {
			return false;
		}
		
	};
}(config);

exports = module.exports = scope;
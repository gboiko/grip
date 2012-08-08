var scope = function(config,utils){
	var core_path = config.core.dir,
		fetcher = function(name){
			if (dependency[name]) {
				return dependency[name];
			} else {
				var module = null;
				try {
					var path_name = core_path+name.toLowerCase();
					module = require(path_name);
				} catch(exp) {
					console.error(exp);
				}
				if (!module){ return false; }
				dependency[name] = module;
				return  dependency[name] = dependency[name](fetcher,utils);
			}
		},
		dependency = {
			'Config' : config
		}; 
	return fetcher;
};

exports = module.exports = scope;
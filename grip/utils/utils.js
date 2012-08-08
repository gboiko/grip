exports = module.exports = function(){
	var modules = {};
	return function(name){
		if (modules[name]){
			return modules[name];
		} else {
			return module[name] = require(name);
		}
	};
}();

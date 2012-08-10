exports = module.exports = function(){
	var modules = {},
        get = function(name) {
            if (modules[name]){
                return modules[name];
            } else {
                return module[name] = require(name);
            }
        },
        bind = function(fn,context) {
            console.log(fn);
            return function(){
                return fn.apply(context,arguments);
            }
        };

	return {
        get: get,
        bind: bind
    };
}();

// Implementation of mediator pattern to act as application core


function Core (scope,utils) {
	var Sandbox = scope('Sandbox'),
		Events = scope('Events');
		config = scope('Config');
	
	console.log(utils);
		
	var bind = function (func,context){
		return function(){
			return func.apply(context,arguments);
		}
	};
	
	var Core = {
		/**
		 * Modules descriptor
		 * 
		 * @type Object
		 */
		modules: {},
		
		/**
		 * Sandboxes
		 * 
		 * @type Object
		 */
		sandboxes: {},
		
		/**
		 * Inititalize of application
		 * first loading all modules from dirs 
		 * initialize all modules
		 * 
		 * @params {Array} pathes to custom modules directories
		 * 
		 * @returns {Core}
		 */
		init: function () {
			this.loadModules(config.modules.dir);
		},
		
		/**
		 * Module loader
		 * Loads all modules that presented in specified folders
		 * 
		 * @params {String} pathes to modules directory
		 * 
		 * @returns {Boolean} load success/load fails
		 */
		loadModules: function (dir) {
			var modules = utils('fs').readdirSync(dir);
			
			modules.forEach(function(module){
				console.log(require(dir+module+'/descriptor.json'));
			});
		},
		
		/**
		 * initialize modules looking by this.modules
		 * 
		 */
		initModules: function () {
			
		},
		
		/**
		 * Init specific module
		 * 
		 * @params {String} name of module to be inited
		 * 
		 * @returns {Core}
		 */
		initModule: function (name) {
			
		},
		
		/**
		 * Destroy module
		 * 
		 * @params {String} name of module to be destroyed
		 * 
		 * @returns {Core}
		 */
		destroyModule: function (name) {
						
		},
		
		/**
		 * Get module localization
 		 * 
 		 * @param {String} name of module
 		 * 
 		 * @returns {Object} dict of lang pack
 		 */
		getLocale: function (name) {
			
		},
		
		/**
		 * Get module resources 
		 * 
 		 * @param {String} name of module
 		 * 
 		 * @returns {Object} dict of module settings
		 */
		getResource: function (name) {
			
		}
		
	};
	
	var CoreGlobals = {
		publish: 		bind(Events.publish, Events),
		subscribe:		bind(Events.subscribe, Events),
		unsubscribe: 	bind(Events.unsubscribe, Events),
		init:			bind(Core.init, Core),
		destroyModule:  bind(Core.destroyModule, Core),
		getLocales:		bind(Core.getLocale, Core),
		getResources:	bind(Core.getResource, Core)
	};
	
	return CoreGlobals;
};

exports = module.exports = Core;



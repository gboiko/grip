//Basic implementation of facade pattern to act as a sandbox for modules
//All modules sandboxed are refer to the single and same core

function Sandbox (scope) {
	var Core = scope('Core'),
		Events = scope('Events');
	
	var sid = 0;
	
	var Sandbox = function (descriptor) {
		this.descriptor = descriptor || {};
		this.namespaces = this.descriptor.name + ++sid;
	};
	
	/**
	 * Permission module check 
	 * @params 
	 * 
	 * @returns {Boolean}
	 */
	Sandbox.prototype.is = function () {
		var actions = this.descriptor.actions;
		return true;
	};
	
	/**	
	 * Event subscribe
	 * 
	 * @params {String} event name to subscribe
	 * @params {Function} callback function to be executed on event fire
	 * 
	 * @returns {Sandbox}
	 */
	Sandbox.prototype.subscribe = function (event,callback) {
				
	};
	
	/**
	 * Events unsubscribe
	 * 
	 * @params {String} event name to unsubscrive
	 * @params {Function } callback function to be executed on unsubscribe ready
	 * 
	 * @returns {Sandbox}
	 */
	Sandbox.prototype.unsubscribe = function (event,callback) {
		
	};
	
	/**
	 * Event publisher
	 * 
	 * @params {String} event name
	 * @params 			data to be published in stream
	 * 
	 * @returns {Sandbox}
	 */
	Sandbox.prototype.publish = function (event,data) {
		
	};
	
	/**
	 * Get module localization
	 * 
	 * @returns {Object} langs dict relay on current settings lang 
	 */
	Sandbox.prototype.getLocale = function () {
		
		
	};
	
	/**
	 * Get module resources
	 * 
	 * @return {Object} resources dict
	 */
	Sandbox.prototype.getResource = function () {
		
	};
		
	return Sandbox;	
};

exports = module.exports = Sandbox;


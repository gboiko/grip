function Events (scope) {
	var Events = {
		/**
		 * @type {Object}
		 * 
		 * @format
		 * 
		 * {
		 * 	"channel": {
		 * 		"namespace": [function]
	 	 * 	}
		 * }
		 * 
		 */
		channels: {},
		
		/**
		 * Event publisher
		 * 
 		 * @param {String} channel
 		 * @param {Object} data
         * @param {String} namespace
         * 
         * @returns {Boolean} true if event published false if something bad
		 */
		publish: function (channel,data,namespace) {
			
		},
		
		/**
		 * Event subscriber
		 * 
		 * @params {String} channel
		 * @params {Function} callback
		 * @params {String} namespace
		 * 
		 * @returns {Events}
		 */
		subscribe: function (channel,callback,namespace) {
			
		},
		
		/**
		 * Event unsubscriber
		 * 
		 * @params {String} channel
		 * @params {Function} callback
		 * @params {String} namespace
		 * 
		 * @returns {Events}
		 */
		unsubscribe: function (channel,callback,namespace) {
			
		}
	};
	
	return Events;
};

exports = module.exports = Events;

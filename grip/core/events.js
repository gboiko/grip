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
		 * Check if channel exist
		 * 
		 * @params {String} name of channel
		 * 
		 * @returns {Boolean} true/false
		 */
		is: function (channel) {
			if (this.channels[channel]) {return true} else { return false }
		},
		
		/**
		 * Get exisiting channel
		 * 
		 *  @params {String} channel name
		 * 
		 *  @returns {Object} dict channel 
		 */
		getChannel: function (channel) {
			return this.channels[channel];
		},
		
		/**
		 * Create channel
		 * 
		 * @params {String} channel name
		 * 
		 * @returns {Boolean} true
		 */
		createChannel: function (channel) {
			this.channels[channel] = [];
			return true;
		},
		
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
			if (this.is(channel)){
				channel = this.getChannel(channel);
				for(var i = 0, channel_length = channel.length;
					i < channel_length; i ++) {
						var subscriber = channel[i];
						subscriber(data);
					}
			} else {
				return false;
			}
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
			if (this.is(channel)) {
				this.getChannel(channel).push(callback);
			} else {
				this.createChannel(channel);
				this.getChannel(channel).push(callback);
			};
            return this;
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
}

exports = module.exports = Events;

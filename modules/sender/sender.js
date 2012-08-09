var Sender = function(sandbox){
	function Sender(sandox){
		setInterval(function(){
			console.log('Publisher data published');
			sandbox.publish('data',Math.random());
		},sandox.getResource('interval'))
	};
	
	return Sender(sandbox);
};

exports = module.exports = Sender;

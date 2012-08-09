var Sender = function(sandbox){
	function Sender(sandox){
		setInterval(function(){
			console.log('Publisher data published');
			sandbox.publish('data',Math.random());
		},1000)
	};
	
	return Sender();
};

exports = module.exports = Sender;

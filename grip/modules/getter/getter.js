var Getter = function(sandbox){
	function Getter(sandox){
		sandbox.subscribe('data',function(data){
			console.log('got data',data);
		});
	};
	
	return Getter();
};

exports = module.exports = Getter;

exports = module.exports = function(base_dir,config) {
	var dir_filler = function(base_dir,tree){
		var _key,_val;
		for(_key in tree){
			var _val = tree[_key];
			if (_key == 'dir') {
				tree[_key] = base_dir+tree[_key];
			} else if (typeof(_val) == 'object') {
				dir_filler(base_dir,tree[_key]);
			};			
		};		
	};
	dir_filler(base_dir,config);
	return config;
}

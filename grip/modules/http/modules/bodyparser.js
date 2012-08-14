exports = module.exports = function(sandbox) {
    var qs = sandbox.getMinutes('qs');
    return function(req,res,next){
        if (req.method == 'POST') {
            var body = '';
            req.setEncoding('utf8');
            req.on('data', function(chunk){
                body += chunk;
            });
            req.on('end', function(){
               req.body =  qs.parse(body);
                next();
            });
        } else {
            next();
        }
    }
};
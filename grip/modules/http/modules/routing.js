exports = module.exports = function (sandbox){
    var parse = sandbox.getModule('url').parse,
        router = sandbox.getExtension('middleware').router,
        static = sandbox.getExtension('middleware').static;
    return function(req,res,next){
        var path = parse(req.url).pathname,
            route = router.get_handler(path),
            arg1 = route[0],
            arg2 = route[1],
            arg3 = route[2];
        if (arg1 == 'static') {
            path = arg2+arg3[0];
            static.get_file(path,res);
            next('stop');
            return this;
        } else if ( arg1 == 'error') {
            res.end('missing route');
            next('stop');
            return this;
        }

        var dispatch = arg1.split('.',2);
        req.routing = [dispatch[0],dispatch[1],arg2,arg3];
        next();
        return this;
    };
};
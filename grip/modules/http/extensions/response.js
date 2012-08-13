exports = module.exports = function (sandbox){
    var http = sandbox.getModule('http');
    http.OutgoingMessage.prototype.send = function (data,code) {
        code = code || 200;
        var buffer = new Buffer(data),
            response = this;
        response.writeHead(code,{
            "Content-Type": "text/html; charset=utf-8",
            "Content-Length": buffer.length,
            'X-Powered-By': 'Lobster'
        });
        response.write(buffer);
        response.end();
        return response;
    };
    return this;
};
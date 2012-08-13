exports = module.exports = function (sandbox) {
    var http = sandbox.getModule('http');
    http.IncomingMessage.prototype.getCookie = function (name) {
        return sandbox.getExtension('middleware').cookies.get(name,this);
    };
};
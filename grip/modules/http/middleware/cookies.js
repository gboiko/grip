var Cookies = function(){

    function Cookies () {
        this.cookies_register = {};
    }

    Cookies.prototype.get = function (name,request) {
        var headers = request.headers["cookie"];
        if (!headers) { return false }

        var match = headers.match(this.get_pattern(name));
        if (!match) {
            return false
        } else {
            return match[1]
        }
    };

    Cookies.prototype.set = function (name,value,args,response) {
        var headers = response.getHeader("Set-Cookies") || [];
        var cookie = Cookie(name,value,args);

        if (typeof headers === 'string') {
            headers = [headers]
        }

        headers.push(cookie.make_header());
        return this
    };

    Cookies.prototype.get_pattern = function (name) {
        if (this.cookies_register[name]) { return  this.cookies_register[name]}
        var pattern = new RegExp("(?:^|;) *" +
            name.replace( /[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&" ) +
            "=([^;]*)");
        this.cookies_register[name] = pattern;
        return pattern;
    };
    return Cookies;
};

var Cookie = function(name,value,args){
    var value = value || "",
        path = args.path || "/",
        expires = args.expires || false,
        domain = args.domain || false,
        httponly = args.httponly || false;

    return {
        stringify : function () {
            return name+'='+value
        },
        make_header : function () {
            var header = this.stringify();
            if (path) {
                header += "; path"+path
            }
            if (expires) {
                header += "; expired"+expires
            }
            if (domain) {
                header += "; domain"+domain
            }
            if (httponly) {
                header += "; httponly"
            }
            return header
        }
    };
};

exports = module.exports = Cookies;
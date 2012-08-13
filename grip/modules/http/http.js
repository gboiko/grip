//Implementation of basic http server

var UserRegister = function (server) {
    var register = {};
    var uid = 0;
    return {
        set_user: function (req,res) {
            var uid = this.get_uid();
            register[uid] = {
                request  : req,
                response : res
            }
        },
        get_user: function (uid) {
            return register[uid]
        },
        delete_user: function (uid) {
            delete register[uid]
        },
        get_uid: function () {
            return ++uid
        }
    };
};

var ContextMaker = function (req,res,server) {
    var modules = server.get_context_modules();

    return this;
};

var Server = function(sandbox){
    function Server(sandbox){
        var http = sandbox.getModule('http'),
            port = sandbox.getResource('port'),
            host = sandbox.getResource('host');
        this.caller = sandbox.bind(this.caller,this);
        this.user_register = UserRegister(this);
        this.init();
        http = http.createServer(this.caller).listen(port,host);
        return this;
    }

    Server.prototype.init = function () {
        sandbox.getExtension('extensions');
        sandbox.getExtension('modules');
    };

    Server.prototype.caller = function (req,res) {
        res.send('Ok boy extensions seems to fosdrk');
    };

    Server.prototype.generate_context = function (req,res) {

    };

    Server.prototype.get_context_modules = function () {
        var modules_names = sandbox.getResource('context_modules').split(',');
        var modules = [];
        for(var i = 0, len = modules_names.length; i<len; i++){
            var name = require(__dirname+'/modules/'+modules_names[i]);
        }
        return modules;
    };

    sandbox.subscribe('server_events', function(data){
        if (data == 'start'){
            console.log('get');
            new Server(sandbox);
        }
    });

    return this;

};

exports = module.exports = Server;


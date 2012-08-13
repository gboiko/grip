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
        console.log('starting it devil machine');
        var http = sandbox.getModule('http');
        this.caller = sandbox.bind(this.caller,this);
        http = http.createServer(this.caller).listen(8340);
        this.user_register = UserRegister(this);
        return this;
    }

    Server.prototype.caller = function (req,res) {
        console.log(sandbox.getExtension());
        console.log(sandbox.getExtension('modules'));
        console.log(sandbox.getExtension('extensions'));
        console.log(sandbox.getExtension('middleware'));
        //console.log(this.get_context_modules());
        res.writeHead(200, {'Content-Type': 'text/plain'});
        res.end('asd');
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


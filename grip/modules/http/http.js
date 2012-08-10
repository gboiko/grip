//Implementation of basic http server

var Server = function(sandbox){
    function Server(sandbox){
        console.log('starting it devil machine');
        var http = sandbox.getModule('http');
        this.caller = sandbox.bind(this.caller,this);
        http = http.createServer(this.caller).listen(8340);
        return this;
    }

    Server.prototype.caller = function (req,res) {
        console.log('created server');
        res.writeHead(200, {'Content-Type': 'text/plain'});
        res.end('asd');
    };

    sandbox.subscribe('server_events', function(data){
        if (data == 'start'){
            new Server(sandbox);
        }
    });

    return this;

};

exports = module.exports = Server;


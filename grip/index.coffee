#get argv
args = process.argv

#load config settings
config = require('../config/config')

#load base comunication modules
HTTPServer = require('./HTTPServer/http')
WSServer = require('./WSServer/ws')

#load user managment modules
Home = require('./Home/home')

class App
    constructor: ->
        @delegated_users = {}
        @guest_users = {}
        HTTPServer = HTTPServer
            .createHttpServer(@http_in)
            .listen(config.host,config.port)
        @WSServer = WSServer
            .createWSServer(@ws_in)
            .listen(HTTPServer)
        
    http_in: (request,response) =>
        new Home.HttpInput(request,response,this)
        
    ws_in: (input) =>
        new Home.WsInput(input,this)
    
    ws_out: (uid,data) =>
        @WSServer.send(uid,data)
               
application = new App()
  


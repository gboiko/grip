routs =
#Define main urls
    "/":
      action: 'home.main'
      protected: true
    "/main":
      action: 'home.main'
      protected: true
    "/mtext":
      action: 'home.text' 
#Define authorization urls
    "/register":
      action: 'register.register'
    "/login":
      action: 'logger.log_in'
    "/logout":
      action: 'logger.log_out'

#Define tags urls
    "/tag_add":
      action: 'tag.add'
      protected: true
    "/tag_remove":
      action: 'tag.remove'
      protected: true   
#Define link urls
    "/link_preload":
      action: 'link.preload'
    "/test_fetch":
      action: 'link.testfetch'
    "/link_add":
      action: 'link.add'
      protected: true
    "/link_remove":
      action: 'link.remove'
      protected: true
    "/link_edit":
      action: 'link.edit'
      protected: true      
    "/link_view":
      action: 'link.view_all'
      protected: true        
      paths:
          "/(\\\d+)":
            action: 'link.view_one'
            regexp: true
            protected: true  
#Static file dispatcher
    "/js/***":
      static : true
      dir : '/public/js/'
    "/css/***":
      static : true
      dir : '/public/css/'
    "/images/***":
      static : true
      dir : '/public/images/'
    "/data/***":
      static : true
      dir : '/public/data/'
    "/templates/***":
      static : true
      dir : '/public/templates/'
#serve user profiles
    "\/(\\\d+)":
      action: 'profile.get'
      regexp: true
      protected: true 
#server stats
    "/stats":
      action: 'stats.info'
      paths:
        "/register":
          action: 'stats.register'
      
module.exports = routs

###
  This is basic routing table for router.coffee module.
  for defining basic url just add following structure:
      "/link_add":
        action: 'link.add'
  Possible options are :
      action: 'link.add' - define controller to process url
      protected: true/false - define if url path need user authorization
      regexp: true/false - define if url pattern should be proccesed as regexp
      paths: - Define sub path of url for example 
          paths: 
             "/remove_comment" : 
                action: 'link.remove_comment'
          will produce access to url  /link_add/remove_comment
  
       "/public/***": - *** in path says that all request to public/ will be
          proccessed with action controller and all string behind public/ will
          be passed as args
      
      "/some/*" - will pass only first slash to args
  
  if param regexp set to true , you can pass path as regexp, and regexped value
    will be passed as args
      "\/hw(\\\d+)" - will procces for url /hw213 pass 213 to controller as args          
###

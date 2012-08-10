// Implementation of mediator pattern to act as application core


function Core (scope,utils) {
    var Sandbox = scope('Sandbox'),
        Events = scope('Events');
        config = scope('Config');

    var Core;
    Core = {
        /**
         * Modules descriptor
         *
         * @type Object
         */
        modules:{},

        /**
         * Sandboxes
         *
         * @type Object
         */
        sandboxes:{},

        /**
         * Inititalize of application
         * first loading all modules from dirs
         * initialize all modules
         *
         * @params {Array} paths to custom modules directories
         *
         * @returns {Core}
         */
        init:function () {
            this.loadModules(config.modules.dir, this.modules);
            this.initModules(this.modules, this.sandboxes);
            Events.publish('server_events','start');
            return this;
        },

        /**
         * Module loader
         * Loads all modules that presented in specified folders
         *
         * @params {String} paths to modules directory
         *
         * @returns {Boolean} load success/load fails
         */
        loadModules:function (dir, modules_dispatcher) {
            var modules = utils.get('fs').readdirSync(dir);
            modules.forEach(function (module) {
               var path_to_module = dir + module + '/',
                    descriptor = null,
                    module_name = null;

                try {
                    descriptor = require(path_to_module + 'descriptor.json');
                    module_name = descriptor.name;
                    modules_dispatcher[module_name] = {
                        descriptor:descriptor,
                        name:module_name,
                        path:path_to_module
                    }
                } catch (exp) {
                    console.log(exp)
                }
            });
            return true;
        },

        /**
         * initialize modules looking by this.modules
         *
         * @params {Object} dict of modules
         * @params {Object} dict of sandboxes
         *
         * @returns {Boolean} init success/or fail
         */
        initModules:function (modules, sandboxes) {
            var _val, _key, self = this;
            for (_key in modules) {
                _val = modules[_key];
                self.initModule(_key, _val, sandboxes);
            }
            return true;
        },

        /**
         * Init specific module
         *
         * @params {String} name of module to be inited
         * @params {Object} params of module to be inited
         * @params {Object} dict of sandboxes
         *
         * @returns {Core}
         */
        initModule:function (name, params, sandboxes) {
            var sandbox = new Sandbox(params),
                module = require(params.path + name);
            sandboxes[name] = sandbox;
            new module(sandbox);
            return this
        },

        /**
         * Destroy module
         *
         * @params {String} name of module to be destroyed
         *
         * @returns {Core}
         */
        destroyModule:function (name) {

        },

        /**
         * Get module localization
         *
         * @param {String} name of module
         *
         * @returns {Object} dict of lang pack
         */
        getLocale:function (name) {

        },

        /**
         * Get module resources
         *
         * @param {String} name of module
         *
         * @returns {Object} dict of module settings
         */
        getResource:function (name) {

        }

    };

    var CoreGlobals = {
        publish:utils.bind(Events.publish, Events),
        subscribe:utils.bind(Events.subscribe, Events),
        unsubscribe:utils.bind(Events.unsubscribe, Events),
        init:utils.bind(Core.init, Core),
        destroyModule:utils.bind(Core.destroyModule, Core),
        getLocales:utils.bind(Core.getLocale, Core),
        getResources:utils.bind(Core.getResource, Core)
    };

    return CoreGlobals;
};

exports = module.exports = Core;



// This is a manifest file that'll be compiled into app.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
//
//= require jquery/jquery-2.1.1.js
//= require jquery-ui
//= require bootstrap-sprockets
//= require metisMenu/jquery.metisMenu.js
//= require pace/pace.min.js
//= require peity/jquery.peity.min.js
//= require slimscroll/jquery.slimscroll.min.js
//= require inspinia.js
//= require angular
//= require angular-rails-templates
//= require angular-ui-router
//= require angular-sanitize
//= require angular-translate
//= require ng-idle
//= require ocLazyLoad
//= require angular-bootstrap
//= require bootstrap
//= require angular/angularInspinia.js
//= require ngInfiniteScroll
//= require_tree ../../templates
//= require_tree ../ogx

(function () {
    angular.module('inspinia', [
        'ui.router',                    // Routing
        'oc.lazyLoad',                  // ocLazyLoad
        'ui.bootstrap',                 // Ui Bootstrap
        'pascalprecht.translate',       // Angular Translate
        'ngIdle',                       // Idle timer
        'ngSanitize',                    // ngSanitize
        'templates',
        'ogx.controller',
        'infinite-scroll'
    ])
})();

// Other libraries are loaded dynamically in the config.js file using the library ocLazyLoad
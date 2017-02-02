
/**
 * INSPINIA - Responsive Admin Theme
 *
 * Inspinia theme use AngularUI Router to manage routing and views
 * Each view are defined as state.
 * Initial there are written state for all view in theme.
 *
 */

function config($stateProvider, $httpProvider, $urlRouterProvider, $ocLazyLoadProvider, IdleProvider, KeepaliveProvider) {
    
    // Send CSRF token with every http request
    $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content");
    
    $urlRouterProvider.otherwise("/ogv");

    $ocLazyLoadProvider.config({
        // Set to true if you want to see what and when is dynamically loaded
        debug: false
    });
    $stateProvider
        .state('ogv', {
            url: '/ogv',
            templateUrl: '/assets/ogx/_list-d3a6a0a03ddbf57823f202a6582f13c90a10443f7e3518f0d13197b05a7225c7.html',
        })
        .state('ogt', {
            url: '/ogt',
            templateUrl: '/assets/ogx/_list-d3a6a0a03ddbf57823f202a6582f13c90a10443f7e3518f0d13197b05a7225c7.html',
        })
        .state('teams', {
            url: '/teams',
            templateUrl: '/assets/ogx/_list-d3a6a0a03ddbf57823f202a6582f13c90a10443f7e3518f0d13197b05a7225c7.html',
        })
        .state('hosts', {
            url: '/hosts',
            templateUrl: '/assets/ogx/_list-d3a6a0a03ddbf57823f202a6582f13c90a10443f7e3518f0d13197b05a7225c7.html',
        })
        .state('files', {
            url: '/files',
            templateUrl: '/assets/ogx/_list-d3a6a0a03ddbf57823f202a6582f13c90a10443f7e3518f0d13197b05a7225c7.html',
        })
        .state('dashboards', {
            abstract: true,
            url: "/dashboards",
            templateUrl: '/assets/common/content-0c012e1be022f4045dab1e79168a6ecfcdc33fd314316c698aa08ee072166fb8.html',
        })
        .state('dashboards.dashboard_1', {
            url: "/dashboard_1",
            templateUrl: "views/dashboard_1.html",
            resolve: {
                loadPlugin: function ($ocLazyLoad) {
                    return $ocLazyLoad.load([
                        {

                            serie: true,
                            name: 'angular-flot',
                            files: [ 'js/plugins/flot/jquery.flot.js', 'js/plugins/flot/jquery.flot.time.js', 'js/plugins/flot/jquery.flot.tooltip.min.js', 'js/plugins/flot/jquery.flot.spline.js', 'js/plugins/flot/jquery.flot.resize.js', 'js/plugins/flot/jquery.flot.pie.js', 'js/plugins/flot/curvedLines.js', 'js/plugins/flot/angular-flot.js', ]
                        },
                        {
                            name: 'angles',
                            files: ['js/plugins/chartJs/angles.js', 'js/plugins/chartJs/Chart.min.js']
                        },
                        {
                            name: 'angular-peity',
                            files: ['js/plugins/peity/jquery.peity.min.js', 'js/plugins/peity/angular-peity.js']
                        }
                    ]);
                }
            }
        });

}
angular
    .module('inspinia')
    .config(config)
    .run(function($rootScope, $state) {
        $rootScope.$state = $state;
    });

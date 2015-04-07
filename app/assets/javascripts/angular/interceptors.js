angular.module('CtrlCalories')
	.config(function($httpProvider){
		$httpProvider.interceptors.push(['$q', '$location', function ($q, $location) {
	        return {
	            'request': function (config) {
	                config.headers = config.headers || {};
	                if(localStorage.getItem("token")) {
	                    config.headers.Authorization = 'Bearer ' + localStorage.getItem("token");
	                }
	                return config;
	            },
	            'responseError': function (response) {
	                if (response.status === 401 || response.status === 403) {
	                    localStorage.removeItem("token");
	                    // $location.path('/signin');
	                }
	                return $q.reject(response);
	            }
	        };
	    }]);
	}).run(function($rootScope, $location) {
        $rootScope.$on( "$routeChangeStart", function(event, next) {
            if (localStorage.getItem("token") == null) {
                if ( next.templateUrl === "partials/restricted.html") {
                    $location.path("/signin");
                }
            }
        });
    });
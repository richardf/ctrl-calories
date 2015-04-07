angular.module('CtrlCalories')
 .config(function($routeProvider){
	$routeProvider
	.when('/', {
		templateUrl: 'templates/home.html',
		controller: 'HomeCtrl'
	})	
	.when('/signin', {
		templateUrl: 'templates/signin.html',
		controller: 'AuthCtrl'
	})
	.when('/signup', {
		templateUrl: 'templates/signup.html',
		controller: 'AuthCtrl'
	})
	.otherwise({ retirectTo: '/'})	
 });
angular.module('CtrlCalories')
 .config(function($routeProvider){
	$routeProvider
	.when('/', {
		templateUrl: 'templates/home.html',
		controller: 'HomeCtrl'
	})	
	.when('/profile', {
		templateUrl: 'templates/profile.html',
		controller: 'ProfileCtrl'
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
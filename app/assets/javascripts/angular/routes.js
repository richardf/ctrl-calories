angular.module('CtrlCalories')
 .config(function($routeProvider){
	$routeProvider
	.when('/', {
		templateUrl: 'templates/home.html',
		controller: 'HomeCtrl'
	})	
 });
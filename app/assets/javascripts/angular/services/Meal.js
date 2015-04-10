angular.module('CtrlCalories')
	.factory('Meal', ['$resource', function ($resource){
		return $resource('/api/meal/:id', {}, {});
	}]);

angular.module('CtrlCalories')
	.factory('Meal', ['$http', function ($http){
		return {
			get: function() {
				return $http({method: 'GET', url: '/api/meal'});
			},
			update: function(id, meal) {
				return $http({method: 'PATCH', url: '/api/meal/' + id, data: meal});
			},
			create: function(meal) {
				return $http({method: 'POST', url: '/api/meal', data: meal});
			},
			delete: function(id) {
				return $http({method: 'DELETE', url: '/api/meal/' + id});
			}
		}
	}]);

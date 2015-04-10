angular.module('CtrlCalories')
	.factory('Meal', ['$http', function ($http){
		return {
			get: function() {
				return $http({method: 'GET', url: '/api/profile/meals'});
			},
			update: function(id, meal) {
				return $http({method: 'PATCH', url: '/api/profile/meals' + id, data: meal});
			},
			create: function(meal) {
				return $http({method: 'POST', url: '/api/profile/meals', data: meal});
			},
			delete: function(id) {
				return $http({method: 'DELETE', url: '/api/profile/meals' + id});
			}
		}
	}]);

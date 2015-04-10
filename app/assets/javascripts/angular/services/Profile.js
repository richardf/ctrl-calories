angular.module('CtrlCalories')
	.factory('Profile', ['$http', function ($http){
		return {
			get: function() {
				return $http({method: 'GET', url: '/api/profile'});
			},
			update: function(profile) {
				return $http({method: 'PATCH', url: '/api/profile', data: profile});	
			},
			create: function(profile) {
				return $http({method: 'POST', url: '/api/profile', data: profile});		
			}
		}
	}]);

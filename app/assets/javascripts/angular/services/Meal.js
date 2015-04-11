angular.module('CtrlCalories')
	.factory('Meal', ['$http', function ($http){
		return {
			get: function(filters) {
				var apiUrl = '/api/profile/meals';
				var allowed_filters = ['start_date', 'end_date', 'start_time', 'end_time'];

				if (filters != null) {
					apiUrl += '?';
					for(i in allowed_filters) {
						var filterValue = filters[allowed_filters[i]]
						
						if(filterValue != null) {
							if(filterValue instanceof Date) {
								filterValue = filterValue.toISOString().substring(0, 10);
							}
							apiUrl += allowed_filters[i] + '=' + filterValue + '&';
						}
					}
					apiUrl = apiUrl.slice(0,-1);
				}

				console.log(apiUrl);

				return $http({method: 'GET', url: apiUrl});
			},
			update: function(id, meal) {
				return $http({method: 'PATCH', url: '/api/profile/meals/' + id, data: meal});
			},
			create: function(meal) {
				return $http({method: 'POST', url: '/api/profile/meals', data: meal});
			},
			delete: function(id) {
				return $http({method: 'DELETE', url: '/api/profile/meals/' + id});
			}
		}
	}]);

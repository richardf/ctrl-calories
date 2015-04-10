angular.module('CtrlCalories')
    .controller('HomeCtrl', ['$rootScope', '$scope', '$location', 'Auth', 'Profile', 'Meal',
        function ($rootScope, $scope, $location, Auth, Profile, Meal) {

        	$scope.clearFilter = function() {
        		$scope.filterStartDt = null;
        		$scope.filterStartTime = null;
        		$scope.filterEndDt = null;
        		$scope.filterEndTime = null;
        	};

    		function loadProfile() {
	        	Profile.get().success(function(data) {
	        		$scope.profile = data;
	        	}).error(function(err) {
	        		$scope.error = err.error;
	        	});
    		};

    		function loadMeals() {
	        	Meal.get().success(function(data) {
	        		$scope.meals = data;
	        		console.log(data);
	        	}).error(function(err) {
	        		$scope.error = err.error;
	        	});
    		};


    		loadProfile();    
    		loadMeals();    	
        }]);

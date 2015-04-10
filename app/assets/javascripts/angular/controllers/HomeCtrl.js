angular.module('CtrlCalories')
    .controller('HomeCtrl', ['$rootScope', '$scope', '$location', 'Auth', 'Profile', 'Meal',
        function ($rootScope, $scope, $location, Auth, Profile, Meal) {

        	$scope.clearFilter = function() {
        		$scope.filterStartDt = null;
        		$scope.filterStartTime = null;
        		$scope.filterEndDt = null;
        		$scope.filterEndTime = null;
        	};

        	$scope.prepareToDelete = function(event) {
				$scope.mealToDelete = event.target.getAttribute("value");
        	};

        	$scope.deleteMeal = function() {
	        	Meal.delete($scope.mealToDelete).success(function() {
	        		$scope.mealToDelete = null;
                    loadProfile();
	        		loadMeals();
	        	}).error(function(err) {
	        		$scope.error = err.error;
	        	});
        	};

            $scope.createMeal = function(meal) {
                Meal.create(meal).success(function() {
                    loadProfile();
                    loadMeals();
                    $scope.newMeal = null;
                }).error(function(err) {
                    console.log(err);
                    $scope.error = err.error;
                });
            };            

            $scope.updateMeal = function(meal) {
                Meal.update(id, meal).success(function() {
                    loadProfile();
                    loadMeals();
                    $scope.updateMeal = null;
                }).error(function(err) {
                    console.log(err);
                    $scope.error = err.error;
                });
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
	        	}).error(function(err) {
	        		$scope.error = err.error;
	        	});
    		};


    		loadProfile();    
    		loadMeals();    	
        }]);

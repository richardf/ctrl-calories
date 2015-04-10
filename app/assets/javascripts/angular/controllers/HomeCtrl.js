angular.module('CtrlCalories')
    .controller('HomeCtrl', ['$rootScope', '$scope', '$location', 'Auth', 'Profile', 'Meal',
        function ($rootScope, $scope, $location, Auth, Profile, Meal) {

        	$scope.clearFilter = function() {
        		$scope.filter.startDt = null;
        		$scope.filter.startTime = null;
        		$scope.filter.endDt = null;
        		$scope.filter.endTime = null;
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

            $scope.prepareToUpdate = function(event) {
                var mealId = event.target.getAttribute("value");
                $scope.mealToUpdate = angular.copy(getMealById(mealId));;
            };

            $scope.updateMeal = function() {
                var meal = $scope.mealToUpdate;
                Meal.update(meal.id, meal).success(function() {
                    loadProfile();
                    loadMeals();
                    $scope.mealToUpdate = null;
                }).error(function(err) {
                    console.log(err);
                    $scope.error = err.error;
                });
            };

            function getMealById(id) {
                return $scope.meals.filter(function( obj ) {
                    return +obj.id === +id;
                })[ 0 ];
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

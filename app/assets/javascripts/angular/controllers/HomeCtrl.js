angular.module('CtrlCalories')
    .controller('HomeCtrl', ['$rootScope', '$scope', '$location', 'Auth', 'Profile',
        function ($rootScope, $scope, $location, Auth, Profile) {

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


    		loadProfile();        	
        }]);

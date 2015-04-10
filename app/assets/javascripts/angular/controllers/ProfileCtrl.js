angular.module('CtrlCalories')
    .controller('ProfileCtrl', ['$rootScope', '$scope', '$location', 'Auth', 'Profile', 
    	function ($rootScope, $scope, $location, Auth, Profile) {

    		$scope.updateProfile = function(profile) {
    			var userProfile = {user: {}};
    			userProfile.user.name = profile.name;

    			if(profile.expected_calories != null) {
    				userProfile.user.expected_calories = profile.expected_calories;	
    			}
    			if(profile.password != null && profile.password.trim()) {
    				userProfile.user.password = profile.password.trim(); 
    			}
    			
    			Profile.update(userProfile).success(function() {
					$scope.notice = "Your profile was updated.";
					$scope.error = null;

	        	}).error(function(err) {
	        		$scope.error = err.error;
	        		$scope.notice = null;
	        	});
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

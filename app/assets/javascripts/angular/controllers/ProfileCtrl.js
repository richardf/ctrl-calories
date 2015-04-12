angular.module('CtrlCalories')
    .controller('ProfileCtrl', ['$rootScope', '$scope', '$location', 'Auth', 'Profile', 
    	function ($rootScope, $scope, $location, Auth, Profile) {

    		$scope.updateProfile = function(profile) {
                if(!validatePassword(profile.password, profile.passwordConf)) {
                    $scope.notice = null;
                    return;
                }

    			var userProfile = {user: {}};
    			userProfile.user.name = profile.name;
    			userProfile.user.expected_calories = profile.expected_calories;	
    			
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

            function validatePassword(passwd, passwdConf) {
                if(passwd !== passwdConf) {
                    $scope.error = 'Passwords do not match.'
                    return false;
                }                
                else if(passwd !== undefined && passwd.length > 0 && passwd.length < 6) {
                    $scope.error = 'Password must have at least 6 characters.'
                    return false;
                }
                return true;
            }

    		function loadProfile() {
	        	Profile.get().success(function(data) {
	        		$scope.profile = data;
	        	}).error(function(err) {
	        		$scope.error = err.error;
	        	});
    		};


    		loadProfile();
        }]);

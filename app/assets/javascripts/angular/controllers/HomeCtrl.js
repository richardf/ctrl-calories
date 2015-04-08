angular.module('CtrlCalories')
    .controller('HomeCtrl', ['$rootScope', '$scope', '$location', 'Auth',
        function ($rootScope, $scope, $location, Auth) {

        	$scope.clearFilter = function() {
        		$scope.filterStartDt = null;
        		$scope.filterStartTime = null;
        		$scope.filterEndDt = null;
        		$scope.filterEndTime = null;
        	};


        }]);

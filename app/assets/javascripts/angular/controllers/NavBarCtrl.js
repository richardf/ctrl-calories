angular.module('CtrlCalories')
    .controller('NavBarCtrl', ['$rootScope', '$scope', '$location', 'Auth',
        function ($rootScope, $scope, $location, Auth) {
            $scope.logout = function () {
                Auth.logout(function () {
                    window.location = "/";
                });
            };

            $scope.isNavActive = function(viewLocation) {
                return viewLocation === $location.path();
            }

            $rootScope.isLogged = function() {
                return Auth.isLogged();
            }
        }]);

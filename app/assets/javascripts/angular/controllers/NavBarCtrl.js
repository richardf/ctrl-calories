angular.module('CtrlCalories')
    .controller('NavBarCtrl', ['$rootScope', '$scope', '$location', 'Auth',
        function ($rootScope, $scope, $location, Auth) {
            $scope.logout = function () {
                Auth.logout(function () {
                    window.location = "/";
                });
            };

            $rootScope.isLogged = function() {
                return Auth.isLogged();
            }
        }]);

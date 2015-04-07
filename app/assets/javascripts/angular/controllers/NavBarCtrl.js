angular.module('CtrlCalories')
    .controller('NavBarCtrl', ['$rootScope', '$scope', '$location', 'Auth',
        function ($rootScope, $scope, $location, Auth) {
            function successAuth(res) {
                localStorage.setItem("token", res.auth_token);
                window.location = "/";
            }

            $scope.signin = function (login, password) {
                var formData = {
                    login: login,
                    password: password
                };

                Auth.signin(formData, successAuth, function () {
                    $rootScope.error = 'Invalid credentials.';
                })
            };

            $scope.signup = function (login, name, password, exp_calories) {
                var formData = {
                    login: login,
                    password: password,
                    name: name,
                    expected_calories: exp_calories
                };

                Auth.signup(formData, successAuth, function (res) {
                    $rootScope.error = res.error || 'Failed to sign up.';
                })
            };

            $scope.logout = function () {
                Auth.logout(function () {
                    window.location = "/"
                });
            };
            $scope.token = localStorage.getItem("token");
            $scope.tokenClaims = Auth.getTokenClaims();
        }]);

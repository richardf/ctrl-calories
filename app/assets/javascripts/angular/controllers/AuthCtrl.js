angular.module('CtrlCalories')
    .controller('AuthCtrl', ['$rootScope', '$scope', '$location', 'Auth',
        function ($rootScope, $scope, $location, Auth) {

            function successSignup() {
                $scope.signin($scope.login, $scope.password);
            }

            function successAuth(res) {
                localStorage.setItem("token", res.auth_token);
                $location.path('/');
            }

            $scope.signin = function () {
                var formData = {
                    login: $scope.login,
                    password: $scope.password
                };

                Auth.signin(formData, successAuth, function () {
                    $rootScope.error = 'Wrong email or password';
                })
            };

            $scope.signup = function () {
                var formData = { user:{
                    login: $scope.login,
                    password: $scope.password,
                    name: $scope.name,
                    expected_calories: $scope.exp_calories
                    }
                };

                Auth.signup(formData, successSignup, function (res) {
                    $rootScope.error = res.error || 'Failed to sign up.';
                })
            };
        }]);

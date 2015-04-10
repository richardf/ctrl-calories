angular.module('CtrlCalories')
    .factory('Auth', ['$http', 'urls', function ($http, urls) {
        function urlBase64Decode(str) {
            //jwt uses base64 url encoder. Some conversion is necessary.
            var output = str.replace('-', '+').replace('_', '/');
            switch (output.length % 4) {
                case 0:
                    break;
                case 2:
                    output += '==';
                    break;
                case 3:
                    output += '=';
                    break;
                default:
                    throw 'Illegal base64url string!';
            }
            return window.atob(output);
        }

        function getClaimsFromToken() {
            var token = localStorage.getItem("token");
            var user = {};
            if (token !== null && typeof token !== 'undefined') {
                var encoded = token.split('.')[1];
                user = JSON.parse(urlBase64Decode(encoded));
            }
            return user;
        }

        var tokenClaims = getClaimsFromToken();

        return {
            signup: function (data, success, error) {
                $http.post('/api/profile', data).success(success).error(error)
            },
            signin: function (data, success, error) {
                $http.post('/api/auth', data).success(success).error(error)
            },
            logout: function (success) {
                tokenClaims = {};
                localStorage.removeItem("token");
                success();
            },
            getTokenClaims: function () {
                return tokenClaims;
            },
            isLogged: function() {
                return localStorage.getItem("token") === null ? false : true;
            }
        };
    }
    ]);


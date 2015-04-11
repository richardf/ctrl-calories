angular.module('CtrlCalories')
.factory('passwordConfValidator', function () {
  return {
    name: 'passwordConfValidator',
    validate: function (value, arguments) {
      var pass = angular.element(arguments.passwordField).val();
      return pass === value;
    }
  };
});
angular.module('CtrlCalories')
.factory('numberValidator', function () {
  return {
    name: 'numberValidator',
    validate: function (value, arguments) {
      return angular.isNumber(value);
    }
  };
});
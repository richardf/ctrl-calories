angular.module('CtrlCalories')
.directive('ngBootstrapFix',['$filter', function($filter) {
	return {
		require: 'ngModel',
		priority: 1,
		link: function($scope, $element, $attrs, ngModelCtrl) {
			ngModelCtrl.$render = function() {
				var viewValue = ngModelCtrl.$viewValue;
				if(viewValue != null && !isNaN(viewValue)) {
					var date = viewValue.toISOString().substring(0,10) + 'T03:00:00.000Z'
					viewValue = new Date(date);
				}
				var val = $filter('date')(viewValue, 'dd-MMMM-yyyy');
				$element.val(val);
			};
		}
	};
}]);
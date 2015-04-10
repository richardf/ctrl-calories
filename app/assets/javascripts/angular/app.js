angular.module('CtrlCalories', ['ngRoute', 'ui.bootstrap'])
   .constant('urls', {
       BASE: 'http://localhost:3000',
       BASE_API: 'http://localhost:3000/api'
   })
	.config(['datepickerConfig', function(datepickerConfig) {
	    datepickerConfig.showWeeks = false;
	}])
;
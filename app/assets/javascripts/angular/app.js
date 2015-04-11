angular.module('CtrlCalories', ['ngRoute', 'ui.bootstrap', 'valdr'])
   .constant('urls', {
       BASE: 'http://localhost:3000',
       BASE_API: 'http://localhost:3000/api'
   })
	.config(['datepickerConfig', function(datepickerConfig) {
	    datepickerConfig.showWeeks = false;
	}])

	.config(function(valdrProvider) {
		valdrProvider.addConstraints({
			'Meal' : {},
			'Profile' : {},
			'signin' : {
				'login' : {
					'required' : {'message' : 'Please inform your email.'},
					'email' : {'message' : 'Please inform a valid email.'}
				}
			}
		});
	})
;



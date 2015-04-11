angular.module('CtrlCalories', ['ngRoute', 'ui.bootstrap', 'valdr'])
   .constant('urls', {
       BASE: 'http://localhost:3000',
       BASE_API: 'http://localhost:3000/api'
   })
	.config(['datepickerConfig', function(datepickerConfig) {
	    datepickerConfig.showWeeks = false;
	}])

	.config(function(valdrProvider) {
		valdrProvider.addValidator('passwordConfValidator');
		valdrProvider.addConstraints({
			'Meal' : {},
			'Profile' : {},
			'signin' : {
				'login' : {
					'email' : {'message' : 'Please inform a valid email.'}
				}
			},
			'signup' : {
				'login' : {
					'email' : {'message' : 'Please inform a valid email.'}
				},
				'password' : {
					'size' : {
						'min' : 6,
						'message': 'Please use at least 6 characters.'
					}
				},
				'passwordConf' : {
					'passwordConfValidator' : {
						'passwordField' : '#password',
						'message' : 'Passwords do not match.'
					}
				}
			}
		});
	})
;



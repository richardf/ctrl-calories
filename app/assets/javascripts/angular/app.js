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
		valdrProvider.addValidator('numberValidator');

		valdrProvider.addConstraints({
			'meal' : {
				'description' : {
					'required' : { 'message': 'This field is required.' }
				},
				'calories' : {
					'numberValidator' : { 'message' : 'This field is numeric.'},
					'required' : { 'message': 'This field is required.' }
				},
				'ate_at_date' : {
					'required' : { 'message': 'This field is required.' }
				},
				'ate_at_time' : {
					'required' : { 'message': 'This field is required.' }
				}
			},
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



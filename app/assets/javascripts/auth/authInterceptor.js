angular.module('app').factory('AuthInterceptor', ['$q', '$injector', 'notifier', 'authService', function($q, $injector, notifier, authService) {
    return {
        request: function(config) {
            // called on every outgoing HTTP request
            var AuthToken = $injector.get("AuthToken");
            var token = AuthToken.get();
            config.headers = config.headers || {};
            if(token) {
                config.headers.Authorization = "Bearer " + token;
            }
            return config || $q.when(config);
        },
        responseError: function(response) {
            if(response.status == 401) {
                notifier.error(response.statusText)
                if(!authService.isLoggedIn()) {
                    notifier.error('You need to login to do that.');
                } else {
                    notifier.error(response.statusText)
                }
                return $q.reject(response);
            } else {
                notifier.error('Error executing last action');
                return $q.reject(response);
            }
        }
    };
}]);

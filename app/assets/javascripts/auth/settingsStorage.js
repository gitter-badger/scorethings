angular.module('app').service('settingsStorage', ['localStorageService', function(localStorageService) {
        return {
            set: function(settings) {
                localStorageService.set('settings', settings);
            },
            get: function() {
                return localStorageService.get('settings');
            },
            clear: function() {
                localStorageService.remove('settings');
            }
        };
    }]);

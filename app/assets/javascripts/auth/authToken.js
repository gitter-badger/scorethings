angular.module('app').service('AuthToken', ['localStorageService', 'jwtHelper', 'identity', 'settingsStorage', function(localStorageService, jwtHelper, identity, settingsStorage) {
        // TODO clean up this service
        return {
            tokenName: 'authToken',
            set: function(token) {
                localStorageService.set(this.tokenName, token);
                identity.username = this.getUsername();
                identity.userId = this.getUserId();
                settingsStorage.set(this.getSettings());
            },
            isSet: function() {
                return !!this.get();
            },
            get: function() {
                return localStorageService.get(this.tokenName);
            },
            getAttr: function(attr) {
                var token = this.get();
                var payload = token && jwtHelper.decodeToken(token);
                return payload && payload[attr];
            },
            isExpired: function() {
                var token = this.get();
                return jwtHelper.isTokenExpired(token);
            },
            getUsername: function() {
                return this.getAttr('username');
            },
            getUserId: function() {
                return this.getAttr('user_id');
            },
            getSettings: function() {
                var settings = this.getAttr('settings');
                if(settings) {
                    return humps.camelizeKeys(settings);
                }
                return null;
            },
            clear: function() {
                localStorageService.remove(this.tokenName);
                identity.username = null;
                identity.userId = null;
            }
        };
    }]);

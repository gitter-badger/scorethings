angular.module('app').service('AuthToken', ['localStorageService', 'jwtHelper', 'identity', function(localStorageService, jwtHelper, identity) {
        return {
            tokenName: 'authToken',
            set: function(token) {
                localStorageService.set(this.tokenName, token);
                identity.userId = this.getUserId();
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
            setAttr: function(attr, newValue) {
                var token = this.get();
                var payload = token && jwtHelper.decodeToken(token);
                return payload && payload[attr];
            },
            isExpired: function() {
                var token = this.get();
                return jwtHelper.isTokenExpired(token);
            },
            getUserId: function() {
                return this.getAttr('user_id');
            },
            clear: function() {
                localStorageService.remove(this.tokenName);
                identity.userId = null;
                identity.username = null;
            }
        };
    }]);

angular.module('app').controller('SettingsCtrl', ['$scope', 'Settings', 'notifier', 'settingsStorage', function($scope, Settings, notifier, settingsStorage) {

    function handleLogOff() {
        $scope.settings = {};
        notifier.error('You need to be logged in to see settings');
        return;
    }

    function initSettings() {
        new Settings().get({}).then(function(settings) {
            settingsStorage.set(settings);
            $scope.settings = settings;
        }, function() {
           notifier.error('failed to get settings');
        });
    }

    $scope.$on('userLoggedOff', function() {
        return handleLogOff();
    });

    $scope.$on('userLoggedOn', function() {
        return initSettings();
    });

    $scope.reset = function() {
        initSettings();
    };

    $scope.save = function() {
        $scope.settings.id = null;
        new Settings($scope.settings).update().then(
            function successUpdate(settings) {
                $scope.settings = settings;
                settingsStorage.set(settings);
                notifier.success('updated settings');
            },
            function errorUpdate() {
                notifier.error('failed to get settings');
            });
    };

    if(!$scope.isLoggedIn()) {
        handleLogOff();
    } else {
        initSettings();
    }

}]);
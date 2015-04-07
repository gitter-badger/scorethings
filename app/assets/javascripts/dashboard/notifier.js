angular.module('yeaskme').value('appToastr', toastr);

angular.module('yeaskme').factory('notifier', ['appToastr', function(appToastr) {
    return {
        success: function(msg) {
            appToastr.success(msg);
        },
        error: function(msg) {
            appToastr.error(msg);
        }
    };
}]);
angular.module('app').value('appToastr', toastr);

angular.module('app').factory('notifier', ['appToastr', function(appToastr) {
    return {
        success: function(msg) {
            appToastr.success(msg);
        },
        error: function(msg) {
            appToastr.error(msg);
        }
    };
}]);
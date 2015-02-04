var spoton = angular.module('spoton');

spoton.controller('HomeCtrl', ['$http', '$scope', function ($http, $scope) {

  $scope.events = [1];

  $http.get('http://localhost:3000/events.json')
    .success(function(data) {
      $scope.events = data;
    });
}]);
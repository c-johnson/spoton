var spoton = angular.module('spoton');

spoton.controller('HomeCtrl', ['$http', '$scope', function ($http, $scope) {
  $scope.toggleButton = 'list';

  $scope.sources = [
    {
      label: "Stanford Event Calendar",
      value: 'stanford'
    },
    {
      label: "Eventbrite Event Calendar",
      value: 'eventbrite'
    }
  ];

  $scope.selectedSource = $scope.sources[0];

  $scope.loadSource = function () {
    $scope.events = [];
    var src = $scope.selectedSource;
    $http.get('http://localhost:3000/events/'+src.value+'.json')
      .success(function(data) {
        $scope.events = data;
      });
  };

  $scope.activate = function (active) {
    $scope.toggleButton = active;
  };

  $scope.loadSource();
}]);
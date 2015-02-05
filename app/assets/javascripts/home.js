var spoton = angular.module('spoton');

spoton.controller('HomeCtrl', ['$http', '$scope', function ($http, $scope) {
  $scope.toggleButton = 'list';

  $scope.sources = [
    {
      label: "Stanford Event Calendar",
      value: 'stanford'
    },
    {
      label: "Stanford Event Calendar (oct)",
      value: 'stanford_oct'
    },
    {
      label: "Eventbrite",
      value: 'eventbrite'
    },
    {
      label: "SF Moma",
      value: 'sf_moma'
    },
    {
      label: "Meetup.com",
      value: 'meetup'
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
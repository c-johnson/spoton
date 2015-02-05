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
    $http.get('/events/'+src.value+'.json')
      .success(function(data) {
        debugger
        $scope.events = $scope.processData(data);
      });
  };

  $scope.processData = function (data) {
    for (var i = 0; i < data.length; i++) {
      var mDate = moment(data[i].date);
      if (mDate.toString() === "Invalid date") {
        data[i].date = null;
      } else {
        data[i].date = mDate;
        data[i].dayOfWeek = mDate.format('ddd');
        data[i].dayOfMonth = mDate.format('D');
        data[i].timeOfEvent = mDate.format('h:mma');
      }
    }
    return data;
  };

  $scope.activate = function (active) {
    $scope.toggleButton = active;
  };

  $scope.loadSource();
}]);
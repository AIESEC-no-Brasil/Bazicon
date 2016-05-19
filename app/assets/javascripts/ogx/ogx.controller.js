angular.module('ogx.controller', [])
	.filter('split', function() {
        return function(input, splitChar, splitIndex) {
            // do some bounds checking here to ensure it has that index
            return (input != null) ? input.split(splitChar)[splitIndex] : '';
        }
    })
  	.controller('oGCDPController', ['$scope','$http','$uibModal','$timeout', function ($scope,$http,$uibModal,$timeout) {

  		$scope.error_msg = false;
	    $scope.busy_scroll = false;

	    $scope.loading_list = false;
	    $scope.loading_detail = false;

	    $scope.commettees = [];
	    $scope.selected_lc = null;

	    $scope.status_filter = 'all';
	    $scope.ops_filter = false;
	    $scope.epi_filter = false;

	    $scope.get_lcs = function() {
		    $http.get('ogx/my_lcs').then(
		    	function successCallback(response) {
		    		$scope.commettees = response.data;
	    			$scope.selected_lc = $scope.commettees[0];
	    			$scope.list();
	    			$scope.load_analysis();
		    	}, function errorCallback(response) {
		    		console.log('Erro ao carregar Comitês');
		    		console.log(response.data);
		    		$scope.commettees = [];
		    	});
	    };

	    $scope.list = function() {
	    	$scope.people = [];
	    	$scope.loading_list = true;
		    params = {
		    	status: $scope.status_filter.toLowerCase(),
		    	ops: $scope.ops_filter,
		    	epi: $scope.epi_filter,
		    	lc: $scope.selected_lc.id,
		    	page: 0
		    };
		    $http.get('/disrupt/ogx/list', {params: params}).then(
		    	function successCallback(response) {
		    		$scope.people = response.data;
			    	$scope.loading_list = false;
	    			$scope.busy_scroll = (response.data.length < 30) ? true : false;
		    		$scope.person = $scope.people[0];
		    	}, function errorCallback(response) {
		    		$scope.error_msg = true;
			    	$scope.loading_list = false;
		    	});
	    };

	    $scope.list_more = function() {
	    	$scope.busy_scroll = true;
	    	$scope.loading_list = true;
		    params = {
		    	status: $scope.status_filter.toLowerCase(),
		    	ops: $scope.ops_filter,
		    	epi: $scope.epi_filter,
		    	lc: $scope.selected_lc.id,
		    	page: Math.floor($scope.people.length / 30)
		    };
		    $http.get('/disrupt/ogx/list', {params: params}).then(
		    	function successCallback(response) {
	    			$scope.people = $scope.people.concat(response.data);
	    			$scope.busy_scroll = (response.data.length < 30) ? true : false;
	    			$scope.loading_list = false;
		    	}, function errorCallback(response) {
		    		$scope.error_msg = true;
	    			$scope.loading_list = false;
		    	});
	    }

	    $scope.load_analysis = function() {
		    params = { lc: $scope.selected_lc.id };
		    $http.get('/disrupt/ogx/kpis', {params: params}).then(
		    	function successCallback(response) {
			    	$scope.analysis = {
			    		total_open : response.data['open'],
			    		month_open : 'later',
			    		total_applied : response.data['applied'],
			    		month_applied : 'later',
			    		total_accepted : response.data['accepted'],
			    		month_accepted : 'later',
			    		total_realized : response.data['realized'],
			    		month_realized : 'later',
			    		total_completed : response.data['completed'],
			    		month_completed : 'later',
			    		total_returnee : response.data['other'],
			    		month_returnee : 'later',
			    	};
		    	}, function errorCallback(response) {
		    		$scope.error_msg = true;
		    	});
	    }

	    $scope.select_ep = function(ep) {
	    	$scope.person = null;
	    	$scope.loading_detail = true;
	    	$timeout(function() {
		    	$scope.person = ep;
			    $scope.loading_detail = false;
				console.log($scope.person);
			}, 500);
	    };

	    $scope.open_edit_modal = function () {
	        var modalInstance = $uibModal.open({
	            templateUrl: 'ogx/_edit_modal.html'
	        });
	    };


	    $scope.status_color = function(ep_status) {
		    switch(ep_status){
		    	case 'open':
		    		return '';
		    	case 'in_progress':
		    		return 'primary';
		    	case 'matched':
		    		return 'info';
		    	case 'realized':
		    		return 'success'
		    	case 'completed':
		    		return 'danger'
		    	default:
		    		return 'danger';
		    }
	    };

	    $scope.cf_step = function(step) {
		    switch(step){
		    	case 'all':
		    		return 'Todos';
		    	case 'open':
		    		return 'Open';
		    	case 'in_progress':
		    		return 'Applied';
		    	case 'matched':
		    		return 'Accepted';
		    	case 'realized':
		    		return 'Realizing';
		    	case 'completed':
		    		return 'Completed'
		    	default:
		    		return 'danger';
		    }
	    };

	    $scope.no_personal_info = function(person) {
	    	return person != null && person.xp_contact_info == null &&
	    		person.xp_address_info == null && 
	    		person.xp_home_lc_id == null && 
	    		person.product == null;
	    }
	}]);
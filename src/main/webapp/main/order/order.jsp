<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script type="text/javascript">
var loaderSpinner;
var orderTable;

$(document).ready(function(){
	loaderSpinner = $('#loader');

	
	$('#addNewOrderModalSaveButton').click(function(){
		if($('#addNewOrderModalForm').valid()){
			$('#addNewOrderModal').modal('hide');
			var parameter = $('#addNewOrderModal form').serialize();
			loaderSpinner.show();
			$.ajax({
				type : "POST",
				url : "createOrder",
				data: parameter,
				cache : false,
				dataType : "json",
				success : function(data){
					if(data.status == "success"){
						popMessage('success', 'Successfully create order');
						setTimeout(function() {
					        $("#pop-message .alert").alert('close');
					    }, 3000);
					}else if(data.status == "fail"){
						popMessage('danger', 'Failed to create order');
						setTimeout(function() {
					        $("#pop-message .alert").alert('close');
					    }, 3000);
					}
					$('#orderTable').DataTable().ajax.reload();
				},
				error: function(data){
					loaderSpinner.hide();
					popMessage('danger', 'Failed to create order');
					setTimeout(function() {
				        $("#pop-message .alert").alert('close');
				    }, 3000);
				}
			}).done(function(){
				loaderSpinner.hide();
			});
		}
	});

	$('#addNewOrderModal').on('show.bs.modal', function(){
		loaderSpinner.show();
		$.ajax({
			type : "GET",
			url : "getLastOrderId",
			cache : false,
			success : function(data){
				$('#orderId').val(data);
				$('#orderDate').val("");
			},
			error: function(data){
				$('#orderId').val("");
				$('#orderDate').val("");
				loaderSpinner.hide();
			}
		}).done(function(){
			loaderSpinner.hide();
		});
	});

	orderTable = $('#orderTable').DataTable( {
		serverSide: true,
		searching: true,
		processing: true,
		responsive: true,
		search: {
			return: true,
		},
		lengthMenu: [
			[1, 5, 10, 20,100], //value
			[1, 5, 10, 20,100], // name
		],
		ordering: true,
		lengthChange: true,
		pageLength: 10,
		ajax: {
			url: 'orderListDataTable',
			type: 'POST',
			data: function(d){
				 d.myKey = 'myValue';
			}
		},
		columns:[
			{data: "id", name:"id"},
			{
				data: "date", 
				name:"date",
				render: function (data, type) {
					if ( type === 'display' || type === 'filter' ) {
						var date = new Date(data);
					    const day = date.toLocaleString('default', { day: '2-digit' });
					    const month = date.toLocaleString('default', { month: 'short' });
					    const year = date.toLocaleString('default', { year: 'numeric' });
					    return day + '-' + month + '-' + year;
					}
					return data;
				}
			},
			{
				data: "total", 
				name:"total_price", 
				render: function (data, type){
					if ( type === 'display' || type === 'filter' ) {
						return 'RM ' + (data/100).toFixed(2);
					}
					return data;
				},
				className: "dt-body-right"
			},
			{
				data: null, 
				orderable: false,
				defaultContent: "",
			}
		],
		order: [[0, 'desc']],
		columnDefs: [
			{
				targets: 3,
				render: function (data, type, row) {
                    return '<a href="order-detail.html?orderId=' + data.id + '" class="btn btn-sm btn-primary m-l-5">Edit</a>'
                    + '<a onclick="showDeleteModal(' + data.id + ')" class="btn btn-sm btn-danger m-l-5" data-toggle="modal" data-target="#deleteOrderModal">Delete</a>'
                    + '<a target="_blank" href="orderReport.do?inline=0&orderId='+data.id+'" class="btn btn-sm btn-info m-l-5">Invoice</a>'
                },
			}
		],
	} );

	
});


// ---------------------------Delete function-----------------------------------------------

// Add delete button when show
function showDeleteModal(dataId){
	$('#deleteOrderModal .modal-title').html('Delete order ' + dataId);
	$('#deleteOrderModal').modal();
	$('#deleteOrderModalButton').html(
			'<button type="button" class="btn btn-primary" onClick="deleteOrder(\'' + dataId + '\')">Delete</button>'
	);
}

// delete button onclick function
function deleteOrder(dataId){
	$('#deleteOrderModal').modal('hide');
	loaderSpinner.show();
	let parameter = 'orderId=' + dataId;
	$.ajax({
		type : "POST",
		url : "deleteOrder",
		data: parameter,
		cache : false,
		dataType : "json",
		success : function(data){
			$('#orderTable').DataTable().ajax.reload();
		},
		error: function(data){
			loaderSpinner.hide();
			popMessage('danger', 'Failed to delete order');
			setTimeout(function() {
		        $("#pop-message .alert").alert('close');
		    }, 3000);
		}
	}).done(function(){
		loaderSpinner.hide();
		popMessage('success', 'Successfully deleted order');
		setTimeout(function() {
	        $("#pop-message .alert").alert('close');
	    }, 3000);
	});
}
</script>


<div class="content-wrap">
	<div class="main">
		<div class="container-fluid">
			<div class="row">
				<div class="col-lg-8 p-r-0 title-margin-right">
					<div class="page-header pull-left">
						<div class="page-title">
        					<ol class="breadcrumb">
            					<li class="breadcrumb-item"><a href="${contextUrl}/install-service-management/order/order.html">Orders</a></li>
        					</ol>
					    </div>
					</div>
				</div>
			</div>
			<section id="main-content">
				<div class="row">
					<div class="col-lg-12">
						<div class="card">
							<div class='row'>
								<div class="col-lg-12">
									<button class="btn btn-sm btn-primary float-right" data-toggle="modal" data-target="#addNewOrderModal"><i class="ti-plus m-r-5"></i>Add new order</button>
								</div>
							</div>
							<div class='row'>
								<div class="col-lg-12">
									<div class="bootstrap-data-table-panel">
										<table id="orderTable" class="table table-striped table-bordered hover">
											<thead>
												<tr>
													<th>Order Id</th>
													<th>Order Date</th>
													<th>Total</th>
													<th>Action</th>
												</tr>
											</thead>
											<tbody>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</section>
		</div>
	</div>
</div>

<div id="loader"></div>
<div id="pop-message"></div>

<div class="modal fade" id="addNewOrderModal" tabindex="-1" role="dialog"
	aria-labelledby="addNewOrderModal" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">Add new order</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<form id="addNewOrderModalForm" class="form-horizontal">
					<div class="form-group row">
						<label for="recipient-name" class="col-sm-3 col-form-label">Id</label>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="orderId" name="orderId" required>
						</div>
					</div>
					<div class="form-group row">
						<label for="recipient-name" class="col-sm-3 col-form-label">Date:</label>
						<div class="col-sm-9">
							<input type="date" class="form-control" id="orderDate" name="orderDate" id="date" required>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" id="addNewOrderModalSaveButton">Save</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="deleteOrderModal" tabindex="-1" role="dialog"
	aria-labelledby="deleteOrderModal" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Delete order</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="alert alert-danger">
					Do you want to delete this order?
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<span id='deleteOrderModalButton'></span>
			</div>
		</div>
	</div>
</div>


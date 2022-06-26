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
			var parameter = $('#addNewOrderModal form').serialize();
			loaderSpinner.show();
			$.ajax({
				type : "POST",
				url : "createOrder",
				data: parameter,
				cache : false,
				dataType : "json",
				success : function(data){
					$('#orderTable').DataTable().ajax.reload();
				},
				error: function(data){
					alert("failed succesfully");
					loaderSpinner.hide();
				}
			}).done(function(){
				loaderSpinner.hide();
			});
			$('#addNewOrderModal').modal('hide');
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
				$('#orderId').val(data);
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
		search: {
			return: true,
		},
		lengthMenu: [
			[1, 5, 10, 20,],
			[1, 5, 10, 20,],
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
				name:"total", 
				orderable: false,
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
					console.log(data);
                    return '<a href="orderDetail?id=' + data.id + '" class="btn btn-sm btn-primary m-l-5">Edit</a>'
                    + '<a class="btn btn-sm btn-danger m-l-5">Delete</a>'
                },
			}
		],
	} );

	
});

</script>


<div class="content-wrap">
	<div class="main">
		<div class="container-fluid">
			<div class="row">
				<div class="col-lg-8 p-r-0 title-margin-right">
					<div class="page-header">
						<div class="page-title">
							<h1>Hello, <span>Welcome Here</span></h1>
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
										<table id="orderTable" class="table table-striped table-bordered">
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
							<input type="text" class="form-control" id="orderId" name="orderId">
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
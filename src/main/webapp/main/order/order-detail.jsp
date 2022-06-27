<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
var orderDetailTable;
var rowNumber = 0;
const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);
var loaderSpinner;

$(document).ready(function(){
	document.title = urlParams.get('orderId');
	getOrder();
	loaderSpinner = $('#loader');
	
	orderDetailTable = $('#orderDetailTable').DataTable({
		ajax: {
			url: 'getOrderDetailList?orderId=' + urlParams.get('orderId'),
			type: 'GET',
		},
		processing: true,
		paging: false,
		columns:[
			{
				data: null , 
				name:"id", 
				defaultContent: "",
				render: function (data, type){
					return ++rowNumber;
				}
			},
			{data: "serviceName", name:"id"},
			{data: "description", name:"id"},
			{data: "width", name:"id"},
			{data: "height", name:"id"},
			{data: null, name:"id"},
			{data: "quantity", name:"id"},
			{
				data: "finalPrice", 
				name:"id",
				render: function (data, type){
					if ( type === 'display' || type === 'filter' ) {
						return 'RM ' + (data/100).toFixed(2);
					}
					return data;
				}
			},
			{data: null, name:"id",defaultContent: "", orderable: false, searchable: false},
		],
		columnDefs: [
			{
				targets: 5, // FT
				render: function (data, type, row) {
					let ft = Math.round(((data.width)/304.8) * 100) / 100;
                    return ft;
                },
			},
		],
	});

});

function getOrder(){
	loaderSpinner = $('#loader');
	loaderSpinner.show();
	$.ajax({
		type : "GET",
		url : "getOrder?orderId="+ urlParams.get('orderId'),
		dataType: 'json',
		cache : false,
		success : function(data){
			var date = new Date(data.date);
			const day = date.toLocaleString('default', { day: '2-digit' });
		    const month = date.toLocaleString('default', { month: '2-digit' });
		    const year = date.toLocaleString('default', { year: 'numeric' });
			$('#orderId').val(data.id);
			$('#orderDate').val(year + '-' + month + '-' + day);
		},
		error: function(data){
			$('#orderId').val("");
			$('#orderDate').val("");
			loaderSpinner.hide();
		}
	}).done(function(){
		loaderSpinner.hide();
	});
}
</script>

<div id="loader"></div>
<div id="pop-message"></div>

<div class="content-wrap">
	<div class="main">
		<div class="container-fluid">
			<div class="row">
				<div class="col-lg-8 p-r-0 title-margin-right">
					<div class="page-header">
						<div class="page-title">
							<h1>Order details</h1>
						</div>
					</div>
				</div>
			</div>
			
			<section id="main-content">
				<div class="row">
					<div class="col-lg-12">
						<div class="card">
							<div class="card-body">
								<div class="row">
									<div class="col-lg-5">
								 		<form id="addNewOrderModalForm" class="form-horizontal">
											<div class="form-group row">
												<label for="recipient-name" class="col-sm-3 col-form-label">Id</label>
												<div class="col-sm-9">
													<input type="text" class="form-control" id="orderId" name="orderId" readonly>
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
								</div>
								 <div class="row">
								 	<div class="col-md-12">
								 		<div class='row'>
											<div class="col-lg-12">
												<button class="btn btn-sm btn-primary float-right" data-toggle="modal" data-target="#addNewOrderDetailModal" onClick="test()"><i class="ti-plus m-r-5"></i>Add new order</button>
											</div>
										</div>
										<div class='row'>
											<div class="col-lg-12">
												<div class="bootstrap-data-table-panel">
													<table id="orderDetailTable" class="table table-striped table-bordered hover">
														<thead>
															<tr>
																<th>#</th>
																<th>Service</th>
																<th>Description</th>
																<th>Width</th>
																<th>Height</th>
																<th>Ft</th>
																<th>Quantity</th>
																<th>Price</th>
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
						</div>
					</div>
				</div>
			</section>
		</div>
	</div>
</div>
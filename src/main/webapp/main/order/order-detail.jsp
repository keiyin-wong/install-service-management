<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
var orderDetailTable;
var rowNumber = 0;
const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);
var loaderSpinner = $('#loader');

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
			{data: "width", name:"id", className: "dt-body-right"},
			{data: "height", name:"id", className: "dt-body-right"},
			{data: null, name:"id", className: "dt-body-right"},
			{
				data: "quantity", 
				name:"id",
				render: function(data, type){
					if(data.useQuantity){
						return data;
					}else{
						return "N/A"
					}
				},
				className: "dt-body-right"
			},
			{
				data: "finalPrice", 
				name:"id",
				render: function (data, type){
					if ( type === 'display' || type === 'filter' ) {
						return 'RM ' + (data/100).toFixed(2);
					}
					return data;
				},
				className: "dt-body-right"
			},
			{
				data:"totalPrice", 
				name:"totalPrice", 
				render: function (data, type){
					if ( type === 'display' || type === 'filter' ) {
						return 'RM ' + (data/100).toFixed(2);
					}
					return data;
				},
				className: "dt-body-right"
			},
			{data: null, name:"id",defaultContent: "", orderable: false, searchable: false},
		],
		columnDefs: [
			{
				targets: 5, // FT
				render: function (data, type, row) {
					if(data.useQuantity){
						return "N/A";
					}
					let ft = Math.round(((data.width)/304.8) * 100) / 100;
                    return ft;
                },
			},
		],
		footerCallback: function (row, data, start, end, display) {
			var api = this.api();
			var intVal = function (i) {
                return typeof i === 'string' ? i.replace(/[\$,]/g, '') * 1 : typeof i === 'number' ? i : 0;
            };
            
            total = api
            .column(8)
            .data()
            .reduce(function (a, b) {
                return intVal(a) + intVal(b);
            }, 0);

            $(api.column(8).footer()).addClass("text-right");
            $(api.column(8).footer()).html('RM ' + (total/100).toFixed(2));
		}
	});

	$('#orderDate').on('change', function(){
		loaderSpinner.show();
		$.ajax({
			type : "POST",
			url : "updateOrder",
			data: $('#orderForm').serialize(),
			success: function(data){
				if(data.status == "success"){
					popMessage('success', 'Successfully update order date');
					getOrder();
				}else if(data.status == "fail"){
					popMessage('danger', 'Failed to order update date');
				}
			},
			error: function(){
				loaderSpinner.hide();
			}
			
		}).done(function(){
			loaderSpinner.hide();
		});
	});

});

function getOrder(){
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
								 		<form id="orderForm" class="form-horizontal">
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
												<button class="btn btn-sm btn-primary float-right" data-toggle="modal" data-target="#addNewOrderDetailModal" onClick="test()"><i class="ti-plus m-r-5"></i>Add new order detail</button>
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
																<th>Total Price</th>
																<th>Action</th>
															</tr>
														</thead>
														<tbody>
														</tbody>
														 <tfoot>
												            <tr>
												                <th colspan="8" style="text-align:right">Total:</th>
												                <th></th>
												            </tr>
												        </tfoot>
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

<div class="modal fade" id="addNewOrderDetailModal" tabindex="-1" role="dialog"
	aria-labelledby="addNewOrderDetailModal" aria-hidden="true">
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
						<label for="recipient-name" class="col-sm-3 col-form-label">Service</label>
						<div class="col-sm-9">
							<select class="form-control" id="createService" name="createService" required>
								<c:forEach var="item" items="${serviceList}">
								    <option value="${item.id}" is-direct-price="${item.differentPrice}">${item.descriptionEnglish}
								    	<c:if test="${not empty item.descriptionChinese}">
											 (${item.descriptionChinese})
										</c:if>
								    </option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="form-group row">
						<label for="recipient-name" class="col-sm-3 col-form-label">Description</label>
						<div class="col-sm-9">
							<textarea rows="3" class="form-control" id="createDescription" name="createDescription"></textarea>
						</div>
					</div>
					<div class="form-group row" id="createWidthDiv">
						<label class="col-sm-3 col-form-label" for="createWidth">Width (宽度)</label>
						<div class="col-sm-9">
							<input type="number" class="form-control" id="createWidth" name="createWidth" value="" min="0" step="0.01">
						</div>
					</div>
					<div class="form-group row" id="createHeightDiv">
						<label class="col-sm-3 col-form-label" for="createHeight">Height (高度)</label>
						<div class="col-sm-9">
							<input type="number" class="form-control" id="createHeight" name="createHeight" value="" min="0" step="0.01">
						</div>
					</div>
					<div class="form-group row" id="createQuantityDiv">
						<label class="col-sm-3 col-form-label" for="createQuantity">Quantity</label>
						<div class="col-sm-9">
							<input type="number" class="form-control" id="createQuantity" name="createQuantity" value="" min="1" step="1">
						</div>
					</div>
					<div class="form-group row">
							<label class="col-sm-3 col-form-label" for="createPrice">Price per service</label>
							<div class="col-sm-9">
								<input type="number" class="form-control" id="createPrice" name="createPrice" value="" min="0" step="0.01" required>
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

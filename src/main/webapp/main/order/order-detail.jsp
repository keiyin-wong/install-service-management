<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<style>
td a {
	color: white !important;
}
</style>


<script>
var orderDetailTable;
const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);
var loaderSpinner = $('#loader');
var differentPriceList = null;

$(document).ready(function(){
	document.title = urlParams.get('orderId');
	getOrder();
	loaderSpinner = $('#loader');
	$('select').selectpicker();
	
	// Get different price list
	$.ajax({
		type: "GET",
		url: "getAllServiceDiffPrices",
		cache : false,
		dataType: "json",
		success : function(data){
			differentPriceList = data;
		},
		error: function (data){
			differentPriceList = [];
		}
	});
	
	
	orderDetailTable = $('#orderDetailTable').DataTable({
		serverSide: false,
		ajax: {
			url: 'getOrderDetailList',
			type: 'POST',
			data: function(d){
				 d.orderId = urlParams.get('orderId');
			},
			dataSrc: function ( json ) {
			  return json;
			}
		},
		responsive: true,
		lengthChange: true,
		pageLength: 10,
		processing: true,
		paging: false,
		columns:[
			{
				data: null , 
				name:"id", 
				defaultContent: "",
				render: function (data, type, row, meta){
					return meta.row + meta.settings._iDisplayStart + 1;
				}
			},
			{data: "serviceName", name:"id"},
			{data: "description", name:"id"},
			{
				data: "width", 
				name:"id",
				render: function (data, type, row) {
					if(row.calculationType != 1){
						return data;
					}else{
						return "N/A";
					}
                },
				//className: "dt-body-right"
			},
			{
				data: "height", 
				name:"id", 
				render: function (data, type, row) {
					if(row.calculationType != 1){
						return data;
					}else{
						return "N/A";
					}
                },
				//className: "dt-body-right"
			},
			{data: null, name:"ft", className: "dt-body-right"},
			{
				data: "quantity", 
				name:"id",
				render: function (data, type, row) {
					if(row.calculationType == 1){
						return data;
					}else{
						return "N/A";
					}
                },
				//className: "dt-body-right"
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
				//className: "dt-body-right"
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
			{data: null, name:"action",defaultContent: "", orderable: false, searchable: false},
		],
		columnDefs: [
			{
				targets: 5, // FT
				render: function (data, type, row) {
					if(data.calculationType == 1){
						return "N/A";
					}
					let ft = Math.round(((data.width)/304.8) * 100) / 100;
                    return ft;
                },
			},
			<sec:authorize access="hasAnyRole('ROLE_ADMIN', 'ROLE_USER_EDIT')">
				{
					targets: 9,
					render: function(data, type, row){
						return "<a onclick='showEditOrderDetailModal("+ data.lineNumber + ")' class='btn btn-sm btn-primary m-l-5'>Edit</a>"
						+ '<a onclick="showDeleteOrderDetailModal(' + data.lineNumber + ')" class="btn btn-sm btn-danger m-l-5" data-toggle="modal" data-target="#deleteOrderModal">Delete</a>'
					}
				}
			</sec:authorize>
		],
		footerCallback: function (row, data, start, end, display) { // Calculate subtotal
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

            $(api.column(0).footer()).addClass("text-right");
            $(api.column(0).footer()).html('RM ' + (total/100).toFixed(2));
		}
		
	});
	
	// $('#orderDetailTable').DataTable().ajax.reload();
	
	$("#printInvoiceButton").click(function(){
		window.open("invoice-merge-sketch?orderId=" + urlParams.get("orderId"), '_blank');
	})

	// Order date data on change and update order
	$('#orderDate').on('change', function(){
		loaderSpinner.show();
		$.ajax({
			type : "POST",
			url : "updateOrder",
			data: $('.order-form-data').serialize(),
			success: function(data){
				if(data.status == "success"){
					popSuccessToastr("Success", 'Successfully update order date');
					getOrder();
				}else if(data.status == "fail"){
					popErrorToastr('Failed', 'Failed to update order date');
				}
			},
			error: function(){
				loaderSpinner.hide();
			}
			
		}).done(function(){
			loaderSpinner.hide();
		});
	});
		
	// ---------------------------------------------------------------------------------
	// Create order detail part
	// ---------------------------------------------------------------------------------

	
	// Add new order detail drop -> drop down on change
	$('#createService').on('change', function(e){
		let selectedOption = $(this).find(':selected');
		if(selectedOption.attr('cal-type') == "1"){
			$("#createWidthDiv").hide();
			$("#createWidth").attr("disabled", true);
			$("#createHeightDiv").hide();
			$("#createHeight").attr("disabled", true);
			$("#createQuantityDiv").show();
			$("#createQuantity").attr("disabled", false);
		}else{
			$("#createWidthDiv").show();
			$("#createWidth").attr("disabled", false);
			$("#createHeightDiv").show();
			$("#createHeight").attr("disabled", false);
			$("#createQuantityDiv").hide();
			$("#createQuantity").attr("disabled", true);
		}
		changeCreatePriveValueBasedOnHeight();
	});
	
	$("#createHeight").on('change', function(e){
		changeCreatePriveValueBasedOnHeight();
	});
	
	// Open create modal
	$('#addNewOrderDetailModalButton').click(function(){
		clearCreateOrderDetailForm();
		$('#addNewOrderDetailModal').modal("show");
	})
	
	// Create modal save button
	$("#addNewOrderDetailModalSaveButton").click(function(){
		createOrderDetail();
	});
	
	$("#addNewOrderDetailModalForm").validate({
		rules : {
			createWidth: {
				required: function(){
					if($('#createService').find('option:selected').attr('cal-type') == "1"){
						return false;
					}else
						return true;
				}
			},
			createHeight: {
				required: function(){
					if($('#createService').find('option:selected').attr('cal-type') == "1"){
						return false;
					}else
						return true;
				}
			},
			createQuantity: {
				required: function(){
					if($('#createService').find('option:selected').attr('cal-type') == "1"){
						return true;
					}else
						return false;
				}
			}
		}
	});
	
	// -----------------------------------------------------------------------------------------------
	// Update order detail
	// -----------------------------------------------------------------------------------------------
	
	$("#editOrderDetailModalForm").validate({
		rules : {
			createWidth: {
				required: function(){
					if($('#editService').find('option:selected').attr('cal-type') == "1"){
						return false;
					}else
						return true;
				}
			},
			createHeight: {
				required: function(){
					if($('#editService').find('option:selected').attr('cal-type') == "1"){
						return false;
					}else
						return true;
				}
			},
			createQuantity: {
				required: function(){
					if($('#editService').find('option:selected').attr('cal-type') == "1"){
						return true;
					}else
						return false;
				}
			}
		}
	});
	
	$('#editService').on('change', function(e){
		let selectedOption = $(this).find(':selected');
		if(selectedOption.attr('cal-type') == "1"){
			$("#editWidthDiv").hide();
			$("#editWidth").attr("disabled", true);
			$("#editHeightDiv").hide();
			$("#editHeight").attr("disabled", true);
			$("#editQuantityDiv").show();
			$("#editQuantity").attr("disabled", false);
		}else{
			$("#editWidthDiv").show();
			$("#editWidth").attr("disabled", false);
			$("#editHeightDiv").show();
			$("#editHeight").attr("disabled", false);
			$("#editQuantityDiv").hide();
			$("#editQuantity").attr("disabled", true);
		}
		changeEditPriveValueBasedOnHeight();
	});
	
	$("#editHeight").on("change", function(){
		changeEditPriveValueBasedOnHeight();
	});
	
	$("#editOrderDetailModalSaveButton").click(function(){
		updateOrderDetail();
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
			
			// Populate the order other columns to the other details tab
			$("#order-remarks").val(data.remarks);
			$("#order-comments").val(data.comments);
		},
		error: function(data){
			$('#orderId').val("");
			$('#orderDate').val("");
			$("#order-remarks").val("");
			$("#order-comments").val("");
			loaderSpinner.hide();
		}
	}).done(function(){
		loaderSpinner.hide();
	});
}

// --------------------------------------------------------------------------------------------
// Create order detail functions
// --------------------------------------------------------------------------------------------

function clearCreateOrderDetailForm(){
	$("#createService").val("");
	$('#createService').selectpicker('val', '');
	$("#createDescription").val("");
	$("#createWidth").val("");
	$("#createHeight").val("");
	$("#createQuantity").val("");
	$("#createPrice").val("");
}

function createOrderDetail(){
	if($('#addNewOrderDetailModalForm').valid()){
		loaderSpinner.show();
		$('#addNewOrderDetailModal').modal("hide");
		var parameter = $("#addNewOrderDetailModalForm").serialize();
		parameter += "&createPriceSen=" + ($("#createPrice").val() * 100);
		parameter += "&orderId=" + ($("#orderId").val());
		$.ajax({
			type : "POST",
			url : "createOrderDetail",
			data: parameter,
			dataType: 'json',
			cache : false,
			success : function(data){
				if(data.status == "success"){
					loaderSpinner.hide();
					popSuccessToastr("Success", 'Successfully create order detail');
				}else if(data.status == "fail"){
					popErrorToastr("Failed", "Failed to create order detail");
				}
				$('#orderDetailTable').DataTable().ajax.reload();
			},
			error: function(data){
				loaderSpinner.hide();
				popErrorToastr("Failed", "Failed to create order detail");
			}
		}).done(function(){
			
		});
	}
}

// --------------------------------------------------------------------------
// Delete order detail functions
// --------------------------------------------------------------------------
function showDeleteOrderDetailModal(lineNumber){
	$('#deleteOrderDetailModal .modal-title').html('Delete order detail');
	$('#deleteOrderDetailModal').modal();
	$('#deleteOrderDetailModalButton').html(
			'<button type="button" class="btn btn-primary" onClick="deleteOrderDetail(\'' + lineNumber + '\')">Delete</button>'
	);
}

function deleteOrderDetail(lineNumber) {
	$('#deleteOrderDetailModal').modal("hide");
	loaderSpinner.show();
	let parameter = 'orderId=' + $("#orderId").val();
	parameter += "&lineNumber=" + lineNumber;
	$.ajax({
		type: "POST",
		url: "deleteOrderDetail",
		data: parameter,
		cache : false,
		dataType: "json",
		success : function(data){
			if(data.status == "success"){
				loaderSpinner.hide();
				popSuccessToastr("Success", 'Successfully delete order detail');
			}else if(data.status == "fail"){
				popErrorToastr("Failed", "Failed to delete order detail");
			}
			$('#orderDetailTable').DataTable().ajax.reload();
		},
		error: function (data){
			loaderSpinner.hide();
			popErrorToastr("Failed", "Failed to delete order detail");
			$('#orderDetailTable').DataTable().ajax.reload();
		}
	});
}

//-----------------------------------------------------------------------------------------------
// Update order detail functions
// -----------------------------------------------------------------------------------------------

function showEditOrderDetailModal(lineNumber){
	clearEditOrderDetailForm();
	$("#editOrderDetailModal").modal("show");
	getEditOrderDetail(lineNumber);
}

function getEditOrderDetail(lineNumber){
	let parameter = ("orderId=" + urlParams.get('orderId'));
	parameter += "&lineNumber=" + lineNumber; 
	loaderSpinner.show();
	$.ajax({
		type: "GET",
		url: "getOrderDetail",
		data: parameter,
		cache : false,
		dataType: "json",
		success : function(data){
			$("#editLineNumber").val(data.lineNumber);
			$("#editService").val(data.serviceId);
			$('#editService').selectpicker('render');
			$("#editDescription").val(data.description);
			$("#editWidth").val(data.width);
			$("#editHeight").val(data.height);
			$("#editQuantity").val(data.quantity);
			$("#editPrice").val((data.finalPrice/100).toFixed(2));
			if(data.calculationType == 1){
				$("#editWidthDiv").hide();
				$("#editHeightDiv").hide();
				$("#editQuantityDiv").show();
				
				$("#editWidth").attr("disabled", true);
				$("#editHeight").attr("disabled", true);
				$("#editQuantity").attr("disabled", false);
				
				
			}else{
				$("#editWidthDiv").show();
				$("#editHeightDiv").show();
				$("#editQuantityDiv").hide();
				$("#editWidth").attr("disabled", false);
				$("#editHeight").attr("disabled", false);
				$("#editQuantity").attr("disabled", true);
			}
			loaderSpinner.hide();
		},
		error: function (data){
			loaderSpinner.hide();
			popErrorToastr("Failed", "Failed to retrieve order detail");
		}
	});
}

function updateOrderDetail(){
	if($('#editOrderDetailModalForm').valid()){
		$('#editOrderDetailModal').modal("hide");
		loaderSpinner.show();
		var parameter = $("#editOrderDetailModalForm").serialize();
		parameter += "&editPriceSen=" + ($("#editPrice").val() * 100);
		parameter += "&orderId=" + ($("#orderId").val());
		$.ajax({
			type: "POST",
			url: "updateOrderDetail",
			data: parameter,
			cache : false,
			dataType: "json",
			success : function(data){
				if(data.status == "success"){
					loaderSpinner.hide();
					popSuccessToastr("Success", 'Successfully update order detail');
				}else if(data.status == "fail"){
					popErrorToastr("Failed", "Failed to update order detail");
				}
				$('#orderDetailTable').DataTable().ajax.reload();
			},
			error: function (data){
				loaderSpinner.hide();
				popErrorToastr("Failed", "Failed to update order detail");
				$('#orderDetailTable').DataTable().ajax.reload();
			}
		});
	}
	
}

function clearEditOrderDetailForm(){
	$("#editService").val("");
	$('#editService').selectpicker('val', '');
	$("#editDescription").val("");
	$("#editWidth").val("");
	$("#editHeight").val("");
	$("#editQuantity").val("");
	$("#editPrice").val("");
}

function getDiffPriceValue(arr, value){
	var result = null;;
	arr.reverse();
	
	// 由大到下，如果现在的height大过，就exit loop by return false. 
	$.each(arr, function(index, item){
		if(value >= item.height){
			result = item.price;
			return false;
		}
		
		// if reached the last, then return the smallest height
		if(index == arr.length - 1){
			result = arr[arr.length - 1].price;
		}
	});
	
	return result;
}

function changeCreatePriveValueBasedOnHeight(){
	let selectedOption = $("#createService").find(':selected');
	if(selectedOption.attr("diff-price") == "true"){
		let list = $.grep(differentPriceList, function (n, i) {
			   return (n.serviceId == selectedOption.attr('value'));
		});
		$("#createPrice").val((getDiffPriceValue(list,$("#createHeight").val())/100).toFixed(2));
	}else
		$("#createPrice").val((selectedOption.attr("data-price")/100).toFixed(2));
}

function changeEditPriveValueBasedOnHeight(){
	let selectedOption = $("#editService").find(':selected');
	if(selectedOption.attr("diff-price") == "true"){
		let list = $.grep(differentPriceList, function (n, i) {
			   return (n.serviceId == selectedOption.attr('value'));
		});
		$("#editPrice").val((getDiffPriceValue(list,$("#editHeight").val())/100).toFixed(2));
	}else{
		$("#editPrice").val((selectedOption.attr("data-price")/100).toFixed(2));
	}
}

</script>

<!-- <div id="loader"></div>
<div id="pop-message"></div> -->

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
				<!-- /# column -->
				<div class="col-lg-4 p-l-0 title-margin-left">
					<div class="page-header">
						<div class="page-title">
							<ol class="breadcrumb">
            					<li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/order/order.html">Orders</a></li>
            					<li class="breadcrumb-item"><a href="javascript:window.location.reload(true)">Orders details</a></li>
        					</ol>
						</div>
					</div>
				</div>
				<!-- /# column -->
			</div>
			<div class="row">
				<div class="col-lg-12 p-r-0">
					<ul class="nav nav-pills customtab2" role="tablist">
						<li class="nav-item"> <a class="nav-link active" data-toggle="tab" href="#main-details-tab" role="tab"><span class="hidden-sm-up"><i class="ti-home"></i></span> <span class="hidden-xs-down">Main Details</span></a> </li>
						<li class="nav-item"> <a class="nav-link" data-toggle="tab" href="#other-details-tab" role="tab"><span class="hidden-sm-up"><i class="ti-user"></i></span> <span class="hidden-xs-down">Other Details</span></a> </li>
					</ul>
				</div>
			</div>
			<section id="main-content">
				<div class="tab-content">
					<div class="tab-pane active" id="main-details-tab" role="tabpanel">
						<div class="">
							<div class="row">
								<div class="col-lg-12">
									<div class="card">
										<div class="card-body">
											<div class="row">
												<div class="col-sm-5">
													<form id="orderForm"
														class="form-horizontal order-form-data">
														<div class="form-group row">
															<label for="recipient-name"
																class="col-sm-3 col-form-label">Id</label>
															<div class="col-sm-9">
																<input type="text" class="form-control" id="orderId"
																	name="orderId" readonly>
															</div>
														</div>
														<div class="form-group row">
															<label for="recipient-name"
																class="col-sm-3 col-form-label">Date:</label>
															<div class="col-sm-9">
																<input type="date" class="form-control" id="orderDate"
																	name="orderDate" id="date" required
																	<sec:authorize access="!hasAnyRole('ROLE_ADMIN', 'ROLE_USER_EDIT')">
																		disabled
																	</sec:authorize>>
															</div>
														</div>
													</form>
												</div>
												<div class="col-sm-2"></div>
												<div class="col-sm-5">
													<div class="row">
														<div class="col-sm-12">
															<button id="printInvoiceButton"
																class="btn btn-sm btn-primary float-right">Print
																Invoice</button>
														</div>
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-md-12">
													<sec:authorize
														access="hasAnyRole('ROLE_ADMIN', 'ROLE_USER_EDIT')">
														<div class='row'>
															<div class="col-lg-12">
																<button id="addNewOrderDetailModalButton"
																	class="btn btn-sm btn-primary float-right"
																	data-toggle="modal">
																	<i class="ti-plus m-r-5"></i>Add new order detail
																</button>
															</div>
														</div>
													</sec:authorize>
													<div class='row'>
														<div class="col-lg-12">
															<div class="bootstrap-data-table-panel">
																<table id="orderDetailTable" class="table hover"
																	style="width: 100%;">
																	<!--table-bordered table-striped table-bordered  -->
																	<thead>
																		<tr>
																			<th>#</th>
																			<th>Service</th>
																			<th>Description</th>
																			<th>Width</th>
																			<th>Height</th>
																			<th>Ft</th>
																			<th>Quantity</th>
																			<th>Unit Price</th>
																			<th>Total Price</th>
																			<th>Action</th>
																		</tr>
																	</thead>
																	<tbody>
																	</tbody>
																	<tfoot>
																		<tr>
																			<th colspan="9" style="text-align: right"></th>
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
						</div>
					</div>
					<div class="tab-pane" id="other-details-tab" role="tabpanel">
						<div>
							<jsp:include
								page="/main/order/order-detail-other-details.jsp" />
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
				<h5 class="modal-title" id="exampleModalLabel">Add new order detail</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<form id="addNewOrderDetailModalForm" class="form-horizontal">
					<div class="form-group row">
						<label for="recipient-name" class="col-sm-3 col-form-label">Service</label>
						<div class="col-sm-9">
							<select class="form-control selectpicker" data-live-search="true" id="createService" name="createService" required>
								<c:forEach var="item" items="${serviceList}">
								    <option value="${item.id}" data-price=${item.price} diff-price="${item.differentPrice}" cal-type="${item.calculationType}">${item.descriptionEnglish}
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
							<input type="number" class="form-control" id="createWidth" name="createWidth" value="" min="0">
						</div>
					</div>
					<div class="form-group row" id="createHeightDiv">
						<label class="col-sm-3 col-form-label" for="createHeight">Height (高度)</label>
						<div class="col-sm-9">
							<input type="number" class="form-control" id="createHeight" name="createHeight" value="" min="0">
						</div>
					</div>
					<div class="form-group row" id="createQuantityDiv">
						<label class="col-sm-3 col-form-label" for="createQuantity">Quantity</label>
						<div class="col-sm-9">
							<input type="number" class="form-control" id="createQuantity" name="createQuantity" value="" min="1" step="1">
						</div>
					</div>
					<div class="form-group row">
							<label class="col-sm-3 col-form-label" for="createPrice">Unit Price</label>
							<div class="col-sm-9">
								<input type="number" class="form-control" id="createPrice" name="createPrice" value="" min="0" step="0.01" required>
							</div>
						</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" id="addNewOrderDetailModalSaveButton">Save</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="editOrderDetailModal" tabindex="-1" role="dialog"
	aria-labelledby="editOrderDetailModal" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">Edit order detail</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<form id="editOrderDetailModalForm" class="form-horizontal">
					<div class="form-group row">
						<label for="recipient-name" class="col-sm-3 col-form-label">Service</label>
						<div class="col-sm-9">
							<select class="form-control" data-live-search="true" id="editService" name="editService" required>
								<c:forEach var="item" items="${serviceList}">
								    <option value="${item.id}" data-price=${item.price} diff-price="${item.differentPrice}" cal-type="${item.calculationType}">${item.descriptionEnglish}
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
							<textarea rows="3" class="form-control" id="editDescription" name="editDescription"></textarea>
						</div>
					</div>
					<div class="form-group row" id="editWidthDiv">
						<label class="col-sm-3 col-form-label" for="editWidth">Width (宽度)</label>
						<div class="col-sm-9">
							<input type="number" class="form-control" id="editWidth" name="editWidth" value="" min="0">
						</div>
					</div>
					<div class="form-group row" id="editHeightDiv">
						<label class="col-sm-3 col-form-label" for="editHeight">Height (高度)</label>
						<div class="col-sm-9">
							<input type="number" class="form-control" id="editHeight" name="editHeight" value="" min="0">
						</div>
					</div>
					<div class="form-group row" id="editQuantityDiv">
						<label class="col-sm-3 col-form-label" for="editQuantity">Quantity</label>
						<div class="col-sm-9">
							<input type="number" class="form-control" id="editQuantity" name="editQuantity" value="" min="1" step="1">
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-3 col-form-label" for="editPrice">Unit Price</label>
						<div class="col-sm-9">
							<input type="number" class="form-control" id="editPrice" name="editPrice" value="" min="0" step="0.01" required>
						</div>
					</div>
					<div>
						<input type="hidden" id="editLineNumber" name="editLineNumber" />
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" id="editOrderDetailModalSaveButton">Save</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="deleteOrderDetailModal" tabindex="-1" role="dialog"
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
					Do you want to delete this?
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<span id='deleteOrderDetailModalButton'></span>
			</div>
		</div>
	</div>
</div>
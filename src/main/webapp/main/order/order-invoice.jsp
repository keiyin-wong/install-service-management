<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
#orderTable tbody tr{
cursor: pointer;
}

.datatable-checkbox{

}
</style>

<script type="text/javascript">
var loaderSpinner;
var orderTable;

$(document).ready(function(){
	loaderSpinner = $('#loader');
	$(".checkbox-options").hide();
	
	// ============================================================
	// Datatable
	// ============================================================
	
	orderTable = $('#orderTable').DataTable( {
		serverSide: true,
		searching: true,
		processing: true,
		language: { 
			//processing: '<i class="fa fa-spinner fa-spin fa-3x fa-fw"></i><span class="sr-only">Loading...</span> '
		},
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
			{
				data: null, 
				orderable: false,
				defaultContent: "",
				className: "datatable-skip-click"
			},
			{
				data: null, 
				orderable: false,
				defaultContent: "",
				render: function (data, type, row) {
					return '<input type="checkbox" name="selectedOrderIds" value="' + data.id + '" data-total="' + data.total + '"  />';
				},
				createdCell: cell => $(cell).addClass("datatable-skip-click").click(function(event){
					var $target = $(event.target);
					if(!$target.is('input:checkbox')){
						if($(this).find('input').is(':checked')){
							$(this).find('input').prop("checked",false);
						}else
							$(this).find('input').prop("checked",true);
					}
					if($("input[type=checkbox][name=selectedOrderIds]:checked").length == 0){
						$(".checkbox-options").hide();
						$("#selected-order-income-total").text("Total: " + "RM 0");
					}else{
						// Calculate the total and show it
						var total = 0;
						$.each($("input[type=checkbox][name=selectedOrderIds]:checked"), function(index, values){
							total = total + Number($(values).attr("data-total"));
						});
						let totalDisplay = 'RM ' + (total/100).toFixed(2);
						$("#selected-order-income-total").text("Total: " + totalDisplay);
						$(".checkbox-options").show();
					}
					//console.log($("input[type=checkbox][name=selectedOrderIds]:checked"));
				})
			},
			{
				data: "id", 
				name:"id",
				render: function (data, type, row) {
					return '<a class="text-primary" href="javascript:showInvoiceModal(' + data + ')" >' + data + '</a>';
				},
				createdCell: cell => $(cell).addClass("text-primary")
			},
			{
				data: "date", 
				name:"date",
				render: function (data, type) {
					if ( type === 'display' || type === 'filter' ) {
						var date = new Date(data);
					    const day = date.toLocaleString('default', { day: '2-digit' });
					    const month = date.toLocaleString('default', { month: '2-digit' });
					    const year = date.toLocaleString('default', { year: 'numeric' });
					    return day + '-' + month + '-' + year;
					}
					return data;
				},
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
				className: "dt-right"
			},
/* 			{
				data: null, 
				orderable: false,
				defaultContent: "",
				className: "datatable-skip-click"
			} */
		],
		order: [[2, 'desc']],
		initComplete: function(settings, json){
			$('#orderTable_filter input').unbind();
			$('#orderTable_filter input').bind('change', function(e) {
				orderTable.search( this.value ).draw();
			}); 
		},
		columnDefs: [
		 	{
				width: "5%", 
				targets: 0
			}
		],
	} );
	
	$('#orderTable').on('click', 'tbody td:not(".datatable-skip-click")', function() {
		let data =  orderTable.row(this).data();
	  	//console.log('API row values : ', orderTable.row(this).data());
	  	showInvoiceModal(data.id);
	});
	
	orderTable.on( 'draw', function () {
		if($("input[type=checkbox][name=selectedOrderIds]:checked").length == 0){
			$(".checkbox-options").hide();
			$("#selected-order-income-total").text("Total: " + "RM 0");
		}else{
			var total = 0;
			$.each($("input[type=checkbox][name=selectedOrderIds]:checked"), function(index, values){
				total = total + Number($(values).attr("data-total"));
			});
			let totalDisplay = 'RM ' + (total/100).toFixed(2);
			$("#selected-order-income-total").text("Total: " + totalDisplay);
			$(".checkbox-options").show();
		}
	});
	
	// ============================================================
	// Invoice modal
	// ============================================================
		
	$("#showInvoiceModalDownloadButton").on("click", function() {
		downloadInvoice($("#showInvoiceModelOrderId").val());
	});
	
});

//============================================================
// Invoice model functions
// ===========================================================
	
function showInvoiceModal (orderId){
/* 	$("#showInvoiceModal .modal-body").html("");
	$('#showInvoiceModal .modal-title').html("Invoice " + orderId);
	$("#showInvoiceModelOrderId").val(orderId);
	$('#showInvoiceModal').modal();
	fillInvoiceToModal(orderId); */
	
	window.open("invoice-merge-sketch?orderId=" + orderId, '_blank');
}

function fillInvoiceToModal(orderId) {
	loaderSpinner.show();
	$.ajax({
		type:"GET",
		url:"orderReportHtml.do?orderId=" + orderId,
		cache: false,
		success: function (data) {
/* 			let html = $("<div>").addClass("row").append(
					$("<div>").addClass("col-md-12").html(data));
			$("#showInvoiceModal .modal-body").append(html); */
			$("#showInvoiceModal .modal-body").html(data);
			loaderSpinner.hide();
		},
		error: function(data) {
			loaderSpinner.hide();
			popErrorToastr("Failed", "Failed to get invoice " + orderId);
		}
	})
}

function downloadInvoice(orderId) {
	window.open("orderReport.do?orderId=" + orderId + "&inline=0");
}


// ============================================================
// Download multiple model functions
// ===========================================================
function showDownloadMultipleModal(){
	$('#downloadMultipleModal .modal-title').html('Download selected invoices');
	$('#downloadMultipleModal').modal();
	$('#downloadMultipleModalButton').html(
			'<button type="button" class="btn btn-primary" onClick="javascript:downloadMultipleInvoices()">Download</button>'
	);
}

function downloadMultipleInvoices() {
	$('#downloadMultipleModal').modal('hide');
	let data = $("input[type=checkbox][name=selectedOrderIds]:checked").serialize();
	window.open("multipleOrderReport.do?"+ data );
	$("input[type=checkbox][name=selectedOrderIds]:checked").prop("checked", false);
	$(".checkbox-options").hide();
	orderTable.DataTable().ajax.reload();
}


// ============================================================
// Download multiple invoices with sketch functions
// ===========================================================

function showDownloadMultipleInvoicesWithSketchModal() {
	$('#downloadMultipleModal .modal-title').html('Download selected invoices');
	$('#downloadMultipleModal').modal();
	$('#downloadMultipleModalButton').html(
			'<button type="button" class="btn btn-primary" onClick="downloadMultipleInvoicesWithSketch()">Download</button>'
	);
}

function downloadMultipleInvoicesWithSketch() {
	$('#downloadMultipleModal').modal('hide');
	let data = $("input[type=checkbox][name=selectedOrderIds]:checked").serialize();
	window.open("multipleOrderReport.do?isMergeWithSketch=1&"+ data );
	$("input[type=checkbox][name=selectedOrderIds]:checked").prop("checked", false);
	$(".checkbox-options").hide();
	orderTable.DataTable().ajax.reload();
}


</script>

<div id="loader"></div>
<div id="pop-message"></div>

<div class="content-wrap">
	<div class="main">
		<div class="container-fluid">
			<div class="row">
				<div class="col-lg-8 p-r-0 title-margin-right">
					<div class="page-header pull-left">
						<div class="page-title">
        					<ol class="breadcrumb">
            					<li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/order/order-invoice.html">Invoices</a></li>
        					</ol>
					    </div>
					</div>
				</div>
			</div>
			<section id="main-content">
				<div class="row">
					<div class="col-lg-6">
						<div class="card">
							<div class="stat-widget-four">
								<div class="stat-icon">
									<i class="ti-stats-up"></i>
								</div>
								<div class="stat-content">
									<div class="text-left dib">
										<div class="stat-heading">Selected Order Total</div>
										<div class="stat-text" id="selected-order-income-total">Total: RM 0</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div class="card">
							<div class='row'>
								<div class="col-lg-12 checkbox-options hidden">
									<button id="show-download-multiple-invoice-modal-button" class="btn btn-sm btn-primary m-l-5"
										onclick="javascript:showDownloadMultipleModal()">Download</button>
									<button id="show-download-multiple-invoice-sketch-modal-button" class="btn btn-sm btn-primary m-l-5" 
										onclick="javascript:showDownloadMultipleInvoicesWithSketchModal()">Download with sketch</button>
								</div>
								<div class="col-lg-12">
									<div class="bootstrap-data-table-panel">
										<table id="orderTable" class="table table-hover compact"> <!-- table-striped -->
											<thead>
												<tr>
													<th>#</th>
													<th></th>
													<th>Order Id</th>
													<th>Order Date</th>
													<th>Total</th>
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

<div class="modal fade" id="showInvoiceModal" tabindex="-1" role="dialog"
	aria-labelledby="showInvoiceModel" aria-hidden="true">
	<input type="hidden" id="showInvoiceModelOrderId" />
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Invoice</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" id="showInvoiceModalDownloadButton">Download</button>
			</div>
		</div>
	</div>
</div>


<div class="modal fade" id="downloadMultipleModal" tabindex="-1" role="dialog"
	aria-labelledby="deleteOrderModal" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Download invoices</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="alert">
					Do you want to download this order?
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<span id='downloadMultipleModalButton'></span>
			</div>
		</div>
	</div>
</div>

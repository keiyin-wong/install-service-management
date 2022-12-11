<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
	
<style>
td a {
	color: white !important;
}
</style>

<script type="text/javascript">
var serviceDatatable;
var loaderSpinner = $('#loader');

$(document).ready(function(){
	serviceDatatable = $("#service-table").DataTable({
		serverSide: true,
		dom: "lfrtip",
		searching: true,
		processing: true,
		responsive: true,
		lengthMenu: [
			[5, 10, 20, 50, 100], //value
			[5, 10, 20, 50, 100], // name
		],
		ordering: true,
		order: [[0, 'asc']],
		lengthChange: true,
		pageLength: 20,
		ajax: {
			url: '${pageContext.request.contextPath}/service/datatable',
			type: 'POST',
			data: function(d){
			}
		},
		columns: [
			{
				data: "id",
				name: "id",
			},
			{
				data: "descriptionEnglish",
				name: "description_english",
			},
			{
				data: "descriptionChinese",
				orderable: false,
				name: "description_chinese",
			},
			{
				data: "calculationType",
				name: "calculation_type",
				render: function (data, type){
					if ( type === 'display' || type === 'filter' ) {
						switch(data) {
							case 0:
								return `<span class="badge badge-primary">FT</span>`;
							case 1:
								return `<span class="badge badge-warning">Quantity</span>`;
							case 2:
								return `<span class="badge badge-info">Panel</span>`;
						}
					}
					return data;
				},
			},
			{
				data: "price",
				name: "price",
				className: "dt-right",
				render: function (data, type){
					if ( type === 'display' || type === 'filter' ) {
						return 'RM ' + (data/100).toFixed(2);
					}
					return data;
				},
			},
			{
				data: null,
				orderable: false,
				defaultContent: "",
			},
		],
		columnDefs: [
			<sec:authorize access="hasAnyRole('ROLE_ADMIN')">
			{
				targets: 5,
				render: function(data, type, row){
					return `
					<a onclick='openEditServiceModal(\${row.id})' class='btn btn-sm btn-primary m-l-5'>Edit</a>`
				}
			}
			</sec:authorize>	
		]
	});
	
})

// ===========================================================
// Edit modal function part
// ===========================================================
	
function openEditServiceModal(id) {
	$("#add-edit-service-modal .modal-title").text("Edit system parameter");
	
	// Modify the modal footer
	$("#add-edit-service-modal .modal-footer").empty().append(
		$("<button>").addClass("btn btn-secondary").prop("type", "button").attr("data-dismiss", "modal").text("Cancel"),
		$("<button>").addClass("btn btn-primary").prop("type", "button").text("Save").click(function() {
			updateSystemParameter();
		}),
	);
	$("#add-edit-service-modal").modal("show");
	
	loaderSpinner.show();
	clearAddEditServiceForm();
	$.ajax({
		type: "GET",
		url: "${pageContext.request.contextPath}/service",
		data: {
			id: id
		},
		cache : false,
		dataType: "json",
		success : function(data){
			$("#add-edit-service-modal-form input[name=id]").val(data.id);
			$("#add-edit-service-modal-form textarea[name=descriptionEnglish]").val(data.descriptionEnglish);
			$("#add-edit-service-modal-form textarea[name=descriptionChinese]").val(data.descriptionChinese);
			$("#add-edit-service-modal-form select[name=calculationType]").val(data.calculationType);
			$("#add-edit-service-modal-form input[name=price]").val((data.price/100).toFixed(2));
			$("#add-edit-service-modal").modal("show");
		},
		error: function (jqxhr){
			popErrorToastr("Failed", "Failed to system parameter");
		},
		complete: function() {
			loaderSpinner.hide();
		}
	});
}

// ===========================================================
// Other functions
// ===========================================================
function clearAddEditServiceForm() {
	$("#add-edit-service-modal-form").trigger("reset");
}
	
</script>

<div class="content-wrap">
	<div class="main">
		<div class="container-fluid">
			<div class="row">
				<div class="col-lg-8 p-r-0 title-margin-right">
					<div class="page-header">
						<div class="page-title">
							<h1>All Installation Services</h1>
						</div>
					</div>
				</div>
				<!-- /# column -->
				<div class="col-lg-4 p-l-0 title-margin-left">
					<div class="page-header">
						<div class="page-title">
							<ol class="breadcrumb">
            					<li class="breadcrumb-item-active"><a href="${pageContext.request.contextPath}/service/service.html">Service</a></li>
							</ol>
						</div>
					</div>
				</div>
				<!-- /# column -->
			</div>
			<!-- /# row -->
			<section id="main-content">
				<div class="row">
					<div class="col-lg-12">
						<div class="card">
							<%--
							<div class="card-title">
								<h3>System parameters</h3>
							</div>
							 --%>
							<div class="card-body">
								<div class="bootstrap-data-table-panel">
									<table id="service-table" 
										class="table table-sm table-hover"
										style="width:100%" >
										<!-- table-striped -->
										<thead>
											<tr>
												<th>Id</th>
												<th>English Description</th>
												<th>Chinese Description</th>
												<th>Calculation type</th>
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
			</section>
		</div>
	</div>
</div>


<div class="modal fade" id="add-edit-service-modal" tabindex="-1" role="dialog"
	aria-labelledby="add-edit-service-modal" aria-hidden="true" data-backdrop="static" >
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title"></h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<form id="add-edit-service-modal-form" class="form-horizontal">
					<input type="hidden" name="id" />
					<div class="form-group row">
						<label for="recipient-name" class="col-sm-3 col-form-label">English Description</label>
						<div class="col-sm-9">
							<textarea rows="3" class="form-control" name="descriptionEnglish"></textarea>
						</div>
					</div>
					<div class="form-group row">
						<label for="recipient-name" class="col-sm-3 col-form-label">Chinese Description</label>
						<div class="col-sm-9">
							<textarea rows="3" class="form-control" name="descriptionChinese"></textarea>
						</div>
					</div>
					<div class="form-group row">
						<label for="recipient-name" class="col-sm-3 col-form-label">Type</label>
						<div class="col-sm-9">
							<select class="form-control" name="calculationType">
								<option value="0">FT</option>	
								<option value="1">Quantity</option>	
								<option value="2">Panel</option>	
							</select>
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-3 col-form-label" for="editPrice">Unit Price</label>
						<div class="col-sm-9">
							<input type="number" class="form-control" name="price" min="0" step="0.01" required>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
			</div>
		</div>
	</div>
</div>

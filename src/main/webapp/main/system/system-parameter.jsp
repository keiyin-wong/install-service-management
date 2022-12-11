<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<script type="text/javascript">
var systemParameterDatatable;
var loaderSpinner = $('#loader');

$(document).ready(function(){
	
	// System parameter datatable
	systemParameterDatatable = $('#system-parameter-table').DataTable({
		serverSide: true,
		dom: "lfrtip",
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
		order: [[0, 'asc']],
		lengthChange: true,
		pageLength: 10,
		ajax: {
			url: '${pageContext.request.contextPath}/system/parameter/datatable',
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
				data: "name",
				name: "name",
			},
			{
				data: "description",
				name: "description",
			},
			{
				data: "value",
				name: "value",
			},
			{
				data: null,
				orderable: false,
				defaultContent: "",
			},
		],
		columnDefs: [
			<sec:authorize access="hasAnyRole('ROLE_ADMIN', 'ROLE_USER_EDIT')">
			{
				targets: 4,
				render: function(data, type, row){
					return `
					<a onclick='javascript:openEditSystemParameterModal(\${row.id})' class='btn btn-sm btn-primary m-l-5'>Edit</a>`
				}
			}
			</sec:authorize>	
		]
	});
	
})

// ===========================================================
// Edit modal function part
// ===========================================================

function openEditSystemParameterModal(id) {
	$("#add-edit-system-parameter-modal .modal-title").text("Edit system parameter");
	
	// Modify the modal footer
	$("#add-edit-system-parameter-modal .modal-footer").empty().append(
		$("<button>").addClass("btn btn-secondary").prop("type", "button").attr("data-dismiss", "modal").text("Cancel"),
		$("<button>").addClass("btn btn-primary").prop("type", "button").text("Save").click(function() {
			updateSystemParameter();
		}),
	);
	
	loaderSpinner.show();
	clearAddEditSystemParameterForm();
	getSystemParameter(id).then((data) => {
		loaderSpinner.hide();
		$("#add-edit-system-parameter-modal-form input[name=id]").val(data.id);
		$("#add-edit-system-parameter-modal-form input[name=name]").val(data.name);
		$("#add-edit-system-parameter-modal-form textarea[name=description]").val(data.description);
		$("#add-edit-system-parameter-modal-form textarea[name=value]").val(data.value);
		$("#add-edit-system-parameter-modal").modal("show");
	}).catch((error) => {
		loaderSpinner.hide();
		popErrorToastr("Failed", "Failed to system parameter");
	})
}

function getSystemParameter(id) {
	return new Promise((resolve, reject) => {
		$.ajax({
			type: "GET",
			url: "${pageContext.request.contextPath}/system/parameter",
			data: {
				id: id
			},
			cache : false,
			dataType: "json",
			success : function(data){
				resolve(data);	
			},
			error: function (jqxhr){
				reject(jqxhr);
			},
		});
	});
}

function updateSystemParameter() {
	$('#add-edit-system-parameter-modal').modal("hide");
	loaderSpinner.show();
	$.ajax({
		type: "POST",
		url: "${pageContext.request.contextPath}/system/parameter/update",
		data: $("#add-edit-system-parameter-modal-form").serialize(),
		cache : false,
		dataType: "json",
		success : function(data){
			if(data.status == "success"){
				popSuccessToastr("Success", 'Successfully update system parameter');
			}else if(data.status == "fail"){
				popErrorToastr("Failed", "Failed to update system parameter");
			}
			$('#system-parameter-table').DataTable().ajax.reload();
		},
		error: function (data){
			popErrorToastr("Failed", "Failed to update system parameter");
			$('#system-parameter-table').DataTable().ajax.reload();
		},
		complete: function() {
			loaderSpinner.hide();
		}
	});
}


// ===========================================================
// Other functions
// ===========================================================
function clearAddEditSystemParameterForm() {
	$("#add-edit-system-parameter-modal-form").trigger("reset");
}
	
</script>

<div class="content-wrap">
	<div class="main">
		<div class="container-fluid">
			<div class="row">
				<div class="col-lg-8 p-r-0 title-margin-right">
					<div class="page-header">
						<div class="page-title">
							<h1>All System Parameters</h1>
						</div>
					</div>
				</div>
				<!-- /# column -->
				<div class="col-lg-4 p-l-0 title-margin-left">
					<div class="page-header">
						<div class="page-title">
							<ol class="breadcrumb">
            					<li class="breadcrumb-item-active"><a href="${pageContext.request.contextPath}/system/system-parameter.html">System Parameter</a></li>
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
									<table id="system-parameter-table" 
										class="table table-hover <%--table-striped table-bordered--%>"
										style="width:100%" >
										<!-- table-striped -->
										<thead>
											<tr>
												<th style="width:5%">Id</th>
												<th style="width:25%">Name</th>
												<th style="width:25%">Description</th>
												<th style="width:25%">Value</th>
												<th style="width:20%">Action</th>
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


<div class="modal fade" id="add-edit-system-parameter-modal" tabindex="-1" role="dialog"
	aria-labelledby="add-edit-system-parameter-modal" aria-hidden="true" data-backdrop="static" >
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
				<form id="add-edit-system-parameter-modal-form" class="form-horizontal">
					<input type="hidden" name="id" />
					<div class="form-group row">
						<label for="recipient-name" class="col-sm-3 col-form-label">Name</label>
						<div class="col-sm-9">
							<input type="text" class="form-control" name="name" />
						</div>
					</div>
					<div class="form-group row">
						<label for="recipient-name" class="col-sm-3 col-form-label">Description</label>
						<div class="col-sm-9">
							<textarea rows="3" class="form-control" name="description"></textarea>
						</div>
					</div>
					<div class="form-group row">
						<label for="recipient-name" class="col-sm-3 col-form-label">Value</label>
						<div class="col-sm-9">
							<textarea rows="5" class="form-control" name="value"></textarea>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
			</div>
		</div>
	</div>
</div>

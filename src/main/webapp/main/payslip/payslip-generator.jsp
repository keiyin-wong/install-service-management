<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<script type="text/javascript">
var loaderSpinner;
var payslipList;

$(document).ready(function(){
	loaderSpinner = $('#loader');
	getAllPayslip();
	
	$("#previewButton").click(function() {
		$('#previewPayslipModal').modal("show");
		loaderSpinner.show();
		let modalBody = $("#previewPayslipModal").find('.modal-body');
		modalBody.html("");
		modalBody.append(
			$("<iframe>").css("width","100%").css("height", "650px").prop("src", "payslipHtml.do")
			.on("load", function() {loaderSpinner.hide();})
		);
	})
	
	// ============================================================
	// information part
	// ============================================================
	$("#informationCard .editButton").click(function () {
		informationEditMode();
	})
	$("#informationCard .cancelButton").click(function () {
		informationViewMode();
		$("#companyName").val(payslipList.find(x => x.type === "comp_name").name);
		$("#payPeriod").val(payslipList.find(x => x.type === "pay_period").name);
		$("#employeeName").val(payslipList.find(x => x.type === "emp_name").name);
		$("#staffId").val(payslipList.find(x => x.type === "staff_id").name);
		$("#department").val(payslipList.find(x => x.type === "dept").name);
		$("#ic").val(payslipList.find(x => x.type === "ic").name);
		
		var trList = $("#earningTable tbody tr");
		console.log(trList[0].children);
		$.each(trList, function(index, values) {
			console.log(index, trList[index]);
			let inputText = values.children[0];
			let amount = values.children[1];
			console.log(inputText, amount);
		});
	})
	$("#informationCard .saveButton").click(function () {
		let parameter = $("#informationForm").serialize();
		loaderSpinner.show();
		$.ajax({
			type: "POST",
			url: "updatePayslipInformation",
			data: parameter,
			cache : false,
			dataType: "json",
			success : function(data) {
				if(data.status == "success") {
					popSuccessToastr("Success", 'Successfully update payslip information');
				}else {
					popErrorToastr("Failed", "Failed to update payslip information");
				}
				loaderSpinner.hide();
				informationViewMode();
				getAllPayslip();
			},
			error: function (data) {
				popErrorToastr("Failed", "Failed to update payslip information");
				loaderSpinner.hide();
				informationViewMode();
				getAllPayslip();
			}
		});
	})
	
	// ============================================================
	// Billing information part
	// ============================================================
		
	$("#billingInformationCard .editButton").click(function () {
		billingInformationEditMode();
	})
		
	$("#billingInformationCard .cancelButton").click(function () {
		billingInformationViewMode();
		$("#epfId").val(payslipList.find(x => x.type === "epf_id").name);
		$("#taxId").val(payslipList.find(x => x.type === "tax_id").name);
		$("#soscoEisId").val(payslipList.find(x => x.type === "sosco_id").name);
		$("#bankId").val(payslipList.find(x => x.type === "bank_acc").name);
	})
	
	$("#billingInformationCard .saveButton").click(function () {
		let parameter = $("#billingInformationForm").serialize();
		loaderSpinner.show();
		$.ajax({
			type: "POST",
			url: "updatePayslipBillingInformation",
			data: parameter,
			cache : false,
			dataType: "json",
			success : function(data) {
				if(data.status == "success") {
					popSuccessToastr("Success", 'Successfully update payslip billing information');
				}else {
					popErrorToastr("Failed", "Failed to update payslip billing information");
				}
				loaderSpinner.hide();
				billingInformationViewMode();
				getAllPayslip();
			},
			error: function (data) {
				popErrorToastr("Failed", "Failed to update payslip billing information");
				loaderSpinner.hide();
				billingInformationViewMode();
				getAllPayslip();
			}
		});
	})
	
	// ============================================================
	// Current month employee epf sosco part
	// ============================================================
		
	$("#currentMonthEmployeeEpfSoscoCard .editButton").click(function () {
		currentMonthEmployeeEpfSoscoEditMode();
	})
		
	$("#currentMonthEmployeeEpfSoscoCard .cancelButton").click(function () {
		currentMonthEmployeeEpfSoscoViewMode();
		
		// Current month employee epf sosco information
		$("#currentMonthEmployeeEpf").val(payslipList.find(x => x.type === "employee_month_epf").amount);
		$("#currentMonthEmployeeSosco").val(payslipList.find(x => x.type === "employee_month_sosco").amount);
		$("#currentMonthEmployeeEis").val(payslipList.find(x => x.type === "employee_month_eis").amount);
	})
	
	$("#currentMonthEmployeeEpfSoscoCard .saveButton").click(function () {
		if($("#currentMonthEmployeeEpfSoscoForm").valid()) {
			let parameter = $("#currentMonthEmployeeEpfSoscoForm").serialize();
			loaderSpinner.show();
			$.ajax({
				type: "POST",
				url: "updateCurrentMonthEmployeeEpfSosco",
				data: parameter,
				cache : false,
				dataType: "json",
				success : function(data) {
					if(data.status == "success") {
						popSuccessToastr("Success", 'Successfully update employee current month epf sosco');
					}else {
						popErrorToastr("Failed", "Failed to update employee current month epf sosco");
					}
					loaderSpinner.hide();
					currentMonthEmployeeEpfSoscoViewMode();
					getAllPayslip();
				},
				error: function (data) {
					popErrorToastr("Failed", "Failed to update employee current month epf sosco");
					loaderSpinner.hide();
					currentMonthEmployeeEpfSoscoViewMode();
					getAllPayslip();
				}
			});
		}
	})
	
	// ============================================================
	// Current month employer epf sosco part
	// ============================================================
		
	$("#currentMonthEmployerEpfSoscoCard .editButton").click(function () {
		currentMonthEmployerEpfSoscoEditMode();
	})
		
	$("#currentMonthEmployerEpfSoscoCard .cancelButton").click(function () {
		currentMonthEmployerEpfSoscoViewMode();
		
		// Current month employee epf sosco information
		$("#currentMonthEmployerEpf").val(payslipList.find(x => x.type === "employer_month_epf").amount);
		$("#currentMonthEmployerSosco").val(payslipList.find(x => x.type === "employer_month_sosco").amount);
		$("#currentMonthEmployerEis").val(payslipList.find(x => x.type === "employer_month_eis").amount);
	})
	
	$("#currentMonthEmployerEpfSoscoCard .saveButton").click(function () {
		if($("#currentMonthEmployerEpfSoscoForm").valid()) {
			let parameter = $("#currentMonthEmployerEpfSoscoForm").serialize();
			loaderSpinner.show();
			$.ajax({
				type: "POST",
				url: "updateCurrentMonthEmployerEpfSosco",
				data: parameter,
				cache : false,
				dataType: "json",
				success : function(data) {
					if(data.status == "success") {
						popSuccessToastr("Success", 'Successfully update employer current month epf sosco');
					}else {
						popErrorToastr("Failed", "Failed to update employer current month epf sosco");
					}
					loaderSpinner.hide();
					currentMonthEmployerEpfSoscoViewMode();
					getAllPayslip();
				},
				error: function (data) {
					popErrorToastr("Failed", "Failed to update employer current month epf sosco");
					loaderSpinner.hide();
					currentMonthEmployerEpfSoscoViewMode();
					getAllPayslip();
				}
			});
		}
	})
	
	// ============================================================
	// Year to date employee epf sosco part
	// ============================================================
		
	$("#yearToDateEmployeeEpfSoscoCard .editButton").click(function () {
		yearToDateEmployeeEpfSoscoEditMode();
	})
		
	$("#yearToDateEmployeeEpfSoscoCard .cancelButton").click(function () {
		yearToDateEmployeeEpfSoscoViewMode();
		
		// Current month employee epf sosco information
		$("#yearToDateEmployeeEpf").val(payslipList.find(x => x.type === "employee_year_epf").amount);
		$("#yearToDateEmployeeSosco").val(payslipList.find(x => x.type === "employee_year_sosco").amount);
		$("#yearToDateEmployeeEis").val(payslipList.find(x => x.type === "employee_year_eis").amount);
	})
	
	$("#yearToDateEmployeeEpfSoscoCard .saveButton").click(function () {
		if($("#yearToDateEmployeeEpfSoscoForm").valid()) {
			let parameter = $("#yearToDateEmployeeEpfSoscoForm").serialize();
			loaderSpinner.show();
			$.ajax({
				type: "POST",
				url: "updateYearToDateEmployeeEpfSosco",
				data: parameter,
				cache : false,
				dataType: "json",
				success : function(data) {
					if(data.status == "success") {
						popSuccessToastr("Success", 'Successfully update employee year to date epf sosco');
					}else {
						popErrorToastr("Failed", "Failed to update employee year to date epf sosco");
					}
					loaderSpinner.hide();
					yearToDateEmployeeEpfSoscoViewMode();
					getAllPayslip();
				},
				error: function (data) {
					popErrorToastr("Failed", "Failed to update employee year to date epf sosco");
					loaderSpinner.hide();
					yearToDateEmployeeEpfSoscoViewMode();
					getAllPayslip();
				}
			});
		}
	})
	
	// ============================================================
	// Year to date employer epf sosco part
	// ============================================================
		
	$("#yearToDateEmployerEpfSoscoCard .editButton").click(function () {
		yearToDateEmployerEpfSoscoEditMode();
	})
		
	$("#yearToDateEmployerEpfSoscoCard .cancelButton").click(function () {
		yearToDateEmployerEpfSoscoViewMode();
		
		// Current month employee epf sosco information
		$("#yearToDateEmployerEpf").val(payslipList.find(x => x.type === "employer_year_epf").amount);
		$("#yearToDateEmployerSosco").val(payslipList.find(x => x.type === "employer_year_sosco").amount);
		$("#yearToDateEmployerEis").val(payslipList.find(x => x.type === "employer_year_eis").amount);
	})
	
	$("#yearToDateEmployerEpfSoscoCard .saveButton").click(function () {
		if($("#yearToDateEmployerEpfSoscoForm").valid()) {
			let parameter = $("#yearToDateEmployerEpfSoscoForm").serialize();
			loaderSpinner.show();
			$.ajax({
				type: "POST",
				url: "updateYearToDateEmployerEpfSosco",
				data: parameter,
				cache : false,
				dataType: "json",
				success : function(data) {
					if(data.status == "success") {
						popSuccessToastr("Success", 'Successfully update employer year to date epf sosco');
					}else {
						popErrorToastr("Failed", "Failed to update employer year to date epf sosco");
					}
					loaderSpinner.hide();
					yearToDateEmployerEpfSoscoViewMode();
					getAllPayslip();
				},
				error: function (data) {
					popErrorToastr("Failed", "Failed to update employer year to date epf sosco");
					loaderSpinner.hide();
					yearToDateEmployerEpfSoscoViewMode();
					getAllPayslip();
				}
			});
		}
	})
})


// ============================================================
// information part
// ============================================================
function informationEditMode() {
	$("#informationCard .editButton").hide();
	$("#informationCard .saveEditButtonBox").show();

	// Make all fields editable
	$("#companyName").prop("readonly", false);
	$("#payPeriod").prop("readonly", false);
	$("#employeeName").prop("readonly", false);
	$("#staffId").prop("readonly", false);
	$("#department").prop("readonly", false);
	$("#ic").prop("readonly", false);
}

function informationViewMode() {
	$("#informationCard .editButton").show();
	$("#informationCard .saveEditButtonBox").hide();

	// Make all fields not editable
	$("#companyName").prop("readonly", true);
	$("#payPeriod").prop("readonly", true);
	$("#employeeName").prop("readonly", true);
	$("#staffId").prop("readonly", true);
	$("#department").prop("readonly", true);
	$("#ic").prop("readonly", true);
}

//============================================================
// Billing information part
//============================================================
function billingInformationEditMode() {
	$("#billingInformationCard .editButton").hide();
	$("#billingInformationCard .saveEditButtonBox").show();

	// Make all fields editable
	$("#epfId").prop("readonly", false);
	$("#taxId").prop("readonly", false);
	$("#soscoEisId").prop("readonly", false);
	$("#bankId").prop("readonly", false);
}

function billingInformationViewMode() {
	$("#billingInformationCard .editButton").show();
	$("#billingInformationCard .saveEditButtonBox").hide();

	// Make all fields not editable
	$("#epfId").prop("readonly", true);
	$("#taxId").prop("readonly", true);
	$("#soscoEisId").prop("readonly", true);
	$("#bankId").prop("readonly", true);
}


//============================================================
// Current month employee epf sosco part
//============================================================
function currentMonthEmployeeEpfSoscoEditMode() {
	$("#currentMonthEmployeeEpfSoscoCard .editButton").hide();
	$("#currentMonthEmployeeEpfSoscoCard .saveEditButtonBox").show();

	// Make all fields editable
	$("#currentMonthEmployeeEpf").prop("readonly", false);
	$("#currentMonthEmployeeSosco").prop("readonly", false);
	$("#currentMonthEmployeeEis").prop("readonly", false);
}

function currentMonthEmployeeEpfSoscoViewMode() {
	$("#currentMonthEmployeeEpfSoscoCard .editButton").show();
	$("#currentMonthEmployeeEpfSoscoCard .saveEditButtonBox").hide();

	// Make all fields not editable
	$("#currentMonthEmployeeEpf").prop("readonly", true);
	$("#currentMonthEmployeeSosco").prop("readonly", true);
	$("#currentMonthEmployeeEis").prop("readonly", true);
}

//============================================================
//Current month employer epf sosco part
//============================================================
function currentMonthEmployerEpfSoscoEditMode() {
	$("#currentMonthEmployerEpfSoscoCard .editButton").hide();
	$("#currentMonthEmployerEpfSoscoCard .saveEditButtonBox").show();

	// Make all fields editable
	$("#currentMonthEmployerEpf").prop("readonly", false);
	$("#currentMonthEmployerSosco").prop("readonly", false);
	$("#currentMonthEmployerEis").prop("readonly", false);
}

function currentMonthEmployerEpfSoscoViewMode() {
	$("#currentMonthEmployerEpfSoscoCard .editButton").show();
	$("#currentMonthEmployerEpfSoscoCard .saveEditButtonBox").hide();

	// Make all fields not editable
	$("#currentMonthEmployerEpf").prop("readonly", true);
	$("#currentMonthEmployerSosco").prop("readonly", true);
	$("#currentMonthEmployerEis").prop("readonly", true);
}

// ============================================================
// Year to date employee epf sosco part
// ============================================================
function yearToDateEmployeeEpfSoscoEditMode() {
	$("#yearToDateEmployeeEpfSoscoCard .editButton").hide();
	$("#yearToDateEmployeeEpfSoscoCard .saveEditButtonBox").show();

	// Make all fields editable
	$("#yearToDateEmployeeEpf").prop("readonly", false);
	$("#yearToDateEmployeeSosco").prop("readonly", false);
	$("#yearToDateEmployeeEis").prop("readonly", false);
}

function yearToDateEmployeeEpfSoscoViewMode() {
	$("#yearToDateEmployeeEpfSoscoCard .editButton").show();
	$("#yearToDateEmployeeEpfSoscoCard .saveEditButtonBox").hide();

	// Make all fields not editable
	$("#yearToDateEmployeeEpf").prop("readonly", true);
	$("#yearToDateEmployeeSosco").prop("readonly", true);
	$("#yearToDateEmployeeEis").prop("readonly", true);
}

//============================================================
//Year to date employee epf sosco part
//============================================================
function yearToDateEmployerEpfSoscoEditMode() {
	$("#yearToDateEmployerEpfSoscoCard .editButton").hide();
	$("#yearToDateEmployerEpfSoscoCard .saveEditButtonBox").show();

	// Make all fields editable
	$("#yearToDateEmployerEpf").prop("readonly", false);
	$("#yearToDateEmployerSosco").prop("readonly", false);
	$("#yearToDateEmployerEis").prop("readonly", false);
}

function yearToDateEmployerEpfSoscoViewMode() {
	$("#yearToDateEmployerEpfSoscoCard .editButton").show();
	$("#yearToDateEmployerEpfSoscoCard .saveEditButtonBox").hide();

	// Make all fields not editable
	$("#yearToDateEmployerEpf").prop("readonly", true);
	$("#yearToDateEmployerSosco").prop("readonly", true);
	$("#yearToDateEmployerEis").prop("readonly", true);
}

//============================================================
// Others part
//============================================================
function getAllPayslip() {
	loaderSpinner.show();
	$.ajax({
		type: "GET",
		url: "getAllPayslip",
		cache : false,
		dataType: "json",
		success : function(data) {
			$("#companyName").val(data.find(x => x.type === "comp_name").name);
			$("#payPeriod").val(data.find(x => x.type === "pay_period").name);
			$("#employeeName").val(data.find(x => x.type === "emp_name").name);
			$("#staffId").val(data.find(x => x.type === "staff_id").name);
			$("#department").val(data.find(x => x.type === "dept").name);
			$("#ic").val(data.find(x => x.type === "ic").name);
			
			// Billing information
			$("#epfId").val(data.find(x => x.type === "epf_id").name);
			$("#taxId").val(data.find(x => x.type === "tax_id").name);
			$("#soscoEisId").val(data.find(x => x.type === "sosco_id").name);
			$("#bankId").val(data.find(x => x.type === "bank_acc").name);
			
			// Current month employee epf sosco information
			$("#currentMonthEmployeeEpf").val(data.find(x => x.type === "employee_month_epf").amount);
			$("#currentMonthEmployeeSosco").val(data.find(x => x.type === "employee_month_sosco").amount);
			$("#currentMonthEmployeeEis").val(data.find(x => x.type === "employee_month_eis").amount);
			
			// Current month employer epf sosco information
			$("#currentMonthEmployerEpf").val(data.find(x => x.type === "employer_month_epf").amount);
			$("#currentMonthEmployerSosco").val(data.find(x => x.type === "employer_month_sosco").amount);	
			$("#currentMonthEmployerEis").val(data.find(x => x.type === "employer_month_eis").amount);
			
			// Year to date employee epf sosco information
			$("#yearToDateEmployeeEpf").val(data.find(x => x.type === "employee_year_epf").amount);
			$("#yearToDateEmployeeSosco").val(data.find(x => x.type === "employee_year_sosco").amount);
			$("#yearToDateEmployeeEis").val(data.find(x => x.type === "employee_year_eis").amount);
			
			// Year to date employer epf sosco information
			$("#yearToDateEmployerEpf").val(data.find(x => x.type === "employer_year_epf").amount);
			$("#yearToDateEmployerSosco").val(data.find(x => x.type === "employer_year_sosco").amount);
			$("#yearToDateEmployerEis").val(data.find(x => x.type === "employer_year_eis").amount);
			
			payslipList = data;
			loaderSpinner.hide();
		},
		error: function (data) {
			loaderSpinner.hide();
		}
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
					<div class="page-header pull-left">
						<div class="page-title">
							<ol class="breadcrumb">
								<li class="breadcrumb-item"><a
									href="${contextUrl}/install-service-management/order/order.html">Payslip
										generator</a></li>
							</ol>
						</div>
					</div>
				</div>
			</div>
		</div>
		<section id="main-content">
			<div class="row">
				<div class="col-md-12">
					<div class="card-body">
						<div class="<%-- d-flex justify-content-center --%> pull-right">
							<!-- <a target="_blank" href="payslip.do?inline=1" class="btn btn-primary m-r-5">Preview</a> -->
							<button class="btn btn-primary m-r-5" id="previewButton">Preview</button>
							<a target="_blank" href="payslip.do?inline=1"
								class="btn btn-primary m-r-5">Print</a> <a target="_blank"
								href="payslip.do?inline=0" class="btn btn-primary m-r-5">Download</a>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-12">
					<div class="card" id="informationCard">
						<div class="card-title">
							<div>
								<h4>Information</h4>
								<div class="pull-right">
									<button class="btn btn-link editButton">Edit</button>
									<span class="pull-right saveEditButtonBox"
										style="display: none"> <a
										class="btn btn-light cancelButton">Cancel</a>
										<button class="btn btn-primary saveButton" type="submit">Save
										</button>
									</span>
								</div>
							</div>
						</div>
						<div class="card-body">
							<form id="informationForm">
								<div class="form-row">
									<div class="form-group col-md-6">
										<label for="companyName">Company Name</label> <input
											type="text" class="form-control" id="companyName"
											name="companyName" placeholder="Company Name" readonly>
									</div>
									<div class="form-group col-md-6">
										<label for="payPeriod">Pay Period</label> <input type="text"
											class="form-control" id="payPeriod" name="payPeriod"
											placeholder="Pay Period" readonly>
									</div>
									<div class="form-group col-md-6">
										<label for="employeeName">Name</label> <input type="text"
											class="form-control" id="employeeName" name="employeeName"
											placeholder="Employee Name" readonly>
									</div>
									<div class="form-group col-md-6">
										<label for="staffId">Staff Id</label> <input type="text"
											class="form-control" id="staffId" name="staffId"
											placeholder="Staff Id" readonly>
									</div>
									<div class="form-group col-md-6">
										<label for="department">Department</label> <input type="text"
											class="form-control" id="department" name="department"
											placeholder="Department" readonly>
									</div>
									<div class="form-group col-md-6">
										<label for="ic">IC</label> <input type="text"
											class="form-control" id="ic" name="ic"
											placeholder="IC number" readonly>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-6">
					<div class="card">
						<div class="card-title">
							<h4>Earning</h4>
						</div>
						<div class="card-body">
							<form>
								<table class="table table-borderless" id="earningTable">
									<thead>
										<tr>
											<th>Name</th>
											<th>Amount</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><input type="text"
												style="border: none; border-bottom: 1px solid;"
												value="BASIC EARNING"></td>
											<td><input type="number"
												style="border: none; border-bottom: 1px solid;" value="3600"></td>
										</tr>
										<tr>
											<td><input type="text"
												style="border: none; border-bottom: 1px solid;"
												value="ALLOWANCE"></td>
											<td><input type="number"
												style="border: none; border-bottom: 1px solid;" value="200"></td>
										</tr>
									</tbody>
								</table>
							</form>
							<div class="row">
								<div class="col-md-12">
									<div class="d-flex justify-content-center">
										<button class="btn">Add</button>
									</div>	
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="card">
						<div class="card-title">
							<h4>Deduction</h4>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-12">
					<div class="card" id="billingInformationCard">
						<div class="card-title">
							<h4>Billing information</h4>
							<div class="pull-right">
								<button class="btn btn-link editButton">Edit</button>
								<span class="pull-right saveEditButtonBox" style="display: none">
									<a class="btn btn-light cancelButton">Cancel</a>
									<button class="btn btn-primary saveButton" type="submit">Save
									</button>
								</span>
							</div>
						</div>
						<div class="card-body">
							<form id="billingInformationForm">
								<div class="form-row">
									<div class="form-group col-md-6">
										<label for="epfId">EPF Id</label> <input type="text"
											class="form-control" name="epfId" id="epfId"
											placeholder="EPF Id" readonly>
									</div>
									<div class="form-group col-md-6">
										<label for="taxId">Tax</label> <input type="text"
											class="form-control" name="taxId" id="taxId"
											placeholder="Tax Id" readonly>
									</div>
									<div class="form-group col-md-6">
										<label for="soscoEisId">SOSCO/EIS</label> <input type="text"
											class="form-control" name="soscoEisId" id="soscoEisId"
											placeholder="SOSCO and EIS Id" readonly>
									</div>
									<div class="form-group col-md-6">
										<label for="bankId">Bank</label> <input type="text"
											class="form-control" name="bankId" id="bankId"
											placeholder="Bank account id" readonly>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-6">
					<div class="card" id="currentMonthEmployeeEpfSoscoCard">
						<div class="card-title">
							<h4>Current Month EPF/SOSCO/EIS (Employee)</h4>
							<div class="pull-right">
								<button class="btn btn-link editButton">Edit</button>
								<span class="pull-right saveEditButtonBox" style="display: none">
									<a class="btn btn-light cancelButton">Cancel</a>
									<button class="btn btn-primary saveButton" type="submit">Save
									</button>
								</span>
							</div>
						</div>
						<div class="card-body">
							<form id="currentMonthEmployeeEpfSoscoForm">
								<div class="form-row">
									<div class="form-group col-md-12">
										<label for="currentMonthEmployeeEpf">Employee EPF</label> <input
											type="number" class="form-control"
											name="currentMonthEmployeeEpf" id="currentMonthEmployeeEpf"
											placeholder="Employee EPF" min="0" step="0.01" required
											readonly>
									</div>
									<div class="form-group col-md-12">
										<label for="currentMonthEmployeeSosco">Employee SOSCO</label>
										<input type="number" class="form-control"
											name="currentMonthEmployeeSosco"
											id="currentMonthEmployeeSosco" placeholder="Employee SOSCO"
											min="0" step="0.01" required readonly>
									</div>
									<div class="form-group col-md-12">
										<label for="currentMonthEmployeeEis">Employee EIS</label> <input
											type="number" class="form-control"
											name="currentMonthEmployeeEis" id="currentMonthEmployeeEis"
											placeholder="Employee EIS" min="0" step="0.01" required
											readonly>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="card" id="currentMonthEmployerEpfSoscoCard">
						<div class="card-title">
							<h4>Current Month EPF/SOSCO/EIS (Employer)</h4>
							<div class="pull-right">
								<button class="btn btn-link editButton">Edit</button>
								<span class="pull-right saveEditButtonBox" style="display: none">
									<a class="btn btn-light cancelButton">Cancel</a>
									<button class="btn btn-primary saveButton" type="submit">Save
									</button>
								</span>
							</div>
						</div>
						<div class="card-body">
							<form id="currentMonthEmployerEpfSoscoForm">
								<div class="form-row">
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employer EPF</label> <input
											type="number" class="form-control"
											name="currentMonthEmployerEpf" id="currentMonthEmployerEpf"
											placeholder="Employee EPF" min="0" step="0.01" required
											readonly>
									</div>
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employer SOSCO</label> <input
											type="number" class="form-control"
											name="currentMonthEmployerSosco"
											id="currentMonthEmployerSosco" placeholder="Employee SOSCO"
											min="0" step="0.01" required readonly>
									</div>
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employer EIS</label> <input
											type="number" class="form-control"
											name="currentMonthEmployerEis" id="currentMonthEmployerEis"
											placeholder="Employee EIS" min="0" step="0.01" required
											readonly>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-6">
					<div class="card" id="yearToDateEmployeeEpfSoscoCard">
						<div class="card-title">
							<h4>Year To Date EPF/SOSCO/EIS (Employee)</h4>
							<div class="pull-right">
								<button class="btn btn-link editButton">Edit</button>
								<span class="pull-right saveEditButtonBox" style="display: none">
									<a class="btn btn-light cancelButton">Cancel</a>
									<button class="btn btn-primary saveButton" type="submit">Save
									</button>
								</span>
							</div>
						</div>
						<div class="card-body">
							<form id="yearToDateEmployeeEpfSoscoForm">
								<div class="form-row">
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employee EPF</label> <input
											type="text" class="form-control" name="yearToDateEmployeeEpf"
											id="yearToDateEmployeeEpf" placeholder="Employee EPF" min="0"
											step="0.01" required readonly>
									</div>
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employee SOSCO</label> <input
											type="text" class="form-control"
											name="yearToDateEmployeeSosco" id="yearToDateEmployeeSosco"
											placeholder="Employee SOSCO" min="0" step="0.01" required
											readonly>
									</div>
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employee EIS</label> <input
											type="text" class="form-control" name="yearToDateEmployeeEis"
											id="yearToDateEmployeeEis" placeholder="Employee EIS" min="0"
											step="0.01" required readonly>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="card" id="yearToDateEmployerEpfSoscoCard">
						<div class="card-title">
							<h4>Year To Date EPF/SOSCO/EIS (Employer)</h4>
							<div class="pull-right">
								<button class="btn btn-link editButton">Edit</button>
								<span class="pull-right saveEditButtonBox" style="display: none">
									<a class="btn btn-light cancelButton">Cancel</a>
									<button class="btn btn-primary saveButton" type="submit">Save
									</button>
								</span>
							</div>
						</div>
						<div class="card-body">
							<form id="yearToDateEmployerEpfSoscoForm">
								<div class="form-row">
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employer EPF</label> <input
											type="text" class="form-control" name="yearToDateEmployerEpf"
											id="yearToDateEmployerEpf" placeholder="Employee EPF" min="0"
											step="0.01" required readonly>
									</div>
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employer SOSCO</label> <input
											type="text" class="form-control"
											name="yearToDateEmployerSosco" id="yearToDateEmployerSosco"
											placeholder="Employee SOSCO" min="0" step="0.01" required
											readonly>
									</div>
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employer EIS</label> <input
											type="text" class="form-control" name="yearToDateEmployerEis"
											id="yearToDateEmployerEis" placeholder="Employee EIS" min="0"
											step="0.01" required readonly>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</section>
	</div>
</div>

<div class="modal fade" id="previewPayslipModal">
	<div class="modal-dialog modal-lg modal-dialog-centered"
		role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Preview payslip</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<iframe width="100%" height="650px" src=""
					title="W3Schools Free Online Web Tutorials"> </iframe>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<span id='deleteOrderDetailModalButton'></span>
			</div>
		</div>
	</div>
</div>
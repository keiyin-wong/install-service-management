<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

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
	// Current month epf sosco part
	// ============================================================
		
	$("#currentMonthEmployeeEpfSoscoCard .editButton").click(function () {
		currentMonthEmployeeEpfSoscoEditMode();
	})
		
	$("#currentMonthEmployeeEpfSoscoCard .cancelButton").click(function () {
		currentMonthEmployeeEpfSoscoViewMode();
		
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
// Current month epf sosco part
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
            					<li class="breadcrumb-item"><a href="${contextUrl}/install-service-management/order/order.html">Payslip generator</a></li>
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
							<a target="_blank" href="payslip.do?inline=1" class="btn btn-primary m-r-5">Print</a>
							<a target="_blank" href="payslip.do?inline=0" class="btn btn-primary m-r-5">Download</a>
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
									<span class="pull-right saveEditButtonBox" style="display: none">
										<a class="btn btn-light cancelButton" >Cancel</a>
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
										<label for="companyName">Company Name</label>
										<input type="text" class="form-control" id="companyName" name="companyName" placeholder="Company Name" readonly>
									</div>
									<div class="form-group col-md-6">
										<label for="payPeriod">Pay Period</label>
										<input type="text" class="form-control" id="payPeriod" name="payPeriod" placeholder="Pay Period" readonly>
									</div>
									<div class="form-group col-md-6">
										<label for="employeeName">Name</label>
										<input type="text" class="form-control" id="employeeName" name="employeeName" placeholder="Employee Name" readonly>
									</div>
									<div class="form-group col-md-6">
										<label for="staffId">Staff Id</label> 
										<input type="text" class="form-control" id="staffId" name="staffId" placeholder="Staff Id" readonly>
									</div>
									<div class="form-group col-md-6">
										<label for="department">Department</label>
										<input type="text" class="form-control" id="department" name="department" placeholder="Department" readonly>
									</div>
									<div class="form-group col-md-6">
										<label for="ic">IC</label>
										<input type="text" class="form-control" id="ic" name="ic" placeholder="IC number" readonly>
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
									<a class="btn btn-light cancelButton" >Cancel</a>
									<button class="btn btn-primary saveButton" type="submit">Save
									</button>
								</span>
							</div>
						</div>
						<div class="card-body">
							<form id="billingInformationForm">
								<div class="form-row">
									<div class="form-group col-md-6">
										<label for="epfId">EPF Id</label>
										<input type="text" class="form-control" name="epfId" id="epfId" placeholder="EPF Id" readonly>
									</div>
									<div class="form-group col-md-6">
										<label for="taxId">Tax</label>
										<input type="text" class="form-control" name="taxId" id="taxId" placeholder="Tax Id" readonly>
									</div>
									<div class="form-group col-md-6">
										<label for="soscoEisId">SOSCO/EIS</label>
										<input type="text" class="form-control" name="soscoEisId" id="soscoEisId" placeholder="SOSCO and EIS Id" readonly>
									</div>
									<div class="form-group col-md-6">
										<label for="bankId">Bank</label>
										<input type="text" class="form-control" name="bankId" id="bankId" placeholder="Bank account id" readonly>
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
									<a class="btn btn-light cancelButton" >Cancel</a>
									<button class="btn btn-primary saveButton" type="submit">Save
									</button>
								</span>
							</div>
						</div>
						<div class="card-body">
							<form>
								<div class="form-row">
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employee EPF</label>
										<input type="number" class="form-control" id="currentMonthEmployeeEpf" placeholder="Employee EPF" min="0" step="0.01" required readonly>
									</div>
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employee SOSCO</label>
										<input type="number" class="form-control" id="currentMonthEmployeeSosco" placeholder="Employee SOSCO" min="0" step="0.01" required readonly>
									</div>
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employee EIS</label>
										<input type="number" class="form-control" id="currentMonthEmployeeEis" placeholder="Employee EIS" min="0" step="0.01" required readonly>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="card">
						<div class="card-title">
							<h4>Current Month EPF/SOSCO/EIS (Employer)</h4>
						</div>
						<div class="card-body">
							<form>
								<div class="form-row">
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employer EPF</label>
										<input type="text" class="form-control" id="employeeEPF" placeholder="Employee EPF">
									</div>
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employer SOSCO</label>
										<input type="text" class="form-control" id="employeeEPF" placeholder="Employee SOSCO">
									</div>
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employer EIS</label>
										<input type="text" class="form-control" id="employeeEPF" placeholder="Employee EIS">
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
							<h4>Year To Date EPF/SOSCO/EIS (Employee)</h4>
						</div>
						<div class="card-body">
							<form>
								<div class="form-row">
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employee EPF</label>
										<input type="text" class="form-control" id="employeeEPF" placeholder="Employee EPF">
									</div>
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employee SOSCO</label>
										<input type="text" class="form-control" id="employeeEPF" placeholder="Employee SOSCO">
									</div>
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employee EIS</label>
										<input type="text" class="form-control" id="employeeEPF" placeholder="Employee EIS">
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="card">
						<div class="card-title">
							<h4>Year To Date EPF/SOSCO/EIS (Employer)</h4>
						</div>
						<div class="card-body">
							<form>
								<div class="form-row">
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employer EPF</label>
										<input type="text" class="form-control" id="employeeEPF" placeholder="Employee EPF">
									</div>
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employer SOSCO</label>
										<input type="text" class="form-control" id="employeeEPF" placeholder="Employee SOSCO">
									</div>
									<div class="form-group col-md-12">
										<label for="employeeEPF">Employer EIS</label>
										<input type="text" class="form-control" id="employeeEPF" placeholder="Employee EIS">
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
	<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Preview payslip</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<iframe width="100%" height="650px" src="" title="W3Schools Free Online Web Tutorials">
				</iframe>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<span id='deleteOrderDetailModalButton'></span>
			</div>
		</div>
	</div>
</div>
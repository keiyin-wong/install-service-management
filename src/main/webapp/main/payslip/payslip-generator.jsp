<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<script type="text/javascript">
var loaderSpinner;

$(document).ready(function(){
	loaderSpinner = $('#loader');
	// ============================================================
	// information part
	// ============================================================
	$("#informationCard .editButton").click(function () {
		informationEditMode();
	})
	$("#informationCard .cancelButton").click(function () {
		informationViewMode();
	})
	getAllPayslip();
})


// ============================================================
// information part
// ============================================================
function informationEditMode() {
	$("#informationCard .editButton").hide();
	$("#informationCard .saveEditButtonBox").show();
}

function informationViewMode() {
	$("#informationCard .editButton").show();
	$("#informationCard .saveEditButtonBox").hide();
}

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
			loaderSpinner.hide();
		},
		error: function (data) {
			
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
							<form>
								<div class="form-row">
									<div class="form-group col-md-6">
										<label for="companyName">Company Name</label>
										<input type="text" class="form-control" id="companyName" placeholder="Company Name">
									</div>
									<div class="form-group col-md-6">
										<label for="payPeriod">Pay Period</label>
										<input type="text" class="form-control" id="payPeriod" placeholder="Pay Period">
									</div>
									<div class="form-group col-md-6">
										<label for="employeeName">Name</label>
										<input type="text" class="form-control" id="employeeName" placeholder="Employee Name">
									</div>
									<div class="form-group col-md-6">
										<label for="staffId">Staff Id</label>
										<input type="text" class="form-control" id="staffId" placeholder="Staff Id">
									</div>
									<div class="form-group col-md-6">
										<label for="department">Department</label>
										<input type="text" class="form-control" id="department" placeholder="Department">
									</div>
									<div class="form-group col-md-6">
										<label for="ic">IC</label>
										<input type="text" class="form-control" id="ic" placeholder="IC number">
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
					<div class="card">
						<div class="card-title">
							<h4>Billing information</h4>
						</div>
						<div class="card-body">
							<form>
								<div class="form-row">
									<div class="form-group col-md-6">
										<label for="epfId">EPF Id</label>
										<input type="text" class="form-control" id="epfId" placeholder="EPF Id">
									</div>
									<div class="form-group col-md-6">
										<label for="taxId">Tax</label>
										<input type="text" class="form-control" id="taxId" placeholder="Tax Id">
									</div>
									<div class="form-group col-md-6">
										<label for="soscoEisId">SOSCO/EIS</label>
										<input type="text" class="form-control" id="soscoEisId" placeholder="SOSCO and EIS Id">
									</div>
									<div class="form-group col-md-6">
										<label for="bankId">Bank</label>
										<input type="text" class="form-control" id="bankId" placeholder="Bank account id">
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
							<h4>Current Month EPF/SOSCO/EIS (Employee)</h4>
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
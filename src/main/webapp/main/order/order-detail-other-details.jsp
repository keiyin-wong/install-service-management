<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>


<script>
	$(document).ready(function() {
		otherDetails1ViewMode();
		otherDetails2ViewMode();
		otherDetails3ViewMode();

		$("#order-other-detail-card-1 .edit-button").click(function() {
			otherDetails1EditMode();

			// Click other cancel button if you edit
			$("#order-other-detail-card-2 .cancelButton").click();	
			$("#order-other-detail-card-3 .cancelButton").click();	
		})

		$("#order-other-detail-card-1 .cancelButton").click(function() {
			otherDetails1ViewMode();
		});

		$("#order-other-detail-card-2 .edit-button").click(function() {
			otherDetails2EditMode();
			
			// Click other cancel button if you edit
			$("#order-other-detail-card-1 .cancelButton").click();	
			$("#order-other-detail-card-3 .cancelButton").click();	
		})

		$("#order-other-detail-card-2 .cancelButton").click(function() {
			otherDetails2ViewMode();
			
			// Reset the remarks and comments field
			$("#order-remarks").val(currentOrder.remarks);
			$("#order-comments").val(currentOrder.comments);
		});
		
		
		// Other details 2 (Remarks and comments)
		$("#order-other-detail-card-2 .save-button").click(function() {
			loaderSpinner.show();
			$.ajax({
				type : "POST",
				url : "updateOrder",
				data: $('.order-form-data').serialize(),
				success: function(data){
					if(data.status == "success"){
						popSuccessToastr("Success", 'Successfully update order remarks and comments');
						getOrder();

						// Reset the remarks and comments field
						$("#order-remarks").val(currentOrder.remarks);
						$("#order-comments").val(currentOrder.comments);
					}else if(data.status == "fail"){
						popErrorToastr('Failed', 'Failed to update order remarks and comments');
					}
				},
				error: function(){
					loaderSpinner.hide();
				}
			}).done(function(){
				loaderSpinner.hide();
				otherDetails2ViewMode();
			});
		})

		// --------------------------------------------------------------------------------------------
		// Order detail 3 
		// --------------------------------------------------------------------------------------------
		
		$("#order-other-detail-card-3 .edit-button").click(function() {
			otherDetails3EditMode();

			// Click other cancel button if you edit
			$("#order-other-detail-card-1 .cancelButton").click();	
			$("#order-other-detail-card-2 .cancelButton").click();	
		})

		$("#order-other-detail-card-3 .cancelButton").click(function() {
			otherDetails3ViewMode();
			
			// Reset the date field
			var date = new Date(currentOrder.date);
			const day = date.toLocaleString('default', { day: '2-digit' });
		    const month = date.toLocaleString('default', { month: '2-digit' });
		    const year = date.toLocaleString('default', { year: 'numeric' });
		    
			$('#orderDate2').val(year + '-' + month + '-' + day);
		});

		$("#order-other-detail-card-3 .save-button").click(function() {
			loaderSpinner.show();
			$.ajax({
				type : "POST",
				url : "updateOrder",
				data: $('.order-form-data').serialize(),
				success: function(data){
					if(data.status == "success"){
						popSuccessToastr("Success", 'Successfully update order');
						getOrder();

						// Reset the date field
						var date = new Date(currentOrder.date);
						const day = date.toLocaleString('default', { day: '2-digit' });
						const month = date.toLocaleString('default', { month: '2-digit' });
						const year = date.toLocaleString('default', { year: 'numeric' });
						$('#orderDate2').val(year + '-' + month + '-' + day);
					}else if(data.status == "fail"){
						popErrorToastr('Failed', 'Failed to update order');
					}
				},
				error: function(){
					loaderSpinner.hide();
				}
			}).done(function(){
				loaderSpinner.hide();
				otherDetails3ViewMode();
			});
		})
		
		
	});

	// ===================================================================================
	// Other details function
	// ===================================================================================
		
	
	function otherDetails1EditMode() {
		$("#order-other-detail-card-1 .edit-button").hide();
		$("#order-other-detail-card-1 .save-edit-button-box").show();
	}

	function otherDetails1ViewMode() {
		$("#order-other-detail-card-1 .edit-button").show();
		$("#order-other-detail-card-1 .save-edit-button-box").hide();
	}
		
	function otherDetails2EditMode() {
		$("#order-other-detail-card-2 .edit-button").hide();
		$("#order-other-detail-card-2 .save-edit-button-box").show();

		$("#order-other-detail-form-2 textarea[name=remarks]").prop("readonly",
				false);
		$("#order-other-detail-form-2 textarea[name=comments]").prop("readonly",
				false);
	}

	function otherDetails2ViewMode() {
		$("#order-other-detail-card-2 .edit-button").show();
		$("#order-other-detail-card-2 .save-edit-button-box").hide();

		$("#order-other-detail-form-2 textarea[name=remarks]").prop("readonly",
				true);
		$("#order-other-detail-form-2 textarea[name=comments]").prop("readonly",
				true);
	}
	
	function otherDetails3EditMode() {
		$("#order-other-detail-card-3 .edit-button").hide();
		$("#order-other-detail-card-3 .save-edit-button-box").show();

		$("#order-other-detail-form-3 input[name=date]").prop("readonly",
				false);
	}

	function otherDetails3ViewMode() {
		$("#order-other-detail-card-3 .edit-button").show();
		$("#order-other-detail-card-3 .save-edit-button-box").hide();

		$("#order-other-detail-form-3 input[name=date]").prop("readonly",
				true);
	}
</script>

<section id="other-details-section">
	<div class="row">
		<div class="col-lg-6">
			<div class="row">
				<div class="col-md-12">
					<div class="card" id="order-other-detail-card-1">
						<div class="card-body">
							<div class="row">
								<div class="col-sm-7"></div>
								<div class="col-sm-5">
									<a class="btn pull-right edit-button">Edit</a> <span
										class="pull-right save-edit-button-box"> <a
										class="btn btn-sm btn-default cancelButton"
										style="color: white !important;">Cancel</a>
										<button class="btn btn-sm btn-primary save-button" type="submit">
											Save</button>
									</span>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12">
									<form id="order-other-detail-form-1"
										class="form-horizontal order-form-data">
										<div class="form-group row">
											<label for="remarks" class="col-sm-3 col-form-label">Invoice#</label>
											<div class="col-sm-9">
												<input type="text" class="form-control" name="id" id="orderId2" readonly />
											</div>
										</div>
									</form>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-12">
					<div class="card" id="order-other-detail-card-3">
						<div class="card-body">
							<div class="row">
								<div class="col-sm-7"></div>
								<div class="col-sm-5">
									<a class="btn pull-right edit-button">Edit</a> <span
										class="pull-right save-edit-button-box"> <a
										class="btn btn-sm btn-default cancelButton"
										style="color: white !important;">Cancel</a>
										<button class="btn btn-sm btn-primary save-button" type="submit">
											Save</button>
									</span>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12">
									<form id="order-other-detail-form-3"
										class="form-horizontal order-form-data">
										<div class="form-group row">
											<label for="date" class="col-sm-3 col-form-label">Date</label>
											<div class="col-sm-9">
												<input type="date" class="form-control" id="orderDate2"
													name="date" required
													<sec:authorize access="!hasAnyRole('ROLE_ADMIN', 'ROLE_USER_EDIT')">
														disabled
													</sec:authorize> />
											</div>
										</div>
									</form>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col-lg-6">
			<div class="row">
				<div class="col-md-12">
					<div class="card" id="order-other-detail-card-2">
						<div class="card-body">
							<div class="row">
								<div class="col-sm-7"></div>
								<div class="col-sm-5">
									<a class="btn pull-right edit-button">Edit</a> <span
										class="pull-right save-edit-button-box"> <a
										class="btn btn-sm btn-default cancelButton"
										style="color: white !important;">Cancel</a>
										<button class="btn btn-sm btn-primary save-button" type="submit">
											Save</button>
									</span>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12">
									<form id="order-other-detail-form-2"
										class="form-horizontal order-form-data">
										<div class="form-group row">
											<label for="remarks" class="col-sm-3 col-form-label">Remarks (Customer Notes)</label>
											<div class="col-sm-9">
												<textarea rows="3" class="form-control" id="order-remarks" name="remarks"
													readonly></textarea>
											</div>
										</div>
										<div class="form-group row">
											<label for="remarks" class="col-sm-3 col-form-label">Comments</label>
											<div class="col-sm-9">
												<textarea rows="3" class="form-control" id="order-comments" name="comments"
													readonly></textarea>
											</div>
										</div>
									</form>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>

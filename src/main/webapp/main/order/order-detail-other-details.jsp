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

		$("#order-other-detail-card-1 .editButton").click(function() {
			otherDetails1EditMode();
		})

		$("#order-other-detail-card-1 .cancelButton").click(function() {
			otherDetails1ViewMode();
		});

		$("#order-other-detail-card-2 .editButton").click(function() {
			otherDetails2EditMode();
		})

		$("#order-other-detail-card-2 .cancelButton").click(function() {
			otherDetails2ViewMode();
		});
	});

	// ===================================================================================
	// Other details function
	// ===================================================================================
		
	
	function otherDetails1EditMode() {
		$("#order-other-detail-card-1 .editButton").hide();
		$("#order-other-detail-card-1 .saveEditButtonBox").show();
	}

	function otherDetails1ViewMode() {
		$("#order-other-detail-card-1 .editButton").show();
		$("#order-other-detail-card-1 .saveEditButtonBox").hide();
	}
		
	function otherDetails2EditMode() {
		$("#order-other-detail-card-2 .editButton").hide();
		$("#order-other-detail-card-2 .saveEditButtonBox").show();

		$("#order-other-detail-form-2 textarea[name=remarks]").prop("readonly",
				false);
		$("#order-other-detail-form-2 textarea[name=comments]").prop("readonly",
				false);
	}

	function otherDetails2ViewMode() {
		$("#order-other-detail-card-2 .editButton").show();
		$("#order-other-detail-card-2 .saveEditButtonBox").hide();

		$("#order-other-detail-form-2 textarea[name=remarks]").prop("readonly",
				true);
		$("#order-other-detail-form-2 textarea[name=comments]").prop("readonly",
				true);
	}
</script>

<section id="other-details-section">
	<div class="row">
		<div class="col-lg-6">
			<div class="card" id="order-other-detail-card-1">
				<div class="card-body">
					<div class="row">
						<div class="col-sm-7"></div>
						<div class="col-sm-5">
							<a class="btn pull-right editButton">Edit</a> <span
								class="pull-right saveEditButtonBox"> <a
								class="btn btn-sm btn-default cancelButton"
								style="color: white !important;">Cancel</a>
								<button class="btn btn-sm btn-primary saveButton" type="submit">
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
										<input type="text" class="form-control" name="newOrderId" readonly>
									</div>
								</div>
								<div class="form-group row">
									<label for="remarks" class="col-sm-3 col-form-label">Comments</label>
									<div class="col-sm-9">
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col-lg-6">
			<div class="card" id="order-other-detail-card-2">
				<div class="card-body">
					<div class="row">
						<div class="col-sm-7"></div>
						<div class="col-sm-5">
							<a class="btn pull-right editButton">Edit</a> <span
								class="pull-right saveEditButtonBox"> <a
								class="btn btn-sm btn-default cancelButton"
								style="color: white !important;">Cancel</a>
								<button class="btn btn-sm btn-primary saveButton" type="submit">
									Save</button>
							</span>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12">
							<form id="order-other-detail-form-2"
								class="form-horizontal order-form-data">
								<div class="form-group row">
									<label for="remarks" class="col-sm-3 col-form-label">Remarks</label>
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
</section>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<div class="sidebar sidebar-hide-to-small sidebar-shrink sidebar-gestures">
	<div class="nano">
		<div class="nano-content">
			<ul>
				<div class="logo">
					<a href="index.html">
					<span>System</span></a>
				</div>
				<li class="label">Main</li>
				<li><a href="${pageContext.request.contextPath}/dashboard/dashboard.html"><i class="ti-home"></i> Dashboard </a></li>
				<li class="label">Order</li>
				<li><a href="${pageContext.request.contextPath}/order/order.html"><i class="ti-layout-grid2"></i> Orders </a></li>
				<li><a href="${pageContext.request.contextPath}/order/order-invoice.html"><i class="ti-files"></i> Invoices </a></li>
				<sec:authorize access="hasAnyRole('ROLE_ADMIN')">
					<li class="label">System</li>
					<li>
						<a href="${pageContext.request.contextPath}/system/system-parameter.html">
						<i class="ti-layout-grid2"></i>System parameter</a>
					</li>
				</sec:authorize>
				<li class="label">Extra</li>
				<li><a href="${pageContext.request.contextPath}/payslip/payslip-generator.html"><i class="ti-files"></i> Generator </a></li>
				<!-- <li class="label">Services</li>
				<li><a href="app-event-calender.html"><i class="ti-package"></i> Service Type </a></li> -->
			</ul>
		</div>
	</div>
</div>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:if test="${empty contextUrl}" >
	<c:set var="contextUrl" value="${pageContext.request.contextPath}"/>
</c:if> 

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
	    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	    <meta name="viewport" content="width=device-width, initial-scale=1">
		<title><tiles:insertAttribute name="title" /></title>
		    <!-- ================= Favicon ================== -->
	    <!-- Standard -->
	    <link rel="shortcut icon" href="http://placehold.it/64.png/000/fff">
	    <!-- Retina iPad Touch Icon-->
	    <link rel="apple-touch-icon" sizes="144x144" href="http://placehold.it/144.png/000/fff">
	    <!-- Retina iPhone Touch Icon-->
	    <link rel="apple-touch-icon" sizes="114x114" href="http://placehold.it/114.png/000/fff">
	    <!-- Standard iPad Touch Icon-->
	    <link rel="apple-touch-icon" sizes="72x72" href="http://placehold.it/72.png/000/fff">
	    <!-- Standard iPhone Touch Icon-->
	    <link rel="apple-touch-icon" sizes="57x57" href="http://placehold.it/57.png/000/fff">
	    <!-- Styles -->
			    <!-- Styles -->
	    <link href="${contextUrl}/assets/css/lib/calendar2/pignose.calendar.min.css" rel="stylesheet">
	    <link href="${contextUrl}/assets/css/lib/chartist/chartist.min.css" rel="stylesheet">
	    <link href="${contextUrl}/assets/css/lib/font-awesome.min.css" rel="stylesheet">
	    <link href="${contextUrl}/assets/css/lib/themify-icons.css" rel="stylesheet">
	    <link href="${contextUrl}/assets/css/lib/owl.carousel.min.css" rel="stylesheet" />
	    <link href="${contextUrl}/assets/css/lib/owl.theme.default.min.css" rel="stylesheet" />
	    <link href="${contextUrl}/assets/css/lib/weather-icons.css" rel="stylesheet" />
	    <link href="${contextUrl}/assets/css/lib/menubar/sidebar.css" rel="stylesheet">
	    <link href="${contextUrl}/assets/css/lib/bootstrap.min.css" rel="stylesheet">
	    <link href="${contextUrl}/assets/css/lib/helper.css" rel="stylesheet">
	    <link href="${contextUrl}/assets/css/style.css" rel="stylesheet">		
		<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.12.1/css/jquery.dataTables.css">
		  
		

	    
	        <!-- jquery vendor -->
	    <script src="${contextUrl}/assets/js/lib/jquery.min.js"></script>
	    <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.3/dist/jquery.validate.min.js"></script>
	    <script src="${contextUrl}/assets/js/lib/jquery.nanoscroller.min.js"></script>
	    <script src="${contextUrl}/assets/js/lib/jquery.nanoscroller.min.js"></script>
	    <script src="${contextUrl}/assets/js/lib/data-table/jquery.dataTables.min.js"></script>
	
	</head>
	<body>
		<tiles:insertAttribute name="menu" />
		
		<tiles:insertAttribute name="header" />
		
		<tiles:insertAttribute name="body" />
		
		
	
	    <!-- nano scroller -->
	    <script src="${contextUrl}/assets/js/lib/menubar/sidebar.js"></script>
	    <script src="${contextUrl}/assets/js/lib/preloader/pace.min.js"></script>
	    <!-- sidebar -->
	
	    <script src="${contextUrl}/assets/js/lib/bootstrap.min.js"></script>
	    <script src="${contextUrl}/assets/js/scripts.js"></script>
	    <!-- bootstrap -->
	
	    <script src="${contextUrl}/assets/js/lib/calendar-2/moment.latest.min.js"></script>
	    <script src="${contextUrl}/assets/js/lib/calendar-2/pignose.calendar.min.js"></script>
	    <script src="${contextUrl}/assets/js/lib/calendar-2/pignose.init.js"></script>
	
	
	    <script src="${contextUrl}/assets/js/lib/weather/jquery.simpleWeather.min.js"></script>
	    <script src="${contextUrl}/assets/js/lib/weather/weather-init.js"></script>
	    <script src="${contextUrl}/assets/js/lib/circle-progress/circle-progress.min.js"></script>
	    <script src="${contextUrl}/assets/js/lib/circle-progress/circle-progress-init.js"></script>
	    <script src="${contextUrl}/assets/js/lib/chartist/chartist.min.js"></script>
	    <script src="${contextUrl}/assets/js/lib/sparklinechart/jquery.sparkline.min.js"></script>
	    <script src="${contextUrl}/assets/js/lib/sparklinechart/sparkline.init.js"></script>
	    <script src="${contextUrl}/assets/js/lib/owl-carousel/owl.carousel.min.js"></script>
	    <script src="${contextUrl}/assets/js/lib/owl-carousel/owl.carousel-init.js"></script>
	    <!-- scripit init-->
	</body>
</html>
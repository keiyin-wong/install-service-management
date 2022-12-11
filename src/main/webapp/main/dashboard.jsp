<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script src="${pageContext.request.contextPath}/assets/js/lib/chart-js/Chart.bundle.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.2.0/js/bootstrap-datepicker.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.2.0/css/datepicker.min.css" rel="stylesheet">

<style>
.ct-series-a .ct-bar {
  /* Colour of your bars */
  stroke:  #00a79d;
  stroke-width: 20;
}
/* @media only screen and (max-width: 400px) {
	.chartBox {
		width: 90%;
		height: 45%;
	}
} */
</style>



<script>
var monthList = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
$(document).ready(function(){
	
	// ===============================================================================
	// Monthly income
	// ===============================================================================
	
	$("#monthlyIncomeDatepicker").datepicker({
	    format: "yyyy",
	    viewMode: "years", 
	    minViewMode: "years",
	    autoclose:true //to close picker once year is selected
	});
	$("#monthlyIncomeDatepicker").datepicker("setDate", new Date());
	
	var monthlyTotalList = new Array();
	
	<c:forEach items="${monthlyTotalList}" var="monthlyTotal" varStatus="loop">
		monthlyTotalList[${loop.index}] = ${monthlyTotal.total}/100;
	</c:forEach>
	
	var ctx = document.getElementById( "monthlyIncomeBarChart" );
	ctx.height = 300;
	var monthlyIncomeBarChart = new Chart( ctx, {
		type: 'bar',
		data: {
			labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
			datasets: [
				{
					label: "Income",
					data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
					borderColor: "rgba(0, 123, 255, 0.9)",
					borderWidth: "0",
					backgroundColor: "rgba(0, 123, 255, 0.5)"
                            }
                        ]
		},
		options: {
			scales: {
				yAxes: [ {
					ticks: {
						beginAtZero: true,
						callback: function(value, index, ticks) {
	                        return 'RM ' + value.toLocaleString();
	                    }
					},
					/* scaleLabel: {
						display: true,
						labelString: 'probability'
					} */
				} ]
			},
			 responsive: true,
			 maintainAspectRatio: false,
		}
	} );
	
	getMonthlyTotal(monthlyIncomeBarChart);
	
	$("#monthlyIncomeDatepicker").on("change", function() {
		getMonthlyTotal(monthlyIncomeBarChart);
	})

})

function getMonthlyTotal(myChart) {
	$.ajax({
		type: "GET",
		url: "getMonthlyTotal?year=" + $("#monthlyIncomeDatepicker").val(),
		cache : false,
		dataType: "json",
		success : function(data){
			var monthlyTotals = new Array();
			$.each(data, function(index, values){
				monthlyTotals[index] = values.total;
			})
			
			if(monthlyTotals.length != 0){
				for(let i = 0; i < 12; i++){
					removeData(myChart);
				}
				for(let i = 0; i < 12; i++){
					addData(myChart, monthList[i], monthlyTotals[i]/100);
				}
			}
			myChart.update();
		},
		error: function (data){
			
		}
	});
}

function addData(chart, label, data) {
    chart.data.labels.push(label);
    chart.data.datasets.forEach((dataset) => {
        dataset.data.push(data);
    });
}

function removeData(chart) {
	chart.data.labels.pop();
    chart.data.datasets.forEach((dataset) => {
        dataset.data.pop();
    });
}
</script>


<!-- <div id="loader"></div>
<div id="pop-message"></div> -->

<div class="content-wrap">
	<div class="main">
		<div class="container-fluid">
			<div class="row">
				<div class="col-lg-8 p-r-0 title-margin-right">
					<div class="page-header">
						<div class="page-title">
							<h1>Welcome, <span>${pageContext.request.userPrincipal.name}</span></h1>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<section>
			<div class="row" id="monthlyIncomeCard">
				<div class="col-md-8">
					<div class="card">
						<div class="card-title">
							<h4>Monthly income&nbsp</h4><input type="text" style="max-width: 50px;  border: none; border-bottom: 1px solid;" name="monthlyIncomeDatepicker" id="monthlyIncomeDatepicker" />
						</div>
						<div class="card-body">
							<canvas id="monthlyIncomeBarChart" style="min-height:160px"></canvas>
						</div>
					</div>
				</div>
			</div>
		</section>
	</div>
</div>
        
            
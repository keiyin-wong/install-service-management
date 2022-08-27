package com.keiyin.ism.controller;

import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.keiyin.ism.constant.ViewConstants;
import com.keiyin.ism.dao.OrderDAO;
import com.keiyin.ism.model.MonthlyTotal;

import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JsonDataSource;


@Controller
@RequestMapping(value = "/dashboard")
public class DashboardController {
	@Autowired
	OrderDAO orderDAO;
	
	private Logger log = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping(value = "/dashboard.html", method = RequestMethod.GET)
	public ModelAndView renderServicePage() {
		Map<String,Object> parameterMap = new HashMap<>();
		List<MonthlyTotal> monthlyTotalList = null;
		try {
			monthlyTotalList = orderDAO.getMonthlyTotal(2022);
		} catch (SQLException e) {
			log.error("Failed to get monthly total list",e);
		}
		parameterMap.put("monthlyTotalList", monthlyTotalList);
		return new ModelAndView(ViewConstants.DASHBOARD_VIEW, parameterMap);
	}
	
	@RequestMapping(value = "/getMonthlyTotal", method = RequestMethod.GET)
	public @ResponseBody List<MonthlyTotal> getMonthlyTotal(@RequestParam int year) {
		List<MonthlyTotal> monthlyTotals = null;
		try {
			 monthlyTotals = orderDAO.getMonthlyTotal(year);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return monthlyTotals;
	}
	@RequestMapping(value="/orderReport.do", method = RequestMethod.GET)
	public void generateOrderInvoiceReport(
			@RequestParam(required=false, defaultValue = "1")int inline, 
			HttpServletRequest request, 
			HttpServletResponse response) {
		Map<String, Object> parameterMap = new HashMap<>();
		String filename = "payslip.pdf";
		log.info("Generating payslip"); 
		try {
			InputStream inputStream = this.getClass().getResourceAsStream("/report/payslip-db.jrxml");
			JasperReport jasperDesign = JasperCompileManager.compileReport(inputStream);
			Connection conn = DriverManager.getConnection("jdbc:mysql://206.189.83.43:3306/payslip?useUnicode=true&characterEncoding=UTF-8", 
					"keiyin", 
					"Wky62616261");
			JasperPrint jasperPrint = JasperFillManager.fillReport(jasperDesign, parameterMap, conn);
			response.setContentType("application/pdf");
			 if(inline == 1) {
				 response.addHeader("Content-disposition", "inline; filename=" +filename);
			 }else {
				 response.addHeader("Content-disposition", "attachment; filename=" +filename);
			 }
	         OutputStream outputStream = response.getOutputStream();
	         log.info("Retrived payslip"); 
	         JasperExportManager.exportReportToPdfStream(jasperPrint, outputStream);
		} catch (JRException e ) {
			log.info("Jasper report part error",e );
		} catch (Exception e) {
			log.info("Unexpected error occur",e );
		}
	}
}

package com.keiyin.ism.controller;

import java.io.InputStream;
import java.io.OutputStream;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.keiyin.ism.constant.ViewConstants;
import com.keiyin.ism.dao.PayslipDAO;
import com.keiyin.ism.model.Payslip;
import com.keiyin.ism.model.WriteResponse;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.export.HtmlExporter;
import net.sf.jasperreports.export.SimpleExporterInput;
import net.sf.jasperreports.export.SimpleHtmlExporterOutput;

@Controller
@RequestMapping(value = "/payslip")
public class PayslipController {
	
	@Autowired
	@Qualifier("payslipDataSource")
	DriverManagerDataSource payslipDataSource;
	
	@Autowired
	@Qualifier("payslipDAO")
	private PayslipDAO payslipDAO;

	private Logger log = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping(value = "/payslip-generator.html", method = RequestMethod.GET)
	public ModelAndView renderPayslipGeneratorPage() {
		 return new ModelAndView(ViewConstants.PAYSLIP_GENERATOR);
	}
	
	@RequestMapping(value = "/getAllPayslip", method = RequestMethod.GET)
	public @ResponseBody List<Payslip> getAllPayslip() {
		List<Payslip> payslipList = null;
		try {
			payslipList = payslipDAO.getAllPayslip();
			log.info("Successfully retrieved payslip information");
		} catch (SQLException e) {
			log.error("Failed to get payslip information", e);
		}
		return payslipList;
	}
	
	@RequestMapping(value = "/updatePayslipInformation", method = RequestMethod.POST)
	public @ResponseBody WriteResponse updatePayslipInformation(
			@RequestParam String companyName,
			@RequestParam String payPeriod,
			@RequestParam String employeeName,
			@RequestParam String staffId,
			@RequestParam String department,
			@RequestParam String ic) {
		
		WriteResponse result = new WriteResponse();
		result.setStatus(WriteResponse.Status.FAIL);
		try {
			if(payslipDAO.updatePayslipInformation(companyName, payPeriod, employeeName, staffId, department, ic)) {
				log.info("Successfully update payslip information");
				result.setStatus(WriteResponse.Status.SUCCESS);
			} else {
				log.info("Failed to update payslip information");
			}
		} catch (SQLException e) {
			log.error("Failed to update payslip information due to SQL exception", e);
		}
		return result;
	}
	
	@RequestMapping(value = "/updatePayslipBillingInformation", method = RequestMethod.POST)
	public @ResponseBody WriteResponse updatePayslipBillingInformation(
			@RequestParam String epfId,
			@RequestParam String taxId,
			@RequestParam String soscoEisId,
			@RequestParam String bankId) {
		
		WriteResponse result = new WriteResponse();
		result.setStatus(WriteResponse.Status.FAIL);
		try {
			if(payslipDAO.updatePayslipBillingInformation(epfId, taxId, soscoEisId, bankId)) {
				log.info("Successfully update payslip billing information");
				result.setStatus(WriteResponse.Status.SUCCESS);
			} else {
				log.info("Failed to update payslip billing information");
			}
		} catch (SQLException e) {
			log.error("Failed to update payslip billing information due to SQL exception", e);
		}
		return result;
	}
	

	@RequestMapping(value = "/updateCurrentMonthEmployeeEpfSosco", method = RequestMethod.POST)
	public @ResponseBody WriteResponse updateCurrentMonthEmployeeEpfSosco(
			@RequestParam double currentMonthEmployeeEpf,
			@RequestParam double currentMonthEmployeeSosco,
			@RequestParam double currentMonthEmployeeEis) {
		
		WriteResponse result = new WriteResponse();
		result.setStatus(WriteResponse.Status.FAIL);
		try {
			if(payslipDAO.updateCurrentMonthEmployeeEpfSosco(currentMonthEmployeeEpf, currentMonthEmployeeSosco, currentMonthEmployeeEis)) {
				log.info("Successfully update employee current month epf sosco");
				result.setStatus(WriteResponse.Status.SUCCESS);
			} else {
				log.info("Failed to update employee current month epf sosco");
			}
		} catch (SQLException e) {
			log.error("Failed to update employee current month epf sosco due to SQL exception", e);
		}
		return result;
	}
	
	@RequestMapping(value = "/updateCurrentMonthEmployerEpfSosco", method = RequestMethod.POST)
	public @ResponseBody WriteResponse updateCurrentMonthEmployerEpfSosco(
			@RequestParam double currentMonthEmployerEpf,
			@RequestParam double currentMonthEmployerSosco,
			@RequestParam double currentMonthEmployerEis) {
		
		WriteResponse result = new WriteResponse();
		result.setStatus(WriteResponse.Status.FAIL);
		try {
			if(payslipDAO.updateCurrentMonthEmployerEpfSosco(currentMonthEmployerEpf, currentMonthEmployerSosco, currentMonthEmployerEis)) {
				log.info("Successfully update employer current month epf sosco");
				result.setStatus(WriteResponse.Status.SUCCESS);
			} else {
				log.info("Failed to update employer current month epf sosco");
			}
		} catch (SQLException e) {
			log.error("Failed to update employer current month epf sosco due to SQL exception", e);
		}
		return result;
	}
	
	@RequestMapping(value = "/updateYearToDateEmployeeEpfSosco", method = RequestMethod.POST)
	public @ResponseBody WriteResponse updateYearToDateEmployeeEpfSosco(
			@RequestParam double yearToDateEmployeeEpf,
			@RequestParam double yearToDateEmployeeSosco,
			@RequestParam double yearToDateEmployeeEis) {
		
		WriteResponse result = new WriteResponse();
		result.setStatus(WriteResponse.Status.FAIL);
		try {
			if(payslipDAO.updateYearToDateEmployeeEpfSosco(yearToDateEmployeeEpf, yearToDateEmployeeSosco, yearToDateEmployeeEis)) {
				log.info("Successfully update employee year to date epf sosco");
				result.setStatus(WriteResponse.Status.SUCCESS);
			} else {
				log.info("Failed to update employee year to date epf sosco");
			}
		} catch (SQLException e) {
			log.error("Failed to update employee year to date epf sosco due to SQL exception", e);
		}
		return result;
	}
	
	@RequestMapping(value = "/updateYearToDateEmployerEpfSosco", method = RequestMethod.POST)
	public @ResponseBody WriteResponse updateYearToDateEmployerEpfSosco(
			@RequestParam double yearToDateEmployerEpf,
			@RequestParam double yearToDateEmployerSosco,
			@RequestParam double yearToDateEmployerEis) {
		
		WriteResponse result = new WriteResponse();
		result.setStatus(WriteResponse.Status.FAIL);
		try {
			if(payslipDAO.updateYearToDateEmployerEpfSosco(yearToDateEmployerEpf, yearToDateEmployerSosco, yearToDateEmployerEis)) {
				log.info("Successfully update employer year to date epf sosco");
				result.setStatus(WriteResponse.Status.SUCCESS);
			} else {
				log.info("Failed to update employer year to date epf sosco");
			}
		} catch (SQLException e) {
			log.error("Failed to update employer year to date epf sosco due to SQL exception", e);
		}
		return result;
	}
	
	@RequestMapping(value = "/updateEarnings", method = RequestMethod.POST)
	public @ResponseBody WriteResponse updateEarnings(@RequestParam(required = false) String[] name, @RequestParam(required = false) double[] amount) {
		
		WriteResponse result = new WriteResponse();
		result.setStatus(WriteResponse.Status.FAIL);
		
		log.info("The name is {} and the amount is {}",Arrays.toString(name), Arrays.toString(amount));
		
		try {
			if(payslipDAO.updateEarnings(name, amount)) {
				log.info("Successfully update earnings");
				result.setStatus(WriteResponse.Status.SUCCESS);
			}else {
				log.info("Failed to update earnings");
			}
		} catch (SQLException e) {
			log.error("Failed to update earnings due to SQL exception", e);
		}
		return result;
	}

	@RequestMapping(value="/payslip.do", method = RequestMethod.GET)
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
//			Connection conn = DriverManager.getConnection("jdbc:mysql://206.189.83.43:3306/payslip?useUnicode=true&characterEncoding=UTF-8", 
//					"keiyin", 
//					"Wky62616261");
			JasperPrint jasperPrint = JasperFillManager.fillReport(jasperDesign, parameterMap, payslipDataSource.getConnection());
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
	
	@RequestMapping(value="/payslipHtml.do", method = RequestMethod.GET)
	public void generateOrderInvoiceReportHtml(
			HttpServletRequest request, 
			HttpServletResponse response) {
		Map<String, Object> parameterMap = new HashMap<>();
		
		try {
			InputStream inputStream = this.getClass().getResourceAsStream("/report/payslip-db.jrxml");
			JasperReport jasperDesign = JasperCompileManager.compileReport(inputStream);
			JasperPrint jasperPrint = JasperFillManager.fillReport(jasperDesign, parameterMap, payslipDataSource.getConnection());
			HtmlExporter exporter = new HtmlExporter();
			exporter.setExporterInput(new SimpleExporterInput(jasperPrint));
			OutputStream outputStream = response.getOutputStream();
			SimpleHtmlExporterOutput htmlExporterOutput = new SimpleHtmlExporterOutput(outputStream);
			exporter.setExporterOutput(htmlExporterOutput);
		    exporter.exportReport();
		} catch (JRException|SQLException e ) {
			log.info("Jasper report part error",e );
		} catch (Exception e) {
			log.info("Unexpected error occur",e );
		}
	}
}

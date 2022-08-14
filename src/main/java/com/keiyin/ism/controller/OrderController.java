package com.keiyin.ism.controller;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.CRC32;
import java.util.zip.CheckedOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.keiyin.ism.constant.ViewConstants;
import com.keiyin.ism.dao.OrderDAO;
import com.keiyin.ism.dao.ServiceDAO;
import com.keiyin.ism.datatable.DatatableRequest;
import com.keiyin.ism.datatable.JsonDatableQueryResponse;
import com.keiyin.ism.datatable.PaginationCriteria;
import com.keiyin.ism.model.Order;
import com.keiyin.ism.model.OrderDetail;
import com.keiyin.ism.model.Service;
import com.keiyin.ism.model.ServiceDiffPrice;
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
@RequestMapping(value = "/order")
public class OrderController {
	
	@Autowired
	@Qualifier("orderDAO")
	OrderDAO orderDAO;
	
	@Autowired
	@Qualifier("serviceDAO")
	ServiceDAO serviceDAO;
	
	@Autowired
	@Qualifier("springJdbcDataSources")
	DriverManagerDataSource springJdbcDataSources;
	
	private Logger log = LoggerFactory.getLogger(this.getClass());
	
	private static final String FAIL = "fail";
	private static final String SUCCESS = "success";
	private static final String INVOICE_JRXML_PATH = "/report/Invoice.jrxml";
	
	
	@RequestMapping(value = "/order.html", method = RequestMethod.GET)
	public ModelAndView renderOrderPage() {
		 return new ModelAndView(ViewConstants.ORDER_VIEW);
	}
	
	@RequestMapping(value = "/orderListDataTable", method = RequestMethod.POST)
	public @ResponseBody JsonDatableQueryResponse queryOrderList(HttpServletRequest request) {
		DatatableRequest datatableRequest = new DatatableRequest(request);
		PaginationCriteria requestPaginationCriteria = datatableRequest.getPaginationRequest();
		List<Order> orderList = new ArrayList<>();
		int totalCount = 0;
		
		try {
			orderList = orderDAO.datatableOrderList(requestPaginationCriteria.getRowStart(), requestPaginationCriteria.getPageSize(), datatableRequest.getSearch(), requestPaginationCriteria.getOrderByClause());
			totalCount = orderDAO.getOrderListCount(datatableRequest.getSearch());
			log.info("Successfully query order list datatable");
		} catch (SQLException e) {
			log.error("Failed query order list datatable", e);
		}
		
		JsonDatableQueryResponse jsonResponse = new JsonDatableQueryResponse();
		jsonResponse.setDraw(datatableRequest.getDraw());
		jsonResponse.setRecordsTotal(totalCount);
		jsonResponse.setData(orderList);
		jsonResponse.setRecordsFiltered(totalCount);
		
		return jsonResponse;
	}
	
	@RequestMapping(value = "/getOrder", method = RequestMethod.GET)
	public @ResponseBody Order getOrder(@RequestParam String orderId) {
		Order order = null;
		
		try {
			order = orderDAO.getOrder(orderId);
			log.info("Successfully retrieved order {}", order);
		} catch (SQLException e) {
			log.error("Failed to retrieve order {}", order, e);
		}
		return order;
	}
	
	@RequestMapping(value = "/getLastOrderId", method = RequestMethod.GET)
	public @ResponseBody String getLastOrderId(HttpServletRequest request) {
		String lastOrderId = null;
		
		try {
			lastOrderId = orderDAO.getLastOrderId();
			log.info("Successfully retrieved last order id {}", lastOrderId);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return lastOrderId;
	}
	
	@RequestMapping(value = "/createOrder", method = RequestMethod.POST)
	public @ResponseBody ResponseEntity<WriteResponse> createOrder(@RequestParam String orderId, @RequestParam String orderDate) {
		WriteResponse result = new WriteResponse();
		
		try {
			orderDAO.insertOrder(orderId, orderDate);
			result.setStatus(SUCCESS);
			log.info("Successfully inserted order {}", orderId);
		} 
		catch (SQLException e) {
			result.setStatus(FAIL);
			result.setData("Failed to create order");
			log.info("Failed insert order {}", orderId, e);
		} 
		
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
	@RequestMapping(value = "updateOrder", method = RequestMethod.POST)
	public @ResponseBody ResponseEntity<WriteResponse> updateOrder(@RequestParam String orderId,@RequestParam String orderDate){
		WriteResponse result = new WriteResponse();
		try {
			if(orderDAO.updateOrder(orderId, orderDate)) {
				result.setStatus(SUCCESS);
				log.info("Successfully updated order {}", orderId);
			}
			else {
				result.setStatus(FAIL);
				log.info("Failed to update order {}", orderId);
			}
		} catch (SQLException e) {
			log.info("Failed to update order {}", orderId, e);
			result.setStatus(FAIL);
		}
		
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
	@RequestMapping(value = "/deleteOrder", method = RequestMethod.POST)
	public @ResponseBody ResponseEntity<WriteResponse> deleteOrder(@RequestParam String orderId){
		WriteResponse result = new WriteResponse();
		
		try {
			orderDAO.deleteOrder(orderId);
			log.info("Successfully deleted order {}", orderId);
			result.setStatus(SUCCESS);
		} catch (SQLException e) {
			log.info("Failed to delete order {}", orderId, e);
			result.setStatus(FAIL);
		}
		
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
	@RequestMapping(value = "/deleteOrders", method = RequestMethod.POST)
	public @ResponseBody ResponseEntity<WriteResponse> deleteOrder(@RequestParam String[] selectedOrderIds){
		WriteResponse result = new WriteResponse();
		
		try {
			orderDAO.deleteMultipleOrder(selectedOrderIds);
			log.info("Successfully deleted order {}", Arrays.toString(selectedOrderIds));
			result.setStatus(SUCCESS);
		} catch (SQLException e) {
			log.info("Failed to delete order {}", Arrays.toString(selectedOrderIds), e);
			result.setStatus(FAIL);
		}
		
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
	
	// ==================================================================================
	// Order detail page
	// ==================================================================================
	
	@RequestMapping(value = "/order-detail.html", method = RequestMethod.GET)
	public ModelAndView renderOrderDetailPage(@RequestParam String orderId) {
		Map<String,Object> parameterMap = new HashMap<>();
		List<Service> serviceList = new ArrayList<>();
		
		try {
			serviceList = serviceDAO.getServiceList();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		parameterMap.put("serviceList", serviceList);
		return new ModelAndView(ViewConstants.ORDER_DETAIL_VIEW, parameterMap);
	}
	
	@RequestMapping(value = "/getOrderDetailDataTable", method = RequestMethod.POST)
	public @ResponseBody JsonDatableQueryResponse queryOrderDetailDatatable(HttpServletRequest request, @RequestParam String orderId) {
		List<OrderDetail> orderDetailList = new ArrayList<>();
		DatatableRequest datatableRequest = new DatatableRequest(request);
		try {
			orderDetailList = orderDAO.getOrderDetailList(orderId);
			log.info("Successfully query order detail list datatable for order {}", orderId);
		} catch (SQLException e) {
			log.info("Failed query order detail list datatable for order {}", orderId, e);
		}
		
		JsonDatableQueryResponse jsonResponse = new JsonDatableQueryResponse();
		jsonResponse.setDraw(datatableRequest.getDraw());
		jsonResponse.setData(orderDetailList);
		jsonResponse.setRecordsTotal(orderDetailList.size());
		jsonResponse.setRecordsFiltered(orderDetailList.size());
		
		return jsonResponse;
	}
	
	@RequestMapping(value = "/getOrderDetailList", method = RequestMethod.POST)
	public @ResponseBody List<OrderDetail> queryOrderDetailList(HttpServletRequest request, @RequestParam String orderId) {
		List<OrderDetail> orderDetailList = new ArrayList<>();
		// DatatableRequest datatableRequest = new DatatableRequest(request);
		try {
			orderDetailList = orderDAO.getOrderDetailList(orderId);
			log.info("Successfully query order detail list datatable for order {}", orderId);
		} catch (SQLException e) {
			log.info("Failed query order detail list datatable for order {}", orderId, e);
		}
		
		return orderDetailList;
	}
	
	@RequestMapping(value = "/getOrderDetail", method = RequestMethod.GET)
	public @ResponseBody OrderDetail getOrderDetail(@RequestParam String orderId, @RequestParam int lineNumber) {
		OrderDetail orderDetail = null;
		
		try {
			orderDetail = orderDAO.getOrderDetail(orderId, lineNumber);
			log.info("Successfully retrieved order detail {}", orderDetail);
		} catch (SQLException e) {
			log.error("Failed to retrieve order detail {}", orderDetail, e);
		}
		return orderDetail;
	}
	
	@RequestMapping(value = "/createOrderDetail", method = RequestMethod.POST)
	public @ResponseBody WriteResponse createOrderDetail(@RequestParam String orderId,
			@RequestParam String createService,
			@RequestParam String createDescription,
			@RequestParam(required = false) String createWidth,
			@RequestParam(required = false) String createHeight,
			@RequestParam(required = false) String createQuantity,
			@RequestParam(value = "createPriceSen") String createPriceSen) {
		
		WriteResponse result = new WriteResponse();
		
		try {
			orderDAO.insertOrderDetail(orderId, createService, createDescription, createWidth, createHeight, createQuantity, createPriceSen);
			log.info("Successfully insert order detail for {}", orderId);
			result.setStatus(SUCCESS);
		}
		catch (SQLException e) {
			result.setStatus(FAIL);
			log.info("Failed insert order detail for {}", orderId, e);
		} 
		
		return result;
	}
	
	@RequestMapping(value = "/deleteOrderDetail", method = RequestMethod.POST)
	public @ResponseBody WriteResponse deleteOrderDetail(@RequestParam String orderId, @RequestParam String lineNumber) {
		
		WriteResponse result = new WriteResponse();
		
		try {
			orderDAO.deleteOrderDetail(orderId, lineNumber);
			log.info("Successfully deleted order detail for {}", orderId);
			result.setStatus(SUCCESS);
		} catch (SQLException e) {
			log.info("Failed to delete order detail for {}", orderId, e);
			result.setStatus(FAIL);
		}
		
		return result;
	}
	
	@RequestMapping(value = "/updateOrderDetail", method = RequestMethod.POST)
	public @ResponseBody WriteResponse deleteOrderDetail(@RequestParam String orderId,
			@RequestParam String editLineNumber,
			@RequestParam String editService,
			@RequestParam String editDescription,
			@RequestParam(required = false) String editWidth,
			@RequestParam(required = false) String editHeight,
			@RequestParam(required = false) String editQuantity,
			@RequestParam String editPriceSen) {
		
		WriteResponse result = new WriteResponse();
		try {
			if(orderDAO.updateOrderDetail(orderId, editLineNumber, editService, editDescription, editWidth, editHeight, editQuantity, editPriceSen)) {
				result.setStatus(SUCCESS);
				log.info("Successfully updated orderDetail {}", orderId);
			}
			else {
				result.setStatus(FAIL);
				log.info("Failed to update orderDetail {}", orderId);
			}
		} catch (SQLException e) {
			log.info("Failed to update orderDetail {}", orderId, e);
			result.setStatus(FAIL);
		}
			
		return result;
		
	}
	
	// ==================================================================================
	// Report part
	// ==================================================================================
	
	@RequestMapping(value = "/order-invoice.html", method = RequestMethod.GET)
	public ModelAndView renderOrderInvoicePage() {
		 return new ModelAndView(ViewConstants.ORDER_INVOICE);
	}
	
	/**
	 * Get a report
	 * 
	 * @param orderId
	 * @param inline
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/orderReport.do", method = RequestMethod.GET)
	public void generateOrderInvoiceReport(
			@RequestParam String orderId, 
			@RequestParam(required=false, defaultValue = "1")int inline, 
			HttpServletRequest request, 
			HttpServletResponse response) {
		Map<String, Object> parameterMap = new HashMap<>();
		String filename = "Invoice_" + orderId + ".pdf";
		
		parameterMap.put("orderId", orderId);
		try {
			InputStream inputStream = this.getClass().getResourceAsStream(INVOICE_JRXML_PATH);
			JasperReport jasperDesign = JasperCompileManager.compileReport(inputStream);
			JasperPrint jasperPrint = JasperFillManager.fillReport(jasperDesign, parameterMap, springJdbcDataSources.getConnection());
			response.setContentType("application/pdf");
			 if(inline == 1) {
				 response.addHeader("Content-disposition", "inline; filename=" +filename);
			 }else {
				 response.addHeader("Content-disposition", "attachment; filename=" +filename);
			 }
	         OutputStream outputStream = response.getOutputStream();
	         log.info("Retrived report for order {}", orderId);
	         JasperExportManager.exportReportToPdfStream(jasperPrint, outputStream);
		} catch (JRException|SQLException e ) {
			log.info("Jasper report part error",e );
		} catch (Exception e) {
			log.info("Unexpected error occur",e );
		}
	}
	
	@RequestMapping(value="/orderReportHtml.do", method = RequestMethod.GET)
	public void generateOrderInvoiceReportHtml(
			@RequestParam String orderId, 
			HttpServletRequest request, 
			HttpServletResponse response) {
		Map<String, Object> parameterMap = new HashMap<>();
		
		parameterMap.put("orderId", orderId);
		try {
			InputStream inputStream = this.getClass().getResourceAsStream(INVOICE_JRXML_PATH);
			JasperReport jasperDesign = JasperCompileManager.compileReport(inputStream);
			JasperPrint jasperPrint = JasperFillManager.fillReport(jasperDesign, parameterMap, springJdbcDataSources.getConnection());
			HtmlExporter exporter = new HtmlExporter();
			exporter.setExporterInput(new SimpleExporterInput(jasperPrint));
			OutputStream outputStream = response.getOutputStream();
			SimpleHtmlExporterOutput htmlExporterOutput = new SimpleHtmlExporterOutput(outputStream);
			exporter.setExporterOutput(htmlExporterOutput);
		    exporter.exportReport();
		    log.info("Retrived report html for order {}", orderId);
		} catch (JRException|SQLException e ) {
			log.info("Jasper report part error",e );
		} catch (Exception e) {
			log.info("Unexpected error occur",e );
		}
	}
	
	/**
	 * Get multiple report
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/multipleOrderReport.do", method = RequestMethod.GET)
	public void generateMultipleOrderInvoiceReport(HttpServletRequest request, 
			HttpServletResponse response,
			@RequestParam String[] selectedOrderIds) {
		log.info("Generating multiple order invoices, {}", Arrays.toString(selectedOrderIds));
		List<OutputStream> oss = new ArrayList<>();
		
		try {
			for (String i : selectedOrderIds) {
				OutputStream os = getReport(i);
				oss.add(os);
			}
		} catch (Exception e) {
			 log.error("report生成出现错误", e);
		}finally{
		    try {
		        for (int i = 0; i < oss.size(); i++) oss.get(i).flush();
		    } catch (Exception e) {}
		}
		OutputStream os = null;
        CheckedOutputStream cos = null;
        ZipOutputStream zipOut = null;
        
        try {
        	os = response.getOutputStream();
        	response.setContentType("application/octet-stream;charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment;filename=reportTesting.zip");
            // 对输出文件做CRC32校验
            cos = new CheckedOutputStream(os, new CRC32());
            zipOut = new ZipOutputStream(cos);
            // 将单个文件的流添加到压缩文件中
            for (int i = 0; i < oss.size(); i++) {
                compressFile(oss.get(i), zipOut, "Invoice_" + selectedOrderIds[i] + ".pdf");
            }
            zipOut.flush();zipOut.close();
            os.flush();
        	
        }catch (Exception e) {
            log.error("Error occurred during zipping", e);
        }
		
	}
	
	public OutputStream getReport(String orderId) throws JRException, SQLException, IOException {
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		JasperPrint jasperPrint = null;
		
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("orderId", orderId);
		InputStream inputStream = this.getClass().getResourceAsStream(INVOICE_JRXML_PATH);
		JasperReport jasperDesign = JasperCompileManager.compileReport(inputStream);
		jasperPrint = JasperFillManager.fillReport(jasperDesign, parameterMap, springJdbcDataSources.getConnection());
		JasperExportManager.exportReportToPdfStream(jasperPrint, os);
		
		return os;
	}
	
	public void compressFile(OutputStream os, ZipOutputStream out, String fileName) throws IOException {
        int buffer = 1024 * 2;
        // 输出流转换为输入流
        ByteArrayOutputStream bos = (ByteArrayOutputStream) os;
        InputStream is = new ByteArrayInputStream(bos.toByteArray());
        BufferedInputStream bis = new BufferedInputStream(is);
        ZipEntry entry = new ZipEntry(fileName);
        out.putNextEntry(entry);
        int count;
        byte data[] = new byte[buffer];
        while ((count = bis.read(data, 0, buffer)) != -1) {
            out.write(data, 0, count);
        }
        bis.close();
    }
	
	
	// -------------------------------------------------------------------------------------
	// Service Type
	// -------------------------------------------------------------------------------------
	
	@RequestMapping(value = "/getAllServiceDiffPrices", method = RequestMethod.GET)
	public @ResponseBody List<ServiceDiffPrice> getAllServiceDiffPrices() {
		List<ServiceDiffPrice> serviceDiffPriceList = new ArrayList<>();
		
		try {
			serviceDiffPriceList = serviceDAO.getAllServiceDiffPrices();
			log.info("Successfully retrieved serviceDiffPriceList");
		} catch (SQLException e) {
			log.error("Failed to retrieve serviceDiffPriceList", e);
		}
		return serviceDiffPriceList;
	} 
	
	
}

package com.keiyin.ism.controller;

import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
import com.keiyin.ism.model.WriteResponse;

@Controller
@RequestMapping(value = "/order")
public class OrderController {
	
	@Autowired
	@Qualifier("orderDAO")
	OrderDAO orderDAO;
	
	@Autowired
	@Qualifier("serviceDAO")
	ServiceDAO serviceDAO;
	
	private Logger log = LoggerFactory.getLogger(this.getClass());
	
	private static final String FAIL = "fail";
	private static final String SUCCESS = "success";
	
	
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
			lastOrderId = String.valueOf(Integer.parseInt(lastOrderId) + 1);
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
	
	
	// ==========================================Order detail page========================================
	
	@RequestMapping(value = "/order-detail.html", method = RequestMethod.GET)
	public ModelAndView renderOrderDetailPage(@RequestParam String orderId) {
		Map<String,Object> parameterMap = new HashMap<String, Object>();
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
	public @ResponseBody JsonDatableQueryResponse queryOrderDetailList(String orderId) {
		List<OrderDetail> orderDetailList = new ArrayList<>();
		
		try {
			orderDetailList = orderDAO.getOrderDetailList(orderId);
			log.info("Successfully query order detail list datatable for order {}", orderId);
		} catch (SQLException e) {
			log.info("Failed query order detail list datatable for order {}", orderId, e);
		}
		
		JsonDatableQueryResponse jsonResponse = new JsonDatableQueryResponse();
		jsonResponse.setData(orderDetailList);
		
		return jsonResponse;
	}
	
	@RequestMapping(value = "/createOrderDetail", method = RequestMethod.POST)
	public @ResponseBody WriteResponse createOrderDetail(@RequestParam String orderId,
			@RequestParam String createService,
			@RequestParam String createDescription,
			@RequestParam(required = false) String createWidth,
			@RequestParam(required = false) String createHeight,
			@RequestParam(required = false) String createQuantity,
			@RequestParam String createPriceSen) {
		
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
	
}

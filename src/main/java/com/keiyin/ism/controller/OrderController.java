package com.keiyin.ism.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
		} catch (SQLException e) {
			e.printStackTrace();
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
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return order;
	}
	
	@RequestMapping(value = "/getLastOrderId", method = RequestMethod.GET)
	public @ResponseBody String getLastOrderId(HttpServletRequest request) {
		String lastOrderId = null;
		
		try {
			lastOrderId = orderDAO.getLastOrderId();
			lastOrderId = String.valueOf(Integer.parseInt(lastOrderId) + 1);
			System.out.println("Retrieved last order id " + lastOrderId);
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
		} 
		catch (SQLException e) {
			e.printStackTrace();
			result.setStatus(FAIL);
			result.setData("Failed to create order");
		} 
		
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
	@RequestMapping(value = "updateOrder", method = RequestMethod.POST)
	public @ResponseBody ResponseEntity<WriteResponse> updateOrder(@RequestParam String orderId,@RequestParam String orderDate){
		WriteResponse result = new WriteResponse();
		try {
			if(orderDAO.updateOrder(orderId, orderDate))
				result.setStatus(SUCCESS);
			else
				result.setStatus(FAIL);
		} catch (SQLException e) {
			e.printStackTrace();
			result.setStatus(FAIL);
		}
		
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
	@RequestMapping(value = "/deleteOrder", method = RequestMethod.POST)
	public @ResponseBody ResponseEntity<WriteResponse> deleteOrder(@RequestParam String orderId){
		WriteResponse result = new WriteResponse();
		
		try {
			orderDAO.deleteOrder(orderId);
			result.setStatus(SUCCESS);
		} catch (SQLException e) {
			e.printStackTrace();
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
	
	@RequestMapping(value = "/getOrderDetailList", method = RequestMethod.GET)
	public @ResponseBody JsonDatableQueryResponse queryOrderDetailList(String orderId) {
		List<OrderDetail> orderDetailList = new ArrayList<>();
		
		try {
			orderDetailList = orderDAO.getOrderDetailList(orderId);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		JsonDatableQueryResponse jsonResponse = new JsonDatableQueryResponse();
		jsonResponse.setData(orderDetailList);
		
		return jsonResponse;
	}
	
}

package com.keiyin.ism.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
import com.keiyin.ism.datatable.DatatableRequest;
import com.keiyin.ism.datatable.JsonDatableQueryResponse;
import com.keiyin.ism.datatable.PaginationCriteria;
import com.keiyin.ism.model.Order;
import com.keiyin.ism.model.WriteResponse;

@Controller
@RequestMapping(value = "/order")
public class OrderController {
	
	@Autowired
	@Qualifier("orderDAO")
	OrderDAO orderDAO;
	
	private static final String FAIL = "fail";
	private static final String SUCCESS = "success";
	
	@RequestMapping(value = "/order.html", method = RequestMethod.GET)
	public ModelAndView renderServicePage() {
		 return new ModelAndView(ViewConstants.ORDER_VIEW);
	}
	
	@RequestMapping(value = "/orderListDataTable", method = RequestMethod.POST)
	public @ResponseBody JsonDatableQueryResponse queryOrderList(HttpServletRequest request) {
		DatatableRequest datatableRequest = new DatatableRequest(request);
		PaginationCriteria requestPaginationCriteria = datatableRequest.getPaginationRequest();
		List<Order> orderList = new ArrayList<>();
		int totalCount = 0;
		
		try {
			orderList = orderDAO.getOrderList(requestPaginationCriteria.getRowStart(), requestPaginationCriteria.getPageSize(), datatableRequest.getSearch(), requestPaginationCriteria.getOrderByClause());
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
}

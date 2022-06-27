package com.keiyin.ism.dao;

import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.keiyin.ism.model.Order;
import com.keiyin.ism.model.OrderDetail;
import com.sun.javafx.binding.StringFormatter;

public class OrderDAO {
	
	private SqlMapClient orderSqlMapClient;
	
	@SuppressWarnings("unchecked")
	public List<Order> getOrderList(int start, int limit, String searchParameter, String orderClause) throws SQLException {
		if(searchParameter.isEmpty()) {
			searchParameter = null;
		}
		if(orderClause.isEmpty()) {
			orderClause = null;
		}
		List<Order> ordersList; 
		Map<String, Object> parameterMap = new HashMap<>();
		if (start != -1 && limit != -1) {
			parameterMap.put("start_row", start);
			parameterMap.put("limit_page", limit);
		}
		parameterMap.put("searchParameter", searchParameter);
		parameterMap.put("orderClause", orderClause);
		
		ordersList = orderSqlMapClient.queryForList("Order.getOrderList", parameterMap);
		
		return ordersList;
	}
	
	public Order getOrder(String orderId) throws SQLException {
		Order order;
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("orderId", orderId);
		order = (Order) orderSqlMapClient.queryForObject("Order.getOrder", parameterMap);
		return order;
	}
	
	public int getOrderListCount(String searchParameter) throws SQLException {
		if(searchParameter.isEmpty()) {
			searchParameter = null;
		}
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("searchParameter", searchParameter);
		return (int) orderSqlMapClient.queryForObject("Order.getOrderListCount", parameterMap);
	}
	
	public String getLastOrderId() throws SQLException {
		return (String) orderSqlMapClient.queryForObject("Order.getLastOrderId");
	}
	
	public void insertOrder(String orderId, String orderDate) throws SQLException {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("orderId", orderId);
		parameterMap.put("orderDate", orderDate);
		orderSqlMapClient.insert("Order.insertOrder", parameterMap);
	}
	
	public void deleteOrder(String orderId) throws SQLException {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("orderId", orderId);
		orderSqlMapClient.insert("Order.deleteOrder", parameterMap);
	}
	
	
	// ==============================Order detail========================================
	@SuppressWarnings("unchecked")
	public List<OrderDetail> getOrderDetailList(String orderId) throws SQLException{
		List<OrderDetail> orderDetailList; 
		orderDetailList = orderSqlMapClient.queryForList("Order.getOrderDetailList", orderId);
		return orderDetailList;
	}
	

	public SqlMapClient getOrderSqlMapClient() {
		return orderSqlMapClient;
	}

	public void setOrderSqlMapClient(SqlMapClient orderSqlMapClient) {
		this.orderSqlMapClient = orderSqlMapClient;
	}
	
}

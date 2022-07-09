package com.keiyin.ism.dao;

import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestParam;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.keiyin.ism.model.Order;
import com.keiyin.ism.model.OrderDetail;
import com.mysql.cj.x.protobuf.MysqlxCrud.Update;

public class OrderDAO {
	
	private SqlMapClient sqlMapClient;
	
	@SuppressWarnings("unchecked")
	public List<Order> datatableOrderList(int start, int limit, String searchParameter, String orderClause) throws SQLException {
		if(searchParameter== null || searchParameter.isEmpty()) {
			searchParameter = null;
		}
		if(orderClause== null || orderClause.isEmpty()) {
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
		
		ordersList = sqlMapClient.queryForList("Order.datatableOrderList", parameterMap);
		
		return ordersList;
	}
	
	public Order getOrder(String orderId) throws SQLException {
		Order order;
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("orderId", orderId);
		order = (Order) sqlMapClient.queryForObject("Order.getOrder", parameterMap);
		return order;
	}
	
	public int getOrderListCount(String searchParameter) throws SQLException {
		if(searchParameter.isEmpty()) {
			searchParameter = null;
		}
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("searchParameter", searchParameter);
		return (int) sqlMapClient.queryForObject("Order.getOrderListCount", parameterMap);
	}
	
	public String getLastOrderId() throws SQLException {
		return (String) sqlMapClient.queryForObject("Order.getLastOrderId");
	}
	
	public void insertOrder(String orderId, String orderDate) throws SQLException {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("orderId", orderId);
		parameterMap.put("orderDate", orderDate);
		sqlMapClient.insert("Order.insertOrder", parameterMap);
	}
	
	public boolean updateOrder(String orderId, String orderDate) throws SQLException {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("orderId", orderId);
		parameterMap.put("orderDate", orderDate);
		
		return (sqlMapClient.update("Order.updateOrder", parameterMap) > 0);
	}
	
	public void deleteOrder(String orderId) throws SQLException {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("orderId", orderId);
		sqlMapClient.delete("Order.deleteOrder", parameterMap);
	}
	
	public void deleteMultipleOrder(String[] selectedOrderIds) throws SQLException {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("selectedOrderIds", selectedOrderIds);
		sqlMapClient.delete("Order.deleteMultipleOrder", parameterMap);
	}
	
	
	// ---------------------------------------------------------------------------
	// Order detail
	// ---------------------------------------------------------------------------
	@SuppressWarnings("unchecked")
	public List<OrderDetail> getOrderDetailList(String orderId) throws SQLException{
		List<OrderDetail> orderDetailList; 
		orderDetailList = sqlMapClient.queryForList("Order.getOrderDetailList", orderId);
		return orderDetailList;
	}
	
	public OrderDetail getOrderDetail(String orderId, int lineNumber) throws SQLException {
		OrderDetail orderDetail = null;
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("orderId", orderId);
		parameterMap.put("lineNumber", lineNumber);
		orderDetail = (OrderDetail) sqlMapClient.queryForObject("Order.getOrderDetail", parameterMap);
		return orderDetail;
	}
	
	public void insertOrderDetail(String orderId,
			String createService,
			String createDescription,
			String createWidth,
			String createHeight,
			String createQuantity,
			String createPriceSen) throws SQLException {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("orderId", orderId);
		parameterMap.put("createService", createService);
		parameterMap.put("createDescription", createDescription);
		parameterMap.put("createWidth", createWidth);
		parameterMap.put("createHeight", createHeight);
		parameterMap.put("createQuantity", createQuantity);
		parameterMap.put("createPriceSen", createPriceSen);
		
		sqlMapClient.insert("Order.insertOrderDetail", parameterMap);
	}
	
	public void deleteOrderDetail(String orderId, String lineNumber) throws SQLException {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("orderId", orderId);
		parameterMap.put("lineNumber", lineNumber);
		sqlMapClient.insert("Order.deleteOrderDetail", parameterMap);
	}

	public boolean updateOrderDetail(
			String orderId,
			String editLineNumber,
			String editService,
			String editDescription,
			String editWidth,
			String editHeight,
			String editQuantity,
			String editPriceSen) throws SQLException {
		
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("orderId", orderId);
		parameterMap.put("editLineNumber", editLineNumber);
		parameterMap.put("editService", editService);
		parameterMap.put("editDescription", editDescription);
		parameterMap.put("editWidth", editWidth);
		parameterMap.put("editHeight", editHeight);
		parameterMap.put("editQuantity", editQuantity);
		parameterMap.put("editPriceSen", editPriceSen);
		
		return (sqlMapClient.update("Order.updateOrderDetail", parameterMap) > 0);
	}
	
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	
	
}

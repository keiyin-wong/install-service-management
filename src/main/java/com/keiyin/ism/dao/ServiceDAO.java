package com.keiyin.ism.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.keiyin.ism.model.Service;
import com.keiyin.ism.model.ServiceDiffPrice;

public class ServiceDAO {
	private SqlMapClient sqlMapClient;
	
	@SuppressWarnings("unchecked")
	public List<Service> getServiceList() throws SQLException {
		List<Service> servicesList;
		
		servicesList = sqlMapClient.queryForList("Service.getServiceList");
		
		return servicesList;
	}
	
	/**
	 * Get service datatable.
	 * 
	 * 
	 * @param start -1 representing no limit
	 * @param limit -1 representing no offset
	 * @param searchParameter <code>null</code> representing did not filter anything
	 * @param orderClause <code>null</code> representing did not order by anything
	 * @return
	 * @throws SQLException
	 */
	@SuppressWarnings("unchecked")
	public List<Service> getServiceDatatable(
			int start, 
			int limit, 
			String searchParameter, 
			String orderClause) throws SQLException {
		if(searchParameter== null || searchParameter.isEmpty()) {
			searchParameter = null;
		}
		if(orderClause== null || orderClause.isEmpty()) {
			orderClause = null;
		}
		Map<String, Object> parameterMap = new HashMap<>();
		if (start != -1 && limit != -1) {
			parameterMap.put("start_row", start);
			parameterMap.put("limit_page", limit);
		}
		parameterMap.put("searchParameter", searchParameter);
		parameterMap.put("orderClause", orderClause);
		
		return sqlMapClient.queryForList("Service.getServiceDatatable", parameterMap);
	}
	
	public int getServiceDatatableCount(String searchParameter) throws SQLException {
		if(searchParameter != null && searchParameter.isEmpty()) {
			searchParameter = null;
		}
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("searchParameter", searchParameter);
		return (int) sqlMapClient.queryForObject("Service.getServiceDatatableCount", parameterMap);
	}
	
	
	public Service getService(Integer id) throws SQLException {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("id", id);
		return (Service) sqlMapClient.queryForObject("Service.getService", parameterMap);
	}
	
	@SuppressWarnings("unchecked")
	public List<ServiceDiffPrice> getAllServiceDiffPrices() throws SQLException {
		List<ServiceDiffPrice> servicesDiffServicesList;
		
		servicesDiffServicesList = sqlMapClient.queryForList("Service.getAllServiceDiffPrices");
		
		return servicesDiffServicesList;
	}
	

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
}

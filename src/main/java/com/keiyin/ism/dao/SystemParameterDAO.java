package com.keiyin.ism.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.keiyin.ism.model.system.parameter.SystemParameter;

@Service
public class SystemParameterDAO {

	@Autowired
	@Qualifier("sqlMapClient")
	private SqlMapClient sqlMapClient;
	
	
	/**
	 * Get system parameter datatable.
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
	public List<SystemParameter> getSystemParameterDatatable(
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
		
		return sqlMapClient.queryForList("SystemParameter.getSystemParameterDatatable", parameterMap);
	}
	
	public int getSystemParameterDatatableCount(String searchParameter) throws SQLException {
		if(searchParameter != null && searchParameter.isEmpty()) {
			searchParameter = null;
		}
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("searchParameter", searchParameter);
		return (int) sqlMapClient.queryForObject("SystemParameter.getSystemParameterDatatableCount", parameterMap);
	}
	

	public SystemParameter getSystemParameter(Integer id) throws SQLException {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("id", id);
		return (SystemParameter) sqlMapClient.queryForObject("SystemParameter.getSystemParameter", parameterMap);
	}
	
	public SystemParameter getSystemParameterByName(String name) throws SQLException {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("name", name);
		return (SystemParameter) sqlMapClient.queryForObject("SystemParameter.getSystemParameter", parameterMap);
	}

	public String getSystemParameterValueByNameEmptyIfNull(String name) throws SQLException {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("name", name);
		SystemParameter systemParameter = (SystemParameter) sqlMapClient.queryForObject("SystemParameter.getSystemParameter", parameterMap);
		if(systemParameter != null) {
			return systemParameter.getValue();
		}
		return "";
	}
	
	public void updateSystemParameterById(SystemParameter systemParameter) throws SQLException {
		sqlMapClient.update("SystemParameter.updateSystemParameterById", systemParameter);	
	}
	
}

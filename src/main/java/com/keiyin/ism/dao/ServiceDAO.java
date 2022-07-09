package com.keiyin.ism.dao;

import java.sql.SQLException;
import java.util.List;

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

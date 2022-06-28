package com.keiyin.ism.dao;

import java.sql.SQLException;
import java.util.List;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.keiyin.ism.model.Service;

public class ServiceDAO {
	private SqlMapClient sqlMapClient;
	
	@SuppressWarnings("unchecked")
	public List<Service> getServiceList() throws SQLException {
		List<Service> servicesList;
		
		servicesList = sqlMapClient.queryForList("Service.getServiceList");
		
		return servicesList;
	}
	

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
}

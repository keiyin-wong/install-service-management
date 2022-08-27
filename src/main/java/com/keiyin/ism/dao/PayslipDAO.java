package com.keiyin.ism.dao;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.keiyin.ism.model.Payslip;

@Service(value = "payslipDAO")
public class PayslipDAO {
	@Autowired
	@Qualifier("sqlMapPaySlipClient")
	private SqlMapClient sqlMapPaySlipClient;
	
	@SuppressWarnings("unchecked")
	public List<Payslip> getAllPayslip() throws SQLException {
		return sqlMapPaySlipClient.queryForList("Payslip.getAllPayslip");
	}
}

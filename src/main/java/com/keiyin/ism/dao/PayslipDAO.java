package com.keiyin.ism.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapSession;
import com.keiyin.ism.model.Payslip;

@Service(value = "payslipDAO")
public class PayslipDAO {
	@Autowired
	@Qualifier("sqlMapPaySlipClient")
	private SqlMapClient sqlMapPaySlipClient;
	
	private Logger log = LoggerFactory.getLogger(this.getClass());
	
	@SuppressWarnings("unchecked")
	public List<Payslip> getAllPayslip() throws SQLException {
		return sqlMapPaySlipClient.queryForList("Payslip.getAllPayslip");
	}
	
	public boolean updatePayslipInformation(
			String companyName,
			String payPeriod,
			String employeeName,
			String staffId,
			String department,
			String ic) throws SQLException {
		
		boolean success = false;
		SqlMapSession sqlMapSession = sqlMapPaySlipClient.openSession();
		try {
			sqlMapSession.startTransaction();
			// sqlMapSession.getCurrentConnection().setAutoCommit(false);
			log.info("Starting transaction to update payslip information");
			Map<String, Object> parameterMap = new HashMap<>();
			String sqlMapQuery = "Payslip.updatePayslipName";
			
			parameterMap.put("type", "comp_name");
			parameterMap.put("name", companyName);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			parameterMap.put("type", "pay_period");
			parameterMap.put("name", payPeriod);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			parameterMap.put("type", "emp_name");
			parameterMap.put("name", employeeName);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			parameterMap.put("type", "staff_id");
			parameterMap.put("name", staffId);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			parameterMap.put("type", "dept");
			parameterMap.put("name", department);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			parameterMap.put("type", "ic");
			parameterMap.put("name", ic);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			log.info("Transaction is completed. All SQL statements are executed and commited into database succesfully.");
			success = true;
		} finally {
			sqlMapSession.endTransaction();
			sqlMapSession.close();
			log.info("Update process payslip information transaction has ended.");
		}
		return success;
	}
	
	public boolean updatePayslipBillingInformation(
			String epfId,
			String taxId,
			String soscoEisId,
			String bankId) throws SQLException {
		
		boolean success = false;
		SqlMapSession sqlMapSession = sqlMapPaySlipClient.openSession();
		try {
			sqlMapSession.startTransaction();
			log.info("Starting transaction to update payslip billing information");
			Map<String, Object> parameterMap = new HashMap<>();
			String sqlMapQuery = "Payslip.updatePayslipName";
			
			parameterMap.put("type", "epf_id");
			parameterMap.put("name", epfId);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			parameterMap.put("type", "tax_id");
			parameterMap.put("name", taxId);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			parameterMap.put("type", "sosco_id");
			parameterMap.put("name", soscoEisId);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			parameterMap.put("type", "bank_acc");
			parameterMap.put("name", bankId);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			log.info("Transaction is completed. All SQL statements are executed and commited into database succesfully.");
			success = true;
		} finally {
			sqlMapSession.endTransaction();
			sqlMapSession.close();
			log.info("Update process payslip billing information transaction has ended.");
		}
		return success;
	}
}

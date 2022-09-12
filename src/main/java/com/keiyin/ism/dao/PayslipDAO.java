package com.keiyin.ism.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.buffer.UnboundedFifoBuffer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.web.firewall.FirewalledRequest;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapSession;
import com.keiyin.ism.model.Payslip;
import com.lowagie.text.Paragraph;

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
	
	public boolean updateCurrentMonthEmployeeEpfSosco(
			double currentMonthEmployeeEpf,
			double currentMonthEmployeeSosco,
			double currentMonthEmployeeEis) throws SQLException {
		
		boolean success = false;
		SqlMapSession sqlMapSession = sqlMapPaySlipClient.openSession();
		try {
			sqlMapSession.startTransaction();
			log.info("Starting transaction to update employee current month epf sosco");
			Map<String, Object> parameterMap = new HashMap<>();
			String sqlMapQuery = "Payslip.updatePayslipAmount";
			
			parameterMap.put("type", "employee_month_epf");
			parameterMap.put("amount", currentMonthEmployeeEpf);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			parameterMap.put("type", "employee_month_sosco");
			parameterMap.put("amount", currentMonthEmployeeSosco);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			parameterMap.put("type", "employee_month_eis");
			parameterMap.put("amount", currentMonthEmployeeEis);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			log.info("Transaction is completed. All SQL statements are executed and commited into database succesfully.");
			success = true;
		} finally {
			sqlMapSession.endTransaction();
			sqlMapSession.close();
			log.info("Update process employee current month epf sosco transaction has ended.");
		}
		return success;
	}
	
	public boolean updateCurrentMonthEmployerEpfSosco(
			double currentMonthEmployerEpf,
			double currentMonthEmployerSosco,
			double currentMonthEmployerEis) throws SQLException {
		
		boolean success = false;
		SqlMapSession sqlMapSession = sqlMapPaySlipClient.openSession();
		try {
			sqlMapSession.startTransaction();
			log.info("Starting transaction to update employer current month epf sosco");
			Map<String, Object> parameterMap = new HashMap<>();
			String sqlMapQuery = "Payslip.updatePayslipAmount";
			
			parameterMap.put("type", "employer_month_epf");
			parameterMap.put("amount", currentMonthEmployerEpf);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			parameterMap.put("type", "employer_month_sosco");
			parameterMap.put("amount", currentMonthEmployerSosco);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			parameterMap.put("type", "employer_month_eis");
			parameterMap.put("amount", currentMonthEmployerEis);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			log.info("Transaction is completed. All SQL statements are executed and commited into database succesfully.");
			success = true;
		} finally {
			sqlMapSession.endTransaction();
			sqlMapSession.close();
			log.info("Update process employer current month epf sosco transaction has ended.");
		}
		return success;
	}
	
	public boolean updateYearToDateEmployeeEpfSosco(
			double yearToDateEmployeeEpf,
			double yearToDateEmployeeSosco,
			double yearToDateEmployeeEis) throws SQLException {
		
		boolean success = false;
		SqlMapSession sqlMapSession = sqlMapPaySlipClient.openSession();
		try {
			sqlMapSession.startTransaction();
			log.info("Starting transaction to update employee year to date epf sosco");
			Map<String, Object> parameterMap = new HashMap<>();
			String sqlMapQuery = "Payslip.updatePayslipAmount";
			
			parameterMap.put("type", "employee_year_epf");
			parameterMap.put("amount", yearToDateEmployeeEpf);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			parameterMap.put("type", "employee_year_sosco");
			parameterMap.put("amount", yearToDateEmployeeSosco);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			parameterMap.put("type", "employee_year_eis");
			parameterMap.put("amount", yearToDateEmployeeEis);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			log.info("Transaction is completed. All SQL statements are executed and commited into database succesfully.");
			success = true;
		} finally {
			sqlMapSession.endTransaction();
			sqlMapSession.close();
			log.info("Update process employee year to date epf sosco transaction has ended.");
		}
		return success;
	}
	
	public boolean updateYearToDateEmployerEpfSosco(
			double yearToDateEmployerEpf,
			double yearToDateEmployerSosco,
			double yearToDateEmployerEis) throws SQLException {
		
		boolean success = false;
		SqlMapSession sqlMapSession = sqlMapPaySlipClient.openSession();
		try {
			sqlMapSession.startTransaction();
			log.info("Starting transaction to update employer year to date epf sosco");
			Map<String, Object> parameterMap = new HashMap<>();
			String sqlMapQuery = "Payslip.updatePayslipAmount";
			
			parameterMap.put("type", "employer_year_epf");
			parameterMap.put("amount", yearToDateEmployerEpf);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			parameterMap.put("type", "employer_year_sosco");
			parameterMap.put("amount", yearToDateEmployerSosco);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			parameterMap.put("type", "employer_year_eis");
			parameterMap.put("amount", yearToDateEmployerEis);
			sqlMapSession.update(sqlMapQuery, parameterMap);
			
			log.info("Transaction is completed. All SQL statements are executed and commited into database succesfully.");
			success = true;
		} finally {
			sqlMapSession.endTransaction();
			sqlMapSession.close();
			log.info("Update process employer year to date epf sosco transaction has ended.");
		}
		return success;
	}
	
	public boolean updateEarnings(String[] name, double[] amount) throws SQLException {
		boolean success = false;
		String earning = "earning";
		
		SqlMapSession sqlMapSession = sqlMapPaySlipClient.openSession();
		
		try {
			log.info("Starting transaction to update earnings");
			sqlMapSession.startTransaction();
			sqlMapSession.getCurrentConnection().setAutoCommit(false);
			
			sqlMapSession.delete("Payslip.deletePayslipByType", earning);
			
			if(name!=null && amount!= null) {
				for(int i = 0; i < name.length; i++) {
					Map<String, Object> parameterMap = new HashMap<>();
					parameterMap.put("name", name[i]);
					parameterMap.put("amount", amount[i]);
					parameterMap.put("type", earning);
					sqlMapSession.insert("Payslip.insertPayslip", parameterMap);
				}
			}
			
			sqlMapSession.getCurrentConnection().commit();
			sqlMapSession.commitTransaction();
			success = true;
		} finally {
			sqlMapSession.endTransaction();
			sqlMapSession.close();
			log.info("Update process update earnings has ended.");
		}
		
		return success;
	}
}

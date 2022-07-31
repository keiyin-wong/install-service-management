package com.keiyin.ism.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.keiyin.ism.constant.ViewConstants;
import com.keiyin.ism.dao.OrderDAO;
import com.keiyin.ism.model.MonthlyTotal;


@Controller
@RequestMapping(value = "/dashboard")
public class DashboardController {
	@Autowired
	OrderDAO orderDAO;
	
	private Logger log = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping(value = "/dashboard.html", method = RequestMethod.GET)
	public ModelAndView renderServicePage() {
		Map<String,Object> parameterMap = new HashMap<>();
		List<MonthlyTotal> monthlyTotalList = null;
		try {
			monthlyTotalList = orderDAO.getMonthlyTotal(2022);
		} catch (SQLException e) {
			log.error("Failed to get monthly total list",e);
		}
		parameterMap.put("monthlyTotalList", monthlyTotalList);
		return new ModelAndView(ViewConstants.DASHBOARD_VIEW, parameterMap);
	}
	
	@RequestMapping(value = "/getMonthlyTotal", method = RequestMethod.GET)
	public @ResponseBody List<MonthlyTotal> getMonthlyTotal(@RequestParam int year) {
		List<MonthlyTotal> monthlyTotals = null;
		try {
			 monthlyTotals = orderDAO.getMonthlyTotal(year);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return monthlyTotals;
	}
}

package com.keiyin.ism.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.keiyin.ism.constant.ViewConstants;
import com.keiyin.ism.dao.SystemParameterDAO;
import com.keiyin.ism.datatable.DatatableRequest;
import com.keiyin.ism.datatable.JsonDatableQueryResponse;
import com.keiyin.ism.datatable.PaginationCriteria;
import com.keiyin.ism.model.WriteResponse;
import com.keiyin.ism.model.system.parameter.SystemParameter;

@Controller
@RequestMapping(value = "/system")
public class SystemParameterController {
	
	private Logger log = LoggerFactory.getLogger(this.getClass());
	@Autowired
	private SystemParameterDAO systemParameterDAO;

	@RequestMapping(value = "/system-parameter.html", method = RequestMethod.GET)
	public ModelAndView renderOrderPage() {
		 return new ModelAndView(ViewConstants.SYSTEM_PARAMETER_VIEW);
	}
	
	@RequestMapping(value = "/parameter/datatable", method = RequestMethod.POST)
	public @ResponseBody JsonDatableQueryResponse queryOrderList(HttpServletRequest request) {
		DatatableRequest datatableRequest = new DatatableRequest(request);
		PaginationCriteria requestPaginationCriteria = datatableRequest.getPaginationRequest();
		List<SystemParameter> systemParameterList = new ArrayList<>();
		int totalCount = 0;
		
		try {
			systemParameterList = systemParameterDAO.getSystemParameterDatatable(
				requestPaginationCriteria.getRowStart(), 
				requestPaginationCriteria.getPageSize(), 
				datatableRequest.getSearch(), 
				requestPaginationCriteria.getOrderByClause()
			);
			totalCount = systemParameterDAO.getSystemParameterDatatableCount(datatableRequest.getSearch());
			log.info("Successfully query system parameter for datatable");
		} catch (SQLException e) {
			log.error("Failed query system parameter for datatable", e);
		}
		
		JsonDatableQueryResponse jsonResponse = new JsonDatableQueryResponse();
		jsonResponse.setDraw(datatableRequest.getDraw());
		jsonResponse.setRecordsTotal(totalCount);
		jsonResponse.setData(systemParameterList);
		jsonResponse.setRecordsFiltered(totalCount);
		
		return jsonResponse;
	}
	
	
	@RequestMapping(value = "/parameter", method = RequestMethod.GET)
	public @ResponseBody SystemParameter getSystemParameter(@RequestParam Integer id) {
		SystemParameter systemParameter = null;
		
		try {
			systemParameter = systemParameterDAO.getSystemParameter(id);
			log.info("Successfully retrieved system parameter {}", systemParameter);
		} catch (SQLException e) {
			log.error("Failed to retrieve system parameter with id {}", id, e);
		}
		return systemParameter;
	}
	
	@RequestMapping(value = "parameter/update", method = RequestMethod.POST)
	public @ResponseBody ResponseEntity<WriteResponse> updateSystemParameter(
			SystemParameter systemParameter){
		WriteResponse result = new WriteResponse();
		try {
			systemParameterDAO.updateSystemParameterById(systemParameter);
			result.setStatus(WriteResponse.Status.SUCCESS);
		} catch (SQLException e) {
			log.info("Failed to update system parameter {}", systemParameter, e);
			result.setStatus(WriteResponse.Status.FAIL);
		}
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
}

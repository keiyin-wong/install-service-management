package com.keiyin.ism.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
import com.keiyin.ism.dao.ServiceDAO;
import com.keiyin.ism.datatable.DatatableRequest;
import com.keiyin.ism.datatable.JsonDatableQueryResponse;
import com.keiyin.ism.datatable.PaginationCriteria;
import com.keiyin.ism.model.Service;


@Controller
@RequestMapping(value = "/service")
public class ServiceController {

	@Autowired
	ServiceDAO serviceDAO;
	
	private Logger log = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping(value = "/service.html", method = RequestMethod.GET)
	public ModelAndView renderOrderPage() {
		 return new ModelAndView(ViewConstants.SERVICE_VIEW);
	}
	
	@RequestMapping(value = "/datatable", method = RequestMethod.POST)
	public @ResponseBody JsonDatableQueryResponse queryOrderList(HttpServletRequest request) {
		DatatableRequest datatableRequest = new DatatableRequest(request);
		PaginationCriteria requestPaginationCriteria = datatableRequest.getPaginationRequest();
		List<Service> serviceList = new ArrayList<>();
		int totalCount = 0;
		
		try {
			serviceList = serviceDAO.getServiceDatatable(
				requestPaginationCriteria.getRowStart(), 
				requestPaginationCriteria.getPageSize(), 
				datatableRequest.getSearch(), 
				requestPaginationCriteria.getOrderByClause()
			);
			totalCount = serviceDAO.getServiceDatatableCount(datatableRequest.getSearch());
			log.info("Successfully query service for datatable");
		} catch (SQLException e) {
			log.error("Failed query service for datatable", e);
		}
		
		JsonDatableQueryResponse jsonResponse = new JsonDatableQueryResponse();
		jsonResponse.setDraw(datatableRequest.getDraw());
		jsonResponse.setRecordsTotal(totalCount);
		jsonResponse.setData(serviceList);
		jsonResponse.setRecordsFiltered(totalCount);
		
		return jsonResponse;
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public @ResponseBody Service getService(@RequestParam Integer id) {
		Service service = null;
		
		try {
			service = serviceDAO.getService(id);
			log.info("Successfully retrieved service {}", service);
		} catch (SQLException e) {
			log.error("Failed to retrieve service with id {}", id, e);
		}
		return service;
	}
}
	
	


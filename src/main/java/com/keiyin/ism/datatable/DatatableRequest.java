package com.keiyin.ism.datatable;


import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;



public class DatatableRequest {
	/** The unique id. */
	private String uniqueId;
	
	/** The draw. */
	private String draw;
	
	/** The start. */
	private Integer start;
	
	/** The length. */
	private Integer length;
	
	/** The search. */
	private String search;
	
	/** The regex. */
	private boolean regex;

	/** The columns. */
	private List<DatatableColumn> columns;
	
	/** The order. */
	private DatatableColumn order;
	
	/** The is global search. */
	private boolean isGlobalSearch;
	
	private int maxParamsToCheck = 0;
	
	/**
	 * Instantiates a new data table request.
	 *
	 * @param request the request
	 */
	public DatatableRequest(HttpServletRequest request) {
		prepareDataTableRequest(request);
	}

	private void prepareDataTableRequest(HttpServletRequest request) {
		Enumeration<String> parameterNames = request.getParameterNames();
		if(parameterNames.hasMoreElements()) {
			this.setStart(Integer.parseInt(request.getParameter("start")));
			this.setLength(Integer.parseInt(request.getParameter("length")));
			this.setUniqueId(request.getParameter("_"));
			this.setDraw(request.getParameter("draw"));
			this.setSearch(request.getParameter("search[value]"));
			this.setRegex(Boolean.valueOf(request.getParameter("search[regex]")));
			int sortableCol = request.getParameter("order[0][column]") == null? -1 : Integer.parseInt(request.getParameter("order[0][column]"));
			List<DatatableColumn> columns = new ArrayList<>();
			if(!AppUtil.isObjectEmpty(this.getSearch())) {
    			this.setGlobalSearch(true);
    		}
			
			maxParamsToCheck = getNumberOfColumns(request);
			
			for(int i=0; i < maxParamsToCheck; i++) {
				if(null != request.getParameter("columns["+ i +"][data]") 
						&& !"null".equalsIgnoreCase(request.getParameter("columns["+ i +"][data]"))  
						&& !AppUtil.isObjectEmpty(request.getParameter("columns["+ i +"][data]"))) {
					DatatableColumn colSpec = new DatatableColumn(request, i);
					if(i == sortableCol) {
						this.setOrder(colSpec);
					}
					columns.add(colSpec);
					
					if(!AppUtil.isObjectEmpty(colSpec.getSearch())) {
						this.setGlobalSearch(false);
					}
				} 
			}
			
			if(!AppUtil.isObjectEmpty(columns)) {
    			this.setColumns(columns);
    		}
		
		}
		
	}
	
	private int getNumberOfColumns(HttpServletRequest request) {
		Pattern p = Pattern.compile("columns\\[[0-9]+\\]\\[data\\]");  
		@SuppressWarnings("rawtypes")
		Enumeration params = request.getParameterNames(); 
		List<String> lstOfParams = new ArrayList<String>();
		while(params.hasMoreElements()){		
		 String paramName = (String)params.nextElement();
		 Matcher m = p.matcher(paramName);
		 if(m.matches())	{
			 lstOfParams.add(paramName);
		 }
		}
		return lstOfParams.size();
	}
	
	public PaginationCriteria getPaginationRequest() {
		PaginationCriteria pagination = new PaginationCriteria();
		pagination.setRowStart(this.getStart());
		pagination.setPageSize(this.getLength());
		
		Map<String, String> filterBy = new HashMap<>();
		Map<String, SortOrderEnum> sortBy = new HashMap<>();
		
		// Set the name from the datatable and [desc or as]
		if(!AppUtil.isObjectEmpty(this.getOrder())) {
			sortBy.put(this.getOrder().getName(), SortOrderEnum.fromValue(this.getOrder().getSortDir()));
		}
		
		// Set the which name of filtered column from the datatable and value
		for(DatatableColumn colSpec : this.getColumns()) {
			if(colSpec.isSearchable()) {
				if(!AppUtil.isObjectEmpty(this.getSearch()) || !AppUtil.isObjectEmpty(colSpec.getSearch())) {
					filterBy.put(colSpec.getData(), (this.isGlobalSearch()) ? this.getSearch() : colSpec.getSearch());
				}
			}
		}
		pagination.setSortBy(sortBy);
		pagination.setFilterBy(filterBy);
		
		return pagination;
	}

	public String getUniqueId() {
		return uniqueId;
	}

	public void setUniqueId(String uniqueId) {
		this.uniqueId = uniqueId;
	}

	public String getDraw() {
		return draw;
	}

	public void setDraw(String draw) {
		this.draw = draw;
	}

	public Integer getStart() {
		return start;
	}

	public void setStart(Integer start) {
		this.start = start;
	}

	public Integer getLength() {
		return length;
	}

	public void setLength(Integer length) {
		this.length = length;
	}

	public String getSearch() {
		return search;
	}

	public void setSearch(String search) {
		this.search = search;
	}

	public boolean isRegex() {
		return regex;
	}

	public void setRegex(boolean regex) {
		this.regex = regex;
	}

	public List<DatatableColumn> getColumns() {
		return columns;
	}

	public void setColumns(List<DatatableColumn> columns) {
		this.columns = columns;
	}

	public DatatableColumn getOrder() {
		return order;
	}

	public void setOrder(DatatableColumn order) {
		this.order = order;
	}

	public boolean isGlobalSearch() {
		return isGlobalSearch;
	}

	public void setGlobalSearch(boolean isGlobalSearch) {
		this.isGlobalSearch = isGlobalSearch;
	}
	
	
}
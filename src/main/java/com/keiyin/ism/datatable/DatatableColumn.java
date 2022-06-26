package com.keiyin.ism.datatable;

import javax.servlet.http.HttpServletRequest;

public class DatatableColumn {
	/** The index. */
	 private int index;
	 
	 /** The data. */
	 private String data;
	 
	 /** The name. */
	 private String name;
	 
	 /** The searchable. */
	 private boolean searchable;
	 
	 /** The orderable. */
	 private boolean orderable;
	 
	 /** The search. */
	 private String search;
	 
	 /** The regex. */
	 private boolean regex;
	 
	 public int getIndex() {
		return index;
	}

	public void setIndex(int index) {
		this.index = index;
	}


	public String getData() {
		return data;
	}


	public void setData(String data) {
		this.data = data;
	}


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public boolean isSearchable() {
		return searchable;
	}


	public void setSearchable(boolean searchable) {
		this.searchable = searchable;
	}


	public boolean isOrderable() {
		return orderable;
	}


	public void setOrderable(boolean orderable) {
		this.orderable = orderable;
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


	public String getSortDir() {
		return sortDir;
	}


	public void setSortDir(String sortDir) {
		this.sortDir = sortDir;
	}


	/** The sort dir. */
	 private String sortDir;
	 
	 
	 /**
	 * Instantiates a new data table column specs.
	 *
	 * @param request the request
	 * @param i the i
	 */
	 public DatatableColumn(HttpServletRequest request, int i) {
	 this.setIndex(i);
	 prepareColumn(request, i);
	 }
	 
	 /**
	 * Prepare column specs.
	 *
	 * @param request the request
	 * @param i the i
	 */
	private void prepareColumn(HttpServletRequest request, int i) {
		
		this.setData(request.getParameter("columns["+ i +"][data]"));
		this.setName(request.getParameter("columns["+ i +"][name]"));
		this.setOrderable(Boolean.valueOf(request.getParameter("columns["+ i +"][orderable]")));
		this.setRegex(Boolean.valueOf(request.getParameter("columns["+ i +"][search][regex]")));
		this.setSearch(request.getParameter("columns["+ i +"][search][value]"));
		this.setSearchable(Boolean.valueOf(request.getParameter("columns["+ i +"][searchable]")));
		
		int sortableCol = request.getParameter("order[0][column]") == null? -1 : Integer.parseInt(request.getParameter("order[0][column]"));
		String sortDir = request.getParameter("order[0][dir]");
		
		if(i == sortableCol) {
			this.setSortDir(sortDir);
		}
	}
 
}

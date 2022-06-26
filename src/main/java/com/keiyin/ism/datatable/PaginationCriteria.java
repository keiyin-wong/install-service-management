package com.keiyin.ism.datatable;


import java.util.Iterator;
import java.util.Map;

public class PaginationCriteria {

	/** The page number. */
	private Integer rowStart;
	
	/** The page size. */
	private Integer pageSize;
	
	/** The total records. */
	private Integer totalRecords;
	
	/** The sort by. */
	private Map<String, String> filterBy;
	
	/** The filter by. */
	private Map<String, SortOrderEnum> sortBy;
	
	public Integer getRowStart() {
		return rowStart;
	}

	public void setRowStart(Integer rowStart) {
		this.rowStart = rowStart;
	}

	public Integer getPageSize() {
		return pageSize;
	}

	public void setPageSize(Integer pageSize) {
		this.pageSize = pageSize;
	}

	public Integer getTotalRecords() {
		return totalRecords;
	}

	public void setTotalRecords(Integer totalRecords) {
		this.totalRecords = totalRecords;
	}

	public Map<String, String> getFilterBy() {
		return filterBy;
	}

	public void setFilterBy(Map<String, String> filterBy) {
		this.filterBy = filterBy;
	}

	public Map<String, SortOrderEnum> getSortBy() {
		return sortBy;
	}

	public void setSortBy(Map<String, SortOrderEnum> sortBy) {
		this.sortBy = sortBy;
	}
	
	public String getOrderByClause() {
		StringBuilder orderClause = null;
		if(!sortBy.isEmpty()) {
			Iterator<Map.Entry<String, SortOrderEnum>> itr = sortBy.entrySet().iterator();
			
			while (itr.hasNext()) {
				Map.Entry<String, SortOrderEnum> pair =  itr.next();
				if(null == orderClause) {
					orderClause = new StringBuilder();
					orderClause.append(ORDER_BY).append(pair.getKey()).append(SPACE).append(pair.getValue());
				}
			}
			
		}
		
		return (orderClause == null)? null : orderClause.toString();
	}
	
	private static final String ORDER_BY = " ORDER BY ";
	private static final String SPACE = " ";
	
}

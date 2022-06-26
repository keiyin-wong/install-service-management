package com.keiyin.ism.datatable;


import java.util.List;

import com.google.gson.Gson;
import com.google.gson.annotations.SerializedName;

public class JsonDatableQueryResponse {
	/** The draw. */
	private String draw;
	
	/** The records filtered. */
	private int recordsFiltered;
	
	/** The records total. */
	private int recordsTotal;

	/** The list of data objects. */
	@SerializedName("data")
	List<?> data;

	public String getJson() {
		return new Gson().toJson(this);
	}
	
	public String getDraw() {
		return draw;
	}

	public void setDraw(String draw) {
		this.draw = draw;
	}

	public int getRecordsFiltered() {
		return recordsFiltered;
	}

	public void setRecordsFiltered(int recordsFiltered) {
		this.recordsFiltered = recordsFiltered;
	}

	public int getRecordsTotal() {
		return recordsTotal;
	}

	public void setRecordsTotal(int recordsTotal) {
		this.recordsTotal = recordsTotal;
	}

	public List<?> getData() {
		return data;
	}

	public void setData(List<?> data) {
		this.data = data;
	}
	
	
}


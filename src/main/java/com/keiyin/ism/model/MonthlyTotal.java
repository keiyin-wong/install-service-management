package com.keiyin.ism.model;

import java.util.ArrayList;
import java.util.List;

public class MonthlyTotal {
	private int year;
	private int month;
	private int total;
	
	public int getYear() {
		return year;
	}
	public void setYear(int year) {
		this.year = year;
	}
	public int getMonth() {
		return month;
	}
	public void setMonth(int month) {
		this.month = month;
	}
	public int getTotal() {
		return total;
	}
	public void setTotal(int total) {
		this.total = total;
	}
	
	public static List<MonthlyTotal> getTwelveMonthsList(int year) {
		List<MonthlyTotal> resultList = new ArrayList<>();
		for(int i = 1; i < 13; i++) {
			MonthlyTotal month = new MonthlyTotal();
			month.setYear(year);
			month.setMonth(i);
			resultList.add(month);
		}
		return resultList;
	}
}

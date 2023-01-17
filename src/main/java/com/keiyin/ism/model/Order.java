package com.keiyin.ism.model;

import java.util.Date;
import java.util.List;

public class Order {
	String id;
	Date date;
	Integer total;
	String remarks;
	String comments;
	List<OrderDetail> orderDetailList;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public Integer getTotal() {
		return total;
	}
	public void setTotal(Integer total) {
		this.total = total;
	}
	public List<OrderDetail> getOrderDetailList() {
		return orderDetailList;
	}
	public void setOrderDetailList(List<OrderDetail> orderDetailList) {
		this.orderDetailList = orderDetailList;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getComments() {
		return comments;
	}
	public void setComments(String comments) {
		this.comments = comments;
	}
	@SuppressWarnings("deprecation")
	@Override
	public String toString() {
		return "[orderId=" + id + ", date=" + date.toLocaleString() + ", total=" + total + "]";
	}
	
}

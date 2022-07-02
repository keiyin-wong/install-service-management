package com.keiyin.ism.model;

import java.util.Date;
import java.util.List;

import org.omg.CosNaming._BindingIteratorImplBase;



public class Order {
	String id;
	Date date;
	Integer total;
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
	
	@Override
	public String toString() {
		return "[orderId=" + id + ", date=" + date.toLocaleString() + ", total=" + total + "]";
	}
	
}

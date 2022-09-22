package com.keiyin.ism.model;


public class OrderDetail {
	String orderId;
	int lineNumber;
	int serviceId;
	String serviceName;
	String description;
	double width;
	double height;
	int quantity;
	int finalPrice;
	int totalPrice;
	int calculationType;
	
	
	public String getOrderId() {
		return orderId;
	}
	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}
	public int getLineNumber() {
		return lineNumber;
	}
	public void setLineNumber(int productLineNumber) {
		this.lineNumber = productLineNumber;
	}
	public int getServiceId() {
		return serviceId;
	}
	public void setServiceId(int serviceId) {
		this.serviceId = serviceId;
	}
	public double getWidth() {
		return width;
	}
	public void setWidth(double width) {
		this.width = width;
	}
	public double getHeight() {
		return height;
	}
	public void setHeight(double height) {
		this.height = height;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public int getFinalPrice() {
		return finalPrice;
	}
	public void setFinalPrice(int finalPrice) {
		this.finalPrice = finalPrice;
	}
	public String getServiceName() {
		return serviceName;
	}
	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public int getCalculationType() {
		return calculationType;
	}
	public void setCalculationType(int calculationType) {
		this.calculationType = calculationType;
	}
	public int getTotalPrice() {
		return totalPrice;
	}
	public void setTotalPrice(int totalPrice) {
		this.totalPrice = totalPrice;
	}
	
	@Override
	public String toString() {
		return "["
				+ "orderId=" + orderId + ", "
				+ "lineNumber=" + lineNumber + ", "
				+ "serviceName=" + serviceName + ", "
				+ "description=" + description + ", "
				+ "width=" + width + ", "
				+ "height=" + height + ", "
				+ "quantity=" + quantity + ", "
				+ "finalPrice=" + finalPrice + ", "
				+ "totalPrice=" + totalPrice + ", "
				+ "calculationType=" + calculationType
				+ "]";
	}
}

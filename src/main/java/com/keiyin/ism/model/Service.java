package com.keiyin.ism.model;

public class Service {
	int id;
	String descriptionEnglish;
	String descriptionChinese;
	boolean differentPrice;
	int price;
	boolean useQuantity;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getDescriptionEnglish() {
		return descriptionEnglish;
	}
	public void setDescriptionEnglish(String descriptionEnglish) {
		this.descriptionEnglish = descriptionEnglish;
	}
	public String getDescriptionChinese() {
		return descriptionChinese;
	}
	public void setDescriptionChinese(String descriptionChinese) {
		this.descriptionChinese = descriptionChinese;
	}
	public boolean isDifferentPrice() {
		return differentPrice;
	}
	public void setDifferentPrice(boolean differentPrice) {
		this.differentPrice = differentPrice;
	}
	public boolean isUseQuantity() {
		return useQuantity;
	}
	public void setUseQuantity(boolean useQuantity) {
		this.useQuantity = useQuantity;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
}

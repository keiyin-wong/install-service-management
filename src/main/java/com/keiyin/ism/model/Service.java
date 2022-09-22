package com.keiyin.ism.model;

public class Service {
	int id;
	String descriptionEnglish;
	String descriptionChinese;
	boolean differentPrice;
	int price;
	int calculationType;
	
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
	public int getCalculationType() {
		return calculationType;
	}
	public void setCalculationType(int calculationType) {
		this.calculationType = calculationType;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
}

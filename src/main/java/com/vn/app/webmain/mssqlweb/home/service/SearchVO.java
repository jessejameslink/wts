package com.vn.app.webmain.mssqlweb.home.service;

import java.io.Serializable;

public class SearchVO implements Serializable {

	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -6344183514047822089L;
	private String startDate;
	private String endDate;
	private String schMarket;
	private String page;
	private String lang;
	private String searchKey;
	private String schItem;
	
	
	
	
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getSchMarket() {
		return schMarket;
	}
	public void setSchMarket(String schMarket) {
		this.schMarket = schMarket;
	}
	public String getPage() {
		return page;
	}
	public void setPage(String page) {
		this.page = page;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
	public String getSearchKey() {
		return searchKey;
	}
	public void setSearchKey(String searchKey) {
		this.searchKey = searchKey;
	}
	public String getSchItem() {
		return schItem;
	}
	public void setSchItem(String schItem) {
		this.schItem = schItem;
	}
	
	
	
	
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
	
	
	
	
	
}

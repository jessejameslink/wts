package com.vn.app.webmain.oraweb.home.service;

import java.io.Serializable;

public class SearchVO implements Serializable {

	/**
	 *   
	 */
	private static final long serialVersionUID = 3307163894648235294L;
	private String startDate;
	private String endDate;
	private String page;
	private String lang;
	private String searchKey; //SinhNH add on 2016/11/1
	private String nType; //SinhNH add on 2016/11/15
	
	public String getPage() {
		return page;
	}
	public void setPage(String page) {
		this.page = page;
	}
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

	public String getType() {
		return nType;
	}
	public void setType(String nType) {
		this.nType = nType;
	}
}

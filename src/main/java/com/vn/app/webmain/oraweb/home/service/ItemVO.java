package com.vn.app.webmain.oraweb.home.service;

import java.io.Serializable;

public class ItemVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -4127737702509966946L;
	private String synm;
	private String marketId;
	private String snum;
	private String secNm_en;
	private String secNm_vn;
	private String ratio;
	
	public String getSynm() {
		return synm;
	}
	public void setSynm(String synm) {
		this.synm = synm;
	}
	public String getMarketId() {
		return marketId;
	}
	public void setMarketId(String marketId) {
		this.marketId = marketId;
	}
	public String getSnum() {
		return snum;
	}
	public void setSnum(String snum) {
		this.snum = snum;
	}
	public String getSecNm_en() {
		return secNm_en;
	}
	public void setSecNm_en(String secNm_en) {
		this.secNm_en = secNm_en;
	}
	public String getSecNm_vn() {
		return secNm_vn;
	}
	public void setSecNm_vn(String secNm_vn) {
		this.secNm_vn = secNm_vn;
	}
	public String getRatio() {
		return ratio;
	}
	public void setRatio(String ratio) {
		this.ratio = ratio;
	}
	
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
}
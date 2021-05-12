package com.vn.app.webmain.mssqlweb.home.service;

import java.io.Serializable;

public class InfoVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -7575225648272242810L;
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	private String symb;
	private String maketId;
	private String name;
	private String nameEN;
	private String mktcap;
	private String low52w;
	private String high52w;
	private String avg52w;
	private String fbuy;
	private String fowned;
	private String dividend;
	private String dividendyield;
	private String beta;
	
	private String eps;
	private String pe;
	private String fpe;
	private String bvps;
	private String pb;
	
	private String lstshare;
	private String shareoutstanding;
	
	
	public String getSymbol() {
		return symb;
	}
	public void setSymbol(String symb) {
		this.symb = symb;
	}
	
	public String getMarketId() {
		return maketId;
	}
	public void setMarketId(String maketId) {
		this.maketId = maketId;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public String getNameEN() {
		return nameEN;
	}
	public void setNameEN(String nameEN) {
		this.nameEN = nameEN;
	}
	
	public String getMktCap() {
		return mktcap;
	}
	public void setMktCap(String mktcap) {
		this.mktcap = mktcap;
	}
	
	public String getLow52w() {
		return low52w;
	}
	public void setLow52w(String low52w) {
		this.low52w = low52w;
	}
	
	public String getHigh52w() {
		return high52w;
	}
	public void setHigh52w(String high52w) {
		this.high52w = high52w;
	}
	
	public String getAvg52w() {
		return avg52w;
	}
	public void setAvg52w(String avg52w) {
		this.avg52w = avg52w;
	}
	
	public String getFBuy() {
		return fbuy;
	}
	public void setFBuy(String fbuy) {
		this.fbuy = fbuy;
	}
	
	public String getFOwned() {
		return fowned;
	}
	public void setFOwned(String fowned) {
		this.fowned = fowned;
	}
	
	public String getDividend() {
		return dividend;
	}
	public void setDividend(String dividend) {
		this.dividend = dividend;
	}
	
	public String getDividendYield() {
		return dividendyield;
	}
	public void setDividendYield(String dividendyield) {
		this.dividendyield = dividendyield;
	}
	
	public String getBeta() {
		return beta;
	}
	public void setBeta(String beta) {
		this.beta = beta;
	}
	
	public String getEPS() {
		return eps;
	}
	public void setEPS(String eps) {
		this.eps = eps;
	}
	
	public String getPE() {
		return pe;
	}
	public void setPE(String pe) {
		this.pe = pe;
	}
	
	public String getFPE() {
		return fpe;
	}
	public void setFPE(String fpe) {
		this.fpe = fpe;
	}
	
	public String getBVPS() {
		return bvps;
	}
	public void setBVPS(String bvps) {
		this.bvps = bvps;
	}
		
	public String getPB() {
		return pb;
	}
	public void setPB(String pb) {
		this.pb = pb;
	}
	
	public String getListShare() {
		return lstshare;
	}
	public void setListShare(String lstshare) {
		this.lstshare = lstshare;
	}
	
	public String getShareOutstanding() {
		return shareoutstanding;
	}
	public void setShareOutstanding(String shareoutstanding) {
		this.shareoutstanding = shareoutstanding;
	}
	
}

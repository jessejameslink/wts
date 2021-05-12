package com.vn.app.webmain.oraweb.home.service;

import java.io.Serializable;

public class LinkVO implements Serializable {

	private static final long serialVersionUID = -8385128915082207010L;
	
	private String id;
	private String data;
	private String filename;
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	//id, data
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	
	public String getData() {
		return data;
	}
	public void setData(String data) {
		this.data = data;
	}
	
	public String getFileName() {
		return filename;
	}
	public void setFileName(String filename) {
		this.filename = filename;
	}
}

package com.vn.app.webmain.oraweb.home.service;

import java.io.Serializable;

public class InvestorVO implements Serializable {

	private static final long serialVersionUID = -8385128915082207010L;
	
	private String id;
	private String data;
	private String title;
	private String filename;
	private String type;
	private String docsize;
	private String created;
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	public String getCreated() {
		return created;
	}
	public void setCreated(String created) {
		this.created = created;
	}
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	
	public String getFileName() {
		return filename;
	}
	public void setFileName(String filename) {
		this.filename = filename;
	}
	
	public String getDocSize() {
		return docsize;
	}
	public void setDocSize(String docsize) {
		this.docsize = docsize;
	}
	
	//id, data, title
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
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
}

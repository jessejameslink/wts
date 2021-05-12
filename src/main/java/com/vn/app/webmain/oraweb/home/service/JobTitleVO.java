package com.vn.app.webmain.oraweb.home.service;

import java.io.Serializable;

public class JobTitleVO implements Serializable {

	private static final long serialVersionUID = -8385128915082207010L;
	
	private String id;
	private String data;
	private String title;
	private String created;
	private String location;
	private String lastdate;
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	public String getCreated() {
		return created;
	}
	public void setCreated(String created) {
		this.created = created;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	
	public String getLastDate() {
		return lastdate;
	}
	public void setLastDate(String lastdate) {
		this.lastdate = lastdate;
	}
	
	//id, data, title
	public String getId() {
		return id;
	}
	public String getData() {
		return data;
	}
	
	public String getTitle() {
		return title;
	}
	public void setId(String id) {
		this.id = id;
	}
	public void setData(String data) {
		this.data = data;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}
}

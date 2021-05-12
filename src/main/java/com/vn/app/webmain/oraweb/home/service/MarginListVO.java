package com.vn.app.webmain.oraweb.home.service;

import java.io.Serializable;

public class MarginListVO implements Serializable {

	private static final long serialVersionUID = -8385128915082207010L;
	
	private String id;
	private String data;
	private String name;
	private String title;
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
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
}

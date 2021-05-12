package com.vn.app.webmain.oraweb.home.service;

import java.io.Serializable;

public class ResearchVO implements Serializable {

	private static final long serialVersionUID = -8385128915082207010L;
	
	private String id;
	private String data;
	private String code;
	private String name;
	private String created;
	public String getCreated() {
		return created;
	}
	public void setCreated(String created) {
		this.created = created;
	}
	public String getModified() {
		return modified;
	}
	public void setModified(String modified) {
		this.modified = modified;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	private String modified;
	
	//id, data, code, name
	public String getId() {
		return id;
	}
	public String getData() {
		return data;
	}
	public String getCode() {
		return code;
	}
	public String getName() {
		return name;
	}
	public void setId(String id) {
		this.id = id;
	}
	public void setData(String data) {
		this.data = data;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public void setName(String name) {
		this.name = name;
	}
}

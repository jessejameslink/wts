package com.vn.app.webmain.oranews.home.service;

import java.io.Serializable;

public class HomeVO2 implements Serializable {

	private static final long serialVersionUID = 2852002717027209273L;
	
	private String timeStr;
	
	@Override
	public String toString() {
		return "HomeVO2 [timeStr=" + timeStr + "]";
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((timeStr == null) ? 0 : timeStr.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		HomeVO2 other = (HomeVO2) obj;
		if (timeStr == null) {
			if (other.timeStr != null)
				return false;
		} else if (!timeStr.equals(other.timeStr))
			return false;
		return true;
	}

	public String getTimeStr() {
		return timeStr;
	}

	public void setTimeStr(String timeStr) {
		this.timeStr = timeStr;
	}	
}

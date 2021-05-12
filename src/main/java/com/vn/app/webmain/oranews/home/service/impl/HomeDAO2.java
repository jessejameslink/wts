package com.vn.app.webmain.oranews.home.service.impl;

import java.util.List;

import com.vn.app.webmain.oranews.home.service.HomeVO2;
import com.vn.app.webmain.oranews.home.service.TablesVO;

public interface HomeDAO2 {

	public HomeVO2 getDBTime2();
	
	public List<TablesVO> getTables();
}

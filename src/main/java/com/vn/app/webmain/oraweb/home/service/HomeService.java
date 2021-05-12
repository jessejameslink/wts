package com.vn.app.webmain.oraweb.home.service;

import java.util.List;

import com.vn.app.webmain.oraweb.home.service.TablesVO;

public interface HomeService {
	
	public HomeVO getDBTime();
	
	public List<TablesVO> getTables();
}

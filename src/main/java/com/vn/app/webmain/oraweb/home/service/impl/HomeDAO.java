package com.vn.app.webmain.oraweb.home.service.impl;

import java.util.List;

import com.vn.app.webmain.oraweb.home.service.TablesVO;
import com.vn.app.webmain.oraweb.home.service.HomeVO;

public interface HomeDAO {

	public HomeVO getDBTime();
	
	public List<TablesVO> getTables();
}

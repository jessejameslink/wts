package com.vn.app.webmain.oranews.home.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.vn.app.webmain.oranews.home.service.HomeService2;
import com.vn.app.webmain.oranews.home.service.HomeVO2;
import com.vn.app.webmain.oranews.home.service.TablesVO;

@Service("homeServiceImpl2")
public class HomeServiceImpl2 implements HomeService2 {

	//@Autowired
	@Inject
	private HomeDAO2 dao;
	
	@Override
	public HomeVO2 getDBTime2() {		
		return dao.getDBTime2();
	}

	@Override
	public List<TablesVO> getTables() {
		return dao.getTables();
	}
}

package com.vn.app.webmain.oraweb.home.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.vn.app.webmain.oraweb.home.service.TablesVO;
import com.vn.app.webmain.oraweb.home.service.HomeService;
import com.vn.app.webmain.oraweb.home.service.HomeVO;

@Service("homeServiceImpl")
public class HomeServiceImpl implements HomeService {

	//@Autowired
	@Inject
	private HomeDAO dao;
	
	@Override
	public HomeVO getDBTime() {		
		return dao.getDBTime();
	}

	@Override
	public List<TablesVO> getTables() {
		return dao.getTables();
	}
}

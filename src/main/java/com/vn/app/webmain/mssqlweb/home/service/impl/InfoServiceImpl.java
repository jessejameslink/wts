package com.vn.app.webmain.mssqlweb.home.service.impl;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.vn.app.webmain.mssqlweb.home.service.InfoService;
import com.vn.app.webmain.mssqlweb.home.service.InfoVO;
import com.vn.app.webmain.mssqlweb.home.service.SearchVO;

@Service("infoServiceImpl")
public class InfoServiceImpl implements InfoService {

	@Inject
	private InfoDAO InfoDAO;
	
	@Override
	public InfoVO	getInfo(SearchVO sch) {
		return InfoDAO.getInfo(sch);
	}
	
	
}

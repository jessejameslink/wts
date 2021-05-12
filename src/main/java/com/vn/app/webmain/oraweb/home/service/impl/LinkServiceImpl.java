package com.vn.app.webmain.oraweb.home.service.impl;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.vn.app.webmain.oraweb.home.service.LinkService;
import com.vn.app.webmain.oraweb.home.service.LinkVO;

@Service("linkServiceImpl")
public class LinkServiceImpl implements LinkService {

	//@Autowired
	@Inject
	private LinkDAO dao;
	
	@Override
	public LinkVO getLinkDetail(String ids) {		
		return dao.getLinkDetail(ids);
	}
	
}

package com.vn.app.webmain.oraweb.home.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.vn.app.webmain.oraweb.home.service.MarginListService;
import com.vn.app.webmain.oraweb.home.service.MarginListVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

@Service("marginListServiceImpl")
public class MarginListServiceImpl implements MarginListService {

	//@Autowired
	@Inject
	private MarginListDAO dao;
	
	@Override
	public MarginListVO getMarginListData(String ids) {		
		return dao.getMarginListData(ids);
	}
	
	public List<MarginListVO> getMarginList(SearchVO sch) {
		return dao.getMarginList(sch);
	}
	
	public List<MarginListVO> getMarginListCnt(SearchVO sch) {
		return dao.getMarginListCnt(sch);
	}
	
}

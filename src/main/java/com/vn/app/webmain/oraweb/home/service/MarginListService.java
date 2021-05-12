package com.vn.app.webmain.oraweb.home.service;

import java.util.List;

public interface MarginListService {
	
	public MarginListVO getMarginListData(String ids);
	public List<MarginListVO> getMarginList(SearchVO sch);
	public List<MarginListVO> getMarginListCnt(SearchVO sch);
	
}

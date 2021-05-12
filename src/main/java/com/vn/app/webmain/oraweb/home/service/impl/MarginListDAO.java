package com.vn.app.webmain.oraweb.home.service.impl;

import java.util.List;

import com.vn.app.webmain.oraweb.home.service.MarginListVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

public interface MarginListDAO {

	public MarginListVO getMarginListData(String ids);
	public List<MarginListVO> getMarginList(SearchVO sch);
	public List<MarginListVO> getMarginListCnt(SearchVO sch);
	
}

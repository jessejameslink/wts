package com.vn.app.webmain.oraweb.home.service.impl;

import java.util.List;

import com.vn.app.webmain.oraweb.home.service.FundInfoVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

public interface FundInfoDAO {
	
	public FundInfoVO getFundInfoDetail(String ids);
	public List<FundInfoVO> getAllFundInfo(SearchVO sch);
	public List<FundInfoVO> getFundInfoCnt(SearchVO sch);
}

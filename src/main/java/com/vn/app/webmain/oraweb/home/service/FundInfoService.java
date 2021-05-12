package com.vn.app.webmain.oraweb.home.service;

import java.util.List;

public interface FundInfoService {
	public FundInfoVO getFundInfoDetail(String ids);
	public List<FundInfoVO> getAllFundInfo(SearchVO sch);
	public List<FundInfoVO> getFundInfoCnt(SearchVO sch);
}

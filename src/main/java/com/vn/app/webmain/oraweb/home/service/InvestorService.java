package com.vn.app.webmain.oraweb.home.service;

import java.util.List;

public interface InvestorService {
	public InvestorVO getInvestorDetail(String ids);
	public List<InvestorVO> getAllInvestor(SearchVO sch);
	public List<InvestorVO> getInvestorCnt(SearchVO sch);
}

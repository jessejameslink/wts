package com.vn.app.webmain.oraweb.home.service.impl;

import java.util.List;

import com.vn.app.webmain.oraweb.home.service.InvestorVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

public interface InvestorDAO {
	
	public InvestorVO getInvestorDetail(String ids);
	public List<InvestorVO> getAllInvestor(SearchVO sch);
	public List<InvestorVO> getInvestorCnt(SearchVO sch);
}

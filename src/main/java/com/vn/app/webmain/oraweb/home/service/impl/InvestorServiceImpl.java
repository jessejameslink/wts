package com.vn.app.webmain.oraweb.home.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.vn.app.webmain.oraweb.home.service.InvestorService;
import com.vn.app.webmain.oraweb.home.service.InvestorVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

@Service("investorServiceImpl")
public class InvestorServiceImpl implements InvestorService {

	//@Autowired
	@Inject
	private InvestorDAO dao;
	
	@Override
	public InvestorVO getInvestorDetail(String ids) {		
		return dao.getInvestorDetail(ids);
	}
	
	public List<InvestorVO> getAllInvestor(SearchVO sch) {
		return dao.getAllInvestor(sch);
	}
	
	public List<InvestorVO> getInvestorCnt(SearchVO sch) {
		return dao.getInvestorCnt(sch);
	}
}

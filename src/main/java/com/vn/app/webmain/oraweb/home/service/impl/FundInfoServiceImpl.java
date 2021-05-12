package com.vn.app.webmain.oraweb.home.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.vn.app.webmain.oraweb.home.service.FundInfoService;
import com.vn.app.webmain.oraweb.home.service.FundInfoVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

@Service("fundInfoServiceImpl")
public class FundInfoServiceImpl implements FundInfoService {

	//@Autowired
	@Inject
	private FundInfoDAO dao;
	
	@Override
	public FundInfoVO getFundInfoDetail(String ids) {		
		return dao.getFundInfoDetail(ids);
	}
	
	public List<FundInfoVO> getAllFundInfo(SearchVO sch) {
		return dao.getAllFundInfo(sch);
	}
	
	public List<FundInfoVO> getFundInfoCnt(SearchVO sch) {
		return dao.getFundInfoCnt(sch);
	}
}

package com.vn.app.webmain.oraweb.home.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.vn.app.webmain.oraweb.home.service.ResearchService;
import com.vn.app.webmain.oraweb.home.service.ResearchVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

@Service("researchServiceImpl")
public class ResearchServiceImpl implements ResearchService {

	//@Autowired
	@Inject
	private ResearchDAO dao;
	
	@Override
	public ResearchVO getResearchData(String ids) {		
		return dao.getResearchData(ids);
	}
	
	public List<ResearchVO> getResearchList(SearchVO sch) {
		return dao.getResearchList(sch);
	}
	
	public List<ResearchVO> getResearchTopList(SearchVO sch) {
		return dao.getResearchTopList(sch);
	}
	
	
	public List<ResearchVO> getResearchCnt(SearchVO sch) {
		return dao.getResearchCnt(sch);
	}
	
}

package com.vn.app.webmain.oraweb.home.service;

import java.util.List;

public interface ResearchService {
	
	public ResearchVO getResearchData(String ids);
	public List<ResearchVO> getResearchList(SearchVO sch);
	public List<ResearchVO> getResearchTopList(SearchVO sch);
	public List<ResearchVO> getResearchCnt(SearchVO sch);
	
}

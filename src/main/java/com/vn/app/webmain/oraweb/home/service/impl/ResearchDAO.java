package com.vn.app.webmain.oraweb.home.service.impl;

import java.util.List;

import com.vn.app.webmain.oraweb.home.service.ResearchVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

public interface ResearchDAO {

	public ResearchVO getResearchData(String ids);
	public List<ResearchVO> getResearchList(SearchVO sch);
	public List<ResearchVO> getResearchTopList(SearchVO sch);
	public List<ResearchVO> getResearchCnt(SearchVO sch);
	
}

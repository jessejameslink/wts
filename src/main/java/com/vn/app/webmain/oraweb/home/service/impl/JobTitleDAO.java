package com.vn.app.webmain.oraweb.home.service.impl;

import java.util.List;

import com.vn.app.webmain.oraweb.home.service.JobTitleVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

public interface JobTitleDAO {
	
	public JobTitleVO getJobTitleDetail(String ids);
	public List<JobTitleVO> getJobTitle(SearchVO sch);
	public List<JobTitleVO> getAllJobTitle(SearchVO sch);
	public List<JobTitleVO> getJobTitleCnt(SearchVO sch);
	
}

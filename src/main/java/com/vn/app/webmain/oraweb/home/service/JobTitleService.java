package com.vn.app.webmain.oraweb.home.service;

import java.util.List;

public interface JobTitleService {
	public JobTitleVO getJobTitleDetail(String ids);
	public List<JobTitleVO> getJobTitle(SearchVO sch);
	public List<JobTitleVO> getAllJobTitle(SearchVO sch);
	public List<JobTitleVO> getJobTitleCnt(SearchVO sch);
	
}

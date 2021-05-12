package com.vn.app.webmain.oraweb.home.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.vn.app.webmain.oraweb.home.service.JobTitleService;
import com.vn.app.webmain.oraweb.home.service.JobTitleVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

@Service("jobTitleServiceImpl")
public class JobTitleServiceImpl implements JobTitleService {

	//@Autowired
	@Inject
	private JobTitleDAO dao;
	
	@Override
	public JobTitleVO getJobTitleDetail(String ids) {		
		return dao.getJobTitleDetail(ids);
	}
	
	public List<JobTitleVO> getJobTitle(SearchVO sch) {
		return dao.getJobTitle(sch);
	}
	
	public List<JobTitleVO> getAllJobTitle(SearchVO sch) {
		return dao.getAllJobTitle(sch);
	}
	
	public List<JobTitleVO> getJobTitleCnt(SearchVO sch) {
		return dao.getJobTitleCnt(sch);
	}
}

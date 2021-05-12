package com.vn.app.webmain.oraweb.home.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.vn.app.webmain.oraweb.home.service.MiraeAssetNewsService;
import com.vn.app.webmain.oraweb.home.service.MiraeAssetNewsVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

@Service("miraeAssetNewsServiceImpl")
public class MiraeAssetNewsServiceImpl implements MiraeAssetNewsService {

	//@Autowired
	@Inject
	private MiraeAssetNewsDAO dao;
	
	@Override
	public MiraeAssetNewsVO getMiraeAssetNewsDetail(String ids) {		
		return dao.getMiraeAssetNewsDetail(ids);
	}
	
	public MiraeAssetNewsVO getQuestionsDetail(String ids) {		
		return dao.getQuestionsDetail(ids);
	}
	
	public MiraeAssetNewsVO getInvestmentEduDetail(String ids) {		
		return dao.getInvestmentEduDetail(ids);
	}
	
	public List<MiraeAssetNewsVO> getMiraeAssetNews(SearchVO sch) {
		return dao.getMiraeAssetNews(sch);
	}
	
	public List<MiraeAssetNewsVO> getAllMiraeAssetNews(SearchVO sch) {
		return dao.getAllMiraeAssetNews(sch);
	}
	
	public List<MiraeAssetNewsVO> getMiraeAssetNewsCnt(SearchVO sch) {
		return dao.getMiraeAssetNewsCnt(sch);
	}
	
	public List<MiraeAssetNewsVO> getAllQuestions(SearchVO sch) {
		return dao.getAllQuestions(sch);
	}
	
	public List<MiraeAssetNewsVO> getQuestionsCnt(SearchVO sch) {
		return dao.getQuestionsCnt(sch);
	}
	
	public List<MiraeAssetNewsVO> getAllInvestmentEdu(SearchVO sch) {
		return dao.getAllInvestmentEdu(sch);
	}
	
	public List<MiraeAssetNewsVO> getInvestmentEduCnt(SearchVO sch) {
		return dao.getInvestmentEduCnt(sch);
	}
}

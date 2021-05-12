package com.vn.app.webmain.oraweb.home.service.impl;

import java.util.List;

import com.vn.app.webmain.oraweb.home.service.MiraeAssetNewsVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

public interface MiraeAssetNewsDAO {
	
	public MiraeAssetNewsVO getMiraeAssetNewsDetail(String ids);
	public MiraeAssetNewsVO getQuestionsDetail(String ids);
	public MiraeAssetNewsVO getInvestmentEduDetail(String ids);
	public List<MiraeAssetNewsVO> getMiraeAssetNews(SearchVO sch);
	public List<MiraeAssetNewsVO> getAllMiraeAssetNews(SearchVO sch);
	public List<MiraeAssetNewsVO> getMiraeAssetNewsCnt(SearchVO sch);
	public List<MiraeAssetNewsVO> getAllQuestions(SearchVO sch);
	public List<MiraeAssetNewsVO> getQuestionsCnt(SearchVO sch);
	public List<MiraeAssetNewsVO> getAllInvestmentEdu(SearchVO sch);
	public List<MiraeAssetNewsVO> getInvestmentEduCnt(SearchVO sch);
	
}

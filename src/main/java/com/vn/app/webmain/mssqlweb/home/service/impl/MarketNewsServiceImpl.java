package com.vn.app.webmain.mssqlweb.home.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.vn.app.webmain.mssqlweb.home.service.MarketNewsService;
import com.vn.app.webmain.mssqlweb.home.service.MarketNewsVO;
import com.vn.app.webmain.mssqlweb.home.service.SearchVO;

@Service("marketNewsServiceImpl")
public class MarketNewsServiceImpl implements MarketNewsService {

	@Inject
	private MarketNewsDAO marketNewsDAO;
	
	@Override
	public List<MarketNewsVO> getMarketNewsList(SearchVO sch) {
		return marketNewsDAO.getMarketNewsList(sch);
	}
	
	@Override
	public Integer getMarketNewsListCnt(SearchVO sch) {
		return marketNewsDAO.getMarketNewsListCnt(sch);
	}
	
	@Override
	public List<MarketNewsVO> getMarketNewsTop3List(SearchVO sch) {
		return marketNewsDAO.getMarketNewsTop3List(sch);
	}
	
	@Override
	public MarketNewsVO	getMarketNews(SearchVO sch) {
		return marketNewsDAO.getMarketNews(sch);
	}
	
	
}

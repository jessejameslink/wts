package com.vn.app.webmain.mssqlweb.home.service;

import java.util.List;

public interface MarketNewsService {

	public List<MarketNewsVO> getMarketNewsList(SearchVO sch);
	public Integer getMarketNewsListCnt(SearchVO sch);
	public List<MarketNewsVO> getMarketNewsTop3List(SearchVO sch);
	public MarketNewsVO	getMarketNews(SearchVO sch);
}

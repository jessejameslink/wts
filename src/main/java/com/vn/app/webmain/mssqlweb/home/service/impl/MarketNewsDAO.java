package com.vn.app.webmain.mssqlweb.home.service.impl;

import java.util.List;

import com.vn.app.webmain.mssqlweb.home.service.MarketNewsVO;
import com.vn.app.webmain.mssqlweb.home.service.SearchVO;

public interface MarketNewsDAO {

	public List<MarketNewsVO> getMarketNewsList(SearchVO sch);
	public Integer getMarketNewsListCnt(SearchVO sch);
	public List<MarketNewsVO> getMarketNewsTop3List(SearchVO sch);
	public MarketNewsVO	getMarketNews(SearchVO sch);
}

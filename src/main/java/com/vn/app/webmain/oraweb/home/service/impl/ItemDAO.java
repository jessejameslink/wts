package com.vn.app.webmain.oraweb.home.service.impl;

import java.util.List;

import com.vn.app.webmain.oraweb.home.service.ItemVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

public interface ItemDAO {
	public List<ItemVO> getItemAllList();
	public List<ItemVO> getItemList(SearchVO sch);
}

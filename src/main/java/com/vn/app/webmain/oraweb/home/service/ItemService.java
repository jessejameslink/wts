package com.vn.app.webmain.oraweb.home.service;

import java.util.List;

public interface ItemService {
	public List<ItemVO> getItemAllList();
	public List<ItemVO> getItemList(SearchVO sch);
}

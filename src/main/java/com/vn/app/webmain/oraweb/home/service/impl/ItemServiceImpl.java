package com.vn.app.webmain.oraweb.home.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.vn.app.webmain.oraweb.home.service.ItemService;
import com.vn.app.webmain.oraweb.home.service.ItemVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

@Service("itemServiceImpl")
public class ItemServiceImpl implements ItemService {

	//@Autowired
	@Inject
	private ItemDAO dao;
	
	public List<ItemVO> getItemAllList() {
		return dao.getItemAllList();
	}
	
	public List<ItemVO> getItemList(SearchVO sch) {
		return dao.getItemList(sch);
	}
}

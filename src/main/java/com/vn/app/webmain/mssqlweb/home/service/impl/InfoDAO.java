package com.vn.app.webmain.mssqlweb.home.service.impl;

import com.vn.app.webmain.mssqlweb.home.service.InfoVO;
import com.vn.app.webmain.mssqlweb.home.service.SearchVO;

public interface InfoDAO {
	public InfoVO	getInfo(SearchVO sch);
}

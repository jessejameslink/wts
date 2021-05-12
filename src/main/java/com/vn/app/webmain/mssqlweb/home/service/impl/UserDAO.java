package com.vn.app.webmain.mssqlweb.home.service.impl;

import java.util.List;

import com.vn.app.webmain.mssqlweb.home.service.UserVO;

public interface UserDAO {

	public List<UserVO> getUsers();
}

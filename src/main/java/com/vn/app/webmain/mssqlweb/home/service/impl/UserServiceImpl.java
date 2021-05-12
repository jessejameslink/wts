package com.vn.app.webmain.mssqlweb.home.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.vn.app.webmain.mssqlweb.home.service.UserService;
import com.vn.app.webmain.mssqlweb.home.service.UserVO;

@Service("userServiceImpl")
public class UserServiceImpl implements UserService {

	@Inject
	private UserDAO userDAO;
	
	@Override
	public List<UserVO> getUsers() {
		
		return userDAO.getUsers();
	}
}

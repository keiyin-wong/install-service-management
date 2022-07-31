package com.keiyin.ism.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.keiyin.ism.constant.ViewConstants;

@Controller
@RequestMapping(value = "/login")
public class LoginController {

	@RequestMapping(value = "/login.html", method = RequestMethod.GET)
	public ModelAndView renderOrderPage(@RequestParam(required = false) String error) {
		 return new ModelAndView(ViewConstants.LOGIN);
	}
	
	/*
	 * @RequestMapping(value = "/logout", method = RequestMethod.GET) public
	 * ModelAndView logout(HttpServletRequest request, HttpServletResponse response)
	 * { Authentication auth =
	 * SecurityContextHolder.getContext().getAuthentication(); if (auth != null){
	 * new SecurityContextLogoutHandler().logout(request, response, auth); } return
	 * new ModelAndView(ViewConstants.LOGIN); }
	 */
}

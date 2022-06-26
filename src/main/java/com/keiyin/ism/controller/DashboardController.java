package com.keiyin.ism.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.keiyin.ism.constant.ViewConstants;


@Controller
@RequestMapping(value = "/dashboard")
public class DashboardController {
	
	@RequestMapping(value = "/dashboard.html", method = RequestMethod.GET)
	public ModelAndView renderServicePage() {
		 return new ModelAndView(ViewConstants.DASHBOARD_VIEW);
	}
}

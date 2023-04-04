package com.JPATest.controller;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JPATest.service.WebService;

import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
@RequestMapping(value = "/views")
public class WebController {

	@Autowired
	WebService webService;
	
	private final static Logger logger = LoggerFactory.getLogger("");
    
    @GetMapping("/lottoIndex")
    public String lottoIndex(){
    	logger.info("###### START [WebController :: /views/lottoIndex] ######");
    	
    	logger.info("###### END [WebController :: /views/lottoIndex] ######");
    	return "lottoIndex";
    }
    
    @ResponseBody
    @GetMapping("/exptdLottoNoSel")
    public Map<String, String> exptdLottoNoSel(){
    	logger.info("###### START [WebController :: /views/exptdLottoNoSel] ######");
    	
    	Map<String, String> rstMap = webService.exptdLottoNoSel();

    	logger.info("###### END [WebController :: /views/exptdLottoNoSel] ######");
    	return rstMap;
    }
}
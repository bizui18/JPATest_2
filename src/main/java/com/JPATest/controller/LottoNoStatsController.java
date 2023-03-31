package com.JPATest.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JPATest.service.LottoNoStatsService;


@Controller
@EnableAutoConfiguration
@RequestMapping(value = "/views")
public class LottoNoStatsController {
	
	@Autowired
	LottoNoStatsService lottoNoStatsService;
	
	private final static Logger logger = LoggerFactory.getLogger("");

	@RequestMapping("/lottoNoStats")
	public String lottoNoStats() throws Exception {
		logger.info("###### START [LottoNoStatsController :: /views/lottoNoStats] ######");
		
		logger.info("###### END [LottoNoStatsController :: /views/lottoNoStats] ######");
		return "lottoNoStatsBoard";
	}
	
	@ResponseBody
	@RequestMapping("/lottoNoStatsSel")
	public List<Map<String, Object>> lottoNoStatsSel(String schStartDrwNo, String schEndDrwNo) throws Exception {
		logger.info("###### START [LottoNoStatsController :: /views/lottoNoStatsSel] ######");

		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("schStartDrwNo", schStartDrwNo);
		reqMap.put("schEndDrwNo", schEndDrwNo);
		System.out.println("###### reqMap = " + reqMap);
		
		List<Map<String, Object>> jpaRstList = lottoNoStatsService.lottoNoStatsSel(reqMap);
	    
		logger.info("###### END [LottoNoStatsController :: /views/lottoNoStatsSel] ######");
		return jpaRstList;
	}
	
}

package com.JPATest.controller;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.JPATest.service.StatsChartService;

@Configuration
@Controller
@EnableAutoConfiguration
@RequestMapping(value = "/views")
public class StatsChartBoardController implements WebMvcConfigurer {

	@Autowired
	StatsChartService service;
	
	private final static Logger logger = LoggerFactory.getLogger("");
	
	@RequestMapping("/statsChartBoard")
	public String apiSendTestBoard() throws Exception {
		logger.info("###### START [StatsChartBoardController :: /views/statsChartBoard] ######");

		logger.info("###### END [StatsChartBoardController :: /views/statsChartBoard] ######");
		return "statsChartBoard";
	}
	
	@ResponseBody
	@RequestMapping("/redisFileRead")
	public String redisFileRead(String schLogFilePath) throws Exception {
		logger.info("###### START [StatsChartBoardController :: /views/redisFileRead] ######");

		service.redisFileRead(schLogFilePath);
		
		logger.info("###### END [StatsChartBoardController :: /views/redisFileRead] ######");
		return "적용";
	}
	
	@ResponseBody
	@RequestMapping("/redisReadStactics")
	public List<Map<String, String>> redisReadStactics(String text) throws Exception {
		logger.info("###### START [StatsChartBoardController :: /views/redisReadStactics] ######");
		
		List<Map<String, String>> rstMap = service.redisReadStactics(text);
		logger.info("rstMap : " + rstMap.toString());
		
		logger.info("###### END [StatsChartBoardController :: /views/redisReadStactics] ######");
		return rstMap;
	}
}

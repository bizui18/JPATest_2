package com.JPATest.controller;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.JPATest.util.util;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Configuration
@Controller
@EnableAutoConfiguration
@RequestMapping(value = "/views")
public class APICompareBoardController implements WebMvcConfigurer {

	private final static Logger logger = LoggerFactory.getLogger("");
	
	@RequestMapping("/compareBoard")
	public String compareBoard() throws Exception {
		logger.info("###### START [APITestBoardController :: /views/compareBoard] ######");
		logger.info("###### END [APITestBoardController :: /views/compareBoard] ######");
		return "compareBoard";
	}
	
	@ResponseBody
	@PostMapping("/sendJsonData")
	public String sendJsonData(String data1, String data2) throws Exception {
		logger.info("###### START [APITestBoardController :: /views/sendJsonData] ######");
		
		if(data1.isEmpty() || data2.isEmpty())return "비교 대상이 비어있습니다.";
	    
		ObjectMapper mapper = new ObjectMapper();
	    TypeReference<Map<String, Object>> typeReference = new TypeReference<Map<String,Object>>() {};
	    
	    Map<String, Object> map1 = mapper.readValue(data1, typeReference);
	    Map<String, Object> map2 = mapper.readValue(data2, typeReference);
	    
	    Map<String, Object> resultMap = compare(map1, map2);
	    
	    String reuslt = mapper.writeValueAsString(resultMap);
	    
		logger.info("###### END [APITestBoardController :: /views/sendJsonData] ######");
		return reuslt;
	}

	@ResponseBody
	@PostMapping("/sendMapData")
	public String sendMapData(String data1, String data2) throws Exception {
		logger.info("###### START [APITestBoardController :: /views/sendMapData] ######");
		
		if(data1.isEmpty() || data2.isEmpty())return "비교 대상이 비어있습니다.";
		
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> map1 = util.convertMap(data1);
		Map<String, Object> map2 = util.convertMap(data2);
		
		Map<String, Object> resultMap = compare(map1, map2);
		
		String reuslt = mapper.writeValueAsString(resultMap);
		
		logger.info("###### END [APITestBoardController :: /views/sendMapData] ######");
		return reuslt;
	}
	
	public static Map<String, Object> compare(Map<String, Object> map1, Map<String, Object> map2) {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();

		if(map1.isEmpty() || map2.isEmpty()) return null;
		
		for(Map.Entry<String, Object> entry1 : map1.entrySet()){
			String key1 = entry1.getKey();
		
			if(!entry1.getValue().equals(map2.get(key1))) {
				Map<String, Object> data = new HashMap<String, Object>();
				data.put("data1", map1.get(key1));
				data.put("data2", map2.get(key1));
				resultMap.put(key1, data);
			}
		}

		for(Map.Entry<String, Object> entry2 : map2.entrySet()){
			String key2 = entry2.getKey();
			
			if(!entry2.getValue().equals(map1.get(key2))) {
				Map<String, Object> data = new HashMap<String, Object>();
				data.put("data1", map1.get(key2));
				data.put("data2", map2.get(key2));
				resultMap.put(key2, data);
			}
		}
		return resultMap;
	}
}

package com.JPATest.util;

import java.util.HashMap;
import java.util.Map;

public class util {
	
	public static Map<String, Object> convertMap(String s) {
		
		if(s.isEmpty())return null;
		
		String keyValuePairs = s.replaceAll("[{}\\s]", "");
		String[] pairs = keyValuePairs.split(",");
		
		Map<String, Object> map = new HashMap<>();
		
		for (String pair : pairs) {
		    String[] keyValue = pair.split("=");
		    if (keyValue.length == 2) {
		    	map.put(keyValue[0], keyValue[1]);
		    }
		}
		return map;
	}

}

package com.JPATest.util;

import org.apache.commons.collections.map.ListOrderedMap;

public class CamelMap extends ListOrderedMap {
	
	private static final long serialVersionUID = -751287613255786065L;
	
	private String toCamelCase(String s) {
		if ((s.indexOf(95) < 0) && (Character.isLowerCase(s.charAt(0)))) {
			return s;
		}
		StringBuilder result = new StringBuilder();
		boolean nextUpper = false;
		int len = s.length();

		for (int i = 0; i < len; i++) {
			char currentChar = s.charAt(i);
			if (currentChar == '_') {
				nextUpper = true;
			} else if (nextUpper) {
				result.append(Character.toUpperCase(currentChar));
				nextUpper = false;
			} else {
				result.append(Character.toLowerCase(currentChar));
			}
		}

		return result.toString();
	}

	@Override
	public Object put(Object key, Object value) {
		return super.put(toCamelCase((String) key), value.toString());
	}

	public static void main(String[] args) {

		CamelMap a = new CamelMap();
		a.put("test_key", 1);
		a.put("testKey2", 1);
		a.put("toCamel", 1);
		System.out.println(a);
	}
}

package com.JPATest.service;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Map.Entry;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.connection.stream.Consumer;
import org.springframework.data.redis.connection.stream.MapRecord;
import org.springframework.data.redis.connection.stream.ReadOffset;
import org.springframework.data.redis.connection.stream.RecordId;
import org.springframework.data.redis.connection.stream.StreamOffset;
import org.springframework.data.redis.connection.stream.StreamReadOptions;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class StatsChartService {

	@Autowired
	RedisTemplate<String, String> redisTemplate;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	public void redisFileRead(String param) throws IOException {
		logger.info("###### START [StatsChartService :: redisFileRead] ######");

		String path = param;
		BufferedReader br = new BufferedReader(new FileReader(path));
		String str = "";
		int cnt = 0;
		boolean brk = false;

		Map<String, Object> dataMap = new HashMap<>();
		while((str = br.readLine()) != null) {
			if(cnt == 2) {
				cnt = 0;
				brk = false;
				dataMap = convertStringToMap(str.replaceAll("## Input data : ", ""));
				Map<String, Object> redisMap = new HashMap<>();
				
				redisMap.put("brthdy", dataMap.get("brthdy").toString().substring(0,2));
				redisMap.put("drvLcnsNo", dataMap.get("drvLcnsNo").toString().substring(0, 2));
				redisMap.put("trmnlModelNm", dataMap.get("trmnlModelNm"));
				redisMap.put("telecomCode", dataMap.get("telecomCode"));
				
				redisTemplate.opsForStream().add("strm",redisMap);
			}else {
				if(brk) {
					cnt ++;
				}else {
					if(str.equals("## [Step-1] MLIFInterceptor preHandle call_URI : /api/mobilelcnse/mlif/manage/reqMobileDrvLcnseTruflsCnfirm")) {
						brk = true;
					}
				}
			}
		}
		br.close();
		
		redisStactics(param);
		
		logger.info("###### END [StatsChartService :: redisFileRead] ######");
	}
	
	public void redisStactics(String param) throws IOException {
		logger.info("###### START [StatsChartService :: redisStactics] ######");
		
		String stream = "strm";
		String group = "grp";
		String consumer = "con1";

		List<MapRecord<String, Object, Object>> re = redisTemplate.opsForStream().read(Consumer.from(group, consumer),
				StreamReadOptions.empty(), StreamOffset.create(stream, ReadOffset.lastConsumed()));

		if (!re.isEmpty()) {
			for (MapRecord<String, Object, Object> mapRecord : re) {
				redisTemplate.opsForStream().acknowledge(stream, group, RecordId.of(mapRecord.getId().toString()));
				redisTemplate.opsForStream().delete(stream, RecordId.of(mapRecord.getId().toString()));

				Map<Object, Object> map = mapRecord.getValue();
				String drvLcnsNo = map.get("drvLcnsNo").toString();
				String brthdy = map.get("brthdy").toString();
				String telecomCode = map.get("telecomCode").toString();
				String trmnlModelNm = map.get("trmnlModelNm").toString();
				
				redisTemplate.opsForHash().increment(stream+1, drvLcnsNo, 1);
				redisTemplate.opsForHash().increment(stream+2, drvLcnsNo+"_"+brthdy, 1);
				redisTemplate.opsForHash().increment(stream+3, drvLcnsNo+"_"+telecomCode, 1);
				redisTemplate.opsForHash().increment(stream+4, brthdy, 1);
				redisTemplate.opsForHash().increment(stream+5, brthdy+"_"+trmnlModelNm, 1);
				redisTemplate.opsForHash().increment(stream+6, brthdy+"_"+telecomCode, 1);
			}
		} else {
			logger.info("###### 데이터 없음 ######");
		}
		
		logger.info("###### END [StatsChartService :: redisStactics] ######");
	}
	
	public List<Map<String, String>> redisReadStactics(String param) throws IOException {
		logger.info("###### START [StatsChartService :: redisReadStactics] ######");
		
		String stream = param;
		
		Map<Object, Object> rstMap = redisTemplate.opsForHash().entries(stream);
		
		int i = 0;
		
		List<Map<String, String>> rstList = new ArrayList<>();
		
		for(Entry<Object, Object> elem : rstMap.entrySet()){
			Map<String, String> map = new HashMap<>();
			String kstr = elem.getKey().toString();
			if(kstr.contains("_")) {
				String key1 = kstr.substring(0,2);
				String key2 = kstr.substring(3);
				map.put("key1", key1);
				map.put("key2", key2);
				
			}else {
				map.put("key1", kstr);
			}
			map.put("val", elem.getValue().toString());
            
            rstList.add(i,map);
            i++;
        }
		
		logger.info("###### END [StatsChartService :: redisReadStactics] ######");
		return rstList;
	}

	public static Map<String, Object> convertStringToMap(String str) throws IOException {
		Properties props = new Properties();

		props.load(new StringReader(str.substring(1, str.length() - 1).replace(", ", "\n")));

		Map<String, Object> map = new HashMap<>();

		for (Map.Entry<Object, Object> e : props.entrySet()) {
			map.put((String) e.getKey(), e.getValue());
		}
		
		return map;
	}
}

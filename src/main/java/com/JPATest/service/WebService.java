package com.JPATest.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.JPATest.entity.ExpctdLottoNo;
import com.JPATest.repository.ExpctdLottoNoRepository;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class WebService {

	@Autowired
	ExpctdLottoNoRepository expctdLottoNoRepository;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	public Map<String, String> exptdLottoNoSel() {
		logger.info("###### START [WebService :: getExptdLottoNo] ######");
		
		PageRequest pageRequest = PageRequest.of(0, 1, Sort.by(Sort.Direction.DESC, "crtDate"));
		
		ExpctdLottoNo ExpctdLottoNo = expctdLottoNoRepository.findAll(pageRequest).getContent().get(0);
		
		Map<String, Integer> hmMap = new HashMap<>();
		hmMap.put("drwtNo1", Integer.parseInt(ExpctdLottoNo.getDrwtNo1()));
		hmMap.put("drwtNo2", Integer.parseInt(ExpctdLottoNo.getDrwtNo2()));
		hmMap.put("drwtNo3", Integer.parseInt(ExpctdLottoNo.getDrwtNo3()));
		hmMap.put("drwtNo4", Integer.parseInt(ExpctdLottoNo.getDrwtNo4()));
		hmMap.put("drwtNo5", Integer.parseInt(ExpctdLottoNo.getDrwtNo5()));
		hmMap.put("drwtNo6", Integer.parseInt(ExpctdLottoNo.getDrwtNo6()));
		
		List<String> listKeySet = new ArrayList<>(hmMap.keySet());
		
		// 오름차순 정렬 방법 
		Map<String, String> rstMap = new HashMap<>();
		int i = 1;
		Collections.sort(listKeySet, (value1, value2) -> (hmMap.get(value1).compareTo(hmMap.get(value2))));
		for(String key : listKeySet) {
			rstMap.put("drwtNo"+i, hmMap.get(key).toString());
			i++;
		}
		
		logger.info("###### END [WebService :: getExptdLottoNo] ######");
		return rstMap;
	}
	
}

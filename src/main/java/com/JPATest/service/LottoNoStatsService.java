package com.JPATest.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.JPATest.mapper.LottoMapper;
import com.JPATest.repository.LottoInfoRepository;
import com.JPATest.repository.MyLottoNoRepository;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class LottoNoStatsService {

	@Autowired
	private LottoMapper lottoMapper;
	
	@Autowired
	MyLottoNoRepository myLottoNoRepository;
	
	@Autowired
	LottoInfoRepository lottoInfoRepository;

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public List<Map<String, Object>> lottoNoStatsSel(Map<String, Object> reqMap) {
		logger.info("###### START [LottoNoStatsService :: lottoNoStatsSel] ######");
		
		List<Map<String, Object>> rstMap = lottoMapper.lottoNoStatsSel(reqMap);
		
		logger.info("###### END [LottoNoStatsService :: lottoNoStatsSel] ######");
		return rstMap;
	}
}

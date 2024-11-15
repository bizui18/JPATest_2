package com.JPATest.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.JPATest.entity.APITest;
import com.JPATest.entity.MyLottoNo;
import com.JPATest.entity.Vrsccmpny;
import com.JPATest.mapper.APITestMapper;
import com.JPATest.repository.APITestRepository;
import com.JPATest.repository.VrsccmpnyRepository;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class APITestService {

	@Autowired
	private APITestMapper apiTestMapper;
	
	@Autowired
	APITestRepository apiTestRepository;
	
	@Autowired
	VrsccmpnyRepository vrsccmpnyRepository;

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public List<APITest> selTrgtUrl() {
		logger.info("###### START [APITestService :: selTrgtUrl] ######");
		
		List<APITest> rstMap = apiTestRepository.findAll();
		
		logger.info("###### END [APITestService :: selTrgtUrl] ######");
		return rstMap;
	}
	
	public List<Vrsccmpny> selVrsccmpnyList() {
		logger.info("###### START [APITestService :: selVrsccmpnyList] ######");
		
		List<Vrsccmpny> vrsccmpny = vrsccmpnyRepository.findAll();
		
		logger.info("###### END [APITestService :: selVrsccmpnyList] ######");
		return vrsccmpny;
	}
	
	public Vrsccmpny selVrsccmpny(String vrsccmpnyManageId, String serverFg) {
		logger.info("###### START [APITestService :: selVrsccmpny] ######");
		
		Vrsccmpny vrsccmpny = vrsccmpnyRepository.findByVrsccmpnyManageIdAndServerFg(vrsccmpnyManageId, serverFg);
		logger.info("vrsccmpny : " + vrsccmpny);
		
		logger.info("###### END [APITestService :: selVrsccmpny] ######");
		return vrsccmpny;
	}
	
	public void saveVrsccmpny(Map<String, String> map) {
		logger.info("###### START [APITestService :: Vrsccmpny] ######");

		Vrsccmpny vrs = vrsccmpnyRepository.save(Vrsccmpny.builder()
												.vrsccmpnyManageId(map.get("vrsccmpnyManageId"))
												.vrsccmpnyNm(map.get("vrsccmpnyNm"))
												.seedKey(map.get("seedKey"))
												.iv(map.get("iv"))
												.serverFg(map.get("serverFg"))
												.build());
		logger.info("vrs : " + vrs);
		logger.info("###### END [APITestService :: Vrsccmpny] ######");
	}
}

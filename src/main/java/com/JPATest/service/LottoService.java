package com.JPATest.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.JPATest.entity.LottoInfo;
import com.JPATest.mapper.LottoMapper;
import com.JPATest.repository.LottoInfoRepository;
import com.JPATest.repository.MyLottoNoRepository;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class LottoService {

	@Autowired
	private LottoMapper lottoMapper;
	
	@Autowired
	MyLottoNoRepository myLottoNoRepository;
	
	@Autowired
	LottoInfoRepository lottoInfoRepository;

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public LottoInfo getDrwNo(){
		logger.info("###### START [LottoService :: getDrwNo] ######");
		
		/*
		 * PageRequest pageRequest = PageRequest.of(0, 1, Sort.by(Sort.Direction.DESC,
		 * "drwNo")); int drwNo =
		 * Integer.parseInt(lottoInfoRepository.findAll(pageRequest).getContent().get(0)
		 * .getDrwNo());
		 * 
		 * return drwNo;
		 */

		
		PageRequest pageRequest = PageRequest.of(0, 1, Sort.by(Sort.Direction.DESC, "drwNo"));
		
		LottoInfo LottoInfo = lottoInfoRepository.findAll(pageRequest).getContent().get(0);

		return LottoInfo;
	}
	
	public void insertLottoInfo(Map<String, Object> map) {
		logger.info("###### START [LottoService :: insertLottoInfo] ######");
		

		LottoInfo LottoInfo1 = LottoInfo.builder()
										.drwNo(map.get("drwNo").toString())
										.drwtNo1(map.get("drwtNo1").toString())
										.drwtNo2(map.get("drwtNo2").toString())
										.drwtNo3(map.get("drwtNo3").toString())
										.drwtNo4(map.get("drwtNo4").toString())
										.drwtNo5(map.get("drwtNo5").toString())
										.drwtNo6(map.get("drwtNo6").toString())
										.bnusNo(map.get("bnusNo").toString())
										.drwNoDate(map.get("drwNoDate").toString())
										.build();
		lottoInfoRepository.save(LottoInfo1);
	}

	public LottoInfo getLottoInfo(String schDrwNo) {
		logger.info("###### START [LottoService :: getLottoInfo] ######");
		
		Optional<LottoInfo> jpaRstMap;
		jpaRstMap = lottoInfoRepository.findById(schDrwNo);
		
		LottoInfo rtnMap = new LottoInfo(schDrwNo, "", "", "", "", "", "", "", "");
		if(!jpaRstMap.isEmpty()) {
			rtnMap = jpaRstMap.get();
		}
		
		return rtnMap;
	}
	
	public List<LottoInfo> getRct5LottoInfo() {
		logger.info("###### START [LottoService :: getRct5LottoInfo] ######");
		
		PageRequest pageRequest = PageRequest.of(0, 5, Sort.by(Sort.Direction.DESC, "drwNo"));
		Page<LottoInfo> lottoInfo = lottoInfoRepository.findAll(pageRequest);
		
		List<LottoInfo> jpaRstListMap = new ArrayList<>();
	    for(LottoInfo result : lottoInfo.getContent()){
            jpaRstListMap.add(result);
        }
	    
		return jpaRstListMap;
	}
	
	public List<Map<String, Object>> getTop6LottoNo(String param) {
		logger.info("###### START [LottoService :: getTop6LottoNo] ######");
		
		List<Map<String, Object>> rstMap = lottoMapper.getTop6LottoNo(param);
		
		return rstMap;
	}
}

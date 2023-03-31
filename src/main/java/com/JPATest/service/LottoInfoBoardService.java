package com.JPATest.service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.JPATest.entity.LottoInfo;
import com.JPATest.mapper.LottoMapper;
import com.JPATest.repository.LottoInfoRepository;
import com.JPATest.repository.MyLottoNoRepository;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class LottoInfoBoardService {

	@Autowired
	private LottoMapper lottoMapper;
	
	@Autowired
	MyLottoNoRepository myLottoNoRepository;
	
	@Autowired
	LottoInfoRepository lottoInfoRepository;

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public LottoInfo getDrwNo(){
		logger.info("###### START [LottoInfoBoardService :: getDrwNo] ######");
		
		PageRequest pageRequest = PageRequest.of(0, 1, Sort.by(Sort.Direction.DESC, "drwNo"));
		
		LottoInfo LottoInfo = lottoInfoRepository.findAll(pageRequest).getContent().get(0);

		logger.info("###### END [LottoInfoBoardService :: getDrwNo] ######");
		return LottoInfo;
	}
	
	public void insertLottoInfo(Map<String, Object> map) {
		logger.info("###### START [LottoInfoBoardService :: insertLottoInfo] ######");
		

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

		logger.info("###### END [LottoInfoBoardService :: insertLottoInfo] ######");
	}

	public LottoInfo selLottoList(String schDrwNo) {
		logger.info("###### START [LottoInfoBoardService :: selLottoList] ######");
		
		Optional<LottoInfo> jpaRstMap;
		jpaRstMap = lottoInfoRepository.findById(schDrwNo);
		
		LottoInfo rtnMap = new LottoInfo(schDrwNo, "", "", "", "", "", "", "", "");
		if(!jpaRstMap.isEmpty()) {
			rtnMap = jpaRstMap.get();
		}
		
		logger.info("###### END [LottoInfoBoardService :: selLottoList] ######");
		return rtnMap;
	}
	
	public List<LottoInfo> getLottoList() {
		logger.info("###### START [LottoInfoBoardService :: getLottoList] ######");
		
		List<LottoInfo> lottoList = lottoInfoRepository.findAll(Sort.by(Sort.Direction.DESC, "drwNo"));
		
		logger.info("###### END [LottoInfoBoardService :: getLottoList] ######");
		return lottoList;
	}
	
	public Page<LottoInfo> getLottoListPage(Pageable pageable, String schDrwNo) {
		logger.info("###### START [LottoInfoBoardService :: getLottoListPage] ######");
		
		Page<LottoInfo> lottoList;
		
		if(schDrwNo.isEmpty()) {
			lottoList = lottoInfoRepository.findAll(pageable);
		}else {
			lottoList = lottoInfoRepository.findAllByDrwNo(pageable, schDrwNo);
		}
		
		logger.info("###### END [LottoInfoBoardService :: getLottoListPage] ######");
		return lottoList;
	}
	
	public List<Map<String, Object>> getTop6LottoNo(String param) {
		logger.info("###### START [LottoInfoBoardService :: getTop6LottoNo] ######");
		
		List<Map<String, Object>> rstMap = lottoMapper.getTop6LottoNo(param);
		
		logger.info("###### END [LottoInfoBoardService :: getTop6LottoNo] ######");
		return rstMap;
	}
}

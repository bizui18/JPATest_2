package com.JPATest.service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.JPATest.entity.MyLottoNo;
import com.JPATest.repository.MyLottoNoRepository;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class MyLottoService {

	@Autowired
	MyLottoNoRepository myLottoNoRepository;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public void insertMyLottoNo(Map<String, Object> map) {
		logger.info("###### START [MyLottoService :: insertMyLottoNo] ######");
		
		int[] drwtNo = {Integer.parseInt(map.get("drwtNo1").toString()),Integer.parseInt(map.get("drwtNo2").toString()),Integer.parseInt(map.get("drwtNo3").toString())
					   ,Integer.parseInt(map.get("drwtNo4").toString()),Integer.parseInt(map.get("drwtNo5").toString()),Integer.parseInt(map.get("drwtNo6").toString())};

		Arrays.sort(drwtNo);

		MyLottoNo MyLottoNo1 = MyLottoNo.builder()
										.drwtNo1(Integer.toString(drwtNo[0]))
										.drwtNo2(Integer.toString(drwtNo[1]))
										.drwtNo3(Integer.toString(drwtNo[2]))
										.drwtNo4(Integer.toString(drwtNo[3]))
										.drwtNo5(Integer.toString(drwtNo[4]))
										.drwtNo6(Integer.toString(drwtNo[5]))
										.build();
		myLottoNoRepository.save(MyLottoNo1);

		logger.info("###### END [MyLottoService :: insertMyLottoNo] ######");
	}
	
	public List<MyLottoNo> selectMyLottoNo() {
		logger.info("###### START [MyLottoService :: selectMyLottoNo] ######");
		
		List<MyLottoNo> jpaListMap = myLottoNoRepository.findAll();
		
		logger.info("###### END [MyLottoService :: selectMyLottoNo] ######");
		return jpaListMap;
	}
	
	public Page<MyLottoNo> selectMyLottoNoPage(Pageable pageable) {
		logger.info("###### START [MyLottoService :: selectMyLottoNoPage] ######");
		
		Page<MyLottoNo> jpaListMap = myLottoNoRepository.findAll(pageable);
		
		logger.info("###### END [MyLottoService :: selectMyLottoNoPage] ######");
		return jpaListMap;
	}
	
	public void deleteMyLottoNo(int param) {
		logger.info("###### START [MyLottoService :: deleteMyLottoNo] ######");
		
		myLottoNoRepository.deleteById(param);
		
		logger.info("###### END [MyLottoService :: deleteMyLottoNo] ######");
	}
	
}

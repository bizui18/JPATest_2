package com.JPATest.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.JPATest.entity.APITest;
import com.JPATest.mapper.APITestMapper;
import com.JPATest.repository.APITestRepository;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class APITestService {

	@Autowired
	private APITestMapper apiTestMapper;
	
	@Autowired
	APITestRepository apiTestRepository;

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public List<APITest> selTrgtUrl() {
		logger.info("###### START [APITestService :: selTrgtUrl] ######");
		
		List<APITest> rstMap = apiTestRepository.findAll();
		
		logger.info("###### END [APITestService :: selTrgtUrl] ######");
		return rstMap;
	}
}

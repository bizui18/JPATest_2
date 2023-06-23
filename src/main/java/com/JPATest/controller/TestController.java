package com.JPATest.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class TestController {

	@Value("${test.start}")
	private String START;
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
	}

}

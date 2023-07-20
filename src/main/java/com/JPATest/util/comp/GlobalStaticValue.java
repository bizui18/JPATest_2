package com.JPATest.util.comp;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * @Class Name : GlobalStaticValue.java
 * @Description : static 전역 변수 관리 (properties 관리)
 *
 * @Copyright (c) 모바일면허증 All right reserved.
 *------------------------------------------------------------------------
 * Modification Information
 *------------------------------------------------------------------------   
 * 수정일 / 수정자 / 수정내용
 * 2020. 5. 11. / 수정 내용을 작성해 주세요.
 *------------------------------------------------------------------------  
 */
@Component
public class GlobalStaticValue {
	
	public static String bszIV;
	public static String httpEncYn;
	
	@Value("t.mobilelcnse.iv")
    private void setBszIV(String bszIV){
		this.bszIV = bszIV;
    }
	
	@Value("Y")
    private void setHttpEncYn(String httpEncYn){
		this.httpEncYn = httpEncYn;
    }
}

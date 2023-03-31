package com.JPATest.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JPATest.entity.LottoInfo;
import com.JPATest.service.LottoInfoBoardService;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;


@Controller
@EnableAutoConfiguration
@RequestMapping(value = "/views")
public class LottoInfoBoardController {
	
	@Autowired
	LottoInfoBoardService lottoInfoBoardService;
	
	private final static Logger logger = LoggerFactory.getLogger("");

	@RequestMapping("/lottoInfoBoard")
	public String lottoInfo(@RequestParam(value="schDrwNo", required=false) String schDrwNo, Model model) throws Exception {
		logger.info("###### START [LottoInfoBoardController :: /views/lottoInfo] ######");
		
		String drwNoDate = lottoInfoBoardService.getDrwNo().getDrwNoDate();
		
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");         
		Date date = df.parse(drwNoDate.replace("-", ""));
		
        Calendar cal = Calendar.getInstance();
        Date strToday = cal.getTime();
        
        cal.setTime(date);
        cal.add(Calendar.DATE, 7);
        
        Date drwDay = cal.getTime();
        		
        if(!strToday.before(drwDay)) {
			Map<String, Object> newLottoInfo = getLottoNo(Integer.parseInt(lottoInfoBoardService.getDrwNo().getDrwNo()) + 1);
			
			if("success".equals(newLottoInfo.get("returnValue"))) {
				lottoInfoBoardService.insertLottoInfo(newLottoInfo);
			}
        }
        
        logger.info("###### END [LottoInfoBoardController :: /views/lottoInfo] ######");
		return "lottoInfoBoard";
	}
	
	@ResponseBody
	@RequestMapping("/lottoInfoSel")
	public Page<LottoInfo> lottoInfoSel(@RequestParam(value="schDrwNo", required=false) String schDrwNo
						  , @PageableDefault(size = 7, sort = "drwNo", direction = Sort.Direction.DESC)Pageable pageable) throws Exception {
		logger.info("###### START [LottoInfoBoardController :: /views/lottoInfoSel] ######");

		Page<LottoInfo> jpaRstList = lottoInfoBoardService.getLottoListPage(pageable, schDrwNo);
	    
		logger.info("###### END [LottoInfoBoardController :: /views/lottoInfoSel] ######");
		return jpaRstList;
	}
	
	@ResponseBody
	@RequestMapping("/selLottoList")
	public LottoInfo selLottoList(@RequestParam(value="schDrwNo", required=false) String schDrwNo) {
		logger.info("###### START [LottoController :: /views/schLottoInfo] ######");
		
		LottoInfo jpaRstMap = lottoInfoBoardService.selLottoList(schDrwNo);
		
		logger.info("###### END [LottoController :: /views/schLottoInfo] ######");
		return jpaRstMap;
	}
	
	public static Map<String, Object> getLottoNo (int drwNo) throws Exception{
		logger.info("###### START [LottoInfoBoardController :: getLottoNo] "+ drwNo +" ######");
		
		String lottoUrl = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=" + drwNo;
		
		URL url = new URL(lottoUrl);
  		URLConnection con = (HttpURLConnection) url.openConnection();
  
  		//con.setRequestMethod("GET"); // optional default is GET
  		//con.setRequestProperty("User-Agent", USER_AGENT); // add request header

  		int responseCode = ((HttpURLConnection) con).getResponseCode();
  
  		BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
  
  		String inputLine;
  		StringBuffer response = new StringBuffer();
  
  		while ((inputLine = in.readLine()) != null) {
  			response.append(inputLine);
  		}
  
  		in.close();

  		System.out.println("HTTP 응답 코드 : " + responseCode);
  		System.out.println("HTTP body : " + response.toString());
  
  		Map<String, Object> lottoInfo = getMapFromJsonObject(response.toString());

  		logger.info("###### END [LottoInfoBoardController :: getLottoNo] "+ drwNo +" ######");
  		return lottoInfo;
	}
	
    /**
     * String JsonObject를 Map<String, String>으로 변환한다.
     *
     * @param jsonObj JSONObject.
     * @return Map<String, Object>.
     */
    @SuppressWarnings("unchecked")
    public static Map<String, Object> getMapFromJsonObject( String jsonObj ) {
    	logger.info("###### START [LottoInfoBoardController :: getMapFromJsonObject] ######");
        Map<String, Object> map = null;
        
        try {
            map = new ObjectMapper().readValue(jsonObj.toString(), Map.class) ;
        } catch (JsonParseException e) {
            e.printStackTrace();
        } catch (JsonMappingException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
 
        logger.info("###### END [LottoInfoBoardController :: getMapFromJsonObject] ######");
        return map;
    }
}

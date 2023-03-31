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
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JPATest.entity.LottoInfo;
import com.JPATest.service.LottoService;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;


@Controller
@EnableAutoConfiguration
@RequestMapping(value = "/views")
public class LottoController {
	
	@Autowired
	LottoService lottoService;
	
	private final static Logger logger = LoggerFactory.getLogger("");

	@RequestMapping("/lottoInfo")
	public String lottoInfo(@RequestParam(value="schDrwNo", required=false) String schDrwNo, Model model) throws Exception {
		logger.info("###### START [LottoController :: /views/lottoInfo] ######");
		
		LottoInfo LottoInfo = lottoService.getDrwNo();
		
		String drwNoDate = LottoInfo.getDrwNoDate();
		
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");         
		Date date = df.parse(drwNoDate.replace("-", ""));
		
        Calendar cal = Calendar.getInstance();
        Date strToday = cal.getTime();
        
        cal.setTime(date);
        cal.add(Calendar.DATE, 7);
        
        Date drwDay = cal.getTime();
        		
        if(!strToday.before(drwDay)) {
    		Map<String, Object> newLottoInfo = getLottoNo(Integer.parseInt(LottoInfo.getDrwNo()) + 1);
    		
    		if("success".equals(newLottoInfo.get("returnValue"))) {
    			lottoService.insertLottoInfo(newLottoInfo);
    		}
        }

        List<LottoInfo> jpaRstListMap = lottoService.getRct5LottoInfo();
	    
	    model.addAttribute("rstListMap", jpaRstListMap);

	    if(schDrwNo == null) schDrwNo = jpaRstListMap.get(0).getDrwNo().toString();
	    
		LottoInfo rstMap = lottoService.getLottoInfo(schDrwNo);
		
		model.addAttribute("drwNo", rstMap.getDrwNo());
		model.addAttribute("drwtNo1", rstMap.getDrwtNo1());
		model.addAttribute("drwtNo2", rstMap.getDrwtNo2());
		model.addAttribute("drwtNo3", rstMap.getDrwtNo3());
		model.addAttribute("drwtNo4", rstMap.getDrwtNo4());
		model.addAttribute("drwtNo5", rstMap.getDrwtNo5());
		model.addAttribute("drwtNo6", rstMap.getDrwtNo6());
		model.addAttribute("bnusNo", rstMap.getBnusNo());
		model.addAttribute("drwNoDate", rstMap.getDrwNoDate());
		
		List<Map<String, Object>> rstList = lottoService.getTop6LottoNo(schDrwNo);
		
		model.addAttribute("topNo", rstList);
		
		logger.info("###### END [LottoController :: /views/lottoInfo] ######");
		return "lottoInfo";
	}
	
	@ResponseBody
	@RequestMapping("/schLottoInfo")
	public LottoInfo schLottoInfo(@RequestParam(value="schDrwNo", required=false) String schDrwNo) {
		logger.info("###### START [LottoController :: /views/schLottoInfo] ######");
		
		LottoInfo jpaRstMap = lottoService.getLottoInfo(schDrwNo);
		
		logger.info("###### END [LottoController :: /views/schLottoInfo] ######");
		return jpaRstMap;
	}

	@ResponseBody
	@RequestMapping("/schTop6LottoNo")
	public List<Map<String, Object>> schTop6LottoNo(@RequestParam(value="schDrwNo", required=false) String schDrwNo) {
		logger.info("###### START [LottoController :: /views/schLottoInfo] ######");
		
		List<Map<String, Object>> rstMap = lottoService.getTop6LottoNo(schDrwNo);
		System.out.println(rstMap);
		
		return rstMap;
	}

	public static Map<String, Object> getLottoNo (int drwNo) throws Exception{
		logger.info("###### START [LottoController :: getLottoNo] "+ drwNo +" ######");
		
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
    	logger.info("###### START [LottoController :: getMapFromJsonObject] ######");
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
 
        return map;
    }
}

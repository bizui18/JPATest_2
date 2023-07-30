package com.JPATest.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.JPATest.entity.APITest;
import com.JPATest.entity.LottoInfo;
import com.JPATest.service.APITestService;
import com.JPATest.service.LottoInfoBoardService;
import com.JPATest.util.cipher.base64.Base64;
import com.JPATest.util.cipher.padding.BlockPadding;
import com.JPATest.util.cipher.seed.KISA_SEED_CBC;
import com.fasterxml.jackson.databind.ObjectMapper;

@Configuration
@Controller
@EnableAutoConfiguration
@RequestMapping(value = "/views")
public class APITestBoardController implements WebMvcConfigurer {

	@Autowired
	APITestService apiTestService;
	
	private final static Logger logger = LoggerFactory.getLogger("");
	
	private static final int SEED_BLOCK_SIZE = 16;
	
	private String dev_key = "MLDDEVSAMPLEKEY!";
	private String dev_iv = "t.mobilelcnse.iv";
	private String prod_key = "ncFqG7o61jWp4HFh!";
	private String prod_iv = "p.mobilelcnse.dr";
	
	@RequestMapping("/apiSendTestBoard")
	public String apiSendTestBoard(@RequestParam(value = "schDrwNo", required = false) String schDrwNo, Model model) throws Exception {
		logger.info("###### START [APITestBoardController :: /views/apiSendTestBoard] ######");

		logger.info("###### END [APITestBoardController :: /views/apiSendTestBoard] ######");
		return "apiSendTestBoard";
	}

	@ResponseBody
	@PostMapping("/sendJson")
	public JSONObject sendJson(String text, String encYn, String urlText, String selUrl) throws Exception {
		logger.info("###### START [APITestBoardController :: /views/sendJson] ######");

		String encryptCBC = "";
		JSONObject result = new JSONObject();
		
		if(!text.isEmpty()) {
		    
	        if(encYn.equals("Y")) {
	        	encryptCBC = "{\"data\":\"" + encryptCBC(text, dev_key, dev_iv) + "\"}";
	        } else {
	        	encryptCBC = "{\"data\":" + text + "}";
	        }
			result = sendData(urlText, encryptCBC, encYn);
		}else {
			result.put("errorCode", "9999");
			result.put("errorMsg", "전송 DATA 부가 없습니다.");
		}
		
		logger.info("###### END [APITestBoardController :: /views/sendJson] ######");
		return result;
	}

	@ResponseBody
	@RequestMapping("/selTrgtUrl")
	public List<APITest> selTrgtUrl() throws Exception {
		logger.info("###### START [APITestBoardController :: /views/selTrgtUrl] ######");

		List<APITest> jpaRstList = apiTestService.selTrgtUrl();
	    
		logger.info("###### END [APITestBoardController :: /views/selTrgtUrl] ######");
		return jpaRstList;
	}
	
	public JSONObject sendData(String url, String jsonData, String encYn) throws IOException, ParseException {

		  CloseableHttpClient client = null;
		  BufferedReader in = null;
		  StringBuffer result = new StringBuffer();

		  try {
		      client = HttpClients.createDefault();
		      HttpPost httpPost = new HttpPost(url);

		      httpPost.setHeader("Content-type", "application/json");

		      // JSON 데이터를 추가.
		      httpPost.setEntity(new StringEntity(jsonData, ContentType.APPLICATION_JSON));

		      // 실행
		      CloseableHttpResponse httpresponse = client.execute(httpPost);

		      // 결과 수신
		      InputStream inputStream = (InputStream)httpresponse.getEntity().getContent();

		      String inputLine = null;
		      in = new BufferedReader(new InputStreamReader(inputStream, "utf-8"));

		      while((inputLine = in.readLine()) != null) {
		          result.append(inputLine);
		      }
		      
		      JSONParser parser = new JSONParser();
		      JSONObject jsonObject = (JSONObject) parser.parse(result.toString());
		      
		      if(encYn.equals("Y")) {
		    	  if(jsonObject.get("resultCode").toString().equals("0000")) {
				      String decryptCBC = decryptCBC(jsonObject.get("data").toString(), dev_key, dev_iv);
				      
				      JSONObject dataJson = (JSONObject) parser.parse(decryptCBC);
				      jsonObject.put("data", dataJson);
		    	  }
		      }
	          return jsonObject;
		      
		  }catch(IOException ioe) {
		      throw ioe;
		  }finally {
		      if(in != null) {
		          try {
		              in.close();
		          } catch(IOException ioe) { throw ioe; }
		      }
		  }
		}

	public static String encryptCBC(String data, String key, String iv)
			throws UnsupportedEncodingException {
		return encryptCBC(data, key, iv, "UTF-8");
	}

	public static String encryptCBC(String data, String key, String iv, String charset)
			throws UnsupportedEncodingException {

		byte[] pData = null;
		if( charset == null ) {
			pData = data.getBytes();
		} else {
			pData = data.getBytes(charset);
		}

		byte[] encdata = KISA_SEED_CBC.SEED_CBC_Encrypt(key.getBytes(), iv.getBytes(), pData, 0, pData.length);

		return Base64.toString(encdata);
	}
	
	public static String decryptCBC(String data, String key, String iv) throws UnsupportedEncodingException {
		return decryptCBC(data, key, iv, "UTF-8");
	}
	
	public static String decryptCBC(String data, String key, String iv, String charset)
			throws UnsupportedEncodingException {
        
		byte[] decryptByte = Base64.toByte(data);
		byte[] decrypt=  KISA_SEED_CBC.SEED_CBC_Decrypt(key.getBytes(), iv.getBytes(), decryptByte, 0, decryptByte.length);

		if( charset == null ) {
			return new String(BlockPadding.getInstance().removePadding(decrypt, SEED_BLOCK_SIZE));
		} else {
			return new String(BlockPadding.getInstance().removePadding(decrypt, SEED_BLOCK_SIZE), charset);
		}
	}

	@RequestMapping("/encDecBoard")
	public String encDecBoard(@RequestParam(value = "schDrwNo", required = false) String schDrwNo, Model model) throws Exception {
		logger.info("###### START [APITestBoardController :: /views/encDecBoard] ######");
		
		logger.info("###### END [APITestBoardController :: /views/encDecBoard] ######");
		return "encDecBoard";
	}

	@ResponseBody
	@PostMapping("/sendEndDecData")
	public String sendEndDecData(String data, String encDecFg, String serverFg) throws Exception {
		logger.info("###### START [APITestBoardController :: /views/sendEndDecData] ######");

		String result = "";
		
		if(!data.isEmpty()) {
	        if(encDecFg.equals("ENC")) {
	        	if(serverFg.equals("DEV")) {
	        		result = encryptCBC(data, dev_key, dev_iv);
	        	}else if(serverFg.equals("PROD")) {
	        		result = encryptCBC(data, prod_key, prod_iv);
	        	}
	        	logger.info(serverFg + "_암호화 : " + result);
	        } else if(encDecFg.equals("DEC")) {
	        	if(serverFg.equals("DEV")) {
	        		result = decryptCBC(data, dev_key, dev_iv);
	        	}else if(serverFg.equals("PROD")) {
	        		result = decryptCBC(data, prod_key, prod_iv);
	        	}
	        	logger.info(serverFg + "_복호화 : " + result);
	        }
		}
		logger.info("###### END [APITestBoardController :: /views/sendEndDecData] ######");
		return result;
	}
	
	@ResponseBody
	@PostMapping("/toJsonConv")
	public String toJsonConv(String data) throws Exception {
		logger.info("###### START [APITestBoardController :: /views/toJsonConv] ######");

	    String str = data;
	    Properties props = new Properties();

	    props.load(new StringReader(str.substring(1, str.length() - 1).replace(", ", "\n")));
	    
	    Map<String, Object> map = new HashMap<>();
	    
	    for (Map.Entry<Object, Object> e : props.entrySet()) {
	        map.put((String) e.getKey(), e.getValue());
	    }

	    ObjectMapper mapper = new ObjectMapper();
	    
	    String json = mapper.writeValueAsString(map); // map => json string
		
		logger.info("###### END [APITestBoardController :: /views/toJsonConv] ######");
		return json;
	}
}

package com.JPATest.controller;

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

import com.JPATest.entity.MyLottoNo;
import com.JPATest.service.MyLottoService;


@Controller
@EnableAutoConfiguration
@RequestMapping(value = "/views")
public class MyLottoController {
	
	@Autowired
	MyLottoService myLottoService;
	
	private final static Logger logger = LoggerFactory.getLogger("");

	@RequestMapping("/myLottoNo")
	public String myLottoNo(@RequestParam(value="schDrwNo", required=false) String schDrwNo, Model model) throws Exception {
		logger.info("###### START [LottoController :: /views/myLottoNo] ######");

		logger.info("###### END [LottoController :: /views/myLottoNo] ######");
		return "myLottoNoBoard";
	}
	

	@ResponseBody
	@RequestMapping("/myLottoNoIns")
	public String myLottoNoIns(@RequestParam Map<String, Object> map){
		logger.info("###### START [MyLottoController :: /views/myLottoNoIns] ######");
		
		myLottoService.insertMyLottoNo(map);

		logger.info("###### END [MyLottoController :: /views/myLottoNoIns] ######");
		return "저장되었습니다.";
	}
	
	@ResponseBody
	@RequestMapping("/myLottoNoSel")
	public Page<MyLottoNo> myLottoNoSel(@RequestParam Map<String, Object> map, @PageableDefault(size=5, sort="crtDate", direction=Sort.Direction.DESC)Pageable pageable) {
		logger.info("###### START [MyLottoController :: /views/myLottoNoSel] ######");
		
		Page<MyLottoNo> jpaListMap = myLottoService.selectMyLottoNoPage(pageable);
		
		logger.info("###### END [MyLottoController :: /views/myLottoNoSel] ######");
		return jpaListMap;
	}
	
	@ResponseBody
	@RequestMapping("/myLottoNoDel")
	public String myLottoNoDel(@RequestParam Map<String, Object> map) {
		logger.info("###### START [MyLottoController :: /views/myLottoNoDel] ######");

		myLottoService.deleteMyLottoNo(Integer.parseInt(map.get("no").toString()));
		
		logger.info("###### END [MyLottoController :: /views/myLottoNoDel] ######");
		return "삭제되었습니다.";
	}
}

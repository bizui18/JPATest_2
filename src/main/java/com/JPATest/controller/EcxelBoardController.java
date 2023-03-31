package com.JPATest.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.apache.commons.io.FileUtils;
import org.apache.poi.openxml4j.util.ZipSecureFile;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@Controller
@EnableAutoConfiguration
@RequestMapping(value = "/views")
public class EcxelBoardController implements WebMvcConfigurer {
	
	private final static Logger logger = LoggerFactory.getLogger("");
	//로컬용
	//private String OPERATE_PATH = System.getProperty("user.dir") + "/src/main/webapp/dailyReport/";
	//private String FINISH_PATH = System.getProperty("user.dir") + "/src/main/webapp/dailyReportFin/";
	
	//배포용
	private String OPERATE_PATH = "/dailyReport/";
	private String FINISH_PATH = "/dailyReportFin/";

	// 서버 배포 시 주석 해제해야 됨(파일 다운로드를 위해)
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/dailyReportFin/**")
                .addResourceLocations("file:///dailyReportFin/");
    }
	
	@RequestMapping("/dailyReportExcel")
	public String dailyReportExcel(@RequestParam(value="schDrwNo", required=false) String schDrwNo, Model model) throws Exception {
		logger.info("###### START [EcxelBoardController :: /views/dailyReportExcel] ######");
		
		makeFolder(OPERATE_PATH);
		makeFolder(FINISH_PATH);
		
		deleteFile(OPERATE_PATH);
		
        logger.info("###### END [EcxelBoardController :: /views/dailyReportExcel] ######");
		return "dailyReportExcel";
	}

	@ResponseBody
	@PostMapping("/multiUpload")
	public String multiUpload(MultipartFile[] uploadFile, String text) throws Exception {
		logger.info("###### START [EcxelBoardController :: /views/multiUpload] ######");
		
		String resutlMsg = "";
		String uploadFolder = OPERATE_PATH + text + "/";
		logger.info("멀티 업로드 파일경로 : " + uploadFolder);
		
		makeFolder(uploadFolder);
		
		for(MultipartFile multipartFile : uploadFile) {
			logger.info("멀티 업로드 파일명 : " + multipartFile.getOriginalFilename());
			
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
			try {
				multipartFile.transferTo(saveFile);
			} catch (Exception e) {
				logger.error(e.getMessage());
			}
		}
		
		resutlMsg = excelOperate(text);
		
		logger.info("###### END [EcxelBoardController :: /views/multiUpload] ######");
		return resutlMsg;
	}

	@ResponseBody
	@RequestMapping("/excelOperate")
	public String excelOperate(@RequestParam String text) throws Exception {
		logger.info("###### START [EcxelBoardController :: /views/excelOperate] ######");
		
		String directo = OPERATE_PATH + text + "/";
		logger.info("엑셀작업 경로 : " + directo);

		long start = System.currentTimeMillis();

		for (Telecom TEL : Telecom.values()) {
			// 통신사별 폴더 생성
			File f = new File(directo + TEL.getName()+"/");
			
			if(!f.exists()) {
				f.mkdirs();
			}

			// 파일 복사
			for (File file : new File(directo).listFiles()) {
				if(file.isFile()) {					
					copyFile(file, f);
				}
			}

			// 엑셀 수정
			logger.info("[작업 시작] : " + TEL.getName());
			
			exel1(f.getAbsolutePath(),TEL);
			
			for (File file : f.listFiles()) {				
				if(file.isFile()) {
					for (File oriFile : new File(directo).listFiles()) {
						if(file.getName().equals(oriFile.getName())) {
							file.delete();
						}
					}	
				}
			}
		}
		logger.info("작업 시간 : " + (System.currentTimeMillis() - start)/1000);
    	
		try {
	    	Date today = new Date();
	    	SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");         
			
			compress(directo, FINISH_PATH, df.format(today).toString() + "_" + text);
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		deleteFile(OPERATE_PATH);
		
		logger.info("###### END [EcxelBoardController :: /views/excelOperate] ######");
		return "작업이 완료되었습니다.";
	}

	@ResponseBody
	@RequestMapping("/excelList")
	public List<Map<String, String>> excelList(@RequestParam Map<String, Object> map) throws Exception {
		logger.info("###### START [EcxelBoardController :: /views/excelList] ######");
		
		List<Map<String, String>> list = new ArrayList<>();
		
		File dir = new File(FINISH_PATH);

		String[] filenames = dir.list();
		for (String filename : filenames) {
			Map<String, String> rstMap = new HashMap<>();
			rstMap.put("fileNm", filename);
			rstMap.put("path", FINISH_PATH);
			list.add(rstMap);
		}
		
		logger.info("###### END [EcxelBoardController :: /views/excelList] ######");
		return list;
	}
	
	@ResponseBody
	@RequestMapping("/delExcel")
	public String delExcel(@RequestParam String fileNm) throws Exception {
		logger.info("###### START [EcxelBoardController :: /views/delExcel] ######");
		logger.info("삭제 파일명 : " + fileNm);
		
		String resultMsg = "";
		
		File file = new File(FINISH_PATH + fileNm);
		
		if(file.exists()) {
			if(file.delete()) { 
				resultMsg = "파일 삭제";
			}else{
				resultMsg = "파일 삭제 실패";
			}
		}else {
			resultMsg = "파일이 존재하지 않습니다.";
		}
		
		logger.info("###### END [EcxelBoardController :: /views/delExcel] ######");
		return resultMsg;
	}
	

	private static void exel1(String directo, Telecom TEL) throws IOException, FileNotFoundException {
		File dir = new File(directo);
		File[] file = dir.listFiles();
		
		ZipSecureFile.setMinInflateRatio(0);		
		
		FileOutputStream os = null;
		XSSFWorkbook x = null;
		
		for (File src : file) {
			if(src.isDirectory()) {
				continue;
			}
			if(!src.getName().endsWith("xlsx")) {
				continue;
			}
			
			x = (XSSFWorkbook) WorkbookFactory.create(src);
			
			XSSFSheet shit = x.getSheetAt(1);
			
			// sk 머지된 영역 제거하기
			// 한번만 반복하면 풀리지 않는 머지 영역이 있어서 3번을 돌린다.
			for (int j = 0; j < 3; j++) {				
				for (int i = 0; i < shit.getNumMergedRegions(); i++) {
					CellRangeAddress s = shit.getMergedRegion(i);
					if(15 < s.getFirstRow() && s.getFirstRow() < 26) {
						shit.removeMergedRegion(i);
					}
				}
			}
			
			// 상단 2줄에 값 옮겨 넣기
			shit.getRow(11).getCell(1).setCellValue(TEL.getName());
			copyRowValue(shit.getRow(13),shit.getRow(13+TEL.getRow()),0);
			copyRowValue(shit.getRow(14),shit.getRow(14+TEL.getRow()),0);

			// 나머지 줄 삭제
			for (int i = 16; i < 26; i++) {
				shit.createRow(i);
			}
			
			// 줄별 처리
			for (int i = 31; i < 37; i++) { // row
				XSSFRow ro = shit.getRow(i);
				if (ro == null)
					continue;

				// 결과 부분 컬럼 수정
				for (int j = 0; j < ro.getLastCellNum(); j++) { // collum
					XSSFCell c = ro.getCell(j);
					if (c != null) {
						if (j == 3) {
							if (ro.getCell(j + TEL.getColumn()).getRawValue() != null) {
								copyCellValue(c, ro.getCell(j + TEL.getColumn()));
							}
						}
						if (4 < j && j < 9) {
							c.setBlank();
							c.setCellStyle(null);
						}
					}
				}
			}
			
			// 빈줄 잘라내기
			shit.shiftRows(26, 48, -10);
			
			// 마무리 작업
			File newFolder = new File(directo);
			if(!newFolder.exists()) {
				newFolder.mkdirs();
			}
			os = new FileOutputStream(new File(newFolder.getAbsolutePath()+"/"+TEL.getName()+"_"+src.getName()));
			x.write(os);

			x.close();
			os.close();
			logger.info("작업 파일명 : " + src.getName());
		}
	}

	private static void copyRowValue(XSSFRow origin,XSSFRow src,int start) {
		for (int j = start; j < origin.getLastCellNum(); j++) {
			XSSFCell t = origin.getCell(j);
			XSSFCell s = src.getCell(j);
			if(t!=null && s !=null) {				
				copyCellValue(t, s);
			}
		}
	}
	
	private static void copyCellValue(XSSFCell origin, XSSFCell src) {
		CellType type = origin.getCellType();
		if(type == CellType.STRING) {
			origin.setCellValue(src.getStringCellValue());
		}else if(type==CellType.NUMERIC) {
			origin.setCellValue(src.getNumericCellValue());
		}else if(type==CellType.FORMULA) {
			origin.setCellValue(src.getCellFormula());			
		}else {
			origin.setCellValue(src.getRawValue());
		}
	}
	
	private static void copyFile(File origin, File... toDiretory) throws Exception {

		// 1. parameter check
		// 1-1 file 인지 확인
		if(!origin.isFile()) {
			logger.info("origin file must be file : " + origin.getName());
			return;
		}
		// 1-2 directory인지 확인
		for (File file : toDiretory) {
			if(!file.isDirectory() || file == null) {
				logger.info("where you want to transfer is not directory");
				return;
			}
		}
		
		// 2. FileInputStream, FileOutputStream 준비
		FileInputStream input = new FileInputStream(origin);
		FileOutputStream[] oss = new FileOutputStream[toDiretory.length];
		for (int i = 0; i < oss.length; i++) {
			oss[i] = new FileOutputStream(toDiretory[i].getAbsolutePath()+"/"+origin.getName());
		}
	
		// 3. 한번에 read하고, write할 사이즈 지정
		byte[] buf = new byte[1024];

		// 4. buf 사이즈만큼 input에서 데이터를 읽어서, output에 쓴다.
		int readData;
		while ((readData = input.read(buf)) > 0) {
			for (FileOutputStream fileOutputStream : oss) {
				fileOutputStream.write(buf, 0, readData);
			}
		}

		// 5. Stream close
		input.close();
		for (FileOutputStream fileOutputStream : oss) {
			fileOutputStream.close();
		}
	}
	
	public enum Telecom {

		SKT("SKT",0,0),
		KT("KT",5,2),
		LGU("LGU",10,4),
		;
		private String name;
		private int row;
		private int column;
		
		private Telecom(String name, int row, int column) {
			this.name = name;
			this.row = row;
			this.column = column;
		}

		public String getName() {
			return name;
		}

		public int getRow() {
			return row;
		}

		public int getColumn() {
			return column;
		}
	}
	
	
	
	public static void makeFolder(String path) {
		File Folder = new File(path);
		if (!Folder.exists()) {
			try{
				Folder.mkdirs();
				logger.info("폴더가 생성되었습니다.");
			} 
			catch(Exception e){
				e.getStackTrace();
			}        
		}
	}
	
	private void compress(String path, String outputPath, String outputFileName) throws Throwable {
		// 파일 압축 성공 여부 
		//boolean isChk = false;
		
		File file = new File(path);
		
		// 파일의 .zip이 없는 경우, .zip 을 붙여준다. 
		int pos = outputFileName.lastIndexOf(".") == -1 ? outputFileName.length() : outputFileName.lastIndexOf(".");
		
		// outputFileName .zip이 없는 경우 
		if (!outputFileName.substring(pos).equalsIgnoreCase(".zip")) {
			outputFileName += ".zip";
		}
		
		// 압축 경로 체크
		if (!file.exists()) {
			throw new Exception("Not File!");
		}
		
		// 출력 스트림
		FileOutputStream fos = null;
		// 압축 스트림
		ZipOutputStream zos = null;
		
		try {
			fos = new FileOutputStream(new File(outputPath + outputFileName));
			zos = new ZipOutputStream(fos);
			
			// 디렉토리 검색를 통한 하위 파일과 폴더 검색 
			searchDirectory(file, file.getPath(), zos);
			
			// 압축 성공.
			//isChk = true;
			logger.info("압축 성공");
		} catch (Throwable e) {
			throw e;
		} finally {
			if (zos != null)
				zos.close();
			if (fos != null)
				fos.close();
		}
	}
	
	/**
	 * @description 디렉토리 탐색
	 * @param file 현재 파일
	 * @param root 루트 경로
	 * @param zos  압축 스트림
	 */
	private void searchDirectory(File file, String root, ZipOutputStream zos) throws Exception {
		// 지정된 파일이 디렉토리인지 파일인지 검색
		if (file.isDirectory()) {
			// 디렉토리일 경우 재탐색(재귀)
			File[] files = file.listFiles();
			for (File f : files) {
				logger.info("압축 파일 :" + f);
				searchDirectory(f, root, zos);
			}
		} else {
			// 파일일 경우 압축을 한다.
			try {
				compressZip(file, root, zos);
			} catch (Throwable e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	/**
	 * @description압축 메소드 
	 * @param file
	 * @param root
	 * @param zos
	 * @throws Throwable
	 */
	private void compressZip(File file, String root, ZipOutputStream zos) throws Throwable {
		FileInputStream fis = null;
		try {
			String zipName = file.getPath().replace(root + "\\", "");
			// 파일을 읽어드림
			fis = new FileInputStream(file);
			// Zip엔트리 생성(한글 깨짐 버그)
			ZipEntry zipentry = new ZipEntry(zipName);
			// 스트림에 밀어넣기(자동 오픈)
			zos.putNextEntry(zipentry);
			int length = (int) file.length();
			byte[] buffer = new byte[length];
			// 스트림 읽어드리기
			fis.read(buffer, 0, length);
			// 스트림 작성
			zos.write(buffer, 0, length);
			// 스트림 닫기
			zos.closeEntry();

		} catch (Throwable e) {
			throw e;
		} finally {
			fis.close();
		}
	}

	public static void deleteFile(String path) throws IOException {
	    File directory = new File(path);
	    FileUtils.cleanDirectory(directory);
	    
	    logger.info("작업 파일 삭제완료");
	}
	
}

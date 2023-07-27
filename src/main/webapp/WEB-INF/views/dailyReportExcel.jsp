<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<link href="/bootstrap/css/bootstrap.css" rel="stylesheet">
	<meta name="viewport" content="width=device-width,initial-scale=1.0">
    <script src="https://use.fontawesome.com/releases/v5.2.0/js/all.js"></script>
    <style>
      html,
      body {
        width: 100%;
        height: 100%;
        margin: 0;
      }
      .container {
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
      }
    </style>	
	<title>Daily Report Excel</title>
</head>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://bootswatch.com/_vendor/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/spin.js/2.3.2/spin.js"></script>
<script>
	$(document).ready(function(){
		fnExcelList();
		
		$("#menuDailyReportExcelPage").attr('class','dropdown-item active'); 
		$("#menuHome").attr('class','nav-link'); 
	});
	
	//작업 파일 리스트
	function fnExcelList(param){
			
		var formData = $("#excelList");
		
	    $.ajax({
	    	url : "excelList"
	        , type : 'GET'
	        , data : formData.serialize()
	        , dataType: 'json'
	        , success : function(result) {
	        	// 리스트
	        	let res="";
	            $('#excelFileListTb > tbody').empty();
	            if(result.length > 0){
		            for(let i=0;i<result.length;i++){
		             	res+="<tr id='excelFileListTr' name='excelFileListTr'>"
		                		+"<td><a href='/dailyReportFin/"+result[i].fileNm+"' download'>"+result[i].fileNm+"</a></td>"
		                		+"<td><button type='button' class='btn btn-primary btn-sm' onClick=\"fnDelExcelFile('"+result[i].fileNm+"')\">삭제</button></td></tr>";
		            }
	            }
		        $('#excelFileListTb').append(res);
	        }
	    	, error : function(xhr, status) {
	            alert(xhr + " : " + status);
	        }
	    });
	}
	
	/*
	//엑셀 작업
	function fnExcelOperate(param){
			
		$('#spinner').show();
		
		var formData = $("#excelOperate");
	    
	    $.ajax({
	    	url : "excelOperate"
	        , type : 'GET'
	        , data : formData.serialize()
	        , dataType: 'text'
	        , success : function(result) {
	        	$('#spinner').hide();
	        	alert(result);
	        }
	    	, error : function(xhr, status) {
	            alert(xhr + " : " + status);
	        }
	    });
	}
	*/
	
	//파일 작업
	function fnMultiUpload(){
	
		if($("#formFile").val() == ""){
			alert("첨부된 파일이 없습니다.");
			return;
		}	
	    
	    var formData = new FormData();
	    var inputFile = $("input[name='formFile']");
	    var files = inputFile[0].files;
	
	    $('#spinner').show();
	    $('#spinnerButton').show();
	    
	    for(var i=0; i<files.length; i++){
	    	formData.append("uploadFile", files[i]);
	    }
	    
	    formData.append("text", $("#text").val());
	    
	    $.ajax({
	        url : "multiUpload"
	        , type : "POST"
	        , processData : false
	        , contentType : false
	        , data : formData
	        , success : function(result) {
	        	$('#spinner').hide();
	        	$('#spinnerButton').hide();
	
	        	alert(result);
	        	fnExcelList();
	        	$("#formFile").val("");
	        }
	    	, error : function(xhr, status) {
	        	alert(xhr + " : " + status);
	        }
	   });
	}
	
	//파일 삭제
	function fnDelExcelFile(fileNm){
		var formData = new FormData();
		formData.append("fileNm", fileNm);
		
	    $.ajax({
	    	url : "delExcel"
	        , type : 'POST'
	        , processData : false
	        , contentType : false
	        , data : formData
	        , success : function(result) {
	        	alert(result);
	        	fnExcelList();
	        }
	    	, error : function(xhr, status) {
	            alert(xhr + " : " + status);
	        }
	    });
	}

</script>
<body>
	<%@ include file="/WEB-INF/views/includes/top.jsp" %>

	<ol class="breadcrumb">
		<li class="breadcrumb-item"><a href="lottoIndex">Home</a></li>
		<li class="breadcrumb-item">Excel</li>
		<li class="breadcrumb-item">일일보고서 엑셀 작업</li>
	</ol>	

		
	<div style="margin: 0px 15px 0px 15px;">

		<h4>일일보고서 엑셀 작업</h4> 

		<form id="multiUpload" action="multiUpload" method="post" enctype="multipart/form-data">
			<table style="margin: 50px 0px 0px 0px;">
				<tr>
					<td>
						<div class="input-group mb-3"style="margin-bottom: 0rem !important">
							<input type="file" multiple="multiple" name="formFile" id="formFile" class="form-control" style="max-width:fit-content"/> 
							<select class="form-select" name="text" id="text" style="max-width:fit-content">
							    <option>1월</option>
							    <option>2월</option>
							    <option>3월</option>
							    <option>4월</option>
							    <option>5월</option>
							    <option>6월</option>
							    <option>7월</option>
							    <option>8월</option>
							    <option>9월</option>
							    <option>10월</option>
							    <option>11월</option>
							    <option>12월</option>
						    </select>
				            <button class="btn btn-primary" type="button" id="multiUpload" onClick="fnMultiUpload()">파일 작업</button>
							<!-- <input class="btn btn-primary" type="submit" value="파일 전송"> -->
						</div>
					</td>
					<td>
						<div>&nbsp;&nbsp;&nbsp;&nbsp;</div>
					</td>
					<td>
					    <div id="spinner" style="display:none;">
							<button class="btn btn-primary" type="button" id="spinnerButton" disabled >
							  <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
							  Loading...
							</button>	            
					    </div>
					</td>	
				</tr>
			</table>
		</form>	

		<form id="excelList" name="excelList" action="excelList" method="GET">
	        <div style="margin: 50px 0px 0px 0px;width:500">
				<table id="excelFileListTb" class="table">
					<thead>
						<tr >
							<th scope="col" width="400">파일명</th>
							<th scope="col" ><button type="button" class="btn btn-primary btn-sm" id="excelList" onClick="fnExcelList()">파일 조회</button></th>
						</tr>
					</thead>		
					<tbody>
					</tbody>
				</table>
	        </div>
		</form>	
	</div>



</body>
</html>

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
	<title>Compare Page</title>
</head>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://bootswatch.com/_vendor/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/spin.js/2.3.2/spin.js"></script>
<script src='//cdnjs.cloudflare.com/ajax/libs/jquery-chained/1.0.1/jquery.chained.min.js'></script>
<script>

	$(document).ready(function(){
		$("#menuComparePage").attr('class','dropdown-item active');
		$("#menuHome").attr('class','nav-link');
		$("#menuAPI").attr('class','nav-link dropdown-toggle active');
		
	});

	//Json 보내기(전송)
	function fnSendJsonData(param){
		var formData = new FormData();
		
		formData.append("data1", $("#sendData1").val());
		formData.append("data2", $("#sendData2").val());
	    
		
	    $.ajax({
	        url : "sendJsonData",
	        type : 'POST', 
	        processData : false,
	        contentType : false,
	        data : formData ,
	        success : function(result) {
	        	$("#resultData").val(result);
	        	fnBeauty();
	        },  
	        error : function(xhr, status) {
	            alert(xhr + " : " + status);
	        }
	    });
	}

	//Map 보내기(전송)
	function fnSendMapData(param){
		var formData = new FormData();
		
		formData.append("data1", $("#sendData1").val());
		formData.append("data2", $("#sendData2").val());
	    
		
	    $.ajax({
	        url : "sendMapData",
	        type : 'POST', 
	        processData : false,
	        contentType : false,
	        data : formData ,
	        success : function(result) {
	        	$("#resultData").val(result);
	        	fnBeauty();
	        },  
	        error : function(xhr, status) {
	            alert(xhr + " : " + status);
	        }
	    });
	}
	
	function fnBeauty(){
		$("#resultData").val(JSON.stringify(JSON.parse($("#resultData").val()),null,4));
	}	
	
</script>
<body>
	<%@ include file="/WEB-INF/views/includes/top.jsp" %>

	<ol class="breadcrumb">
		<li class="breadcrumb-item"><a href="lottoIndex">Home</a></li>
		<li class="breadcrumb-item">API</li>
		<li class="breadcrumb-item active">
		    <a class="nav-link dropdown-toggle show" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="true">비교</a>
		    <div class="dropdown-menu" style="position: absolute; inset: 0px auto auto 0px; margin: 0px; transform: translate(0px, 42px);" data-popper-placement="bottom-start">
		        <a class="dropdown-item" href="apiSendTestBoard">API 전송 테스트</a>
		        <a class="dropdown-item" href="encDecBoard">암복호화</a>
		        <a class="dropdown-item active">비교</a>
		    </div>
		</li>			
	</ol>	

		
	<div style="margin: 0px 15px 0px 15px;">

		<h4>비교</h4> 

		<form id="textArea" name="textArea" action="textArea" method="GET">
			<div class="form-group">
	
			</div>
			<div class="form-group">
				<label class="form-label mt-4" for="sendData">INPUT DATA</label>
				<table style="width:100%">
					<tr>
						<td>
							Data1
						</td> 
						<td>
							Data2
					    </td>
				    </tr>
					<tr>
						<td>
							<textarea class="form-control" id="sendData1" name="sendData1" rows="10" data-grammar="true" spellcheck="false"></textarea>
						</td> 
						<td>
							<textarea class="form-control" id="sendData2" name="sendData2" rows="10" data-grammar="true" spellcheck="false"></textarea>
					    </td>
				    </tr>
				</table>
			</div>
			<div>
				<table>
					<tr>
				    	<td>
							<button class="btn btn-primary" type="button" id="sendJsonDataBt" onClick="fnSendJsonData()">Json 비교</button>
							<button class="btn btn-primary" type="button" id="sendMapDataBt" onClick="fnSendMapData()">Map 비교</button>
						</td>
					</tr>
				</table>
			</div>			
			<div class="form-group">
				<label class="form-label mt-4" for="resultData">RESULT DATA</label>
				<textarea class="form-control" id="resultData" name="resultData" rows="10" data-grammar="true" spellcheck="false"></textarea>
			</div>
			<div>
				<table>
					<tr>
				    	<td>
							<button class="btn btn-primary" type="button" id="beautyBt" onClick="fnBeauty()">Json 정렬</button>
						</td>
					</tr>
				</table>
			</div>			
		</form>	
	</div>
</body>
</html>

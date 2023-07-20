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
	<title>API Send Test Page</title>
</head>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://bootswatch.com/_vendor/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/spin.js/2.3.2/spin.js"></script>
<script>
	$(document).ready(function(){
		fnSchUrl();
	});

	//URL 가져오기
    function fnSchUrl(param){
        $.ajax({
            url : 'selTrgtUrl',
            type : 'GET', 
            success : function(result) {
            	$('#selUrl').empty();
            	if(result.length > 0){
		            for(let i=0; i<result.length;i++){
		            	var option = $("<option value=\"" + result[i].targetUrl + "\">" + result[i].urlAcnt + "</option>");
		                $('#selUrl').append(option);
		            }
	            }
            },  
            error : function(xhr, status) {
                alert(xhr + " : " + status);
            }
        });
    }
	
	//보내기(전송)
	function fnSendJson(param){
		var formData = new FormData();
		var urlText = document.getElementById('serverText').value + document.getElementById('selUrl').value;
		
		formData.append("text", $("#sendJsonText").val());
		formData.append("encYn", $("#encYn").val());
		formData.append("urlText", urlText);
	    
		document.getElementById('sendUrl').value = urlText;
		
	    $.ajax({
	        url : "sendJson",
	        type : 'POST', 
	        processData : false,
	        contentType : false,
	        data : formData ,
	        success : function(result) {
	        	let json = result;
	        	$("#resultJsonText").val(JSON.stringify(result,null,4));
	        },  
	        error : function(xhr, status) {
	            alert(xhr + " : " + status);
	        }
	    });
	}
	
	//서버 선택
	function fnselServer(param){
		document.getElementById('serverText').value = param;
		document.getElementById('sendUrl').value = "";
	}
	
	//API 선택
	function fnselUrl(param){
		document.getElementById('sendUrl').value = "";
	}

</script>
<body>
	<%@ include file="/WEB-INF/views/includes/top.jsp" %>

	<ol class="breadcrumb">
		<li class="breadcrumb-item"><a href="lottoIndex">Home</a></li>
		<li class="breadcrumb-item">API</li>
		<li class="breadcrumb-item">API 전송 테스트</li>
	</ol>	

		
	<div style="margin: 0px 15px 0px 15px;">

		<h4>API 전송 테스트</h4> 

		<form id="textArea" name="textArea" action="textArea" method="GET">
			<div class="form-group">
				<label for="exampleTextarea" class="form-label mt-4">Send JSon DATA 부</label>
				<textarea class="form-control" id="sendJsonText" name="sendJsonText" rows="10" data-grammar="true" spellcheck="false"></textarea>
			</div>
			<div class="form-group">
				<table>
					<tr>
						<td> 암호화 :</td> 
						<td>
							<select class="form-select" name="encYn" id="encYn" style="max-width:fit-content">
						    	<option>Y</option>
						    	<option>N</option>
					    	</select>
					    </td>
						<td width="70" align="right"> URL :</td> 
						<td>
							<select class="form-select" name="selServer" id="selServer" style="max-width:fit-content" onchange="fnselServer(this.value)">
						    	<option value="http://localhost:8082">로컬</option>
						    	<option value="https://dev-interface.pass-mdl.com:5243">개발</option>
					    	</select>
					    </td>
						<td width="320">
					    	<input type="text" id="serverText" name="serverText" class="form-control" value="http://localhost:8082"/>
					    </td>
						<td>
							<select class="form-select" name="selUrl" id="selUrl" style="max-width:fit-content" onchange="fnselUrl(this.value)">
					    	</select>
					    </td>
				    	<td width="100" align="right">
							<button class="btn btn-primary" type="button" id="sendJsonBt" onClick="fnSendJson()">보내기</button>
						</td>
						<td width="800">
					    	<input type="text" id="sendUrl" name="sendUrl" class="form-control" readonly="readonly"/>
					    </td>
				    </tr>
				</table>
			</div>
			<div class="form-group">
				<label for="exampleTextarea" class="form-label mt-4">Result JSon</label>
				<textarea class="form-control" id="resultJsonText" name="resultJsonText" rows="10" data-grammar="true" spellcheck="false"></textarea>
			</div>
		</form>	
	</div>
</body>
</html>

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
<script src='//cdnjs.cloudflare.com/ajax/libs/jquery-chained/1.0.1/jquery.chained.min.js'></script>
<script>
	$(document).ready(function(){
		fnSchUrl();
		
		$("#menuAPISendTestBoard").attr('class','dropdown-item active'); 
		$("#menuHome").attr('class','nav-link');
		$("#selJsonData").css("visibility","hidden");
		
		$("#sendJsonText").on('keydown',(e,data)=>{
			if(e.altKey&&e.key =='s'){
				fnSendJson();	
			}else if(e.altKey&&49 <=e.keyCode && e.keyCode <55){
				hisVal = $("#his" + (e.keyCode - 48)).val();
				$("#sendJsonText").val(hisVal)
				
			}
		});
		for(var i=1; i<7; i++){
			$("#his"+i).hide();
		}
	});

	//URL 가져오기
    function fnSchUrl(param){
        $.ajax({
            url : 'selTrgtUrl',
            type : 'GET', 
            success : function(result) {
            	$('#selAPI').empty();
            	if(result.length > 0){
		            for(let i=0; i<result.length;i++){
		            	var option = $("<option value=\"" + result[i].targetUrl + "\">" + result[i].urlAcnt + "</option>");
		                $('#selAPI').append(option);
		            	
		                var jsonData = $("<option class=\"" + result[i].targetUrl + "\" value=\"" + result[i].jsonData + "\">" + result[i].jsonData + "</option>");
		                $('#selJsonData').append(jsonData);
		            }
	            }
            	$("#selJsonData").chained("#selAPI");
            },  
            error : function(xhr, status) {
                alert(xhr + " : " + status);
            }
        });
    }
	
	//보내기(전송)
	function fnSendJson(param){
		var formData = new FormData();
		var urlText = $("#serverText").val() + $("#selAPI").val();
		
		formData.append("text", $("#sendJsonText").val());
		formData.append("encYn", $("#encYn").val());
		formData.append("urlText", urlText);
	    
		$("#sendUrl").val(urlText);
		$("#resultJsonText").val("");
		
	    $.ajax({
	        url : "sendJson",
	        type : 'POST', 
	        processData : false,
	        contentType : false,
	        data : formData ,
	        success : function(result) {
	        	let json = result;
	        	$("#resultJsonText").val(JSON.stringify(result,null,4));
	        	$("#his1").show();
	        	hisNullcheck();
	        	$("#his1").val($("#sendJsonText").val());
	        },  
	        error : function(xhr, status) {
	            alert(xhr + " : " + status);
	        }
	    });
	}
	
	//서버 선택
	function fnSelServer(param){
		$("#serverText").val(param);
		$("#sendUrl").val("");
	}
	
	//API 선택
	function fnSelAPI(param){
		$("#sendUrl").val("");
	}

	//샘플 Json 양식 생성
	function fnSampleJson(){
		$("#sendUrl").val("");
		$("#sendJsonText").val($("#selJsonData option:selected").text());
	}
	
	function hisNullcheck(){
		for(var i=6; i>1; i--){
			if($("#his"+(i-1)).val() != ""){
				$("#his"+i).show();
			}
			$("#his"+i).val($("#his"+(i-1)).val());
		}
	}
	
	function hisClick(param){
		$("#sendJsonText").val(param);
	}

	function fnToJsonBt(){
		var formData = new FormData();
		
		formData.append("data", $("#sendJsonText").val());
	    
	    $.ajax({
	        url : "toJsonConv",
	        type : 'POST', 
	        processData : false,
	        contentType : false,
	        data : formData ,
	        success : function(result) {
	        	console.log(result);
	        	console.log(JSON.stringify(JSON.parse(result),null,4));
	        	$("#sendJsonText").val(JSON.stringify(JSON.parse(result),null,4));
	        },  
	        error : function(xhr, status) {
	            alert(xhr + " : " + status);
	        }
	    });
	}
</script>
<body>
	<%@ include file="/WEB-INF/views/includes/top.jsp" %>

	<ol class="breadcrumb">
		<li class="breadcrumb-item"><a href="lottoIndex">Home</a></li>
		<li class="breadcrumb-item">API</li>
		<li class="breadcrumb-item active">
		    <a class="nav-link dropdown-toggle show" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="true">API 전송 테스트</a>
		    <div class="dropdown-menu" style="position: absolute; inset: 0px auto auto 0px; margin: 0px; transform: translate(0px, 42px);" data-popper-placement="bottom-start">
		        <a class="dropdown-item active" href="apiSendTestBoard">API 전송 테스트</a>
		        <a class="dropdown-item " href="encDecBoard">암복호화</a>
		    </div>
		</li>
	</ol>	

		
	<div style="margin: 0px 15px 0px 15px;">

		<h4>API 전송 테스트</h4> 

		<form id="textArea" name="textArea" action="textArea" method="GET">
			<div class="form-group">
				<label class="form-label mt-4" for="selJsonData">Send JSon DATA 부</label>
			</div>
			<div class="form-group" style="float:right; width:450px;">
				<table >
					<tr >
						<td>
							HISTORY
						</td>
					</tr>
					<tr>
						<td>
							<input type="text" id="his1" name="his1" class="form-control" onclick="hisClick(this.value)" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td>
							<input type="text" id="his2" name="his2" class="form-control" onclick="hisClick(this.value)" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td>
							<input type="text" id="his3" name="his3" class="form-control" onclick="hisClick(this.value)" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td>
							<input type="text" id="his4" name="his4" class="form-control" onclick="hisClick(this.value)" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td>
							<input type="text" id="his5" name="his5" class="form-control" onclick="hisClick(this.value)" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td>
							<input type="text" id="his6" name="his6" class="form-control" onclick="hisClick(this.value)" readonly="readonly"/>
						</td>
					</tr>
				</table>
			</div>
			<div class="form-group">
				<table>
					<tr>
						<td width="62"> 암호화 :</td> 
						<td width="80">
							<select class="form-select" name="encYn" id="encYn" style="max-width:fit-content">
						    	<option>Y</option>
						    	<option>N</option>
					    	</select>
					    </td>
						<td width="70" align="right"> URL :</td> 
						<td width="95">
							<select class="form-select" name="selServer" id="selServer" style="max-width:fit-content" onchange="fnSelServer(this.value)">
						    	<option value="http://localhost:8082">로컬</option>
						    	<option value="https://dev-interface.pass-mdl.com:5243">개발</option>
					    	</select>
					    </td>
						<td width="320">
					    	<input type="text" id="serverText" name="serverText" class="form-control" value="http://localhost:8082"/>
					    </td>
						<td width="320">
							<select class="form-select" name="selAPI" id="selAPI" style="max-width:fit-content" onchange="fnSelAPI(this.value)">
					    	</select>
					    </td>
				    	<td width="135">
							<button class="btn btn-primary" type="button" id="sampleJsonBt" onClick="fnSampleJson()">Json 양식 생성</button>
						</td>			
						<td width="210">
							<button class="btn btn-primary" type="button" id="toJsonBt" onClick="fnToJsonBt()">Map.toString To Json</button>
						</td>
						<td>
							<select class="form-select" name="selJsonData" id="selJsonData">
					    	</select>
					    </td>
				    </tr>
				    <tr>
				    	<td colspan="9">
							<textarea class="form-control" id="sendJsonText" name="sendJsonText" rows="10" data-grammar="true" spellcheck="false"></textarea>
						</td>
					</tr>
				</table>
				<table>
					<tr>
				    	<td>
							<button class="btn btn-primary" type="button" id="sendJsonBt" onClick="fnSendJson()">보내기</button>
						</td>
						<td width="800">
					    	<input type="text" id="sendUrl" name="sendUrl" class="form-control" readonly="readonly" disabled="disabled"/>
					    </td>
					</tr>
				</table>
			</div>

			<div class="form-group">
				<label class="form-label mt-4" for="resultJsonText">Result JSon</label>
				<textarea class="form-control" id="resultJsonText" name="resultJsonText" rows="10" data-grammar="true" spellcheck="false"></textarea>
			</div>
		</form>	
	</div>
</body>
</html>

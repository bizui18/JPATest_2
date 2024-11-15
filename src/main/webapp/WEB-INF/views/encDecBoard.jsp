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

-- 모달 팝업 css
	h2{
	    text-align: center;
	}
	.modal_btn {
	    display: block;
	    margin: 40px auto;
	    padding: 10px 20px;
	    background-color: royalblue;
	    border: none;
	    border-radius: 5px;
	    color: #fff;
	    cursor: pointer;
	    transition: box-shadow 0.2s;
	}
	.modal_btn:hover {
	    box-shadow: 3px 4px 11px 0px #00000040;
	}
	
	.modal {
	/*팝업 배경*/
		display: none; /*평소에는 보이지 않도록*/
	    position: absolute;
	    top:0;
	    left: 0;
	    width: 100%;
	    height: 100vh;
	    overflow: hidden;
	    background: rgba(0,0,0,0.5);
	}
	.modal .modal_popup {
	/*팝업*/
	    position: absolute;
	    top: 50%;
	    left: 50%;
	    transform: translate(-50%, -50%);
	    padding: 20px;
	    background: #ffffff;
	    border-radius: 20px;
	}
	.modal .modal_popup .close_btn {
	    display: block;
	    padding: 10px 20px;
	    background-color: rgb(116, 0, 0);
	    border: none;
	    border-radius: 5px;
	    color: #fff;
	    cursor: pointer;
	    transition: box-shadow 0.2s;
	}
	.modal.on {
	    display: block;
	}	

    </style>	
	<title>Enc-Dec Page</title>
</head>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://bootswatch.com/_vendor/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/spin.js/2.3.2/spin.js"></script>
<script src='//cdnjs.cloudflare.com/ajax/libs/jquery-chained/1.0.1/jquery.chained.min.js'></script>
<script>

	$(document).ready(function(){
		fnSchVrsccmpnyList();
		
		$("#menuEncDecPage").attr('class','dropdown-item active');
		$("#menuHome").attr('class','nav-link');
		$("#menuAPI").attr('class','nav-link dropdown-toggle active');
		
		const modal = document.getElementById('modal');
		const modalOpen = document.getElementById('modalOpen');
		const modalClose = document.getElementById('modalClose');

		//열기 버튼을 눌렀을 때 모달팝업이 열림
		modalOpen.addEventListener('click',function(){
		  	//'on' class 추가
		    modal.classList.add('on');
		});
		//닫기 버튼을 눌렀을 때 모달팝업이 닫힘
		modalClose.addEventListener('click',function(){
		    //'on' class 제거
		    modal.classList.remove('on');
		});
	});
	
	//보내기(전송)
	function fnSendData(param){
		var formData = new FormData();
		
		formData.append("data", $("#sendData").val());
		formData.append("encDecFg", $("#selEncDecFg").val());
		formData.append("serverFg", $("#selServerFg").val());
		formData.append("selVrsccmpnyManageId", $("#selVrsccmpnyManageId").val());
	    
	    $.ajax({
	        url : "sendEndDecData",
	        type : 'POST', 
	        processData : false,
	        contentType : false,
	        data : formData ,
	        success : function(result) {
	        	$("#resultData").val(result);
	        },  
	        error : function(xhr, status) {
	            alert(xhr + " : " + status);
	        }
	    });
	}
	
	//테스트 테이저 저장
	function fnSaveTestData(param){
		var formData = new FormData();
		formData.append("data", $("#resultData").val());
	    
		$.ajax({
	        url : "saveTestData",
	        type : 'POST', 
	        processData : false,
	        contentType : false,
	        data : formData ,
	        success : function(result) {
	        	$("#resultData").val(result);
	        },  
	        error : function(xhr, status) {
	            alert(xhr + " : " + status);
	        }
	    });
	}
	
	function fnBeauty(){
		$("#resultData").val(JSON.stringify(JSON.parse($("#resultData").val()),null,4));
	}

	
	//대행사 저장
	function fnRegiVrsccmpny(param){
		if(fnCheck()){
			document.getElementById('regiVrsccmpny').disabled = true;
			  
			var formData = new FormData();
			
			formData.append("vrsccmpnyNm", $("#vrsccmpnyNm").val());
			formData.append("vrsccmpnyManageId", $("#vrsccmpnyManageId").val());
			formData.append("seedKey", $("#seedKey").val());
			formData.append("iv", $("#iv").val());
			formData.append("serverFg", $("#serverFg").val());
		    
			$.ajax({
		        url : "saveVrsccmpny",
		        type : 'POST', 
		        processData : false,
		        contentType : false,
		        data : formData ,
		        success : function(result) {
		        	alert(result);
		        	document.getElementById('regiVrsccmpny').disabled = false;
		        	$("#vrsccmpnyNm").val("");
		        	$("#vrsccmpnyManageId").val("")
		        	$("#seedKey").val("")
		        	$("#iv").val("")
		        	$("#selVrsccmpnyManageId").val("");
		        	modal.classList.remove('on');
		        	fnSchVrsccmpnyList();
		        	
		        },  
		        error : function(xhr, status) {
		            alert(xhr + " : " + status);
		        }
		    });
		}
	}

	//대행사 목록 가져오기
    function fnSchVrsccmpnyList(param){
        $.ajax({
            url : 'selVrsccmpnyList',
            type : 'GET', 
            success : function(result) {
            	$('#selVrsccmpnyList').empty();
            	if(result.length > 0){
	            	var nullOption = $("<option value=\"\">대행사 리스트</option>");
	                $('#selVrsccmpnyList').append(nullOption);
		            for(let i=0; i<result.length;i++){
		            	var option = $("<option value=\"" + result[i].vrsccmpnyManageId + "\">" + result[i].serverFg + "_" + result[i].vrsccmpnyNm + "(" + result[i].vrsccmpnyManageId + ")" + "</option>");
		                $('#selVrsccmpnyList').append(option);
		            }
	            }
            },  
            error : function(xhr, status) {
                alert(xhr + " : " + status);
            }
        });
    }
	
	//대행사 선택
	function fnSelVrsccmpnyList(param){
		$("#selVrsccmpnyManageId").val(param);
	}

    function fnCheck(){
    	let no1 = document.getElementById("vrsccmpnyNm");
    	let no2 = document.getElementById("vrsccmpnyManageId");
    	let no3 = document.getElementById("seedKey");
    	let no4 = document.getElementById("iv");
    	let no5 = document.getElementById("serverFg");

    	var arr = [];
    	arr.push(no1.value);
    	arr.push(no2.value);
    	arr.push(no3.value);
    	arr.push(no4.value);
    	arr.push(no5.value);

    	for(var i=0; i<arr.length; i++){
    		if(arr[i] == "" ){
    			alert("입력 하세요.");
    			eval("no" + (i+1)).focus();
    			return false;
    		}
    	}
    	return true;
    }
	</script>
<body>
	<%@ include file="/WEB-INF/views/includes/top.jsp" %>

	<ol class="breadcrumb">
		<li class="breadcrumb-item"><a href="lottoIndex">Home</a></li>
		<li class="breadcrumb-item">API</li>
		<li class="breadcrumb-item active">
		    <a class="nav-link dropdown-toggle show" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="true">암복호화</a>
		    <div class="dropdown-menu" style="position: absolute; inset: 0px auto auto 0px; margin: 0px; transform: translate(0px, 42px);" data-popper-placement="bottom-start">
		        <a class="dropdown-item" href="apiSendTestBoard">API 전송 테스트</a>
		        <a class="dropdown-item active">암복호화</a>
		    </div>
		</li>			
	</ol>	

		
	<div style="margin: 0px 15px 0px 15px;">

		<h4>암복호화</h4> 

		<form id="textArea" name="textArea" action="textArea" method="GET">
			<div class="form-group">
	
			</div>
			<div class="form-group">
				<label class="form-label mt-4" for="sendData">INPUT DATA</label>
				<table>
					<tr>
						<td> 암복호화 :</td> 
						<td>
							<select class="form-select" name="selEncDecFg" id="selEncDecFg" style="max-width:fit-content">
						    	<option value="DEC">복호화</option>
						    	<option value="ENC">암호화</option>
					    	</select>
					    </td>
						<td width="70" align="right"> 서버 :</td> 
						<td>
							<select class="form-select" name="selServerFg" id="selServerFg" style="max-width:fit-content">
						    	<option value="DEV">개발</option>
						    	<option value="PROD">운영</option>
					    	</select>
					    </td>
						<td width="110" align="right"> 대행사 ID :</td> 
						<td><input type="text" id="selVrsccmpnyManageId" name="selVrsccmpnyManageId" class="form-control" type="text"/></td>
						<td width="320">
							<select class="form-select" name="selVrsccmpnyList" id="selVrsccmpnyList" style="max-width:fit-content" onclick="fnSelVrsccmpnyList(this.value)">
					    	</select>
					    </td>
				    </tr>
				</table>
				<textarea class="form-control" id="sendData" name="sendData" rows="10" data-grammar="true" spellcheck="false"></textarea>
			</div>
			<div>
				<table>
					<tr>
				    	<td>
							<button class="btn btn-primary" type="button" id="sendDataBt" onClick="fnSendData()">보내기</button>
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
							<button class="btn btn-primary" type="button" id="beautyBt" onClick="fnBeauty()">JSON 정렬</button>
						</td>
				    	<td>
							<button class="btn btn-primary" type="button" id="saveTestDataBt" onClick="fnSaveTestData()">테스트 데이터 저장</button>
						</td>
						<td>
					        <button type="button" class="btn btn-primary" id="modalOpen" name="modalOpen">대행사 등록</button>
					    </td>
					</tr>
				</table>
			</div>			
		</form>	
	</div>
	<!--모달 팝업-->
	<div class="modal" id="modal">
	    <div class="modal_popup" id="modal_popup">
			<form id="regiFm" name="regiFm">
				<div style="margin: 0px 15px 0px 15px;">
			        <h4>대행사 등록</h4> 
					<table>
						<thead>
							<tr>
								<td><label class="col-form-label mt-4">대행사 명</label></td>
								<td><label class="col-form-label mt-4">대행사 ID</label></td>
								<td><label class="col-form-label mt-4">SEED Key</label></td>
								<td><label class="col-form-label mt-4">VI</label></td>
								<td><label class="col-form-label mt-4">서버</label></td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><input type="text" id="vrsccmpnyNm" name="vrsccmpnyNm" class="form-control" type="text"/></td>
								<td><input type="text" id="vrsccmpnyManageId" name="vrsccmpnyManageId" class="form-control" type="text"/></td>
								<td><input type="text" id="seedKey" name="seedKey" class="form-control" type="text"/></td>
								<td><input type="text" id="iv" name="iv" class="form-control" type="text"/></td>
								<td width="120">
									<select class="form-select" name="serverFg" id="serverFg" style="max-width:fit-content">
								    	<option value="DEV">개발</option>
								    	<option value="PROD">운영</option>
							    	</select>
							    </td>
							</tr>
						</tbody>
					</table>
			        <button type="button" class="btn btn-primary" id="regiVrsccmpny" name="regiVrsccmpny" onClick="fnRegiVrsccmpny()">등록</button>
			        <button type="button" class="btn btn-outline-primary" id="modalClose" name="modalClose">닫기</button>
				</div>
			</form>
	    </div>
	</div>
</body>
</html>

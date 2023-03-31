<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<link href="/bootstrap/css/bootstrap.css" rel="stylesheet">
	<meta name="viewport" content="width=device-width,initial-scale=1.0">
	<title>My Lotto Number</title>
</head>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://bootswatch.com/_vendor/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script>
	$(document).ready(function(){
		fnSchMyLottoNo();

		$("#menuMylottoNoPage").attr('class','dropdown-item active'); 
		$("#menuHome").attr('class','nav-link'); 
	});
	
	//로또 번호 랜덤 생성
	function fnCrtLottoNo(){
		var lotto = [];
		while(lotto.length < 6){
			var num = parseInt(Math.random() * 45 + 1);
			if(lotto.indexOf(num) == -1){
				lotto.push(num);
			}
		}
		lotto.sort((a,b)=>a-b);

		document.getElementById("drwtNo1").value = lotto[0];
		document.getElementById("drwtNo2").value = lotto[1];
		document.getElementById("drwtNo3").value = lotto[2];
		document.getElementById("drwtNo4").value = lotto[3];
		document.getElementById("drwtNo5").value = lotto[4];
		document.getElementById("drwtNo6").value = lotto[5];
	}


	//나의 로또 번호 저장
    function fnSaveMyLottoNo(){
    	if(!fnCheckMyLottoNo()){
    		return;
    	}

        var formData = $("#crtLottoNoFm")

        $.ajax({
            url : $("#crtLottoNoFm").attr('action'),
            type : 'GET', 
            data : formData.serialize(), 
            dataType: 'text',
            success : function(result) {
                alert(result);
                fnSchMyLottoNo();
                fnCrtLottoNo();
            },  
            error : function(xhr, status) {
                alert(xhr + " : " + status);
            }
        });
    }

	//나의 로또 번호 조회
    function fnSchMyLottoNo(param){
        var formData = $("#myLottoNoFm");

        $.ajax({
            url : $("#myLottoNoFm").attr('action'),
            type : 'GET', 
            data : formData.serialize() +"&page="+param,
            dataType: 'text',
            success : function(result) {
	            let json=JSON.parse(result);
	            
	            // 리스트
	            let content = json.content;
	            let res="";
	            $('#myLottoNoTb1 > tbody').empty();
	            if(content.length > 0){
		            for(let i=0;i<content.length;i++){
		             	res+="<tr id='myLottoNoTr' name='myLottoNoTr'>"
		                		+"<td  scope='row'>"+content[i].crtDate.replace('T',' ')+"</td>"
		                		+"<td >"+content[i].drwtNo1+"</td>"
		                		+"<td >"+content[i].drwtNo2+"</td>"
		                		+"<td >"+content[i].drwtNo3+"</td>"
		                		+"<td >"+content[i].drwtNo4+"</td>"
		                		+"<td >"+content[i].drwtNo5+"</td>"
		                		+"<td >"+content[i].drwtNo6+"</td>"
		                		+"<td><button type='button' class='btn btn-primary btn-sm' onClick=\"fnDelMyLottoNo('"+content[i].no+"')\">삭제</button></td></tr>";
		            }
	            }else{
	            	res+="<tr id='myLottoNoTr' name='myLottoNoTr'>"
	            	    +"	<td width='705'>조회된 데이터가 없습니다.</td></tr>";
	            }
			    $('#myLottoNoTb1').append(res);
			    
			    // 페이징
			    $('#myLottoNoTb2').empty();

			    let pageP10 = json.number + 10;
			    if(json.totalPages-1 < pageP10) pageP10 = json.totalPages-1
			    
			    let pageM10 = json.number - 10;
			    if( 0 > pageM10) pageM10 = 0;
			    
			    let resPage = "<ul class=\"pagination\">";
			    
			    if(json.totalPages > 5){
			    //페이지 6개 이상
			    	//[<<] 페이지
			    	resPage += "<li class=\"page-item\">"
			    			+  "	<a class=\"page-link\" href='#;return false;' onClick=\"fnSchMyLottoNo("+ (pageM10) +")\">&laquo;</a>"
			    			+  "</li>";
			    	
			    	//첫번째 페이지
			    	if(json.number == 0){
			    		resPage += "<li class=\"page-item active\">";
			    	}else{
			    		resPage += "<li class=\"page-item\">";
			    	}
		    		resPage	+= "	<a class=\"page-link\" href='#;return false;' onClick=\"fnSchMyLottoNo("+ (0) +")\">"+ (1) +"</a>"
		    					+  "</li>";
		    		
			    	for(var j=json.number-1; j<json.number+2; j++){
		    			if(j > 1 && json.number-1 == j){
		    				resPage += "<li class=\"page-item\">"
		    						+  "	<a class=\"page-link disabled\">&#8230;</a>"
		    						+  "</li>";
		    			}

			    		if(j >= 1  && j < json.totalPages-1){
				    		if(j == json.number){
					    		resPage += "<li class=\"page-item active\">";
				    		}else{
					    		resPage += "<li class=\"page-item\">";
				    		}
			    			
			    			resPage	+= "	<a class=\"page-link\" href='#;return false;' onClick=\"fnSchMyLottoNo("+ (j) +")\">"+ (j+1) +"</a>"
			    					+  "</li>";
	
			    			if(j >= json.number+1 && j < json.totalPages-2){
			    				resPage += "<li class=\"page-item\">"
			    						+  "	<a class=\"page-link disabled\">&#8230;</a>"
			    						+  "</li>";
			    			}
		    			}
			    	}
			    	
			    	//마지막 페이지
    				if(json.number == json.totalPages-1){
    					resPage += "<li class=\"page-item active\">";
    				}else{
				    	resPage += "<li class=\"page-item\">"
    				}
					resPage += "	<a class=\"page-link\" href='#;return false;' onClick=\"fnSchMyLottoNo("+ (json.totalPages-1) +")\">"+ (json.totalPages) +"</a>"
							+  "</li>";
    				
    				//[>>] 페이지
    				resPage += "<li class=\"page-item\">"
		    				+  "	<a class=\"page-link\" href='#;return false;' onClick=\"fnSchMyLottoNo("+ (pageP10) +")\">&raquo;</a>"
		    				+  "</li>";

			    }else{
			    //페이지 5개 이하
			    	for(var k=0; k<json.totalPages; k++){
			    		if(k == json.pageable.pageNumber){
					    	resPage += "<li class=\"page-item active\">"
			    		}else{
					    	resPage += "<li class=\"page-item\">"
			    		}
				    	resPage +=  "	<a class=\"page-link\" href='#;return false;' onClick=\"fnSchMyLottoNo("+ (k) +")\">"+ (k+1) +"</a>"
				    			+   "</li>"
			    	}
			    }
		    	resPage += "</ul>";
		    	
		    	$('#myLottoNoTb2').append(resPage);
            },  
            error : function(xhr, status) {
                alert(xhr + " : " + status);
            }
        });
    }

	//나의 로또 번호 삭제
    function fnDelMyLottoNo(val){
        var formData = new Object();
        formData.no = val;

        $.ajax({
            url : "myLottoNoDel",
            type : 'GET', 
            data : formData,
            dataType: 'text',
            success : function(result) {
            	alert(result);
            	fnSchMyLottoNo();
            },  
            error : function(xhr, status) {
                alert(xhr + " : " + status);
            }
        });
    }
    
    //나의 로또 번호 유효성 체크
    function fnCheckMyLottoNo(){
    	let no1 = document.getElementById("drwtNo1");
    	let no2 = document.getElementById("drwtNo2");
    	let no3 = document.getElementById("drwtNo3");
    	let no4 = document.getElementById("drwtNo4");
    	let no5 = document.getElementById("drwtNo5");
    	let no6 = document.getElementById("drwtNo6");

    	var arr = [];

    	arr.push(no1.value);
    	arr.push(no2.value);
    	arr.push(no3.value);
    	arr.push(no4.value);
    	arr.push(no5.value);
    	arr.push(no6.value);

    	for(var i=0; i<arr.length; i++){
    		if(arr[i] == "" || arr[i].match(/^[0-9]+$/) == null ||  Number(arr[i]) > 45){
    			alert("[번호 " + (i+1) + "] 45이하 숫자를 입력 하세요.");
    			eval("no" + (i+1)).focus();
    			return false;
    		}
    	}
    	
    	for(var i=1; i<arr.length; i++){
    		if([i], arr.slice(i).includes(arr[i-1])){
	    		alert("[번호 "+i+"]가 중복입니다.");
	    		eval("no" + (i)).focus();
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
		<li class="breadcrumb-item">Lotto</li>
		<li class="breadcrumb-item active">
		    <a class="nav-link dropdown-toggle show" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="true">나의 로또 번호</a>
		    <div class="dropdown-menu" style="position: absolute; inset: 0px auto auto 0px; margin: 0px; transform: translate(0px, 42px);" data-popper-placement="bottom-start">
		        <a class="dropdown-item" href="lottoInfoBoard">로또 당첨 번호</a>
		        <a class="dropdown-item active" href="myLottoNo">나의 로또 번호</a>
		        <div class="dropdown-divider"></div>
		        <a class="dropdown-item" href="lottoNoStats">번호별 당첨 통계</a>
		    </div>
		</li>
	</ol>	
		
	<form id="crtLottoNoFm" name="crtLottoNoFm" action="myLottoNoIns" method="GET">
		<div style="margin: 0px 15px 0px 15px;">
			<h4>나의 로또 번호</h4> 
			<table>
				<thead>
					<tr>
						<td><label class="col-form-label mt-4">번호 1</label></td>
						<td><label class="col-form-label mt-4">번호 2</label></td>
						<td><label class="col-form-label mt-4">번호 3</label></td>
						<td><label class="col-form-label mt-4">번호 4</label></td>
						<td><label class="col-form-label mt-4">번호 5</label></td>
						<td><label class="col-form-label mt-4">번호 6</label></td>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><input type="text" id="drwtNo1" name="drwtNo1" class="form-control" type="text"/></td>
						<td><input type="text" id="drwtNo2" name="drwtNo2" class="form-control" type="text"/></td>
						<td><input type="text" id="drwtNo3" name="drwtNo3" class="form-control" type="text"/></td>
						<td><input type="text" id="drwtNo4" name="drwtNo4" class="form-control" type="text"/></td>
						<td><input type="text" id="drwtNo5" name="drwtNo5" class="form-control" type="text"/></td>
						<td><input type="text" id="drwtNo6" name="drwtNo6" class="form-control" type="text"/></td>
					</tr>
				</tbody>
			</table>
			<button type="button" class="btn btn-outline-primary" onClick="fnCrtLottoNo()">랜덤 생성</button>
			<button type="button" class="btn btn-primary" onClick="fnSaveMyLottoNo()">번호 저장</button>
		</div>
	</form>
	
	<form id="myLottoNoFm" name="myLottoNoFm" action="myLottoNoSel" method="GET">
		<div style="margin: 15px 15px 0px 15px;">
			<table id="myLottoNoTb1" class="table table-responsive table-hover">
				<thead>
					<tr>
						<th scope="col">저장일시</th>
						<th scope="col">번호 1</th>
						<th scope="col">번호 2</th>
						<th scope="col">번호 3</th>
						<th scope="col">번호 4</th>
						<th scope="col">번호 5</th>
						<th scope="col">번호 6</th>
						<th scope="col"><button type="button" class="btn btn-outline-primary btn-sm" onClick="fnSchMyLottoNo()">조회</button></th>
					</tr>
				</thead>		
				<tbody>
				</tbody>
			</table>
		</div>
		<div style="margin: 15px 15px 0px 15px;" id="myLottoNoTb2">
		</div>
	</form>
</body>
</html>

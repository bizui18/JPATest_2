<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<link href="https://bootswatch.com/5/zephyr/bootstrap.css" rel="stylesheet">
	<meta name="viewport" content="width=device-width,initial-scale=1.0">
	<title>My Lotto Number</title>
	<style>
		table{
			border-style:solid;
			border-width:1px;
			text-align:center;
			width:700px;
		}
		td{
			border-style:solid;
			border-width:1px;
		}
		
	@media(max-width:600px){
		table{
			border-style:solid;
			border-width:1px;
			text-align:center;
			width:100%;
		}
		td{
			border-style:solid;
			border-width:1px;
		}
	}
	</style>
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
    function fnSchMyLottoNo(){
        var formData = $("#myLottoNoFm")

        $.ajax({
            url : $("#myLottoNoFm").attr('action'),
            type : 'GET', 
            data : formData.serialize(),
            dataType: 'text',
            success : function(result) {
	            let json=JSON.parse(result);
	            let res="";
	            $('#myLottoNoTb2 > tbody').empty();
	            if(json.length > 0){
		            for(let i=0;i<json.length;i++){
		             	res+="<tr id='myLottoNoTr' name='myLottoNoTr' onmouseover=\"this.style.background='#87CEFA'\" onmouseout=\"this.style.background='white'\">"
		                		+"<td width='30%'>"+json[i].crtDate.replace('T',' ')+"</td>"
		                		+"<td width='10%'>"+json[i].drwtNo1+"</td>"
		                		+"<td width='10%'>"+json[i].drwtNo2+"</td>"
		                		+"<td width='10%'>"+json[i].drwtNo3+"</td>"
		                		+"<td width='10%'>"+json[i].drwtNo4+"</td>"
		                		+"<td width='10%'>"+json[i].drwtNo5+"</td>"
		                		+"<td width='10%'>"+json[i].drwtNo6+"</td>"
		                		+"<td width='10%'><input type='button' value='삭제' onClick=\"fnDelMyLottoNo('"+json[i].no+"')\" /></td></tr>";
		            }
	            }else{
	            	res+="<tr id='myLottoNoTr' name='myLottoNoTr'>"
	            			+"<td width='705'>조회된 데이터가 없습니다.</td></tr>";
	            }
			    $('#myLottoNoTb2').append(res);
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
		<li class="breadcrumb-item active">나의 로또 번호</li>
	</ol>	
		
	<form id="crtLottoNoFm" name="crtLottoNoFm" action="myLottoNoIns" method="GET">
		<div style="margin-top:20px;">
		<table>
			<tr>
				<td><input type="button" value="로또 번호 랜덤 생성" onClick="fnCrtLottoNo()"/></td>
			</tr>
		</table>
		</div>
		<div id="crtLottoDiv" style="display:block">
		<table>
			<tr style="background-color:#00BFFF">
				<td width="13%">번호 1</td>
				<td width="13%">번호 2</td>
				<td width="13%">번호 3</td>
				<td width="13%">번호 4</td>
				<td width="13%">번호 5</td>
				<td width="13%">번호 6</td>
				<td rowspan="2"><input type="button" value="번호 저장" onClick="fnSaveMyLottoNo()" /></td>
			</tr>		
			<tr>
				<td width="13%"><input type="text" id="drwtNo1" name="drwtNo1" style="width:85%;text-align:right" value=""/></td>
				<td width="13%"><input type="text" id="drwtNo2" name="drwtNo2" style="width:85%;text-align:right" value=""/></td>
				<td width="13%"><input type="text" id="drwtNo3" name="drwtNo3" style="width:85%;text-align:right" value=""/></td>
				<td width="13%"><input type="text" id="drwtNo4" name="drwtNo4" style="width:85%;text-align:right" value=""/></td>
				<td width="13%"><input type="text" id="drwtNo5" name="drwtNo5" style="width:85%;text-align:right" value=""/></td>
				<td width="13%"><input type="text" id="drwtNo6" name="drwtNo6" style="width:85%;text-align:right" value=""/></td>
			</tr>
		</table>
		</div>
	</form>
	
	<form id="myLottoNoFm" name="myLottoNoFm" action="myLottoNoSel" method="GET">
		<div style="margin-top:20px;display:block">
		<table id="myLottoNoTb1" name="myLottoNoTb1">
			<tr style="background-color:#1E90FF">
				<td colspan="8">나의 로또 번호</td>
			</tr>
			<tr style="background-color:#00BFFF">
				<td width="30%">저장일시</td>
				<td width="10%">번호 1</td>
				<td width="10%">번호 2</td>
				<td width="10%">번호 3</td>
				<td width="10%">번호 4</td>
				<td width="10%">번호 5</td>
				<td width="10%">번호 6</td>
				<td width="10%"><input type="button" value="조회" onClick="fnSchMyLottoNo()" /></td>
			</tr>		
		</table>
		<table id="myLottoNoTb2" name="myLottoNoTb2">
		</table>
		</div>
	</form>

	<form id="lottoInfo" name="lottoInfo" action="lottoInfo" method="POST">
		<div style="margin-top:20px;display:block">
		<input type="submit" value="이전"/>
		</div>
	</form>
	
</body>
</html>

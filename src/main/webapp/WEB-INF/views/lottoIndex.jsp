<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://bootswatch.com/5/zephyr/bootstrap.css" rel="stylesheet">
	<meta name="viewport" content="width=device-width,initial-scale=1.0">
	<title>Home</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://bootswatch.com/_vendor/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script>
	$(document).ready(function(){

		fnSchExptdLottoNoSel()
	});
	
	//로또 번호 조회
    function fnSchExptdLottoNoSel(){
        $.ajax({
            url : 'exptdLottoNoSel',
            type : 'GET', 
            data : '',
            dataType: 'text',
            success : function(result) {
	            let json=JSON.parse(result);
	            
	            var obj_length = Object.keys(json).length;
	            
				let cardColor1, cardColor2, cardColor3, cardColor4, cardColor5, cardColor6;
				
				for(var i=1; i<=Object.keys(json).length; i++){
					if(eval("json.drwtNo"+i) < 11) window["cardColor"+i] = "card text-white bg-warning mb-3";
	            	else if(eval("json.drwtNo"+i) > 10 && eval("json.drwtNo"+i) < 21) window["cardColor"+i] = "card text-white bg-primary mb-3";
	            	else if(eval("json.drwtNo"+i) > 20 && eval("json.drwtNo"+i) < 31) window["cardColor"+i] = "card text-white bg-danger mb-3";
	            	else if(eval("json.drwtNo"+i) > 30 && eval("json.drwtNo"+i) < 41) window["cardColor"+i] = "card bg-light mb-3";
	            	else if(eval("json.drwtNo"+i) > 40 && eval("json.drwtNo"+i) < 51) window["cardColor"+i] = "card text-white bg-success mb-3";

	            	$('#card'+i).attr('class', window["cardColor"+i]); 
		            $('#drwtNo'+i).html(eval("json.drwtNo"+i));
				}
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
	  <li class="breadcrumb-item active">Home</li>
	</ol>	
	
	<form>
		<div style="margin: 0px 15px 0px 15px;">
			<h4>금주 예상 로또 번호</h4> 
			<div id="card1" class="card text-white bg-primary mb-3" style="max-width: 7rem; margin: 50px 20px 0px 0px; float:left;">
				<div class="card-header">1번</div>
				<div class="card-body">
					<h4 class="card-title" id="drwtNo1"></h4>
				 </div>
			</div>	
			<div id="card2" class="card text-white bg-success mb-3" style="max-width: 7rem; margin: 50px 20px 0px 0px; float:left;">
				<div class="card-header">2번</div>
				<div class="card-body">
					<h4 class="card-title" id="drwtNo2"></h4>
				 </div>
			</div>	
			<div id="card3" class="card text-white bg-danger mb-3" style="max-width: 7rem; margin: 50px 20px 0px 0px; float:left;">
				<div class="card-header">3번</div>
				<div class="card-body">
					<h4 class="card-title" id="drwtNo3"></h4>
				 </div>
			</div>	
			<div id="card4" class="card text-white bg-warning mb-3" style="max-width: 7rem; margin: 50px 20px 0px 0px; float:left;">
				<div class="card-header">4번</div>
				<div class="card-body">
					<h4 class="card-title" id="drwtNo4"></h4>
				 </div>
			</div>	
			<div id="card5" class="card text-white bg-info mb-3" style="max-width: 7rem; margin: 50px 20px 0px 0px; float:left;">
				<div class="card-header">5번</div>
				<div class="card-body">
					<h4 class="card-title" id="drwtNo5"></h4>
				 </div>
			</div>	
			<div id="card6" class="card bg-light mb-3" style="max-width: 7rem; margin: 50px 20px 0px 0px; float:left;">
				<div class="card-header">6번</div>
				<div class="card-body">
					<h4 class="card-title" id="drwtNo6"></h4>
				 </div>
			</div>	
		</div>
	</form>
</body>
</html>

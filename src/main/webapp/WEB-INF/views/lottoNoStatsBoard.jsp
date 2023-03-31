<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<link href="/bootstrap/css/bootstrap.css" rel="stylesheet">
	<meta name="viewport" content="width=device-width,initial-scale=1.0">
	<title>Lotto Number States</title>
</head>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://bootswatch.com/_vendor/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.5.0/Chart.min.js"></script>
<script>

	$(document).ready(function(){

		$("#menulottoNoStatsPage").attr('class','dropdown-item active'); 
		$("#menuHome").attr('class','nav-link'); 
		
		fnSchLottoNoStats()
	});
	
	//나의 로또 번호 조회
    function fnSchLottoNoStats(param){

		if(Number($("#schStartDrwNo").val()) > Number($("#schEndDrwNo").val())){
    		alert("조회 마지막 차수가 시작 차수보다 커야 합니다.");
    		return;
    	}
		
        let formData = $("#schLottoNoStatsFm");

        $.ajax({
            url : $("#schLottoNoStatsFm").attr('action'),
            type : 'GET', 
            data : formData.serialize(),
            dataType: 'text',
            success : function(result) {
	            let json=JSON.parse(result);
	            
	            // 수평 바 차트		
	            let labels = [];
	            let data = [];
	            let backgroundColor = [];
	            
	            for(let i=0; i<json.length; i++){
	            	labels[i] = json[i].drwtNo;
	            	data[i] = json[i].cnt;
	            	
	            	if(json[i].drwtNo < 11) backgroundColor[i] = "#fbc400";
	            	else if(json[i].drwtNo > 10 && json[i].drwtNo < 21) backgroundColor[i] = "#69c8f2";
	            	else if(json[i].drwtNo > 20 && json[i].drwtNo < 31) backgroundColor[i] = "#ff7272";
	            	else if(json[i].drwtNo > 30 && json[i].drwtNo < 41) backgroundColor[i] = "#aaa";
	            	else if(json[i].drwtNo > 40 && json[i].drwtNo < 51) backgroundColor[i] = "#b0d840";
	            }
	            
				$('#barChart').remove();
				$('#chartDiv').append('<canvas id="barChart" style="height:400vh; width:100vw"></canvas>');
				
				new Chart(document.getElementById("barChart"), {
				    type: 'horizontalBar',
				    data: {
				      labels: labels,
				      datasets: [
				        {
				          label: "당첨 횟수",
				          backgroundColor: backgroundColor,
				          data: data
				        }
				      ]
				    },
				    options: {
		              scales: {
		                  xAxes: [{
		                  	  maxBarThickness: 200,
		                  	  categoryPercentage: 5.7,
		                      ticks: {
		                          display: true,
		                          min: 0
		                      }
		                  }]
		              },
				      legend: { display: false }
				    }
				});
				
	            // 목록
	            let res="";
	            
	            $('#schLottoNoStatsTb > tbody').empty();
  				if(json.length > 0){
  					for(let j=0; j<json.length; j++){
		             	res += "<tr><td>"+json[j].drwtNo+"</td>"
		                	+  "    <td>"+json[j].cnt+"</td></tr>";
	                }
                }else{
                	res+="<tr><td>조회된 데이터가 없습니다.</td></tr>"
                }
		            
		        $('#schLottoNoStatsTb').append(res);				
	            
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
		<li class="breadcrumb-item">Lotto</li>
		<li class="breadcrumb-item active">
		    <a class="nav-link dropdown-toggle show" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="true">번호별 당첨 통계</a>
		    <div class="dropdown-menu" style="position: absolute; inset: 0px auto auto 0px; margin: 0px; transform: translate(0px, 42px);" data-popper-placement="bottom-start">
		        <a class="dropdown-item" href="lottoInfoBoard">로또 당첨 번호</a>
		        <a class="dropdown-item" href="myLottoNo">나의 로또 번호</a>
		        <div class="dropdown-divider"></div>
		        <a class="dropdown-item active" href="lottoNoStats">번호별 당첨 통계</a>
		    </div>
		</li>		
	</ol>	

	<form id="schLottoNoStatsFm" name="schLottoNoStatsFm" action="lottoNoStatsSel" method="GET">
		<div style="margin: 0px 15px 0px 15px;">
			
			<h4>번호별 로또 당첨 통계</h4>
	        
	        <div class="input-group mb-3" style="margin: 50px 0px 0px 0px;">
	            <input type="text" id="schStartDrwNo" name="schStartDrwNo" style="max-width:fit-content" class="form-control" placeholder="조회 시작 당첨 회차"/> 
	            &nbsp;~&nbsp;
	            <input type="text" id="schEndDrwNo" name="schEndDrwNo" style="max-width:fit-content" class="form-control" placeholder="조회 마지막 당첨 회차"/>
	            <button class="btn btn-primary" type="button" id="schLottoNoStatsBt" onClick="fnSchLottoNoStats()">조회</button>
	        </div>
	        <div id="chartDiv" style="margin: 15px 0px 0px 0px;">
	        	<canvas id="barChart"></canvas>
	        </div>
	        
	        <div style="margin: 30px 0px 0px 0px;">
				<table class="table table-hover" id="schLottoNoStatsTb">
				    <thead>
				        <tr>
				            <th scope="col">번호</th>
				            <th scope="col">당첨 횟수</th>
				        </tr>
				    </thead>
				    <tbody>
				    </tbody>
				</table>
			</div>
			
		</div>
	</form>
</body>
</html>

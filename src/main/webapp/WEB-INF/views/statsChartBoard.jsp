<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<link href="/bootstrap/css/bootstrap.css" rel="stylesheet">
	<meta name="viewport" content="width=device-width,initial-scale=1.0">
	<title>Log Statistics</title>
</head>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://bootswatch.com/_vendor/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.5.0/Chart.min.js"></script>
<script src='https://cdn.plot.ly/plotly-2.11.1.min.js'></script>
<script src='https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.17/d3.min.js'></script>
<script>
	$(document).ready(function(){

		$("#menuChartPage").attr('class','dropdown-item active');
		$("#menuHome").attr('class','nav-link'); 
		$("#menuStatistics").attr('class','nav-link dropdown-toggle active'); 
		
	});
	
	//파일 작업
	function fnLogFile(){
	
		if($("#schLogFilePath").val() == ""){
			alert("경로가 없습니다.");
			return;
		}	
	   
		$("#schLogFilePathBt").attr("disabled", true);
		 
		let formData = $("#schLogFileFm");
        $.ajax({
            url : $("#schLogFileFm").attr('action'),
            type : 'GET', 
            data : formData.serialize(),
            dataType: 'text',
            success : function(result) {
	        	alert(result);
	        	$("#schLogFilePath").val("");
	    		$("#schLogFilePathBt").attr("disabled", false);
	        }
	    	, error : function(xhr, status) {
	        	alert(xhr + " : " + status);
	        	$("#schLogFilePathBt").attr("disabled", false);
	        }
	    });
	}
	
	//통계 조회
    function fnSchStats(param){

        let formData = $("#schStatsFm");

        $.ajax({
            url : $("#schStatsFm").attr('action'),
            type : 'GET', 
            data : formData.serialize(),
            dataType: 'text',
            success : function(result) {
            	let json=JSON.parse(result);

            	var key1Arr = new Array();
            	var key2Arr = new Array();
            	var valArr = new Array();
            	
            	var skKeyArr = new Array();
            	var ktKeyArr = new Array();
            	var lgKeyArr = new Array();
            	
            	var skValArr = new Array();
            	var ktValArr = new Array();
            	var lgValArr = new Array();
            	
            	var ski = 0;
            	var kti = 0;
            	var lgi = 0;
            	
            	for(let i=0; i<json.length; i++){
					
            		valArr[i] = json[i].val;

					if($("#text").val() == "strm1" || $("#text").val() == "strm2" || $("#text").val() == "strm3"){
						var var1 = json[i].key1;
						if("11" == var1){
							var1 = "서울";						
						}else if("12" == var1){
							var1 = "부산";
						}else if("13" == var1){
							var1 = "경기 남부";
						}else if("14" == var1){
							var1 = "강원";
						}else if("15" == var1){
							var1 = "충북";
						}else if("16" == var1){
							var1 = "충남";
						}else if("17" == var1){
							var1 = "전북";
						}else if("18" == var1){
							var1 = "전남";
						}else if("19" == var1){
							var1 = "경북";
						}else if("20" == var1){
							var1 = "경남";
						}else if("21" == var1){
							var1 = "제주";
						}else if("22" == var1){
							var1 = "대구";
						}else if("23" == var1){
							var1 = "인천";
						}else if("24" == var1){
							var1 = "광주";
						}else if("25" == var1){
							var1 = "대전";
						}else if("26" == var1){
							var1 = "울산";
						}else if("28" == var1){
							var1 = "경기 북부";
						}
						key1Arr[i] = var1;
            		}else{
            			key1Arr[i] = json[i].key1 + "년생";
            		}
					
					if($("#text").val() != "strm1" && $("#text").val() != "strm4"){
						var var2 = String(json[i].key2);
						
						if("1002003" == var2){
							var2 = "SKT";
							skValArr[ski] = valArr[i]
							skKeyArr[ski] = key1Arr[i]
							ski++;
						} else if("1002002" == var2){
							var2 = "LGU";
							lgValArr[lgi] = valArr[i]
							lgKeyArr[lgi] = key1Arr[i]
							lgi++;
						} else if("1002001" == var2){
							var2 = "KT";
							ktValArr[kti] = valArr[i]
							ktKeyArr[kti] = key1Arr[i]
							kti++;
						}
						
						key2Arr[i] = var2;
					}
            	}

            	if($("#text").val() == "strm2" || $("#text").val() == "strm5"){
		            var trace1 = {
	         		  x: key1Arr,
	         		  y: key2Arr,
	         		  text: valArr,
	         		  mode: 'markers',
	         		  marker: {
	         		    //color: ['rgb(93, 164, 214)', 'rgb(255, 144, 14)',  'rgb(44, 160, 101)', 'rgb(255, 65, 54)'],
	         		    //opacity: [1, 0.8, 0.6, 0.4],
	         		    size: valArr
	         		  }
	         		};
	
	         		var data = [trace1];
	
	         		var layout = {
	         		  title: $("#text option:selected").text()
	         		  , showlegend: false
	         		  , height: 1200
	         		  //, width: 1200
	         		  , xaxis: {
	         			}
	         		  , yaxis: {
	         			}
	         		};
	         		
         			Plotly.newPlot('myDiv', data, layout);			
         			
            	}else if($("#text").val() == "strm3" || $("#text").val() == "strm6"){
           			var sk = {
       				  x: skKeyArr,
       				  y: skValArr,
       				  name: 'SK',
       				  type: 'bar'
       				};
       				var kt = {
       				  x: ktKeyArr,
       				  y: ktValArr,
       				  name: 'KT',
       				  type: 'bar'
       				};
       				var lg = {
       				  x: lgKeyArr,
       				  y: lgValArr,
       				  name: 'LG',
       				  type: 'bar'
       				 }

       				var data = [sk, kt, lg];
       				var layout = {
       				  //xaxis: {title: '지역'},
       				  yaxis: {title: '사용량'},
       				  barmode: 'relative',
       				  title: $("#text option:selected").text()
       				  , height: 1200
       				};

       				Plotly.newPlot('myDiv', data, layout);
       				
            	}else{
            		var data = [
            			  {
            			    x: key1Arr,
            			    y: valArr,
            			    type: 'bar'
            			  }
            		];

            		var layout = {
      	         		  title: $("#text option:selected").text()
      	         		  , yaxis: {title: '사용량'}
      	         		  , showlegend: false
      	         		  , height: 1200
      	         		  //, width: 1200
      	         	};
            		
            		Plotly.newPlot('myDiv', data, layout);
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
		<li class="breadcrumb-item"><a href="lottoIndex">Home</a></li>
		<li class="breadcrumb-item">Statistics</li>
		<li class="breadcrumb-item">통계</li>
	</ol>
		
	<form id="schLogFileFm" name="schLogFileFm" action="redisFileRead" method="GET">
		<div style="margin: 0px 15px 0px 15px;">
			
			<h4>Log 통계</h4>
	        
	        <div class="input-group mb-3" style="margin: 50px 0px 0px 0px;">
	            <input type="text" id="schLogFilePath" name="schLogFilePath" style="max-width:fit-content" class="form-control" placeholder="로그파일 경로"/> 
	            <button class="btn btn-primary" type="button" id="schLogFilePathBt" name="schLogFilePathBt" onClick="fnLogFile()">로그 적용</button>
	        </div>
		</div>
	</form>
	
	<form id="schStatsFm" name="schStatsFm" action="redisReadStactics" method="GET">
        <div class="input-group mb-3" style="margin: 0px 0px 0px 15px;">
			<select class="form-select" name="text" id="text" style="max-width:fit-content">
			    <option value="strm1">지역 건수</option>
			    <option value="strm2">지역_나이 건수</option>
			    <option value="strm3">지역_통신사 건수</option>
			    <option value="strm4">나이 건수</option>
			    <option value="strm5">나이_기종 건수</option>
			    <option value="strm6">나이_통신사 건수</option>
		    </select>
            <button class="btn btn-primary" type="button" id="schStats" name="schStats" onClick="fnSchStats()">조회</button>
        </div>

        <div id='myDiv'><!-- Plotly chart will be drawn inside this DIV --></div>
	</form>
</body>
</html>

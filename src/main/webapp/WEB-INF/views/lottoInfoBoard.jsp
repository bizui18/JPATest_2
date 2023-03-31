<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<link href="/bootstrap/css/bootstrap.css" rel="stylesheet">
	<meta name="viewport" content="width=device-width,initial-scale=1.0">
	<title>Lotto Info</title>
</head>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://bootswatch.com/_vendor/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script>
	$(document).ready(function(){
		fnSchLottoNo();

		$("#menuLottoInfoPage").attr('class','dropdown-item active'); 
		$("#menuHome").attr('class','nav-link'); 
	});
	
	
	//로또 번호 조회
    function fnSchLottoNo(param){
    	
    	var formData = $("#schLottoInfo");
        
        $.ajax({
            url : "lottoInfoSel",
            type : 'GET', 
            data : formData.serialize() +"&page="+param, 
            dataType: 'text',
            success : function(result) {
            	let json=JSON.parse(result);
	            let res="";
	            
	            // 목록
	            $('#schLottoInfoTb1 > tbody').empty();
  				if(json.content.length > 0){
  					for(let i=0; i<json.content.length; i++){
		             	res += "<tr><td>"+json.content[i].drwNo+"</td>"
		                	+  "    <td>"+json.content[i].drwtNo1+"</td>"
		                	+  "    <td>"+json.content[i].drwtNo2+"</td>"
		                	+  "    <td>"+json.content[i].drwtNo3+"</td>"
		                	+  "    <td>"+json.content[i].drwtNo4+"</td>"
		                	+  "    <td>"+json.content[i].drwtNo5+"</td>"
		                	+  "    <td>"+json.content[i].drwtNo6+"</td>"
		                	+  "    <td>"+json.content[i].bnusNo+"</td>"
		                	+  "    <td>"+json.content[i].drwNoDate+"</td></tr>"
	                }
                }else{
                	res+="<tr><td>조회된 데이터가 없습니다.</td></tr>"
                }
		            
		        $('#schLottoInfoTb1').append(res);
		        
		        
			    // 페이징
			    $('#schLottoInfoTb2').empty();

			    let pageP10 = json.number + 10;
			    if(json.totalPages-1 < pageP10) pageP10 = json.totalPages-1
			    
			    let pageM10 = json.number - 10;
			    if( 0 > pageM10) pageM10 = 0;
			    
			    let resPage = "<ul class=\"pagination\">";
			    
			    if(json.totalPages > 5){
			    //페이지 6개 이상
			    	//[<<] 페이지
			    	resPage += "<li class=\"page-item\">"
			    			+  "	<a class=\"page-link\" href='#;return false;' onClick=\"fnSchLottoNo("+ (pageM10) +")\">&laquo;</a>"
			    			+  "</li>";
			    	
			    	//첫번째 페이지
			    	if(json.number == 0){
			    		resPage += "<li class=\"page-item active\">";
			    	}else{
			    		resPage += "<li class=\"page-item\">";
			    	}
		    		resPage	+= "	<a class=\"page-link\" href='#;return false;' onClick=\"fnSchLottoNo("+ (0) +")\">"+ (1) +"</a>"
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
			    			
			    			resPage	+= "	<a class=\"page-link\" href='#;return false;' onClick=\"fnSchLottoNo("+ (j) +")\">"+ (j+1) +"</a>"
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
					resPage += "	<a class=\"page-link\" href='#;return false;' onClick=\"fnSchLottoNo("+ (json.totalPages-1) +")\">"+ (json.totalPages) +"</a>"
							+  "</li>";
    				
    				//[>>] 페이지
    				resPage += "<li class=\"page-item\">"
		    				+  "	<a class=\"page-link\" href='#;return false;' onClick=\"fnSchLottoNo("+ (pageP10) +")\">&raquo;</a>"
		    				+  "</li>";

			    }else{
			    //페이지 5개 이하
			    	for(var k=0; k<json.totalPages; k++){
			    		if(k == json.pageable.pageNumber){
					    	resPage += "<li class=\"page-item active\">"
			    		}else{
					    	resPage += "<li class=\"page-item\">"
			    		}
				    	resPage +=  "	<a class=\"page-link\" href='#;return false;' onClick=\"fnSchLottoNo("+ (k) +")\">"+ (k+1) +"</a>"
				    			+   "</li>"
			    	}
			    }
		    	resPage += "</ul>";
		    	
		    	$('#schLottoInfoTb2').append(resPage);
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
		    <a class="nav-link dropdown-toggle show" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="true">로또 당첨 번호</a>
		    <div class="dropdown-menu" style="position: absolute; inset: 0px auto auto 0px; margin: 0px; transform: translate(0px, 42px);" data-popper-placement="bottom-start">
		        <a class="dropdown-item active" href="lottoInfoBoard">로또 당첨 번호</a>
		        <a class="dropdown-item" href="myLottoNo">나의 로또 번호</a>
		        <div class="dropdown-divider"></div>
		        <a class="dropdown-item" href="lottoNoStats">번호별 당첨 통계</a>		        
		    </div>
		</li>		
	</ol>	
		
	<form id="schLottoInfo" name="schLottoInfo" method="GET" onsubmit="return false;" >
		<div style="margin: 0px 15px 0px 15px;">
			<h4>로또 당첨 번호</h4> 
	        <div class="input-group mb-3" style="margin: 50px 0px 0px 0px;">
	            <input type="text" id="schDrwNo" name="schDrwNo" style="max-width:fit-content" class="form-control" placeholder="당첨 회차"/>
	            <button class="btn btn-primary" type="button" id="schLottoInfoBt" onClick="fnSchLottoNo()">조회</button>
	        </div>
			<table id="schLottoInfoTb1" class="table table-responsive table-hover">
				<thead>
					<tr>
						<th scope="col">회차</th>
						<th scope="col">번호 1</th>
						<th scope="col">번호 2</th>
						<th scope="col">번호 3</th>
						<th scope="col">번호 4</th>
						<th scope="col">번호 5</th>
						<th scope="col">번호 6</th>
						<th scope="col">보너스 번호</th>
						<th scope="col">추첨일자</th>
					</tr>
				</thead>		
				<tbody>
				</tbody>			
			</table>
		</div>
		<div style="margin: 15px 15px 0px 15px;" id="schLottoInfoTb2">
		</div>		
	</form>	
</body>
</html>

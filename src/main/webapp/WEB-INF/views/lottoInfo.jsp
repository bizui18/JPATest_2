<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width,initial-scale=1.0">
	<title>LottoInfo</title>
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
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>

	//로또 번호 조회
    function fnSchLottoNo(){
        var formData = $("#schLottoInfoFm")
        
        $.ajax({
            url : $("#schLottoInfoFm").attr('action'),
            type : 'GET', 
            data : formData.serialize(), 
            dataType: 'text',
            success : function(result) {
            	let json=JSON.parse(result);
	            let res="";

	            $('#schLottoInfoTb2 > tbody').empty();
  
  				if(json.drwtNo1 != ""){
	             	res+="<tr id='schLottoInfoTr' name='schLottoInfoTr'>"
	                		+"<td width='10%'>"+json.drwNo+"</td>"
	                		+"<td width='10%'>"+json.drwtNo1+"</td>"
	                		+"<td width='10%'>"+json.drwtNo2+"</td>"
	                		+"<td width='10%'>"+json.drwtNo3+"</td>"
	                		+"<td width='10%'>"+json.drwtNo4+"</td>"
	                		+"<td width='10%'>"+json.drwtNo5+"</td>"
	                		+"<td width='10%'>"+json.drwtNo6+"</td>"
	                		+"<td width='15%'>"+json.bnusNo+"</td>"
	                		+"<td width='15%'>"+json.drwNoDate+"</td>"
                }else{
                	res+="<tr id='schLottoInfoTr' name='schLottoInfoTr'>"
                			+"<td width='738'>조회된 데이터가 없습니다.</td>"
                }
		            
		        $('#schLottoInfoTb2').append(res);
            },  
            error : function(xhr, status) {
                alert(xhr + " : " + status);
            }
        });
    }

	//최근 회차 로또 당첨 번호 탑6 조회
    function fnSchTop6LottoNo(){
        var formData = $("#schTop6LottoNoFm")
        
        $.ajax({
            url : $("#schTop6LottoNoFm").attr('action'),
            type : 'GET', 
            data : formData.serialize(), 
            dataType: 'text',
            success : function(result) {
	            let json=JSON.parse(result);
	            let res="";

	            $('#schTop6LottoNoTb2 > tbody').empty();
	            
	            if(json.length > 0){
	            	res+="<tr id='schTop6LottoNoTr' name='schTop6LottoNoTr'>"
		            
		            for(let i=0;i<json.length;i++){
		             	res+="<td width='70'>"+ json[i].drwtNo +"<br>("+ json[i].cnt +"회)</td>";
		            }
		            
		            res+="</tr>"
	            }else{
	            	res+="<tr id='schTop6LottoNoTr' name='schTop6LottoNoTr'>"
	            			+"<td width='705'>조회된 데이터가 없습니다.</td></tr>";
	            }
			    $('#schTop6LottoNoTb2').append(res);
            },  
            error : function(xhr, status) {
                alert(xhr + " : " + status);
            }
        });
    }
	
</script>
<body>
	<form name="lottoInfoFm" id="lottoInfoFm" action="lottoInfo">
		<div style="margin-top:20px;">
		<table>
			<tr style="background-color:#1E90FF">
				<td colspan="9" >최근 5개 회차 로또 당첨 번호</td>
			</tr>
			<tr style="background-color:#00BFFF">
				<td width="70">회차</td>
				<td width="70">번호 1</td>
				<td width="70">번호 2</td>
				<td width="70">번호 3</td>
				<td width="70">번호 4</td>
				<td width="70">번호 5</td>
				<td width="70">번호 6</td>
				<td width="100">보너스 번호</td>
				<td width="100">추첨 일자</td>
			</tr>
			<c:forEach var="item" items="${rstListMap}">
			<tr onmouseover="this.style.background='#87CEFA'" onmouseout="this.style.background='white'">
				<td>${item.drwNo}</td>
				<td>${item.drwtNo1}</td>
				<td>${item.drwtNo2}</td>
				<td>${item.drwtNo3}</td>
				<td>${item.drwtNo4}</td>
				<td>${item.drwtNo5}</td>
				<td>${item.drwtNo6}</td>
				<td>${item.bnusNo}</td>
				<td>${item.drwNoDate}</td>
			</tr>
			</c:forEach>
		</table>
		</div>
	</form>
	
	<form name="schLottoInfoFm" id="schLottoInfoFm" action="schLottoInfo">		
		<div style="margin-top:20px;">
		<table>
			<tr style="background-color:#1E90FF">
				<td width="60%">로또 당첨 회차 조회</td>
				<td width="30%"><input type="text" name="schDrwNo" style="width:90%;text-align:right" value="${drwNo}"/></td>
				<td width="10%"><input type="button" value="조회" onClick="fnSchLottoNo()" /></td>
			</tr>
		</table>
		<table>
			<tr style="background-color:#00BFFF">
				<td width="10%">회차</td>
				<td width="10%">번호 1</td>
				<td width="10%">번호 2</td>
				<td width="10%">번호 3</td>
				<td width="10%">번호 4</td>
				<td width="10%">번호 5</td>
				<td width="10%">번호 6</td>
				<td width="15%">보너스 번호</td>
				<td width="15%">추첨 일자</td>
			</tr>
		</table>
		<table id="schLottoInfoTb2" name="schLottoInfoTb2">		
			<tr>
				<td width="10%">${drwNo}</td>
				<td width="10%">${drwtNo1}</td>
				<td width="10%">${drwtNo2}</td>
				<td width="10%">${drwtNo3}</td>
				<td width="10%">${drwtNo4}</td>
				<td width="10%">${drwtNo5}</td>
				<td width="10%">${drwtNo6}</td>
				<td width="15%">${bnusNo}</td>
				<td width="15%">${drwNoDate}</td>
			</tr>
		</table>
		</div>
	</form>
	
		
	<form>		
		<div style="margin-top:20px;">
		<table>
			<tr style="background-color:#1E90FF">
				<td colspan="6">로또 당첨 번호 탑6</td>
			</tr>
			<tr style="background-color:#00BFFF">
				<td width="70">Top 1</td>
				<td width="70">Top 2</td>
				<td width="70">Top 3</td>
				<td width="70">Top 4</td>
				<td width="70">Top 5</td>
				<td width="70">Top 6</td>
			</tr>
		</table>
		<table>		
			<tr>
				<c:forEach var="item" items="${topNo}">
					<td width="70">${item.drwtNo}<br>(${item.cnt}회)</td>
				</c:forEach>			
			</tr>
		</table>
		</div>
	</form>

	<form name="schTop6LottoNoFm" id="schTop6LottoNoFm" action="schTop6LottoNo">		
		<div style="margin-top:20px;">
		<table>
			<tr style="background-color:#1E90FF">
				<td width="60%">최근 회차 로또 당첨 번호 탑6</td>
				<td width="30%"><input type="text" name="schDrwNo" style="width:90%;text-align:right" value="${drwNo}"/></td>
				<td width="10%"><input type="button" value="조회" onClick="fnSchTop6LottoNo()" /></td>
			</tr>
		</table>
		<table>
			<tr style="background-color:#00BFFF">
				<td width="70">Top 1</td>
				<td width="70">Top 2</td>
				<td width="70">Top 3</td>
				<td width="70">Top 4</td>
				<td width="70">Top 5</td>
				<td width="70">Top 6</td>
			</tr>
		</table>
		<table id="schTop6LottoNoTb2" name="schTop6LottoNoTb2">		
			<tr>
				<c:forEach var="item" items="${topNo}">
					<td width="70">${item.drwtNo}<br>(${item.cnt}회)</td>
				</c:forEach>			
			</tr>
		</table>
		</div>
	</form>	
	
	<form id="myLottoNoPage" name="myLottoNoPage" action="myLottoNoPage" method="POST">
		<div style="margin-top:20px;display:block">
		<input type="submit" value="나의 로또 번호 조회 페이지 이동"/>
		</div>
	</form>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <link href="https://bootswatch.com/5/zephyr/bootstrap.css" rel="stylesheet">
</head>

<body>
	<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
	    <div class="container-fluid">
	        <a class="navbar-brand" href="lottoIndex">TEST Page</a>
	        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarColor01" aria-controls="navbarColor01" aria-expanded="false" aria-label="Toggle navigation">
	            <span class="navbar-toggler-icon"></span>
	        </button>
	        <div class="collapse navbar-collapse" id="navbarColor01">
	            <ul class="navbar-nav me-auto">
	                <li class="nav-item">
	                    <a class="nav-link active" id="menuHome" href="lottoIndex">Home</a>
	                </li>
	                <li class="nav-item dropdown">
	                    <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">Lotto</a>
	                    <div class="dropdown-menu" id="menuLotto">
	                        <a class="dropdown-item" id="menuLottoInfoPage" href="lottoInfoBoard">로또 당첨 정보</a>
	                        <a class="dropdown-item" id="menuMylottoNoPage" href="myLottoNo">나의 로또 번호</a>
	                        <div class="dropdown-divider"></div>
	                        <a class="dropdown-item" id="menulottoNoStatsPage" href="lottoNoStats">번호별 당첨 통계</a>
	                    </div>
	                </li>
	                <li class="nav-item dropdown">
	                    <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">Excel</a>
	                    <div class="dropdown-menu" id="menuExcel">
	                        <a class="dropdown-item" id="menuDailyReportExcelPage" href="dailyReportExcel">일일보고서 엑셀 작업</a>
	                    </div>
	                </li>
	                <li class="nav-item dropdown">
	                    <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">API</a>
	                    <div class="dropdown-menu" id="menuTest">
	                        <a class="dropdown-item" id="menuAPISendTestBoard" href="apiSendTestBoard">API 전송 테스트</a>
	                        <a class="dropdown-item" id="menuEncDecPage" href="encDecBoard">암복호화</a>
	                    </div>
	                </li>
	                <li class="nav-item dropdown">
	                    <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">Statistics</a>
	                    <div class="dropdown-menu" id="menuStats">
	                        <a class="dropdown-item" id="menuChart" href="statsChartBoard">차트</a>
	                    </div>
	                </li>
	                <li class="nav-item dropdown">
	                    <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">Chat</a>
	                    <div class="dropdown-menu" id="menuChatRoom">
	                        <a class="dropdown-item" id="menuChat" href="chatRoomBoard">채팅</a>
	                    </div>
	                </li>
	            </ul>
	        </div>
	    </div>
	</nav>
</body>

</html>
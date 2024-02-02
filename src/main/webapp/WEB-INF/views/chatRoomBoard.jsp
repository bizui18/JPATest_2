<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<link href="/bootstrap/css/bootstrap.css" rel="stylesheet">
	<meta name="viewport" content="width=device-width,initial-scale=1.0">
	<title>Chat Room</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css"
          integrity="sha384-GJzZqFGwb1QTTN6wy59ffF1BuGJpLSa9DkKMp0DgiMDm4iYMj70gZWKYbI706tWS" crossorigin="anonymous">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js" integrity="sha384-wHAiFfRlMFy6i5SRaxvfOCifBUQy1xHdJ/yoi7FRNXMRBu5WHdZYu1hA6ZOblgut" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js" integrity="sha384-B0UglyR+jN6CkvvICOB2joaf5I4l3gm9GU6Hc1og6Ls7i6U/mkkaduKaBhlAXv9k" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="/css/chatroom/main.css"/>
    <style>
        #menu{
            width: 310px;
        }
        button#uploadFile {
            margin-left: 225px;
            margin-top: -55px;
        }
        input {
            padding-left: 5px;
            outline: none;
            width: 250px;
            margin-top: 15px;
        }
        .btn fa fa-download {
            background-color: DodgerBlue;
            border: none;
            color: white;
            padding: 12px 30px;
            cursor: pointer;
            font-size: 20px;
        }

        .input-group{width:80.5%}
        .chat-container{position: relative;}
        .chat-container .btn-group{position:absolute; bottom:-12px; right:-50px; transform: translate(-50%,-50%);}
    </style>	
</head>

<script src="https://use.fontawesome.com/releases/v5.2.0/js/all.js"></script>
<script src="https://bootswatch.com/_vendor/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.4/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$("#menuChat").attr('class','dropdown-item active'); 
		$("#menuHome").attr('class','nav-link'); 
	});


</script>
<body>
	<%@ include file="/WEB-INF/views/includes/top.jsp" %>

	<ol class="breadcrumb">
		<li class="breadcrumb-item"><a href="lottoIndex">Home</a></li>
		<li class="breadcrumb-item">Chat</li>
		<li class="breadcrumb-item">채팅</li>
	</ol>


	<div id="username-page">
		<div class="username-page-container">
			<h1 class="title">Type your username</h1>
			<form id="usernameForm" name="usernameForm">
				<input type="text" id="name" placeholder="Username" autocomplete="off" class="form-control" />
				<div class="form-group">
					<button type="submit" class="accent username-submit">Start Chatting</button>
				</div>
			</form>
		</div>
	</div>

	<div id="chat-page" class="hidden">
		<div class="btn-group dropend">
			<button class="btn btn-secondary dropdown-toggle" type="button"
				id="showUserListButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">참가한 유저</button>
			<div id="list" class="dropdown-menu" aria-labelledby="showUserListButton"></div>
		</div>
		<div class="chat-container">
			<div class="chat-header">
				<h2>[Chat Room]</h2>
			</div>
			<div class="connecting">Connecting...</div>
			<ul id="messageArea">

			</ul>
			<form id="messageForm" name="messageForm" nameForm="messageForm">
				<div class="form-group">
					<div class="input-group clearfix">
						<input type="text" id="message" placeholder="Type a message..." autocomplete="off" class="form-control" />
						<button type="submit" class="primary">Send</button>
					</div>
				</div>
			</form>
		</div>
	</div>
<script type="text/javascript">
	var usernamePage = document.querySelector('#username-page');
	var chatPage = document.querySelector('#chat-page');
	var usernameForm = document.querySelector('#usernameForm');
	var messageForm = document.querySelector('#messageForm');
	var messageInput = document.querySelector('#message');
	var messageArea = document.querySelector('#messageArea');
	var connectingElement = document.querySelector('.connecting');
	
	var stompClient = null;
	var username = null;
	
	var colors = [
	    '#2196F3', '#32c787', '#00BCD4', '#ff5652',
	    '#ffc107', '#ff85af', '#FF9800', '#39bbb0'
	];
	
	// roomId 파라미터 가져오기
	const url = new URL(location.href).searchParams;
	//const roomId = url.get('roomId');
	const roomId = "roomId";
	
	function connect(event) {
	    username = document.querySelector('#name').value.trim();
	    if (username === '' || !username) {
	        event.preventDefault();
	        return;
	    }
	    // username 중복 확인
	    username = isDuplicateName(username);
	    
	    // usernamePage 에 hidden 속성 추가해서 가리고
	    // chatPage 를 등장시킴
	    usernamePage.classList.add('hidden');
	    chatPage.classList.remove('hidden');
	
	    // 연결하고자하는 Socket 의 endPoint
	    var socket = new SockJS('/ws-stomp');
	    stompClient = Stomp.over(socket);
	
	    stompClient.connect({}, onConnected, onError);
	    event.preventDefault();
	}
	
	function onConnected() {
	    // sub 할 url => /sub/chat/room/roomId 로 구독한다
	    stompClient.subscribe('/sub/chat/room/' + roomId, onMessageReceived);
	
	    // 서버에 username 을 가진 유저가 들어왔다는 것을 알림
	    // /pub/chat/enterUser 로 메시지를 보냄
	    stompClient.send("/pub/chat/enterUser",
	        {},
	        JSON.stringify({
	            "roomId": roomId,
	            sender: username,
	            type: 'ENTER'
	        })
	    )
	
	    //fileUtil.init();
	    connectingElement.classList.add('hidden');
	
	}
	
	// 유저 리스트 받기
	// ajax 로 유저 리스를 받으며 클라이언트가 입장/퇴장 했다는 문구가 나왔을 때마다 실행된다.
	function getUserList() {
	    const $list = $("#list");
	
	    let url = '/chat/userlist';
	    let data = {
	        "roomId": "roomId"
	    }
	
	    let successCallback = function(data){
	        var users = "";
	        for (let i = 0; i < data.length; i++) {
	            //console.log("data[i] : "+data[i]);
	            users += "<li class='dropdown-item'>" + data[i] + "</li>"
	        }
	        $list.html(users);
	    }
	
	    let errorCallback = function(error){
	        console.error(error)
	    }
	
	    //$.ajax(url, 'GET', '', data, successCallback, errorCallback);
	    $.ajax({
	        url:url,
	        type:'GET',
	        data:data,
	        success:successCallback,
	        error:errorCallback
	    });
	}
	
	//유저 닉네임 중복 확인
	function isDuplicateName(username) {
		//console.log("[isDuplicateName] username:", username);
	    let url = '/chat/duplicateName';
	    let data = {
	        "username": username,
	        "roomId": "roomId"
	    }
	
	    let successCallback = function(data){
	        username = data;
	    }
	
	    let errorCallback = function(error){
	        console.error(error)
	    }
	
	    //ajax(url, 'GET', '', data, successCallback, errorCallback);
	    $.ajax({
	        url:url,
	        type:'GET',
	        data:data,
	        async: false,
	        success:successCallback,
	        error:errorCallback
	    });
	    
	    //console.log("함수 동작 확인 : " + username);
		return username;
	}
	
	function onError(error) {
	    connectingElement.textContent = 'Could not connect to WebSocket server. Please refresh this page to try again!';
	    connectingElement.style.color = 'red';
	}
	
	// 메시지 전송때는 JSON 형식을 메시지를 전달한다.
	function sendMessage(event) {
	    var messageContent = messageInput.value.trim();
	
	    if (messageContent && stompClient) {
	        var chatMessage = {
	            "roomId": roomId,
	            sender: username,
	            message: messageInput.value,
	            type: 'TALK'
	        };
	
	        stompClient.send("/pub/chat/sendMessage", {}, JSON.stringify(chatMessage));
	        messageInput.value = '';
	    }
	    event.preventDefault();
	}
	
	// 메시지를 받을 때도 마찬가지로 JSON 타입으로 받으며,
	// 넘어온 JSON 형식의 메시지를 parse 해서 사용한다.
	function onMessageReceived(payload) {
	    console.log("payload 들어오냐? :"+payload);
	    var chat = JSON.parse(payload.body);
	
	    var messageElement = document.createElement('li');
	
	    if (chat.type === 'ENTER') {  // chatType 이 enter 라면 아래 내용
	        messageElement.classList.add('event-message');
	        chat.content = chat.sender + chat.message;
	        getUserList();
	
	    } else if (chat.type === 'LEAVE') { // chatType 가 leave 라면 아래 내용
	        messageElement.classList.add('event-message');
	        chat.content = chat.sender + chat.message;
	        getUserList();
	
	    } else { // chatType 이 talk 라면 아래 내용
	        messageElement.classList.add('chat-message');
	
	        var avatarElement = document.createElement('i');
	        var avatarText = document.createTextNode(chat.sender[0]);
	        avatarElement.appendChild(avatarText);
	        avatarElement.style['background-color'] = getAvatarColor(chat.sender);
	
	        messageElement.appendChild(avatarElement);
	
	        var usernameElement = document.createElement('span');
	        var usernameText = document.createTextNode(chat.sender);
	        usernameElement.appendChild(usernameText);
	        messageElement.appendChild(usernameElement);
	    }
	
	    var contentElement = document.createElement('p');
	    // 만약 minioDataUrl 의 값이 null 이 아니라면 => chat 내용이 파일 업로드와 관련된 내용이라면
	    // img 를 채팅에 보여주는 작업
	    if(chat.file != null){
	        const file = chat.file;
	        var imgElement = document.createElement('img');
	        imgElement.setAttribute("src", file.minioDataUrl);
	        imgElement.setAttribute("width", "300");
	        imgElement.setAttribute("height", "300");
	
	        var downBtnElement = document.createElement('button');
	        downBtnElement.setAttribute("class", "btn fa fa-download");
	        downBtnElement.setAttribute("id", "downBtn");
	        downBtnElement.setAttribute("name", file.fileName);
	
	        downBtnElement.addEventListener('click', function() {
	            fileUtil.downloadFile(file.fileName, file.filePath);
	        });
	
	        contentElement.appendChild(imgElement);
	        contentElement.appendChild(downBtnElement);
	
	    }else{
	        // 만약 minioDataUrl 의 값이 null 이라면
	        // 이전에 넘어온 채팅 내용 보여주기기
	       var messageText = document.createTextNode(chat.message);
	        contentElement.appendChild(messageText);
	    }
	
	    messageElement.appendChild(contentElement);
	
	    messageArea.appendChild(messageElement);
	    messageArea.scrollTop = messageArea.scrollHeight;
	}
	
	
	function getAvatarColor(messageSender) {
	    var hash = 0;
	    for (var i = 0; i < messageSender.length; i++) {
	        hash = 31 * hash + messageSender.charCodeAt(i);
	    }
	
	    var index = Math.abs(hash % colors.length);
	    return colors[index];
	}
	
	usernameForm.addEventListener('submit', connect, true);
	messageForm.addEventListener('submit', sendMessage, true);	
</script>
</body>
</html>

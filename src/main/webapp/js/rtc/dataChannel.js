/**
 * DataChannel 을 다루기 위한 js
 */
let chanId = 0;

const dataChannel = {
    user : null,
    init: function() {
        // 핸들러들을 바인딩하여 'this'가 항상 dataChannel 객체를 참조하도록 보장하기 위함
        this.handleDataChannelOpen = this.handleDataChannelOpen.bind(this);
        this.handleDataChannelClose = this.handleDataChannelClose.bind(this);
        this.handleDataChannelMessageReceived = this.handleDataChannelMessageReceived.bind(this);
        this.handleDataChannelError = this.handleDataChannelError.bind(this);
    },
    initDataChannelUser : function(user) {
        this.user = user;
    },
    isNullOrUndefined : function(value) {
        return value === null || value === undefined;
    },
    getChannelName : function() {
        return chanId++;
    },
    handleDataChannelOpen: function(event)  {
        if (this.isNullOrUndefined(event)) return;
        // console.log("dataChannel.OnOpen", event);
        this.sendMessage("등장!!")
    },
    handleDataChannelMessageReceived: function(event) { // datachannel 메시지 받는 부분
        if (this.isNullOrUndefined(event)) return;
        // console.log("dataChannel.OnMessage:", event);
        let recvMessage = JSON.parse(event.data);

        if (recvMessage.type === "file") {
            let file = recvMessage.fileMeta;

            // 파일 메시지 처리
            console.log("Received file:", file.fileName);

            let sendUser = recvMessage.userName;
            let message = sendUser + " 님이 파일을 업로드하였습니다";

            this.showNewMessage(message, 'other');
            this.showNewFileMessage(file, 'other');

        } else {
            // 일반 메시지 처리
            let message = recvMessage.userName + " : " + recvMessage.message;
            this.showNewMessage(message, "other");
        }
    },
    handleDataChannelError: function(error) {
        if (this.isNullOrUndefined(error)) return;
        console.error("dataChannel.OnError:", error);
    },
    handleDataChannelClose: function(leaveEvent, event) {
        if (this.isNullOrUndefined(event)) return;
        // console.log("dataChannel.OnClose", event);
    },
    sendMessage: function(message) {
        if (this.isNullOrUndefined(message)) return;
        let messageData = {
            type : "message",
            userName : this.user.name,
            message : message
        }

        this.user.rtcPeer.send(JSON.stringify(messageData));
    },
    sendFileMessage : function(fileMeta){
        fileMeta.userName = this.user.name;
        this.user.rtcPeer.send(JSON.stringify(fileMeta));
        this.showNewFileMessage(fileMeta.fileMeta, 'self');
    },
    showNewMessage: function(recvMessage, type) {
        // TODO 이거는 datachannelChatting 으로 넘어가야하는거...? 고민할것! => 넘어가는게 맞는듯ㅠ
        // 기본은 '나'가 보낸것
        type = type === undefined ? 'self' : type;

        if (type === 'self') {
            if (!recvMessage) return;

            dataChannelChatting.$messagesContainer.append([
                '<li class="self">',
                recvMessage,
                '</li>'
            ].join(''));

            this.sendMessage(recvMessage);

            // clean out old message
            dataChannelChatting.$userTextInput.html('');

            // focus on input
            dataChannelChatting.$userTextInput.focus();

            dataChannelChatting.$messagesContainer.finish().animate({
                scrollTop: dataChannelChatting.$messagesContainer.prop("scrollHeight")
            }, 250);

        } else {
            dataChannelChatting.$messagesContainer.append([
                '<li class="other">',
                recvMessage,
                '</li>'
            ].join(''));
        }
    },
    showNewFileMessage : function(file, type){

        // 이미지 요소 생성 및 설정
        var imgElement = $('<img>', {
            src: file.minioDataUrl,
            width: 300,
            height: 300
        });
        imgElement.addClass(type);

        // 다운로드 버튼 요소 생성 및 설정
        var downBtnElement = $('<button>', {
            class: 'btn fa fa-download',
            id: 'downBtn',
            name: file.fileName
        }).on('click', function() {
            dataChannelFileUtil.downloadFile(file.fileName, file.filePath);
        });

        // contentElement 생성
        var contentElement = $('<li>').append(imgElement, downBtnElement);
        contentElement.addClass(type);

        // $messagesContainer에 contentElement 추가
        dataChannelChatting.$messagesContainer.append(contentElement);
    }
}
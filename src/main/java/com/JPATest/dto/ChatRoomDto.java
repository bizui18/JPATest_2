package com.JPATest.dto;

import java.util.HashMap;
import java.util.UUID;

import lombok.Data;

/**
 * @desc 는 문자 채팅 방을 위한 dto 클래
 */
// Stomp 를 통해 pub/sub 를 사용하면 구독자 관리가 알아서 된다!!
// 따라서 따로 세션 관리를 하는 코드를 작성할 필도 없고,
// 메시지를 다른 세션의 클라이언트에게 발송하는 것도 구현 필요가 없다!
@Data
public class ChatRoomDto {
    private String roomId; // 채팅방 아이디
    private String roomName; // 채팅방 이름 
    private long userCount = 0; // 채팅방 인원수

    private HashMap<String, String> userlist = new HashMap<String, String>();

    public ChatRoomDto create(String roomName){
        ChatRoomDto chatRoom = new ChatRoomDto();
        //chatRoom.roomId = UUID.randomUUID().toString();
        chatRoom.roomId = "roomId";
        chatRoom.roomName = roomName;

        return chatRoom;
    }

}

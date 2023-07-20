package com.JPATest.util.cipher.seed;

import java.io.UnsupportedEncodingException;

import org.springframework.beans.factory.annotation.Value;

import com.JPATest.util.cipher.base64.Base64;
import com.JPATest.util.cipher.padding.BlockPadding;
import com.JPATest.util.comp.GlobalStaticValue;

public class Seed128ByKisa {
	private static final int SEED_BLOCK_SIZE = 16;
//	private static final byte bszIV[] = GlobalStaticValue.bszIV.getBytes();
	private static final byte bszIV[] = "t.mobilelcnse.iv".getBytes();

	public static String encryptCBC(String data, String key)
			throws UnsupportedEncodingException {
		return encryptCBC(data, key, "UTF-8");
	}
	
	public static String encryptCBC(String data, String key, String charset)
			throws UnsupportedEncodingException {
		
		byte[] pData = null;
		if( charset == null ) {
			pData = data.getBytes();
		} else {
			pData = data.getBytes(charset);
		}
		
		//data의 byte 길이를 16(SEED_BLOCK_SIZE) 으로 나누었을 때 나머지가 1인 데이터일 경우에만 복호화시 끝부분에 □□□□□□□□□□□□□□□ 의 깨짐문자 포함현상 발생
//		byte[] pData = null;
//		if( charset == null ) {
//			pData = BlockPadding.getInstance().addPadding(data.getBytes(), SEED_BLOCK_SIZE);
//		} else {
//			pData = BlockPadding.getInstance().addPadding(data.getBytes(charset), SEED_BLOCK_SIZE);
//		}
		
		byte[] encdata = KISA_SEED_CBC.SEED_CBC_Encrypt(key.getBytes(), bszIV, pData, 0, pData.length);
		
		return Base64.toString(encdata);
	}
	
	public static String decryptCBC(String data, String key) throws UnsupportedEncodingException {
		return decryptCBC(data, key, "UTF-8");
	}
	
	public static String decryptCBC(String data, String key, String charset)
			throws UnsupportedEncodingException {
		
		byte[] decryptByte = Base64.toByte(data);
		byte[] decrypt=  KISA_SEED_CBC.SEED_CBC_Decrypt(key.getBytes(), bszIV, decryptByte, 0, decryptByte.length);
		
		if( charset == null ) {
			return new String(BlockPadding.getInstance().removePadding(decrypt, SEED_BLOCK_SIZE));
		} else {
			return new String(BlockPadding.getInstance().removePadding(decrypt, SEED_BLOCK_SIZE), charset);
		}
	}
}

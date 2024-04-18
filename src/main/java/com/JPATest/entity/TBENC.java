package com.JPATest.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@ToString
@Getter
@Entity
@Table(name = "TB_ENC")
public class TBENC {
	static JSONParser parser = new JSONParser();
	@Id
	@Column
	private String enc;

	@Builder
	public TBENC(String enc) {
		super();
		this.enc = enc;
	}
	
}

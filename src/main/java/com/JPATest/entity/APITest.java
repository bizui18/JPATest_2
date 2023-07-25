package com.JPATest.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@ToString
@Getter
@Entity
@Table(name = "API_TEST_URL")
public class APITest {
	@Id
	@Column(length = 100)
	private String targetUrl;
	
	@Column(length = 200)
	private String urlAcnt;
	
	@Column(length = 300)
	private String jsonData;
	
	@Builder
	public APITest(String targetUrl, String urlAcnt, String jsonData) {
		this.targetUrl = targetUrl;
		this.urlAcnt = urlAcnt;
		this.jsonData = jsonData;
	}
}
package com.JPATest.entity;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@ToString
@Getter
@Entity
@AllArgsConstructor
@Table(name = "MY_LOTTO_NO")
public class MyLottoNo {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int no;
	
	@Column(length = 2)
	private String drwtNo1;
	
	@Column(length = 2)
	private String drwtNo2;
	
	@Column(length = 2)
	private String drwtNo3;
	
	@Column(length = 2)
	private String drwtNo4;
	
	@Column(length = 2)
	private String drwtNo5;
	
	@Column(length = 2)
	private String drwtNo6;
	
	@Column(length = 10)
	private LocalDateTime crtDate;
	
	@Builder
	public MyLottoNo(String drwtNo1, String drwtNo2, String drwtNo3, String drwtNo4, String drwtNo5, String drwtNo6, String crtDate) {
		this.drwtNo1 = drwtNo1;
		this.drwtNo2 = drwtNo2;
		this.drwtNo3 = drwtNo3;
		this.drwtNo4 = drwtNo4;
		this.drwtNo5 = drwtNo5;
		this.drwtNo6 = drwtNo6;
		this.crtDate = LocalDateTime.now();
	}
}
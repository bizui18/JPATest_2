package com.JPATest.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;

import org.springframework.data.domain.Persistable;
import org.springframework.lang.Nullable;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@ToString
@Getter
@Entity
@IdClass(VrsccmpnyPK.class)
@Table(name = "VRSCCMPNY_MANAGE")
public class Vrsccmpny {
	
	@Id
	@Column
	private String serverFg;
	
	@Id
	@Column
	private String vrsccmpnyManageId;

	@Column
	private String vrsccmpnyNm;
	
	@Column
	private String seedKey;
	
	@Column
	private String iv;
	
	@Builder
	public Vrsccmpny(String vrsccmpnyManageId, String vrsccmpnyNm, String seedKey, String iv, String serverFg) {
		this.vrsccmpnyManageId = vrsccmpnyManageId;
		this.vrsccmpnyNm = vrsccmpnyNm;
		this.seedKey = seedKey;
		this.iv = iv;
		this.serverFg = serverFg;
	}
}
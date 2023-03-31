package com.JPATest.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.JPATest.entity.LottoInfo;

@Repository
public interface LottoInfoRepository extends JpaRepository<LottoInfo, String>{

	Page<LottoInfo> findAll(Pageable pageable);

	Page<LottoInfo> findAllByDrwNo(Pageable pageable, String drwNo);
	
}
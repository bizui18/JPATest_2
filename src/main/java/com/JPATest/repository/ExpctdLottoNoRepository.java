package com.JPATest.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.JPATest.entity.ExpctdLottoNo;

@Repository
public interface ExpctdLottoNoRepository extends JpaRepository<ExpctdLottoNo, Integer>{

	Page<ExpctdLottoNo> findAll(Pageable pageable);
	
}
package com.JPATest.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.JPATest.entity.MyLottoNo;

@Repository
public interface MyLottoNoRepository extends JpaRepository<MyLottoNo, Integer>{

	Page<MyLottoNo> findAll(Pageable pageable);

}
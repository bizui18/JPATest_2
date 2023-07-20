package com.JPATest.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.JPATest.entity.APITest;

@Repository
public interface APITestRepository extends JpaRepository<APITest, String>{

	Page<APITest> findAll(Pageable pageable);

}
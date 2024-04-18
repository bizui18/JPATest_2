package com.JPATest.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.JPATest.entity.TBENC;

@Repository
public interface TBENCRepository extends JpaRepository<TBENC, String> {

	List<TBENC> findAll();
}

package com.JPATest.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.JPATest.entity.Vrsccmpny;

@Repository
public interface VrsccmpnyRepository extends JpaRepository<Vrsccmpny, String>{
	
	Vrsccmpny findByVrsccmpnyManageIdAndServerFg (String vrsccmpnyManageId, String serverFg);
	
}
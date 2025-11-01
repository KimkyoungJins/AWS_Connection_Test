package org.example.mobile_server.repository;

import org.example.mobile_server.entity.SleepRecord;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SleepRecordRepository extends JpaRepository<SleepRecord, Long> {
}
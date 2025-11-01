package org.example.mobile_server.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED) // JPA는 기본 생성자가 필요함
public class SleepRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String userId;

    private LocalDateTime sleepStartTime;
    private LocalDateTime sleepEndTime;
    private Integer heartRate;
    private Integer respiratoryRate;
    private Double bodyTemperature;

    @Builder
    public SleepRecord(String userId, LocalDateTime sleepStartTime, LocalDateTime sleepEndTime, Integer heartRate, Integer respiratoryRate, Double bodyTemperature) {
        this.userId = userId;
        this.sleepStartTime = sleepStartTime;
        this.sleepEndTime = sleepEndTime;
        this.heartRate = heartRate;
        this.respiratoryRate = respiratoryRate;
        this.bodyTemperature = bodyTemperature;
    }
}
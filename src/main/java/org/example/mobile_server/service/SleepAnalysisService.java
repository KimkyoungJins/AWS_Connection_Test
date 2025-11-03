package org.example.mobile_server.service;

import org.example.mobile_server.dto.SleepAnalysisResponse;
import org.example.mobile_server.dto.SleepRecordRequest;
import org.example.mobile_server.entity.SleepRecord;
import org.example.mobile_server.repository.SleepRecordRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.util.Map;

@Service
@RequiredArgsConstructor // final 필드에 대한 생성자를 자동으로 만들어줌
public class SleepAnalysisService {

    private final SleepRecordRepository sleepRecordRepository;

    @Transactional
    public SleepAnalysisResponse recordAndAnalyze(SleepRecordRequest request) {
        // 1. 사용자 ID 가져오기 (실제로는 SecurityContext 등에서 인증된 사용자 정보를 가져와야 함)
        String userId = "test-user"; // 임시 사용자 ID

        // 2. 요청 데이터를 기반으로 SleepRecord 엔티티 생성
        SleepRecord sleepRecord = SleepRecord.builder()
                .userId(userId)
                .sleepStartTime(request.getSleepStartTime())
                .sleepEndTime(request.getSleepEndTime())
                .heartRate(request.getHeartRate())
                .respiratoryRate(request.getRespiratoryRate())
                .bodyTemperature(request.getBodyTemperature())
                .build();

        // 3. 데이터베이스에 저장
        SleepRecord savedRecord = sleepRecordRepository.save(sleepRecord);

        // 4. 수면 상태 분석 (핵심 연산 로직)
        long totalMinutes = Duration.between(request.getSleepStartTime(), request.getSleepEndTime()).toMinutes();
        String status;
        String message;

        // [새로운 분석 알고리즘]
        // 각 항목별 상태 레벨 계산 (0: 좋음, 1: 보통, 2: 나쁨, 3: 위험)
        int hr = request.getHeartRate();
        int hrLevel;
        if (hr < 30 || hr > 150) {
            hrLevel = 3; // 위험
        } else if (hr < 40 || hr >= 86) {
            hrLevel = 2; // 나쁨
        } else if (hr >= 61 && hr <= 85) {
            hrLevel = 1; // 보통
        } else { // 40-60
            hrLevel = 0; // 좋음
        }

        int rr = request.getRespiratoryRate();
        int rrLevel;
        if (rr < 5 || rr > 40) {
            rrLevel = 3; // 위험
        } else if (rr < 10 || rr > 25) {
            rrLevel = 2; // 나쁨
        } else if (rr >= 12 && rr <= 18) {
            rrLevel = 0; // 좋음
        } else { // 10, 11, 19-25
            rrLevel = 1; // 보통
        }

        double temp = request.getBodyTemperature();
        int tempLevel;
        if (temp < 35.0 || temp > 39.0) {
            tempLevel = 3; // 위험
        } else if (temp < 35.5 || temp > 37.8) {
            tempLevel = 2; // 나쁨
        } else if (temp >= 36.0 && temp <= 37.0) {
            tempLevel = 0; // 좋음
        } else { // 35.5-35.9, 37.1-37.8
            tempLevel = 1; // 보통
        }

        // 가장 나쁜 상태를 기준으로 전체 수면 상태 결정
        int finalLevel = Math.max(hrLevel, Math.max(rrLevel, tempLevel));

        switch (finalLevel) {
            case 3:
                status = "위험";
                message = "건강에 위협이 될 수 있는 심각한 비정상 수치가 측정되었습니다. 즉시 전문가의 진단이 필요합니다.";
                break;
            case 2:
                status = "나쁨";
                message = "스트레스, 불편한 잠자리 등으로 수면의 질이 크게 떨어진 것 같습니다. 원인을 확인해보세요.";
                break;
            case 1:
                status = "보통";
                message = "대체로 무난한 수면 상태입니다. 꾸준히 좋은 수면 습관을 유지해보세요.";
                break;
            default:
                status = "좋음";
                message = "몸과 마음이 깊은 휴식을 취했습니다. 이상적인 수면 상태입니다!";
                break;
        }

        // 5. 최종 응답(Response) 객체 생성 및 반환
        return SleepAnalysisResponse.builder()
                .recordId(savedRecord.getId())
                .userId(userId)
                .totalSleepTimeMinutes(totalMinutes)
                .sleepStatus(status)
                .summaryMessage(message)
                .savedData(Map.of(
                        "heartRate", savedRecord.getHeartRate(),
                        "respiratoryRate", savedRecord.getRespiratoryRate(),
                        "bodyTemperature", savedRecord.getBodyTemperature()
                ))
                .build();
    }
}
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

        // [분석 알고리즘 예시]
        if (totalMinutes < 360 || request.getHeartRate() > 85) { // 6시간 미만이거나 심박수가 85 초과
            status = "나쁨";
            message = String.format("총 %d시간 %d분 주무셨네요. 수면 시간이 부족하거나 심박수가 다소 높습니다.", totalMinutes / 60, totalMinutes % 60);
        } else if (totalMinutes >= 420 && request.getHeartRate() <= 70) { // 7시간 이상이고 심박수가 70 이하
            status = "좋음";
            message = String.format("총 %d시간 %d분 동안 안정적인 수면을 취했습니다. 아주 좋습니다!", totalMinutes / 60, totalMinutes % 60);
        } else {
            status = "보통";
            message = String.format("총 %d시간 %d분 주무셨습니다. 무난한 수면 상태입니다.", totalMinutes / 60, totalMinutes % 60);
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
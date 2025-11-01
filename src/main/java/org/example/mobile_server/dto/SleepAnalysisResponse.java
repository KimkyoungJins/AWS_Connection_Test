package org.example.mobile_server.dto;

import lombok.Builder;
import lombok.Getter;
import java.util.Map;

@Getter
@Builder // 빌더 패턴으로 객체를 쉽게 생성하게 해줌
public class SleepAnalysisResponse {
    private Long recordId;
    private String userId; // 실제로는 JWT 토큰 등에서 추출
    private long totalSleepTimeMinutes;
    private String sleepStatus;
    private String summaryMessage;
    private Map<String, Object> savedData;
}
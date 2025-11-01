package org.example.mobile_server.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import java.time.LocalDateTime;

@Getter
public class SleepRecordRequest {

    @NotNull(message = "수면 시작 시간은 필수입니다.")
    private LocalDateTime sleepStartTime;

    @NotNull(message = "수면 종료 시간은 필수입니다.")
    private LocalDateTime sleepEndTime;

    @NotNull(message = "심박수는 필수입니다.")
    @Positive(message = "심박수는 양수여야 합니다.")
    private Integer heartRate;

    @NotNull(message = "호흡수는 필수입니다.")
    @Positive(message = "호흡수는 양수여야 합니다.")
    private Integer respiratoryRate;

    @NotNull(message = "체온은 필수입니다.")
    private Double bodyTemperature;
}
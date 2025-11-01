package org.example.mobile_server.controller;

import org.example.mobile_server.dto.SleepAnalysisResponse;
import org.example.mobile_server.dto.SleepRecordRequest;
import org.example.mobile_server.service.SleepAnalysisService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/sleep")
public class SleepApiController {

    private final SleepAnalysisService sleepAnalysisService;

    @PostMapping("/record-and-analyze")
    public ResponseEntity<SleepAnalysisResponse> recordAndAnalyze(
            @Valid @RequestBody SleepRecordRequest request
    ) {
        SleepAnalysisResponse response = sleepAnalysisService.recordAndAnalyze(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
}
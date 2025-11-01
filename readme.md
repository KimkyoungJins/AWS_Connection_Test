네, 알겠습니다. 제공해주신 API 명세서 2개를 더 명확하고 보기 좋은 마크다운 형식으로 다듬어 드릴게요.

-----

# 📝 건강 정보 기록 API

## 1\. 개요

본 API는 사용자가 모바일 애플리케이션에서 측정한 건강 데이터(심박수, 호흡수, 체온)를 주기적으로 서버에 기록하기 위해 사용됩니다.

## 2\. 엔드포인트

  * **HTTP Method:** `POST`
  * **URL:** `/api/health-metrics`

## 3\. 요청 (Request)

#### Headers

| Key           | Value              | 설명                                        |
| :------------ | :----------------- | :------------------------------------------ |
| `Content-Type`| `application/json` | 요청 본문이 JSON 형식임을 나타냅니다.       |
| `Authorization`| `Bearer <TOKEN>`   | (선택) 사용자 인증 토큰을 포함합니다.       |

#### Body

요청 본문은 아래 필드를 포함하는 JSON 객체여야 합니다.

```json
{
  "heartRate": 80,
  "respiratoryRate": 16,
  "bodyTemperature": 36.5
}
```

| 필드명            | 타입   | 설명                               | 필수 여부 |
| :---------------- | :----- | :--------------------------------- | :-------- |
| `heartRate`       | Number | 분당 심박수 (BPM)                  | **예** |
| `respiratoryRate` | Number | 분당 호흡수 (회/분)                | **예** |
| `bodyTemperature` | Number | 섭씨(°C) 단위의 체온 (소수점 가능) | **예** |

## 4\. 응답 (Response)

### ✅ 성공 (`201 Created`)

데이터가 성공적으로 저장되었을 때 반환됩니다.

```json
{
  "id": "metric_1a2b3c4d5e",
  "userId": "user_xyz789",
  "heartRate": 80,
  "respiratoryRate": 16,
  "bodyTemperature": 36.5,
  "createdAt": "2025-10-31T10:00:00Z"
}
```

### ❌ 실패

#### `400 Bad Request`

필수 필드가 누락되었거나 데이터 타입이 올바르지 않을 때 반환됩니다.

```json
{
  "error": "Invalid Input",
  "message": "heartRate 필드는 필수이며 숫자여야 합니다."
}
```

#### `500 Internal Server Error`

데이터베이스 연결 실패 등 서버 측 문제로 인해 저장에 실패했을 때 반환됩니다.

```json
{
  "error": "Internal Server Error",
  "message": "데이터를 처리하는 중 오류가 발생했습니다."
}
```

-----

-----

# 😴 수면 상태 분석 API

## 1\. 개요

본 API는 사용자가 수면 종료를 알렸을 때, 서버에 기록된 건강 데이터를 기반으로 수면의 질을 \*\*"연산(분석)"\*\*하도록 요청하기 위해 사용됩니다.

## 2\. 엔드포인트

  * **HTTP Method:** `POST`
  * **URL:** `/api/sleep/analyze`

## 3\. 요청 (Request)

#### Headers

| Key           | Value              | 설명                                      |
| :------------ | :----------------- | :---------------------------------------- |
| `Content-Type`| `application/json` | 요청 본문이 JSON 형식임을 나타냅니다.     |
| `Authorization`| `Bearer <TOKEN>`   | **(필수)** 분석할 사용자를 식별합니다. |

#### Body

서버에게 분석할 데이터의 시간 범위를 알려줍니다.

```json
{
  "sleepStartTime": "2025-10-31T23:30:00Z",
  "sleepEndTime": "2025-11-01T07:00:00Z"
}
```

| 필드명          | 타입   | 설명                             | 필수 여부 |
| :-------------- | :----- | :------------------------------- | :-------- |
| `sleepStartTime`| String | 수면 시작 시간 (ISO 8601 형식)   | **예** |
| `sleepEndTime`  | String | 수면 종료 시간 (ISO 8601 형식)   | **예** |

## 4\. 응답 (Response)

### ✅ 성공 (`200 OK`)

서버가 해당 기간의 데이터를 성공적으로 분석했을 때 반환됩니다.

```json
{
  "analysisId": "analysis_9f8e7d6c",
  "userId": "user_xyz789",
  "sleepStartTime": "2025-10-31T23:30:00Z",
  "sleepEndTime": "2025-11-01T07:00:00Z",
  "totalSleepTimeMinutes": 450,
  "sleepStatus": "좋음",
  "summaryMessage": "총 7시간 30분 동안 안정적인 수면을 취했습니다.",
  "analysisDetails": {
    "avgHeartRate": 58,
    "avgRespiratoryRate": 14,
    "avgBodyTemperature": 36.3
  }
}
```

| 필드명              | 타입   | 설명                                                    |
| :------------------ | :----- | :------------------------------------------------------ |
| `analysisId`        | String | 분석 결과의 고유 식별자(ID)                             |
| `userId`            | String | 분석 대상 사용자의 고유 식별자(ID)                      |
| `totalSleepTimeMinutes` | Number | 총 수면 시간 (분 단위)                                  |
| **`sleepStatus`** | String | **[핵심 결과]** 수면 상태 ("좋음" / "보통" / "나쁨")    |
| `summaryMessage`    | String | Flutter 화면에 표시할 간단한 요약 메시지                |
| `analysisDetails`   | Object | 분석에 사용된 세부 데이터 요약 (평균 심박수, 호흡수 등) |

### ❌ 실패

#### `400 Bad Request`

필수 시간 값이 누락되거나 날짜 형식이 잘못된 경우 반환됩니다.

```json
{
  "error": "Invalid Time Range",
  "message": "sleepStartTime과 sleepEndTime은 필수이며 ISO 8601 형식이어야 합니다."
}
```

#### `404 Not Found`

요청한 기간 동안 분석할 수면 데이터가 없는 경우 반환됩니다.

```json
{
  "error": "Not Found",
  "message": "분석할 수면 데이터가 해당 기간에 존재하지 않습니다."
}
```

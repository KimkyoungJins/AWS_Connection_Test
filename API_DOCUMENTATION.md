제시하신 'Sleep-well API Documentation'의 내용을 한국어로 번역하고 정리했습니다.

-----

# 🛌 Sleep-well API 문서

본 문서는 Sleep-well Flutter 애플리케이션에서 사용하는 API의 사양을 제공합니다.

-----

## 기본 URL (Base URL)

모든 API 엔드포인트에 대한 기본 URL은 다음과 같습니다:
`http://13.237.113.165:8080`

-----

## 엔드포인트 (Endpoints)

### 수면 데이터 기록 및 분석 (Record and Analyze Sleep Data)

이 엔드포인트는 수면 관련 데이터를 수신하고, 이를 기록한 후 수면 분석 요약 결과를 반환합니다.

  * **URL:** `/api/sleep/record-and-analyze`
  * **메소드 (Method):** `POST`
  * **헤더 (Headers):**
      * `Content-Type`: `application/json`

#### 요청 본문 (Request Body)

요청 본문은 다음과 같은 구조를 가진 JSON 객체여야 합니다:

| 필드 | 타입 | 설명 | 예시 |
| :--- | :--- | :--- | :--- |
| `sleepStartTime` | 문자열 (String) | 수면 시작 시각. **ISO 8601 UTC 형식**입니다. | `"2025-10-31T22:00:00.000Z"` |
| `sleepEndTime` | 문자열 (String) | 수면 종료 시각. **ISO 8601 UTC 형식**입니다. | `"2025-11-01T06:00:00.000Z"` |
| `heartRate` | 정수 (Integer) | 수면 중 평균 심박수 (분당 박동수, bpm). | `65` |
| `respiratoryRate` | 정수 (Integer) | 수면 중 평균 호흡수 (분당 호흡수). | `16` |
| `bodyTemperature` | 실수 (Double) | 수면 중 평균 체온 (**섭씨**). | `36.5` |

**요청 예시 (Example Request):**

```json
{
  "sleepStartTime": "2025-10-31T22:00:00.000Z",
  "sleepEndTime": "2025-11-01T06:00:00.000Z",
  "heartRate": 65,
  "respiratoryRate": 16,
  "bodyTemperature": 36.5
}
```

#### 응답 (Responses)

  * **성공 (상태 코드 `201 Created`)**

    데이터가 성공적으로 기록 및 분석되면, 서버는 요약 메시지를 포함하는 JSON 객체를 반환합니다.

| 필드 | 타입 | 설명 | 예시 |
| :--- | :--- | :--- | :--- |
| `summaryMessage` | 문자열 (String) | 수면 분석에 대한 텍스트 요약입니다. | `"수면 데이터가 성공적으로 기록 및 분석되었습니다. 수면의 질이 좋고, 심박수와 호흡수가 안정적이었습니다."` |
| `...` | `any` | 다른 분석 데이터가 포함될 수 있습니다. | |

**성공 응답 예시 (Example Success Response):**

```json
{
  "summaryMessage": "수면 데이터가 성공적으로 기록 및 분석되었습니다. 수면의 질이 좋고, 심박수와 호흡수가 안정적이었습니다."
}
```

  * **실패 (상태 코드 `4xx` 또는 `5xx`)**

    요청이 실패할 경우, 서버는 오류 메시지를 포함하는 JSON 객체를 반환합니다.

| 필드 | 타입 | 설명 |
| :--- | :--- | :--- |
| `message` | 문자열 (String) | 오류에 대한 설명입니다. |

**오류 응답 예시 (Example Error Response):**

```json
{
  "message": "Invalid input: heartRate must be a positive number."
}
```

-----

이 문서를 바탕으로 **Flutter 애플리케이션에서 해당 API를 호출하는 코드 예시**를 작성해 드릴까요?

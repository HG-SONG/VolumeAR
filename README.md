# VolumeAR
ARKit 기반 회전체 부피 측정 앱. 평면을 인식하고, 사용자가 곡선을 그리면 해당 곡선을 회전축 기준으로 회전시켜 3D 부피를 계산합니다. 일상용 간이 측정부터 엔지니어링/교육용 실험까지 활용 가능합니다.
## 미완성

# 📌 ARKit 기반 부피 측정 아이디어 정리
## 1. 기본 아이디어

### ARKit으로 월드 좌표계를 이용한 절대 거리 측정이 가능하다! 
카메라 좌표계에서 카메라는 원점(0,0,0)에 위치하지만, **월드 좌표(World Transform)**로의 변경이 가능함.

ARKit의 ARHitTest(또는 raycast)를 사용하면,
카메라로부터 화면의 특정 픽셀 방향으로, 충돌 지점의 월드 좌표를 얻을 수 있음.

해당 지점까지의 거리(빗변)와 지평면의 법선 벡터를 알고 있으면, 해당 점의 수평·수직 위치를 계산 가능.

그리고, 이 모든 것들을 ARKit을 이용하여 얻을 수 있음. 

---

## 2. 지점 위치 계산

### 법선 벡터
- 지평면이 수평이라면 법선 벡터: **(0, 1, 0)**
- 이 법선은 지평면과 이루는 각도를 구하는 데 사용

### 끼인각 계산
- **충돌 지점까지의 거리** = `distance`
- **지평면 법선 벡터** = `n`
- **충돌 지점 방향 단위 벡터** (distance로 정규화된 방향 벡터) = <img width="20" height="26" alt="스크린샷 2025-08-04 오후 11 59 50" src="https://github.com/user-attachments/assets/97ecfdeb-564f-46d0-9d28-d5982ff5aeaf" />

- **끼인각 `θ`**: <img width="127" height="39" alt="스크린샷 2025-08-04 오후 11 59 18" src="https://github.com/user-attachments/assets/1f91e444-ebde-44e6-a491-0d4d3c82b86a" />

### 직각삼각형 구성
- **빗변**: `distance` (카메라 → 충돌 지점 거리)
- **끼인각**: `θ`
- **인접변(수평 거리)**: <img width="138" height="31" alt="스크린샷 2025-08-05 오전 12 00 57" src="https://github.com/user-attachments/assets/828e2417-06f5-43a5-9e51-22915ceb3c9c" />
- **반대변(높이)**: <img width="135" height="33" alt="스크린샷 2025-08-05 오전 12 01 26" src="https://github.com/user-attachments/assets/b8c45add-ddb3-46c4-8e4c-bd45a7cad15b" />

<img width="579" height="603" alt="스크린샷 2025-08-05 오전 12 02 56" src="https://github.com/user-attachments/assets/a6bd03cf-f9ce-4e8c-974c-fee828502838" />

---

## 3. 곡면 데이터 수집
- 화면의 여러 지점을 샘플링하여 충돌 지점 좌표를 수집
- 이렇게 얻은 좌표들은 측정 대상 물체 표면의 **3D 포인트 클라우드**를 형성
- 포인트들을 **회전축**(예: y축)에 대해 **수직 방향 단면 곡선**으로 투영

---

## 4. 부피 계산

### 단면적 적분
- 회전축에 수직한 방향에서 본 단면 곡선 `r(y)`를 얻음  
- 면적:<img width="162" height="72" alt="스크린샷 2025-08-05 오전 12 05 24" src="https://github.com/user-attachments/assets/1d610c94-20f5-4b90-9306-28bcabb86ebe" />
- `r(y)`는 해당 y값에서의 반경

### 회전체 부피 (회전축 회전)
- 2π로 회전시키면, 원판 방법에 따라 부피:<img width="201" height="62" alt="스크린샷 2025-08-05 오전 12 05 40" src="https://github.com/user-attachments/assets/0b2015eb-4113-4f08-9dcc-bd042373dd11" />


<img width="681" height="491" alt="스크린샷 2025-08-05 오전 12 06 51" src="https://github.com/user-attachments/assets/b74b3ba2-7ab4-4c1f-a8a3-ff2e86044add" />

---

## 5. ARKit 적용 포인트
- `raycast` 또는 `hitTest`로 표면 점 좌표를 수집
- `ARPlaneAnchor`에서 지평면 법선 벡터를 얻거나, 수평면 기준 `(0, 1, 0)` 사용
- 측정 대상이 **회전축 대칭**을 가진다고 가정하면, 비교적 간단하게 부피 계산 가능



![햘 (1)](https://github.com/user-attachments/assets/47559e62-4c1f-456f-804a-1f34f72f6c40)

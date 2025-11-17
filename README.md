# Odor Modeling System (악취 모델링 시스템)

태성환경연구소 통합관리시스템 - 모델링 및 시각화 플랫폼

## 📋 프로젝트 개요

이 프로젝트는 CALPUFF/CALMET 모델링 결과를 데이터베이스에 저장하고 웹 인터페이스를 통해 시각화하는 시스템입니다.

## 🏗️ 프로젝트 구조

```
odorsystem/
├── TSEI_modeling/          # Spring Boot 웹 애플리케이션
│   ├── src/                # 소스 코드
│   ├── pom.xml             # Maven 의존성
│   └── documentation/      # 문서화 파일들
├── modeling/               # CALPUFF/CALMET 모델링 스크립트
│   ├── bin/                # 실행 파일
│   ├── inp/                # 입력 파일
│   ├── out/                # 출력 파일
│   ├── run/                # 실행 디렉토리
│   └── util/               # 유틸리티 스크립트
└── modeling_DB/            # 데이터베이스 스키마
    ├── DB구조생성.sql      # 테이블 생성 스크립트
    └── place_data_temp입력.sql  # 위치 데이터
```

## 🚀 빠른 시작

### 1. 데이터베이스 설정

```bash
# MySQL 설치 및 실행
brew services start mysql@8.0

# 데이터베이스 생성
mysql -uroot -p1234 < modeling_DB/DB구조생성.sql

# 위치 데이터 임포트
mysql -uroot -p1234 tseiweb < modeling_DB/place_data_temp입력.sql
```

### 2. 애플리케이션 실행

```bash
cd TSEI_modeling
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home
mvn spring-boot:run
```

### 3. 웹 인터페이스 접속

- 메인 모델링 페이지: http://localhost:9084/soms/page3
- 추가 페이지: http://localhost:9084/soms/page5

## 📚 주요 문서

- **[DATABASE_SETUP.md](TSEI_modeling/DATABASE_SETUP.md)** - 데이터베이스 설정 가이드
- **[MODELING_OUTPUT_WORKFLOW.md](TSEI_modeling/MODELING_OUTPUT_WORKFLOW.md)** - 모델링 출력 처리 워크플로우
- **[DEPLOYMENT_AND_ACCESS.md](TSEI_modeling/DEPLOYMENT_AND_ACCESS.md)** - 배포 및 팀 접근 설정
- **[QUICK_NETWORK_SETUP.md](TSEI_modeling/QUICK_NETWORK_SETUP.md)** - 빠른 네트워크 접근 설정
- **[WHY_LOADING_EXPLAINED.md](TSEI_modeling/WHY_LOADING_EXPLAINED.md)** - 로딩 상태 설명

## 🔧 기술 스택

- **Backend**: Spring Boot 2.7.2, MyBatis, Java 11
- **Database**: MySQL 8.0
- **Frontend**: Thymeleaf, JavaScript, Google Maps API
- **Modeling**: CALPUFF, CALMET, CALPOST
- **Data Processing**: Python (pandas, pymysql)

## 📦 주요 기능

1. **모델링 데이터 관리**
   - CALPUFF/CALMET 출력 파일 처리
   - 데이터베이스 자동 삽입
   - 날짜/시간별 데이터 조회

2. **시각화**
   - Google Maps 기반 지도 표시
   - 농도 데이터 색상 코딩
   - 사업장 및 관심지점 마커

3. **기상 데이터**
   - OpenWeatherMap API 연동
   - 실시간 기상 정보 표시

4. **데이터 분석**
   - 관심지점별 악취 세기 계산
   - 영향 사업장 분석
   - 시간대별 농도 변화

## 🔐 데이터베이스 구조

### 주요 테이블

- `modeling_data1`: 모델링 농도 데이터 (lat, lon, conc1-10, e_idx, reg_date)
- `modeling_weather1`: 기상 데이터 (wind_dir, wind_spd, temp, humi, pressure, reg_date)
- `place_data_temp`: 위치 데이터 (lat, lon, name, p_index, poi)

## 👥 팀 협업

### 모델링 데이터 처리 워크플로우

1. 모델링 팀이 CSV 파일 제공
2. Python 스크립트로 데이터 처리
3. 데이터베이스에 자동 삽입
4. 웹 인터페이스에서 즉시 확인

자세한 내용은 [MODELING_OUTPUT_WORKFLOW.md](TSEI_modeling/MODELING_OUTPUT_WORKFLOW.md) 참조

### 팀 접근 설정

팀원들이 애플리케이션에 접근할 수 있도록 네트워크 설정:
- [QUICK_NETWORK_SETUP.md](TSEI_modeling/QUICK_NETWORK_SETUP.md) - 5분 빠른 설정
- [DEPLOYMENT_AND_ACCESS.md](TSEI_modeling/DEPLOYMENT_AND_ACCESS.md) - 상세 배포 가이드

## 🔄 업데이트 로그

### 최근 변경사항

- ✅ 데이터베이스 연결 설정 완료
- ✅ 모델링 데이터 처리 스크립트 구현
- ✅ 웹 인터페이스 구현
- ✅ 문서화 완료
- ✅ Git 저장소 초기화

## 📝 라이센스

프로젝트 내부 사용

## 📞 문의



# No.6-Pj: 악취 예보 시스템

( ... 프로젝트에 대한 간략한 소개 ... )

---

## 🚀 1. 개발 환경 설정 (필독)

이 프로젝트는 민감한 DB 접속 정보(비밀번호 등)를 GitHub에 직접 올리지 않습니다.

`.gitignore` 파일에 의해 실제 설정 파일(`application.properties`, `config.json`)은 **무시**되도록 설정되어 있습니다.

프로젝트를 `clone` 받은 후, 서버와 모델을 실행하기 위해 **반드시** 아래 3개의 설정 파일을 수동으로 생성해야 합니다.

### ## A. Spring 서버 설정 (`TSEI_modeling`)

1.  **템플릿 파일:** `TSEI_modeling/src/main/resources/application.properties.example`
2.  **생성할 파일:** 위 템플릿 파일을 **복사**하여 `TSEI_modeling/src/main/resources/application.properties` 파일을 생성합니다.
3.  **수정:** `application.properties` 파일을 열어, `[DB호스트]`, `[ID]`, `[비밀번호]` 부분을 **본인의 로컬 DB 환경**에 맞게 수정합니다.

### ## B. 모델 스크립트 설정 (`mdl` - 실시간)

1.  **템플릿 파일:** `mdl/util/real-time_weather_emissions_transfer_3D/config.json.example`
2.  **생성할 파일:** 위 템플릿 파일을 **복사**하여 `config.json` 파일을 같은 폴더에 생성합니다.
3.  **수정:** `config.json` 파일을 열어 본인의 DB 정보를 입력합니다.

### ## C. 모델 스크립트 설정 (`mdl` - DB 저장)

1.  **템플릿 파일:** `mdl/util/insert_weather_modeling_to_DB_3D/config.json.example`
2.  **생성할 파일:** 위 템플릿 파일을 **복사**하여 `config.json` 파일을 같은 폴더에 생성합니다.
3.  **수정:** `config.json` 파일을 열어 본인의 DB 정보를 입력합니다.

> **[참고]**
> 이렇게 생성한 `application.properties`와 `config.json` 파일들은 `.gitignore`에 의해 안전하게 보호되며, GitHub에 업로드되지 않습니다.
프로젝트 관련 문의사항은 팀 리더에게 연락하세요.

---

**태성환경연구소** - Smart Tracking Control System


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

### 시작 가이드
- **[QUICK_START_WITH_LOCAL_DATA.md](TSEI_modeling/QUICK_START_WITH_LOCAL_DATA.md)** - 로컬 모델링 데이터 처리 빠른 시작 가이드
- **[MODELING_OUTPUT_WORKFLOW.md](TSEI_modeling/MODELING_OUTPUT_WORKFLOW.md)** - 모델링 출력 처리 워크플로우

### 설정 및 배포
- **[DATABASE_SETUP.md](TSEI_modeling/DATABASE_SETUP.md)** - 데이터베이스 설정 가이드
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

프로젝트 관련 문의사항은 팀 리더에게 연락하세요.

---

**태성환경연구소** - Smart Tracking Control System


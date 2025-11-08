-- --------------------------------------------------------
-- 호스트:                          192.168.200.171
-- 서버 버전:                        5.6.51-log - MySQL Community Server (GPL)
-- 서버 OS:                        Win64
-- HeidiSQL 버전:                  12.5.0.6677
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- tseiweb 데이터베이스 구조 내보내기
CREATE DATABASE IF NOT EXISTS `tseiweb` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `tseiweb`;

-- 테이블 tseiweb.modeling_data1 구조 내보내기
CREATE TABLE IF NOT EXISTS `modeling_data1` (
  `md_idx` int(11) NOT NULL AUTO_INCREMENT COMMENT '일련번호',
  `e_idx` int(11) NOT NULL,
  `lat` double DEFAULT NULL COMMENT '위도',
  `lon` double DEFAULT NULL COMMENT '경도',
  `conc1` double DEFAULT NULL COMMENT '배출농도',
  `conc2` double DEFAULT NULL,
  `conc3` double DEFAULT NULL,
  `conc4` double DEFAULT NULL,
  `conc5` double DEFAULT NULL,
  `conc6` double DEFAULT NULL,
  `conc7` double DEFAULT NULL,
  `conc8` double DEFAULT NULL,
  `conc9` double DEFAULT NULL,
  `conc10` double DEFAULT NULL,
  `reg_date` datetime NOT NULL COMMENT '날짜',
  PRIMARY KEY (`md_idx`,`reg_date`),
  KEY `reg_date` (`reg_date`),
  KEY `reg_date_desc` (`reg_date`)
) ENGINE=InnoDB AUTO_INCREMENT=101801245 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='모델링 데이터'
/*!50100 PARTITION BY RANGE (year(`reg_date`))
(PARTITION part1 VALUES LESS THAN (2022) ENGINE = InnoDB,
 PARTITION part2 VALUES LESS THAN (2023) ENGINE = InnoDB,
 PARTITION part3 VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION part4 VALUES LESS THAN (2025) ENGINE = InnoDB,
 PARTITION part5 VALUES LESS THAN (2026) ENGINE = InnoDB) */;

-- 내보낼 데이터가 선택되어 있지 않습니다.

-- 테이블 tseiweb.modeling_weather1 구조 내보내기
CREATE TABLE IF NOT EXISTS `modeling_weather1` (
  `mw_idx` int(11) NOT NULL AUTO_INCREMENT COMMENT '일련번호',
  `wind_dir` double DEFAULT NULL COMMENT '풍향',
  `wind_spd` double DEFAULT NULL COMMENT '풍속',
  `temp` double DEFAULT NULL COMMENT '기온',
  `humi` double DEFAULT NULL COMMENT '습도',
  `pressure` double DEFAULT NULL COMMENT '기압',
  `reg_date` datetime NOT NULL COMMENT '날짜',
  PRIMARY KEY (`mw_idx`,`reg_date`),
  KEY `reg_date` (`reg_date`)
) ENGINE=InnoDB AUTO_INCREMENT=18242 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='모델링 기상정보'
/*!50100 PARTITION BY RANGE (year(`reg_date`))
(PARTITION part1 VALUES LESS THAN (2022) ENGINE = InnoDB,
 PARTITION part2 VALUES LESS THAN (2023) ENGINE = InnoDB,
 PARTITION part3 VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION part4 VALUES LESS THAN (2025) ENGINE = InnoDB,
 PARTITION part5 VALUES LESS THAN (2026) ENGINE = InnoDB) */;

-- 내보낼 데이터가 선택되어 있지 않습니다.

-- 테이블 tseiweb.place_data_temp 구조 내보내기
CREATE TABLE IF NOT EXISTS `place_data_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lat` varchar(45) NOT NULL,
  `lon` varchar(45) NOT NULL,
  `name` varchar(45) NOT NULL,
  `p_index` int(11) DEFAULT NULL COMMENT '사업장 번호와 모델링 프로그램 input(배출구 데이터) 순번과 일치되어야 함.',
  `poi` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- 내보낼 데이터가 선택되어 있지 않습니다.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

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

-- 테이블 데이터 tseiweb.place_data_temp:~23 rows (대략적) 내보내기
INSERT INTO `place_data_temp` (`id`, `lat`, `lon`, `name`, `p_index`, `poi`) VALUES
	(1, '35.4729', '129.3589', '한화케미칼㈜', 2, NULL),
	(2, '35.4803', '129.3545', '효성화학㈜', 3, NULL),
	(3, '35.4607', '129.3578', 'SK케미칼㈜', 4, NULL),
	(4, '35.4945', '129.3811', '농협사료㈜ 울산지사', 5, NULL),
	(5, '35.4287', '129.3457', '고려아연㈜', 6, NULL),
	(6, '35.4552', '129.3371', '대한유화 울산공장', 7, NULL),
	(7, '35.4071', '129.3549', '무림피엔피', 8, NULL),
	(8, '35.46', '129.3337', '㈜범우', 9, NULL),
	(9, '35.4604', '129.3276', '부산주공㈜', 10, NULL),
	(10, '35.431', '129.3319', '이수화학 온산공장', 11, NULL),
	(11, '35.4299', '129.3308', 'LG화학 온산공장', 12, NULL),
	(12, '35.4352', '129.347', 'LS-Nikko 동제련㈜', 13, NULL),
	(13, '35.4489', '129.3399', 'S-OIL㈜-1', 14, NULL),
	(14, '35.4498', '129.3423', 'S-OIL㈜-2', 15, NULL),
	(15, '35.4902', '129.3218', '금호석유화학㈜', 16, NULL),
	(16, '35.4941', '129.3362', '대한유화(울산)', 17, NULL),
	(17, '35.4994', '129.3245', '롯데케미칼㈜', 18, NULL),
	(18, '35.4924', '129.3317', '이수화학 울산공장', 19, NULL),
	(19, '35.5302', '129.3613', '롯데정밀화학㈜', 20, NULL),
	(20, '35.5095', '129.3382', '태광산업㈜', 1, NULL),
	(21, '35.455605', '129.329849', '울산TP비즈니스센터', 0, 1),
	(22, '35.500847', '129.320129', '울산석유화학단지입구', 0, 1),
	(23, '35.428398', '129.338959', '고려아연 사거리', 0, 1);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

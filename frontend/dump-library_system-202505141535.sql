-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: library_system
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `isbn` varchar(20) NOT NULL,
  `title` varchar(100) NOT NULL,
  `author` varchar(50) NOT NULL,
  `category` varchar(20) DEFAULT NULL,
  `totalCopies` int DEFAULT NULL,
  `availableCopies` int DEFAULT NULL,
  `location` varchar(50) DEFAULT NULL,
  `cover` varchar(200) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'9787123456789','图书名称1','作者1','literature',5,3,'书架1-1','https://example.com/cover1.jpg','这是图书1的简介，内容非常丰富，值得一读。'),(2,'9787987654321','图书名称2','作者2','science',8,6,'书架2-2','https://example.com/cover2.jpg','这是图书2的简介，内容非常丰富，值得一读。'),(3,'9787567890123','图书名称3','作者3','technology',10,8,'书架3-3','https://example.com/cover3.jpg','这是图书3的简介，内容非常丰富，值得一读。'),(4,'9787321654789','图书名称4','作者4','history',3,2,'书架4-4','https://example.com/cover4.jpg','这是图书4的简介，内容非常丰富，值得一读。'),(5,'9787111222333','图书名称5','作者5','philosophy',6,4,'书架5-5','https://example.com/cover5.jpg','这是图书5的简介，内容非常丰富，值得一读。'),(6,'9787444555666','图书名称6','作者6','art',7,5,'书架6-6','https://example.com/cover6.jpg','这是图书6的简介，内容非常丰富，值得一读。'),(7,'9787778889990','图书名称7','作者7','economics',9,7,'书架7-7','https://example.com/cover7.jpg','这是图书7的简介，内容非常丰富，值得一读。'),(8,'9787000111222','图书名称8','作者8','education',4,3,'书架8-8','https://example.com/cover8.jpg','这是图书8的简介，内容非常丰富，值得一读。'),(9,'9787666777888','图书名称9','作者9','literature',5,4,'书架9-9','https://example.com/cover9.jpg','这是图书9的简介，内容非常丰富，值得一读。'),(10,'9787333444555','图书名称10','作者10','science',8,6,'书架10-10','https://example.com/cover10.jpg','这是图书10的简介，内容非常丰富，值得一读。'),(11,'9787555666777','图书名称11','作者11','technology',10,8,'书架11-11','https://example.com/cover11.jpg','这是图书11的简介，内容非常丰富，值得一读。'),(12,'9787888999000','图书名称12','作者12','history',3,2,'书架12-12','https://example.com/cover12.jpg','这是图书12的简介，内容非常丰富，值得一读。'),(13,'9787222333444','图书名称13','作者13','philosophy',6,4,'书架13-13','https://example.com/cover13.jpg','这是图书13的简介，内容非常丰富，值得一读。'),(14,'9787111222333','图书名称14','作者14','art',7,5,'书架14-14','https://example.com/cover14.jpg','这是图书14的简介，内容非常丰富，值得一读。'),(15,'9787666777888','图书名称15','作者15','economics',9,7,'书架15-15','https://example.com/cover15.jpg','这是图书15的简介，内容非常丰富，值得一读。');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'testuser','123456'),(3,'202301510008','$2b$10$hdtAsgAVvOuniafe/wFv3eQ3r7v05PLeMsNzzIelzId5meoW0dXzC'),(4,'123','$2b$10$IweXqKtBsDjn2jgnJ1KXfOPsNCPv/y2jnfXjFfjxiVszrCTijJZse'),(5,'admin','$2b$10$/SyAfSFpRmSECMdA38ZAZuhHH4rllW0Wh1aY76cEY8LJO4DdLJh/S');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'library_system'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-14 15:35:16

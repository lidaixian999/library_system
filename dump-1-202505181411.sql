-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: 1
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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'9787020049741','平凡的世界','路遥','history',10,3,'书架1-1','https://picsum.photos/200/300?random=1','一部全景式地表现中国当代城乡社会生活的长篇小说。'),(2,'9787020137082','活着','余华','literature',8,6,'书架1-2','https://picsum.photos/200/300?random=2','讲述了在大时代背景下，主人公徐福贵的人生和家庭不断经受着苦难，到了最后，所有亲人都先后离他而去，仅剩下年老的他和一头老牛相依为命的故事。'),(3,'9787532745214','老人与海','欧内斯特·海明威','literature',3,2,'书架1-3','https://picsum.photos/200/300?random=3','故事围绕一位老年古巴渔夫，与一条巨大的马林鱼在离岸很远的湾流中的搏斗展开。'),(4,'9787535440041','时间简史','史蒂芬·霍金','science',6,4,'书架2-1','https://picsum.photos/200/300?random=4','介绍了宇宙的起源、黑洞、时间旅行等宇宙学的前沿概念。'),(5,'9787535794408','万物简史','比尔·布莱森','science',7,5,'书架2-2','https://picsum.photos/200/300?random=5','以幽默风趣的语言，讲述了宇宙从大爆炸到人类出现的演化过程。'),(6,'9787111628119','人类简史：从动物到上帝','尤瓦尔·赫拉利','history',10,8,'书架3-1','https://picsum.photos/200/300?random=6','讲述了人类如何从一个普通的非洲灵长类动物，演化成地球的主宰。'),(7,'9787111496710','未来简史','尤瓦尔·赫拉利','history',4,3,'书架3-2','https://picsum.photos/200/300?random=7','探讨了人类未来可能的发展方向，如人工智能、生物技术等对人类社会的影响。'),(8,'9787111590411','三体','刘慈欣','technology',9,7,'书架4-1','https://picsum.photos/200/300?random=8','一部科幻小说，讲述了地球人类文明和三体文明的信息交流、生死搏杀及两个文明在宇宙中的兴衰历程。'),(9,'9787111482218','失控：全人类的最终命运和结局','凯文·凯利','technology',5,4,'书架4-2','https://picsum.photos/200/300?random=9','讨论了分布式系统、网络经济、生物进化等领域的前沿思想。'),(10,'9787544720710','解忧杂货店','东野圭吾','literature',8,6,'书架1-4','https://picsum.photos/200/300?random=10','讲述了一家名为\"解忧杂货店\"的店铺，人们可以在那里写下烦恼投进店前门卷帘门的投信口，第二天就会在店后的牛奶箱里得到回答的故事。'),(11,'9787508630682','大数据时代','维克托·迈尔-舍恩伯格','technology',7,5,'书架4-3','https://picsum.photos/200/300?random=11','介绍了大数据时代的思维变革、商业变革和管理变革。'),(12,'9787300225045','思考，快与慢','丹尼尔·卡尼曼','economics',6,4,'书架5-1','https://picsum.photos/200/300?random=12','讲述了人类思维的两种模式：快思考和慢思考，以及它们如何影响我们的决策。'),(13,'9787508659607','资本论','卡尔·马克思','economics',3,2,'书架5-2','https://picsum.photos/200/300?random=13','以剩余价值为中心，对资本主义进行了彻底的批判。');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `borrow`
--

DROP TABLE IF EXISTS `borrow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `borrow` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '借阅记录ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `book_id` int NOT NULL COMMENT '图书ID',
  `borrow_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '借出时间',
  `return_date` datetime DEFAULT NULL COMMENT '归还时间',
  `due_date` datetime NOT NULL COMMENT '应还时间',
  `status` enum('borrowed','returned','overdue') DEFAULT 'borrowed' COMMENT '借阅状态',
  PRIMARY KEY (`id`),
  KEY `fk_borrow_user` (`user_id`),
  KEY `fk_borrow_book` (`book_id`),
  CONSTRAINT `fk_borrow_book` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_borrow_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `borrow`
--

LOCK TABLES `borrow` WRITE;
/*!40000 ALTER TABLE `borrow` DISABLE KEYS */;
INSERT INTO `borrow` VALUES (3,2,3,'2025-05-16 15:06:23','2025-05-16 15:07:21','2025-06-15 15:06:23','returned'),(4,2,2,'2025-05-16 15:09:53','2025-05-18 12:14:50','2025-05-15 15:09:53','overdue'),(5,1,2,'2025-05-17 22:59:24','2025-05-18 12:14:26','2025-05-16 22:59:24','overdue'),(6,4,3,'2025-05-17 23:38:10','2025-05-18 12:10:31','2025-05-16 23:38:10','returned'),(7,4,8,'2025-05-18 12:15:19','2025-05-18 14:01:06','2025-07-24 12:15:19','returned');
/*!40000 ALTER TABLE `borrow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '密码（加密存储）',
  `role` enum('admin','user') DEFAULT 'user' COMMENT '角色',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像URL',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'user1','$2b$10$ZrcqymdEBZPpBdx697u75u6ZKTfmZhURo6kbX8hNG.YC62kpoY7G2','user',NULL,'2025-05-15 03:39:06','123@qq.com'),(2,'admin','$2b$10$ZrcqymdEBZPpBdx697u75u6ZKTfmZhURo6kbX8hNG.YC62kpoY7G2','admin',NULL,'2025-05-15 03:39:42','234@qq.com'),(3,'202301510008','$2b$10$udI0BzkFwYJwtB/d2iulaONEEdYmjAtyCDnjZHQizwxKtvu0GvEX2','user',NULL,'2025-05-17 15:09:36',NULL),(4,'123','$2b$10$0rxDxOLhjE1.XsXXadr50.nG0gKsXXGtkfv006yrC/8.FC1D4t0R6','user',NULL,'2025-05-17 15:16:38','123@lmj.com'),(5,'321','$2b$10$qpCHQmOz/77a984SHf9aQ.8xTYDeOVYORh2tYfux6/0aJoBK2X3uO','user',NULL,'2025-05-17 15:18:56','321@qq.com'),(6,'321321','$2b$10$TZ21Wx77W1h2PKiLEXE0cOgRzzAnNmMjxbGx9zZsm0h9Q/B5fIAu2','user',NULL,'2025-05-17 15:20:26',NULL),(7,'admin33','$2b$10$u.aFPuRYgeWwTLoK8fCvteoSTypceokkCXvOUK9s.ZYrGXtaF/sx.','user',NULL,'2025-05-17 15:20:42',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database '1'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-18 14:11:05

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
  PRIMARY KEY (`id`),
  UNIQUE KEY `books_unique` (`isbn`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'9787020049741','平凡的世界','路遥','literature',5,3,'书架1-1','https://picsum.photos/200/300?random=1','一部全景式地表现中国当代城乡社会生活的长篇小说。'),(2,'9787020137082','活着','余华','literature',8,6,'书架1-2','https://picsum.photos/200/300?random=2','讲述了在大时代背景下，主人公徐福贵的人生和家庭不断经受着苦难，到了最后，所有亲人都先后离他而去，仅剩下年老的他和一头老牛相依为命的故事。'),(3,'9787532745214','老人与海','欧内斯特·海明威','literature',3,2,'书架1-3','https://picsum.photos/200/300?random=3','故事围绕一位老年古巴渔夫，与一条巨大的马林鱼在离岸很远的湾流中的搏斗展开。'),(4,'9787535440041','时间简史','史蒂芬·霍金','science',6,4,'书架2-1','https://picsum.photos/200/300?random=4','介绍了宇宙的起源、黑洞、时间旅行等宇宙学的前沿概念。'),(5,'9787535794408','万物简史','比尔·布莱森','science',7,5,'书架2-2','https://picsum.photos/200/300?random=5','以幽默风趣的语言，讲述了宇宙从大爆炸到人类出现的演化过程。'),(6,'9787111628119','人类简史：从动物到上帝','尤瓦尔·赫拉利','history',10,8,'书架3-1','https://picsum.photos/200/300?random=6','讲述了人类如何从一个普通的非洲灵长类动物，演化成地球的主宰。'),(7,'9787111496710','未来简史','尤瓦尔·赫拉利','history',4,3,'书架3-2','https://picsum.photos/200/300?random=7','探讨了人类未来可能的发展方向，如人工智能、生物技术等对人类社会的影响。'),(8,'9787111590411','三体','刘慈欣','technology',9,7,'书架4-1','https://picsum.photos/200/300?random=8','一部科幻小说，讲述了地球人类文明和三体文明的信息交流、生死搏杀及两个文明在宇宙中的兴衰历程。'),(9,'9787111482218','失控：全人类的最终命运和结局','凯文·凯利','technology',5,4,'书架4-2','https://picsum.photos/200/300?random=9','讨论了分布式系统、网络经济、生物进化等领域的前沿思想。'),(10,'9787544720710','解忧杂货店','东野圭吾','literature',8,6,'书架1-4','https://picsum.photos/200/300?random=10','讲述了一家名为\"解忧杂货店\"的店铺，人们可以在那里写下烦恼投进店前门卷帘门的投信口，第二天就会在店后的牛奶箱里得到回答的故事。'),(11,'9787508630682','大数据时代','维克托·迈尔-舍恩伯格','technology',7,5,'书架4-3','https://picsum.photos/200/300?random=11','介绍了大数据时代的思维变革、商业变革和管理变革。'),(12,'9787300225045','思考，快与慢','丹尼尔·卡尼曼','economics',6,4,'书架5-1','https://picsum.photos/200/300?random=12','讲述了人类思维的两种模式：快思考和慢思考，以及它们如何影响我们的决策。'),(13,'9787508659607','资本论','卡尔·马克思','economics',3,2,'书架5-2','https://picsum.photos/200/300?random=13','以剩余价值为中心，对资本主义进行了彻底的批判。'),(14,'9787544730788','梦的解析','西格蒙德·弗洛伊德','philosophy',4,3,'书架6-1','https://picsum.photos/200/300?random=14','弗洛伊德通过对梦的分析，提出了潜意识的概念，开创了精神分析学派。'),(16,'9787115472582','JavaScript高级程序设计','Nicholas C. Zakas','technology',10,10,'A区3排2架','https://example.com/cover.jpg','经典JavaScript书籍，深入讲解JavaScript核心概念'),(18,'9787302518356','Python编程：从入门到实践','Eric Matthes','technology',15,15,'B区2排1架','https://example.com/python-cover.jpg','一本适合初学者的Python编程书籍，涵盖基础知识和实践项目'),(21,'9787302518336','Python1编程：从入门到实践','Eric Matthes','technology',15,15,'B区2排1架','https://example.com/python-cover.jpg','一本适合初学者的Python编程书籍，涵盖基础知识和实践项目'),(24,'1','1','1','technology',1,1,'B区1排1架',NULL,NULL);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `borrow`
--

LOCK TABLES `borrow` WRITE;
/*!40000 ALTER TABLE `borrow` DISABLE KEYS */;
/*!40000 ALTER TABLE `borrow` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'testuser','123456'),(3,'202301510008','$2b$10$hdtAsgAVvOuniafe/wFv3eQ3r7v05PLeMsNzzIelzId5meoW0dXzC'),(4,'123','$2b$10$IweXqKtBsDjn2jgnJ1KXfOPsNCPv/y2jnfXjFfjxiVszrCTijJZse'),(5,'admin','$2b$10$/SyAfSFpRmSECMdA38ZAZuhHH4rllW0Wh1aY76cEY8LJO4DdLJh/S'),(6,'321','$2b$10$cj5OaXCvtycBrsogPo3dFe3rrZ6v7o4VWkm3Tvei0BTPglKB7pdXO');
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

-- Dump completed on 2025-05-16 17:55:09

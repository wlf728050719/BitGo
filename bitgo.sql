/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 5.5.40 : Database - bitgo
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`bitgo` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `bitgo`;

/*Table structure for table `comments` */

DROP TABLE IF EXISTS `comments`;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `description` text NOT NULL,
  `score` int(11) DEFAULT NULL,
  `DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `next_id` int(11) DEFAULT '-1',
  `TYPE` enum('original','follow','reply') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;

/*Data for the table `comments` */

insert  into `comments`(`id`,`order_id`,`description`,`score`,`DATE`,`next_id`,`TYPE`) values (28,12,'1',5,'2024-12-09 17:04:55',29,'original'),(29,12,'2',NULL,'2024-12-09 17:20:05',30,'reply'),(30,12,'3',NULL,'2024-12-09 17:20:51',35,'follow'),(33,12,'4',NULL,'2024-12-10 18:34:26',-1,'follow'),(34,12,'5',NULL,'2024-12-10 18:37:04',-1,'follow'),(35,12,'6',NULL,'2024-12-10 18:37:51',-1,'follow');

/*Table structure for table `inventory` */

DROP TABLE IF EXISTS `inventory`;

CREATE TABLE `inventory` (
  `product_id` int(11) NOT NULL DEFAULT '0',
  `stock` int(11) NOT NULL,
  `sale_amount` int(11) DEFAULT '0',
  PRIMARY KEY (`product_id`),
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `inventory` */

insert  into `inventory`(`product_id`,`stock`,`sale_amount`) values (1,3,2),(2,5,0),(3,5,0),(4,5,0),(5,5,0),(6,5,0),(7,5,0),(8,5,0),(9,5,0),(10,5,0),(11,5,0),(12,5,0),(13,5,0),(14,5,0),(15,5,0),(16,5,0);

/*Table structure for table `orders` */

DROP TABLE IF EXISTS `orders`;

CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `buyer_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `shipping_address` varchar(255) NOT NULL,
  `recipient_name` varchar(100) NOT NULL,
  `STATUS` enum('pending','shipped','delivered','canceled') NOT NULL DEFAULT 'pending',
  `DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `buyer_id` (`buyer_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `orders` */

insert  into `orders`(`id`,`buyer_id`,`product_id`,`amount`,`phone`,`shipping_address`,`recipient_name`,`STATUS`,`DATE`) values (9,1,5,1,'1','1','1','canceled','2024-12-08 21:40:56'),(10,1,7,1,'1','1','1','shipped','2024-12-09 15:28:26'),(11,1,7,1,'1','1','1','pending','2024-12-09 15:28:58'),(12,1,5,1,'1','1','1','delivered','2024-12-09 15:28:58'),(13,1,11,1,'1','1','1','pending','2024-12-09 17:04:43'),(14,1,5,1,'6','6','6','delivered','2024-12-09 17:25:33'),(15,1,5,1,'1','1','1','delivered','2024-12-09 17:31:54'),(16,1,1,1,'1','1','1','delivered','2024-12-09 17:43:17'),(17,1,1,1,'2','2','2','delivered','2024-12-09 17:44:40'),(18,1,1,1,'2','2','2','canceled','2024-12-09 17:45:09');

/*Table structure for table `product_images` */

DROP TABLE IF EXISTS `product_images`;

CREATE TABLE `product_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `image_url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;

/*Data for the table `product_images` */

insert  into `product_images`(`id`,`product_id`,`image_url`) values (1,1,'app.media.Home1'),(2,1,'app.media.Home2'),(3,1,'app.media.Home3'),(4,2,'app.media.Sports1'),(5,2,'app.media.Sports2'),(6,2,'app.media.Sports3'),(7,3,'app.media.Beauty1'),(8,3,'app.media.Beauty2'),(9,3,'app.media.Beauty3'),(10,4,'app.media.Baby1'),(11,4,'app.media.Baby2'),(12,4,'app.media.Baby3'),(13,5,'app.media.Digital1'),(14,5,'app.media.Digital2'),(15,5,'app.media.Digital3'),(16,6,'app.media.Appliances1'),(17,6,'app.media.Appliances2'),(18,6,'app.media.Appliances3'),(19,7,'app.media.Sports1'),(20,7,'app.media.Sports2'),(21,7,'app.media.Sports3'),(22,8,'app.media.Books1'),(23,8,'app.media.Books2'),(24,8,'app.media.Books3'),(25,9,'app.media.Pets1'),(26,9,'app.media.Pets2'),(27,9,'app.media.Pets3'),(28,10,'app.media.Antiques1'),(29,11,'app.media.Sports1'),(30,11,'app.media.Sports2'),(31,11,'app.media.Sports3'),(32,12,'app.media.Crafts1'),(33,12,'app.media.Crafts2'),(34,12,'app.media.Crafts3'),(35,13,'app.media.Antiques1'),(36,13,'app.media.Antiques2'),(37,13,'app.media.Antiques3'),(38,14,'app.media.Digital1'),(39,14,'app.media.Digital2'),(40,14,'app.media.Digital3'),(41,15,'app.media.Toys1'),(42,15,'app.media.Toys2'),(43,15,'app.media.Toys3'),(44,16,'app.media.Office1'),(45,16,'app.media.Office2'),(46,16,'app.media.Office3'),(47,17,'app.media.Appliances1'),(48,17,'app.media.Appliances2'),(49,17,'app.media.Appliances3'),(50,18,'app.media.Beauty1'),(51,18,'app.media.Beauty2'),(52,18,'app.media.Beauty3'),(53,19,'app.media.Pets1'),(54,19,'app.media.Pets2'),(55,19,'app.media.Pets3'),(56,20,'app.media.Books1');

/*Table structure for table `product_types` */

DROP TABLE IF EXISTS `product_types`;

CREATE TABLE `product_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `TYPE` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `TYPE` (`TYPE`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

/*Data for the table `product_types` */

insert  into `product_types`(`id`,`TYPE`) values (1,'优惠券码'),(13,'办公文具'),(11,'包表服饰'),(15,'古玩收藏'),(12,'图书音像'),(9,'宠物花卉'),(2,'家居生活'),(10,'家用电器'),(14,'手工艺品'),(5,'数码产品'),(6,'服饰鞋帽'),(8,'模玩动漫'),(4,'母婴用品'),(3,'美容彩妆'),(7,'运动户外');

/*Table structure for table `products` */

DROP TABLE IF EXISTS `products`;

CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(100) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `location` varchar(100) DEFAULT NULL,
  `type_id` int(11) NOT NULL,
  `DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `seller_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type_id` (`type_id`),
  KEY `seller_id` (`seller_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`type_id`) REFERENCES `product_types` (`id`) ON DELETE CASCADE,
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

/*Data for the table `products` */

insert  into `products`(`id`,`NAME`,`description`,`price`,`location`,`type_id`,`DATE`,`seller_id`) values (1,'家用吸尘器','高效能家用吸尘器，适合各种地面清洁。','299.99','北京市朝阳区',10,'2024-12-06 16:30:43',1),(2,'运动鞋','透气舒适的运动鞋，适合跑步和日常穿着。','499.00','上海市浦东新区',6,'2024-12-06 16:30:43',1),(3,'美容面膜','深层滋养，适合各种肤质的美容面膜。','89.50','广州市天河区',3,'2024-12-06 16:30:43',1),(4,'婴儿推车','轻便折叠婴儿推车，适合外出使用。','799.00','深圳市南山区',4,'2024-12-06 16:30:43',1),(5,'智能音响','支持语音控制的智能音响，音质出众。','599.99','杭州市西湖区',5,'2024-12-06 16:30:43',1),(6,'咖啡机','全自动咖啡机，轻松制作各种咖啡。','1299.00','成都市锦江区',10,'2024-12-06 16:30:43',1),(7,'瑜伽垫','环保材料制成的瑜伽垫，防滑设计。','199.00','武汉市武昌区',7,'2024-12-06 16:30:43',1),(8,'儿童图画书','适合3-6岁儿童的图画书，丰富多彩。','59.90','南京市鼓楼区',12,'2024-12-06 16:30:43',1),(9,'宠物玩具','适合狗狗的耐咬玩具，增加互动乐趣。','39.90','重庆市渝中区',9,'2024-12-06 16:30:43',1),(10,'古董花瓶','精美的古董花瓶，适合家居装饰。','1500.00','西安市碑林区',15,'2024-12-06 16:30:43',1),(11,'运动手表','多功能运动手表，支持心率监测和GPS定位。','899.00','北京市海淀区',5,'2024-12-06 16:31:04',1),(12,'手工艺品','独特的手工艺品，适合收藏和赠送。','250.00','上海市徐汇区',14,'2024-12-06 16:31:04',1),(13,'古董家具','精美的古董家具，适合家居装饰。','5000.00','广州市越秀区',15,'2024-12-06 16:31:04',1),(14,'数码相机','高像素数码相机，适合专业摄影。','2999.00','深圳市福田区',5,'2024-12-06 16:31:04',1),(15,'儿童玩具','安全环保的儿童玩具，适合3岁以上儿童。','149.00','杭州市下城区',4,'2024-12-06 16:31:04',1),(16,'办公桌','现代简约风格的办公桌，适合家庭和办公室使用。','799.00','武汉市汉阳区',2,'2024-12-06 16:31:04',1),(17,'家用电饭煲','智能电饭煲，支持多种烹饪模式。','399.00','南京市浦口区',10,'2024-12-06 16:31:04',1),(18,'美容仪器','高科技美容仪器，帮助改善肌肤。','1299.00','重庆市沙坪坝区',3,'2024-12-06 16:31:04',1),(19,'宠物食品','营养丰富的宠物食品，适合各种宠物。','89.90','西安市雁塔区',9,'2024-12-06 16:31:04',1),(20,'图书','各类图书，适合不同年龄段的读者。','39.90','成都市青羊区',12,'2024-12-06 16:31:04',1);

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(15) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `state` enum('active','using','frozen','canceled','banned') NOT NULL DEFAULT 'active',
  `last_login` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account` (`account`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Data for the table `users` */

insert  into `users`(`id`,`account`,`username`,`password`,`email`,`state`,`last_login`) values (1,'12345678900','wlf123','04ae4a975cd1638053f679e92441f36d','72805719@qq.com','active','2024-12-05 16:17:23');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

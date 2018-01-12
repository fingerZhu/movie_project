/*
Navicat MySQL Data Transfer

Source Server         : 本地数据库
Source Server Version : 50719
Source Host           : localhost:3306
Source Database       : movie

Target Server Type    : MYSQL
Target Server Version : 50719
File Encoding         : 65001

Date: 2018-01-12 17:23:52
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `pwd` varchar(100) DEFAULT NULL,
  `is_super` smallint(6) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `role_id` (`role_id`),
  KEY `ix_admin_addtime` (`addtime`),
  CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES ('1', 'finger', 'pbkdf2:sha256:50000$IvZ5IEdB$4349edfefd157f79b0cd7d340857532171d3a17a9282972127659488ef3525ce', '0', '1', '2017-12-27 16:40:28');
INSERT INTO `admin` VALUES ('2', 'finger1', 'pbkdf2:sha256:50000$dkzVtlOk$180b3e3a82a29e8b931727eb9d1b201ac2092e3e31783d3350676bc46c4e2a97', '0', '2', '2017-12-27 16:42:05');

-- ----------------------------
-- Table structure for adminlog
-- ----------------------------
DROP TABLE IF EXISTS `adminlog`;
CREATE TABLE `adminlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `ip` varchar(100) DEFAULT NULL,
  `addtime` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_id` (`admin_id`),
  KEY `ix_adminlog_addtime` (`addtime`),
  CONSTRAINT `adminlog_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of adminlog
-- ----------------------------
INSERT INTO `adminlog` VALUES ('1', '1', '127.0.0.1', '2018-01-10');
INSERT INTO `adminlog` VALUES ('2', '2', '127.0.0.1', '2018-01-10');
INSERT INTO `adminlog` VALUES ('3', '1', '127.0.0.1', '2018-01-11');
INSERT INTO `adminlog` VALUES ('4', '1', '127.0.0.1', '2018-01-11');
INSERT INTO `adminlog` VALUES ('5', '1', '127.0.0.1', '2018-01-11');
INSERT INTO `adminlog` VALUES ('6', '2', '127.0.0.1', '2018-01-11');
INSERT INTO `adminlog` VALUES ('7', '1', '127.0.0.1', '2018-01-11');

-- ----------------------------
-- Table structure for auth
-- ----------------------------
DROP TABLE IF EXISTS `auth`;
CREATE TABLE `auth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `url` (`url`),
  KEY `ix_auth_addtime` (`addtime`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth
-- ----------------------------
INSERT INTO `auth` VALUES ('1', '添加标签', '/admin/tag/add/', '2018-01-11 10:19:33');
INSERT INTO `auth` VALUES ('2', '编辑标签', '/admin/tag/edit/<int:id>/', '2018-01-11 10:22:07');
INSERT INTO `auth` VALUES ('3', '标签列表', '/admin/tag/list/<int:page>/', '2018-01-11 10:22:50');
INSERT INTO `auth` VALUES ('4', '删除标签', '/admin/tag/del/<int:id>/', '2018-01-11 10:23:09');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text,
  `movie_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `movie_id` (`movie_id`),
  KEY `user_id` (`user_id`),
  KEY `ix_comment_addtime` (`addtime`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`),
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES ('1', '好看', '4', '7', '2018-01-10 10:19:26');
INSERT INTO `comment` VALUES ('2', '经典', '4', '15', '2018-01-10 10:19:27');
INSERT INTO `comment` VALUES ('3', '给力', '6', '12', '2018-01-10 10:19:27');
INSERT INTO `comment` VALUES ('5', '垃圾', '4', '10', '2018-01-10 10:19:28');
INSERT INTO `comment` VALUES ('6', '无聊', '4', '14', '2018-01-10 10:19:28');
INSERT INTO `comment` VALUES ('7', '恶心', '4', '12', '2018-01-10 10:19:28');

-- ----------------------------
-- Table structure for movie
-- ----------------------------
DROP TABLE IF EXISTS `movie`;
CREATE TABLE `movie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `info` text,
  `logo` varchar(255) DEFAULT NULL,
  `star` smallint(6) DEFAULT NULL,
  `playnum` bigint(20) DEFAULT NULL,
  `commentnum` bigint(20) DEFAULT NULL,
  `tag_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `release_time` date DEFAULT NULL,
  `length` varchar(100) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`),
  UNIQUE KEY `url` (`url`),
  UNIQUE KEY `logo` (`logo`),
  KEY `tag_id` (`tag_id`),
  KEY `ix_movie_addtime` (`addtime`),
  CONSTRAINT `movie_ibfk_1` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of movie
-- ----------------------------
INSERT INTO `movie` VALUES ('4', '环太平洋', '20180108144022bb437dab382a438bb7ab00a0caea5fe3.mp4', '阿瓦尔撒地方', '2018010814402274aafb140ec044cb8e0a204fe4fd47af.png', '5', '0', '0', '5', '美国', '2018-02-01', '5', '2018-01-08 14:40:23');
INSERT INTO `movie` VALUES ('6', '啥的符文123456', '201801081533406734d40cd2bb49b38d313ab2de42da4e.mp4', '玩儿玩儿人123456', '2018010815334044e8e44466744e0aa884b0f12b8fe1c0.png', '1', '0', '0', '6', '名人堂123456', '2018-01-21', '3123456', '2018-01-08 15:05:59');

-- ----------------------------
-- Table structure for moviecol
-- ----------------------------
DROP TABLE IF EXISTS `moviecol`;
CREATE TABLE `moviecol` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text,
  `movie_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `movie_id` (`movie_id`),
  KEY `user_id` (`user_id`),
  KEY `ix_moviecol_addtime` (`addtime`),
  CONSTRAINT `moviecol_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`),
  CONSTRAINT `moviecol_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of moviecol
-- ----------------------------
INSERT INTO `moviecol` VALUES ('1', '废话', '4', '13', '2018-01-10 11:01:25');
INSERT INTO `moviecol` VALUES ('3', '废话', '6', '15', '2018-01-10 11:01:25');
INSERT INTO `moviecol` VALUES ('4', '废话', '4', '11', '2018-01-10 11:01:25');
INSERT INTO `moviecol` VALUES ('5', '废话', '4', '12', '2018-01-10 11:01:25');
INSERT INTO `moviecol` VALUES ('6', '废话', '4', '14', '2018-01-10 11:01:25');
INSERT INTO `moviecol` VALUES ('7', '废话', '6', '11', '2018-01-10 11:01:25');
INSERT INTO `moviecol` VALUES ('8', '废话', '4', '14', '2018-01-10 11:01:25');
INSERT INTO `moviecol` VALUES ('9', '废话', '6', '12', '2018-01-10 11:01:25');
INSERT INTO `moviecol` VALUES ('10', '废话', '4', '12', '2018-01-10 11:01:25');

-- ----------------------------
-- Table structure for oplog
-- ----------------------------
DROP TABLE IF EXISTS `oplog`;
CREATE TABLE `oplog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `ip` varchar(100) DEFAULT NULL,
  `reason` varchar(600) DEFAULT NULL,
  `addtime` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_id` (`admin_id`),
  KEY `ix_oplog_addtime` (`addtime`),
  CONSTRAINT `oplog_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of oplog
-- ----------------------------
INSERT INTO `oplog` VALUES ('1', '1', '127.0.0.1', '添加标签sdf', '2018-01-10');
INSERT INTO `oplog` VALUES ('2', '1', '127.0.0.1', '添加标签456', '2018-01-10');
INSERT INTO `oplog` VALUES ('3', '1', '127.0.0.1', '添加标签哈哈', '2018-01-10');

-- ----------------------------
-- Table structure for preview
-- ----------------------------
DROP TABLE IF EXISTS `preview`;
CREATE TABLE `preview` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`),
  UNIQUE KEY `logo` (`logo`),
  KEY `ix_preview_addtime` (`addtime`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of preview
-- ----------------------------
INSERT INTO `preview` VALUES ('1', '木乃伊12', '201801081623428d93529f29384fc298c08fcef19be61d.png', '2018-01-08 15:51:26');
INSERT INTO `preview` VALUES ('3', '武器而', '20180110144603ba1dd8189b444b90a4d1fddde77d7b73.png', '2018-01-10 14:46:04');

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `auths` varchar(600) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `ix_role_addtime` (`addtime`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', '超级管理员', '1,2,3,4', '2017-12-27 16:20:12');
INSERT INTO `role` VALUES ('2', '普通管理员', '3', '2018-01-11 11:01:21');

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `ix_tag_addtime` (`addtime`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tag
-- ----------------------------
INSERT INTO `tag` VALUES ('3', '爱情', '2018-01-05 15:56:15');
INSERT INTO `tag` VALUES ('4', '动作', '2018-01-05 15:56:45');
INSERT INTO `tag` VALUES ('5', '科幻', '2018-01-05 15:56:53');
INSERT INTO `tag` VALUES ('6', '悬疑', '2018-01-05 16:00:33');
INSERT INTO `tag` VALUES ('10', '传记', '2018-01-10 14:07:55');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `pwd` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(11) DEFAULT NULL,
  `info` text,
  `face` varchar(255) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `ix_user_addtime` (`addtime`),
  KEY `face` (`face`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('7', '小红', '123', '888316493@qq.com', '18650979653', '小红', '20180108150558dd20b1539be94e0b854315bc9e9b63b6.png', '2018-01-08 16:49:20', '27cd89b78ea540b6a5bf444531a586e9');
INSERT INTO `user` VALUES ('8', '小明', '123', '381281328@qq.com', '18667110547', '小明', '20180108150558dd20b1539be94e0b854315bc9e9b63b6.png', '2018-01-08 16:49:20', '6ccacca6ceec45fd9df83e8e1fc0854d');
INSERT INTO `user` VALUES ('9', '小李', '123', '333277891@qq.com', '18639597757', '小李', '20180108150558dd20b1539be94e0b854315bc9e9b63b6.png', '2018-01-08 16:49:20', '4ec1cb0fafd4489a9d0df7ca5add690e');
INSERT INTO `user` VALUES ('10', '小刚', '123', '494062075@qq.com', '18658024691', '小刚', '20180108150558dd20b1539be94e0b854315bc9e9b63b6.png', '2018-01-08 16:49:20', '49f08e9170984959bc8e024bfe498dd1');
INSERT INTO `user` VALUES ('11', '小朱', '123', '826158720@qq.com', '18698155919', '小朱', '20180108150558dd20b1539be94e0b854315bc9e9b63b6.png', '2018-01-08 16:49:20', 'e5d76620a4da453b83d83a08feb54502');
INSERT INTO `user` VALUES ('12', '小A', '123', '470249856@qq.com', '18676861145', '小A', '20180108150558dd20b1539be94e0b854315bc9e9b63b6.png', '2018-01-08 16:49:20', '9aeb662b52c149faaa16047e950ec3e0');
INSERT INTO `user` VALUES ('13', '小B', '123', '174889464@qq.com', '18659294011', '小B', '20180108150558dd20b1539be94e0b854315bc9e9b63b6.png', '2018-01-08 16:49:20', '4d69cff7375940c193b3fb2da82510c4');
INSERT INTO `user` VALUES ('14', '小C', '123', '597365465@qq.com', '18693483069', '小C', '20180108150558dd20b1539be94e0b854315bc9e9b63b6.png', '2018-01-08 16:49:20', '96c3ab11d67c4f4cb564567a7920e190');
INSERT INTO `user` VALUES ('15', '小D', '123', '559930305@qq.com', '18685818318', '小D', '20180108150558dd20b1539be94e0b854315bc9e9b63b6.png', '2018-01-08 16:49:20', 'ccda261397eb4d699fc7464a3a08d23e');

-- ----------------------------
-- Table structure for userlog
-- ----------------------------
DROP TABLE IF EXISTS `userlog`;
CREATE TABLE `userlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `ip` varchar(100) DEFAULT NULL,
  `addtime` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `ix_userlog_addtime` (`addtime`),
  CONSTRAINT `userlog_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of userlog
-- ----------------------------
INSERT INTO `userlog` VALUES ('1', '8', '127.0.0.1', '2018-01-10');
INSERT INTO `userlog` VALUES ('2', '10', '127.0.0.1', '2018-01-10');
INSERT INTO `userlog` VALUES ('3', '9', '127.0.0.1', '2018-01-09');
INSERT INTO `userlog` VALUES ('4', '11', '127.0.0.1', '2018-01-12');
INSERT INTO `userlog` VALUES ('5', '15', '127.0.0.1', '2018-01-03');
INSERT INTO `userlog` VALUES ('6', '14', '127.0.0.1', '2018-01-16');
INSERT INTO `userlog` VALUES ('7', '7', '127.0.0.1', '2018-01-15');
INSERT INTO `userlog` VALUES ('8', '13', '127.0.0.1', '2018-01-24');
INSERT INTO `userlog` VALUES ('9', '12', '127.0.0.1', '2018-01-12');

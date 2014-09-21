/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50525
 Source Host           : localhost
 Source Database       : etim

 Target Server Type    : MySQL
 Target Server Version : 50525
 File Encoding         : utf-8

 Date: 09/21/2014 17:15:56 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `friend`
-- ----------------------------
DROP TABLE IF EXISTS `friend`;
CREATE TABLE `friend` (
  `friend_id` int(11) NOT NULL AUTO_INCREMENT,
  `friend_from` int(11) DEFAULT NULL COMMENT 'a from b, b是a的好友',
  `friend_to` int(11) DEFAULT NULL,
  `req_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`friend_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `friend`
-- ----------------------------
BEGIN;
INSERT INTO `friend` VALUES ('34', '2', '1', '34'), ('35', '1', '2', '35');
COMMIT;

-- ----------------------------
--  Table structure for `message`
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `msg_id` int(11) NOT NULL AUTO_INCREMENT,
  `msg_from` int(11) NOT NULL,
  `msg_to` int(11) NOT NULL,
  `req_time` datetime NOT NULL COMMENT '请求发送时间',
  `send_time` datetime NOT NULL,
  `sent` tinyint(4) NOT NULL COMMENT '是否已发送给接收方0没有1已发送',
  `message` varchar(45) NOT NULL,
  PRIMARY KEY (`msg_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `message`
-- ----------------------------
BEGIN;
INSERT INTO `message` VALUES ('1', '2', '1', '2014-09-17 22:29:39', '2014-09-17 22:29:39', '1', 'Hello'), ('2', '2', '1', '2014-09-17 22:34:17', '2014-09-17 22:34:17', '1', 'Df '), ('3', '2', '1', '2014-09-17 22:34:21', '2014-09-17 22:34:21', '1', 'Dfdf'), ('4', '2', '1', '2014-09-17 22:34:25', '2014-09-17 22:34:25', '1', 'Dfdf '), ('5', '2', '1', '2014-09-17 22:34:40', '2014-09-17 22:34:40', '1', 'Dfdf sss '), ('6', '1', '2', '2014-09-18 09:20:49', '2014-09-18 09:20:49', '1', 'Hello'), ('7', '1', '1', '2014-09-18 09:21:02', '2014-09-18 09:21:02', '1', 'Hello2 ');
COMMIT;

-- ----------------------------
--  Table structure for `request`
-- ----------------------------
DROP TABLE IF EXISTS `request`;
CREATE TABLE `request` (
  `req_id` int(11) NOT NULL AUTO_INCREMENT,
  `req_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0:请求未发送 1:请求已发送 2:请求被拒绝 4:请求已同意 0|2:请求被拒绝未发送到请求方 1|2:请求被拒绝已发送请求方向 0|4:请求已同意未发送到请求方 1|4:请求已同意已发送到请求方',
  `req_time` datetime NOT NULL,
  `req_send_time` datetime NOT NULL COMMENT '请求发送时间',
  `action_time` datetime NOT NULL COMMENT '接受或拒绝时间',
  `action_send_time` datetime NOT NULL COMMENT '请求或拒绝发送到原请求方的时间',
  PRIMARY KEY (`req_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `request`
-- ----------------------------
BEGIN;
INSERT INTO `request` VALUES ('34', '5', '2014-09-11 23:22:29', '2014-09-11 23:22:29', '2014-09-11 23:22:35', '2014-09-11 23:22:35'), ('35', '1', '2014-09-11 23:22:45', '2014-09-11 23:22:45', '2014-09-11 23:22:45', '2014-09-11 23:22:45');
COMMIT;

-- ----------------------------
--  Table structure for `status`
-- ----------------------------
DROP TABLE IF EXISTS `status`;
CREATE TABLE `status` (
  `status_id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `status_name` varchar(45) NOT NULL COMMENT '在线状态',
  PRIMARY KEY (`status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `status`
-- ----------------------------
BEGIN;
INSERT INTO `status` VALUES ('1', '在线'), ('2', '隐身'), ('3', '离开'), ('4', '离线');
COMMIT;

-- ----------------------------
--  Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) DEFAULT NULL,
  `password` varchar(45) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `reg_time` datetime DEFAULT NULL COMMENT '注册时间',
  `last_time` datetime DEFAULT NULL COMMENT '上次操作时间,',
  `signature` varchar(45) DEFAULT '暂无签名' COMMENT '用户签名',
  `gender` tinyint(4) DEFAULT NULL COMMENT '性别',
  `status_id` tinyint(4) DEFAULT '4' COMMENT '状态ID 1:在线 2:隐身 3:离开 4:离线',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `user`
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES ('1', 'admin1', 'admin', '2014-09-04 17:13:02', '2014-09-04 17:13:02', '暂无签名', '0', '1'), ('2', 'admin2', 'admin', '2014-09-04 17:14:07', '2014-09-04 17:14:07', '暂无签名', '0', '1'), ('3', 'admin3', 'admin', '2014-09-04 17:14:23', '2014-09-04 17:14:23', '暂无签名', '0', '1'), ('4', 'admin4', 'admin', '2014-09-04 17:14:38', '2014-09-04 17:14:38', '暂无签名', '0', '4'), ('5', 'admin5', 'admin', '2014-09-04 17:14:46', '2014-09-04 17:14:46', '暂无签名', '0', '4');
COMMIT;


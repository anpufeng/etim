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

 Date: 09/03/2014 23:00:00 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `event`
-- ----------------------------
DROP TABLE IF EXISTS `event`;
CREATE TABLE `event` (
  `event_id` int(11) NOT NULL AUTO_INCREMENT,
  `event_type` tinyint(4) NOT NULL COMMENT '事件类型 0添加好友,1删除好友',
  `event_done` bit(1) NOT NULL COMMENT '是否完成',
  PRIMARY KEY (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `event`
-- ----------------------------
BEGIN;
INSERT INTO `event` VALUES ('1', '1', b'1');
COMMIT;

-- ----------------------------
--  Table structure for `friend`
-- ----------------------------
DROP TABLE IF EXISTS `friend`;
CREATE TABLE `friend` (
  `friend_id` int(11) NOT NULL AUTO_INCREMENT,
  `friend_from` int(11) NOT NULL COMMENT 'a from b, b是a的好友',
  `friend_to` int(11) NOT NULL,
  `request_time` datetime NOT NULL COMMENT '请求添加时间',
  `action_time` datetime NOT NULL COMMENT '处理请求时间',
  `req_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0:请求未发送 1:请求已发送 2：请求被拒绝 3：请求已同意',
  PRIMARY KEY (`friend_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `friend`
-- ----------------------------
BEGIN;
INSERT INTO `friend` VALUES ('1', '1', '2', '2014-08-31 22:11:39', '2014-08-31 22:11:39', '3'), ('2', '1', '3', '2014-08-31 22:11:51', '2014-08-31 22:11:51', '3'), ('3', '1', '4', '2014-09-03 16:52:33', '2014-09-03 16:52:33', '0'), ('4', '2', '4', '2014-09-03 17:02:13', '2014-09-03 17:02:13', '0'), ('5', '2', '4', '2014-09-03 20:46:01', '2014-09-03 20:46:01', '0'), ('6', '2', '4', '2014-09-03 21:08:07', '2014-09-03 21:08:07', '0');
COMMIT;

-- ----------------------------
--  Table structure for `message`
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `msg_id` int(11) NOT NULL AUTO_INCREMENT,
  `msg_from` int(11) NOT NULL,
  `msg_to` int(11) NOT NULL,
  `request_time` datetime NOT NULL COMMENT '请求发送时间',
  `send_time` datetime NOT NULL COMMENT '真正发送到对方的时间',
  `sent` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已发送给接收方0没有1已发送',
  `message` char(128) NOT NULL,
  PRIMARY KEY (`msg_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `message`
-- ----------------------------
BEGIN;
INSERT INTO `message` VALUES ('1', '2', '1', '2014-09-02 15:09:45', '2014-09-02 15:09:48', '0', 'hello test1'), ('2', '2', '1', '2014-09-02 18:05:23', '2014-09-02 18:05:25', '0', 'hello tes what kind of message you received?'), ('3', '2', '3', '2014-09-02 18:26:02', '2014-09-02 18:26:05', '0', 'msg from 2 to 3'), ('4', '2', '1', '2014-09-02 10:04:17', '2014-09-02 10:04:20', '1', '已发送');
COMMIT;

-- ----------------------------
--  Table structure for `status`
-- ----------------------------
DROP TABLE IF EXISTS `status`;
CREATE TABLE `status` (
  `status_id` tinyint(6) NOT NULL AUTO_INCREMENT,
  `status_name` char(8) NOT NULL,
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
  `user_id` int(6) NOT NULL AUTO_INCREMENT,
  `username` char(16) NOT NULL,
  `password` char(16) NOT NULL,
  `reg_time` datetime NOT NULL COMMENT '注册时间',
  `last_time` datetime NOT NULL COMMENT '上次操作时间,',
  `signature` char(32) NOT NULL DEFAULT '暂无签名',
  `gender` tinyint(1) NOT NULL COMMENT '性别',
  `status_id` tinyint(4) NOT NULL DEFAULT '3',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username_index` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `user`
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES ('1', 'admin', 'admin', '2014-08-31 22:10:56', '2014-08-31 22:10:56', '暂无签名', '0', '1'), ('2', 'admin2', 'admin', '2014-08-31 22:11:11', '2014-08-31 22:11:11', '暂无签名', '0', '1'), ('3', 'admin3', 'admin', '2014-08-31 22:11:22', '2014-08-31 22:11:22', '暂无签名', '0', '4'), ('4', 'admin4', 'admin', '2014-09-03 16:52:25', '2014-09-03 16:52:25', '暂无签名', '0', '4');
COMMIT;


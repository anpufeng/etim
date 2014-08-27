/*
 Navicat Premium Data Transfer

 Source Server         : localhost-mysql
 Source Server Type    : MySQL
 Source Server Version : 50619
 Source Host           : localhost
 Source Database       : etim

 Target Server Type    : MySQL
 Target Server Version : 50619
 File Encoding         : utf-8

 Date: 08/26/2014 20:07:52 PM
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `message`
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `msg_id` int(11) NOT NULL AUTO_INCREMENT,
  `msg_from` int(11) NOT NULL,
  `msg_to` int(11) NOT NULL,
  `send_time` datetime NOT NULL,
  `sent` bit(1) NOT NULL COMMENT '是否已发送给接收方',
  `message` char(128) NOT NULL,
  PRIMARY KEY (`msg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `status`
-- ----------------------------
DROP TABLE IF EXISTS `status`;
CREATE TABLE `status` (
  `status_id` tinyint(6) NOT NULL AUTO_INCREMENT,
  `status_name` char(8) NOT NULL,
  PRIMARY KEY (`status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40000 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;


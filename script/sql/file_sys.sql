/*
 Navicat Premium Dump SQL

 Source Server         : mysql
 Source Server Type    : MySQL
 Source Server Version : 80040 (8.0.40)
 Source Host           : localhost:3306
 Source Schema         : file_sys

 Target Server Type    : MySQL
 Target Server Version : 80040 (8.0.40)
 File Encoding         : 65001

 Date: 18/12/2025 00:53:28
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL COMMENT '编号',
  `data_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '数据源名称',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------

-- ----------------------------
-- Table structure for sys_client
-- ----------------------------
DROP TABLE IF EXISTS `sys_client`;
CREATE TABLE `sys_client`  (
  `id` bigint NOT NULL COMMENT 'id',
  `client_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户端id',
  `client_key` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户端key',
  `client_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户端秘钥',
  `grant_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '授权类型',
  `device_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '设备类型',
  `active_timeout` int NULL DEFAULT 1800 COMMENT 'token活跃超时时间',
  `timeout` int NULL DEFAULT 604800 COMMENT 'token固定超时',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统授权表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_client
-- ----------------------------
INSERT INTO `sys_client` VALUES (1, 'e5cd7e4891bf95d1d19206ce24a7b32e', 'pc', 'pc123', 'password,social', 'pc', 1800, 604800, '0', '0', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-02 14:34:57');
INSERT INTO `sys_client` VALUES (2, '428a8310cd442757ae699df5d894f051', 'app', 'app123', 'password,sms,social', 'android', 1800, 604800, '0', '0', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-02 14:34:57');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` bigint NOT NULL COMMENT '参数主键',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '000000' COMMENT '租户编号',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '000000', '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '000000', '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '000000', '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (5, '000000', '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (11, '000000', 'OSS预览列表资源开关', 'sys.oss.previewListResource', 'true', 'Y', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-02 15:09:19', 'true:开启, false:关闭');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL COMMENT '部门id',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '000000' COMMENT '租户编号',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `dept_category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '部门类别编码',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` bigint NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, '000000', 0, '0', '龙江产互', 'ljch', 0, 1, '', '', '0', '0', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-11 10:34:39');
INSERT INTO `sys_dept` VALUES (101, '000000', 100, '0,100', '科创与产品管理部', 'kcycpglb', 0, NULL, '', '', '0', '0', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-11 10:34:53');
INSERT INTO `sys_dept` VALUES (103, '000000', 101, '0,100,101', '平台研发中心', 'ptyfzx', 0, NULL, '', '', '0', '0', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-11 10:35:07');
INSERT INTO `sys_dept` VALUES (1998941822647369730, '000000', 101, '0,100,101', '质量管理中心', 'zlglzx', 0, NULL, NULL, NULL, '0', '0', 103, 1, '2025-12-11 10:24:04', 1, '2025-12-11 10:35:17');

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL COMMENT '字典编码',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '000000' COMMENT '租户编号',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, '000000', 1, '男', '0', 'sys_user_sex', '', '', 'Y', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, '000000', 2, '女', '1', 'sys_user_sex', '', '', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, '000000', 3, '未知', '2', 'sys_user_sex', '', '', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, '000000', 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, '000000', 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, '000000', 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, '000000', 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (12, '000000', 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, '000000', 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, '000000', 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, '000000', 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, '000000', 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, '000000', 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, '000000', 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (19, '000000', 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (20, '000000', 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (21, '000000', 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (22, '000000', 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (23, '000000', 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (24, '000000', 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (25, '000000', 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (26, '000000', 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (27, '000000', 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (28, '000000', 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (29, '000000', 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (30, '000000', 0, '密码认证', 'password', 'sys_grant_type', 'el-check-tag', 'default', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '密码认证');
INSERT INTO `sys_dict_data` VALUES (31, '000000', 0, '短信认证', 'sms', 'sys_grant_type', 'el-check-tag', 'default', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '短信认证');
INSERT INTO `sys_dict_data` VALUES (32, '000000', 0, '邮件认证', 'email', 'sys_grant_type', 'el-check-tag', 'default', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '邮件认证');
INSERT INTO `sys_dict_data` VALUES (33, '000000', 0, '小程序认证', 'xcx', 'sys_grant_type', 'el-check-tag', 'default', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '小程序认证');
INSERT INTO `sys_dict_data` VALUES (34, '000000', 0, '三方登录认证', 'social', 'sys_grant_type', 'el-check-tag', 'default', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '三方登录认证');
INSERT INTO `sys_dict_data` VALUES (35, '000000', 0, 'PC', 'pc', 'sys_device_type', '', 'default', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, 'PC');
INSERT INTO `sys_dict_data` VALUES (36, '000000', 0, '安卓', 'android', 'sys_device_type', '', 'default', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '安卓');
INSERT INTO `sys_dict_data` VALUES (37, '000000', 0, 'iOS', 'ios', 'sys_device_type', '', 'default', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, 'iOS');
INSERT INTO `sys_dict_data` VALUES (38, '000000', 0, '小程序', 'xcx', 'sys_device_type', '', 'default', 'N', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '小程序');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL COMMENT '字典主键',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '000000' COMMENT '租户编号',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `tenant_id`(`tenant_id` ASC, `dict_type` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '000000', '用户性别', 'sys_user_sex', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '000000', '菜单状态', 'sys_show_hide', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '000000', '系统开关', 'sys_normal_disable', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (6, '000000', '系统是否', 'sys_yes_no', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '000000', '通知类型', 'sys_notice_type', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '000000', '通知状态', 'sys_notice_status', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '000000', '操作类型', 'sys_oper_type', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '000000', '系统状态', 'sys_common_status', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (11, '000000', '授权类型', 'sys_grant_type', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '认证授权类型');
INSERT INTO `sys_dict_type` VALUES (12, '000000', '设备类型', 'sys_device_type', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '客户端设备类型');

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL COMMENT '访问ID',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '000000' COMMENT '租户编号',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户账号',
  `client_key` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '客户端',
  `device_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '设备类型',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (1995751668742897665, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-02 15:07:32');
INSERT INTO `sys_logininfor` VALUES (1995757815570907137, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '退出成功', '2025-12-02 15:31:57');
INSERT INTO `sys_logininfor` VALUES (1995758920753233921, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-02 15:36:21');
INSERT INTO `sys_logininfor` VALUES (1998938360777900034, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-11 10:10:18');
INSERT INTO `sys_logininfor` VALUES (2000443835390365698, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-15 13:52:31');
INSERT INTO `sys_logininfor` VALUES (2000446362676649985, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-15 14:02:34');
INSERT INTO `sys_logininfor` VALUES (2000448282711580673, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '退出成功', '2025-12-15 14:10:12');
INSERT INTO `sys_logininfor` VALUES (2000448332472803330, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-15 14:10:24');
INSERT INTO `sys_logininfor` VALUES (2000448473506275329, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '退出成功', '2025-12-15 14:10:57');
INSERT INTO `sys_logininfor` VALUES (2000448487158734850, '000000', 'xiaohong1', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '1', '密码输入错误1次', '2025-12-15 14:11:01');
INSERT INTO `sys_logininfor` VALUES (2000448503017398273, '000000', 'xiaohong1', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '1', '验证码错误', '2025-12-15 14:11:04');
INSERT INTO `sys_logininfor` VALUES (2000448513872257026, '000000', 'xiaohong1', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-15 14:11:07');
INSERT INTO `sys_logininfor` VALUES (2000449261255286786, '000000', 'xiaohong1', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '退出成功', '2025-12-15 14:14:05');
INSERT INTO `sys_logininfor` VALUES (2000449296864927745, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '1', '密码输入错误1次', '2025-12-15 14:14:14');
INSERT INTO `sys_logininfor` VALUES (2000449326099226625, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '1', '密码输入错误2次', '2025-12-15 14:14:21');
INSERT INTO `sys_logininfor` VALUES (2000449351445405698, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '1', '密码输入错误3次', '2025-12-15 14:14:27');
INSERT INTO `sys_logininfor` VALUES (2000449446786129922, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '1', '密码输入错误4次', '2025-12-15 14:14:49');
INSERT INTO `sys_logininfor` VALUES (2000449477173862401, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-15 14:14:57');
INSERT INTO `sys_logininfor` VALUES (2000449699069321217, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '退出成功', '2025-12-15 14:15:49');
INSERT INTO `sys_logininfor` VALUES (2000449762596249601, '000000', 'xiaohong1', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-15 14:16:05');
INSERT INTO `sys_logininfor` VALUES (2000459567364857858, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-15 14:55:02');
INSERT INTO `sys_logininfor` VALUES (2000459762802647042, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '退出成功', '2025-12-15 14:55:49');
INSERT INTO `sys_logininfor` VALUES (2000459842435702785, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-15 14:56:08');
INSERT INTO `sys_logininfor` VALUES (2000459959830077441, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '退出成功', '2025-12-15 14:56:36');
INSERT INTO `sys_logininfor` VALUES (2000459995183865857, '000000', 'xiaohong1', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-15 14:56:44');
INSERT INTO `sys_logininfor` VALUES (2000485262300307458, '000000', 'xiaohong1', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '退出成功', '2025-12-15 16:37:08');
INSERT INTO `sys_logininfor` VALUES (2000485277768900610, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-15 16:37:12');
INSERT INTO `sys_logininfor` VALUES (2000486688762126337, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '退出成功', '2025-12-15 16:42:49');
INSERT INTO `sys_logininfor` VALUES (2000486731162345474, '000000', 'xiaohong1', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-15 16:42:59');
INSERT INTO `sys_logininfor` VALUES (2000492764685426689, '000000', 'xiaohong1', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '退出成功', '2025-12-15 17:06:57');
INSERT INTO `sys_logininfor` VALUES (2000492793491906562, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-15 17:07:04');
INSERT INTO `sys_logininfor` VALUES (2000493083150540801, '000000', 'admin', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '退出成功', '2025-12-15 17:08:13');
INSERT INTO `sys_logininfor` VALUES (2000493151484141569, '000000', 'xiaohong1', 'pc', 'pc', '0:0:0:0:0:0:0:1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-15 17:08:29');
INSERT INTO `sys_logininfor` VALUES (2001300859059277826, '000000', 'admin', 'pc', 'pc', '127.0.0.1', '内网IP', 'Chrome', 'Windows 10 or Windows Server 2016', '0', '登录成功', '2025-12-17 22:38:02');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query_param` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '路由参数',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '显示状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 2, 'system', NULL, '', 1, 0, 'M', '0', '0', '', 'system', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-17 23:52:11', '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 4, 'monitor', NULL, '', 1, 0, 'M', '0', '1', '', 'monitor', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-17 23:52:49', '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 5, 'tool', NULL, '', 1, 0, 'M', '0', '1', '', 'tool', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-17 23:52:59', '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, 'PLUS官网', 0, 6, 'https://gitee.com/dromara/RuoYi-Vue-Plus', NULL, '', 0, 0, 'M', '0', '1', '', 'guide', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-17 23:53:24', 'RuoYi-Vue-Plus官网地址');
INSERT INTO `sys_menu` VALUES (5, '测试菜单', 0, 7, 'demo', NULL, '', 1, 0, 'M', '0', '1', '', 'star', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-17 23:53:33', '测试菜单');
INSERT INTO `sys_menu` VALUES (6, '租户管理', 0, 3, 'tenant', NULL, '', 1, 0, 'M', '0', '1', '', 'chart', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-17 23:52:21', '租户管理目录');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 4, 'menu', 'system/menu/index', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-11 10:57:29', '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 3, 'dept', 'system/dept/index', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-11 10:57:20', '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', 1, 0, 'C', '0', '1', 'system:post:list', 'post', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-11 10:56:03', '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', 1, 0, 'C', '0', '1', 'system:dict:list', 'dict', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-11 10:56:09', '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', 1, 0, 'C', '0', '1', 'system:config:list', 'edit', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-11 10:56:16', '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', 1, 0, 'C', '0', '1', 'system:notice:list', 'message', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-02 15:14:35', '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', 1, 0, 'M', '0', '0', '', 'log', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (115, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (116, '修改生成配置', 3, 2, 'gen-edit/index/:tableId', 'tool/gen/editTable', '', 1, 1, 'C', '1', '0', 'tool:gen:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '/tool/gen');
INSERT INTO `sys_menu` VALUES (117, 'Admin监控', 2, 5, 'Admin', 'monitor/admin/index', '', 1, 0, 'C', '0', '0', 'monitor:admin:list', 'dashboard', 103, 1, '2025-12-02 14:34:57', NULL, NULL, 'Admin监控菜单');
INSERT INTO `sys_menu` VALUES (118, '文件管理', 1, 10, 'oss', 'system/oss/index', '', 1, 0, 'C', '0', '0', 'system:oss:list', 'upload', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-18 00:22:27', '文件管理菜单');
INSERT INTO `sys_menu` VALUES (120, '任务调度中心', 2, 6, 'snailjob', 'monitor/snailjob/index', '', 1, 0, 'C', '0', '0', 'monitor:snailjob:list', 'job', 103, 1, '2025-12-02 14:34:57', NULL, NULL, 'SnailJob控制台菜单');
INSERT INTO `sys_menu` VALUES (121, '租户管理', 6, 1, 'tenant', 'system/tenant/index', '', 1, 0, 'C', '0', '0', 'system:tenant:list', 'list', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '租户管理菜单');
INSERT INTO `sys_menu` VALUES (122, '租户套餐管理', 6, 2, 'tenantPackage', 'system/tenantPackage/index', '', 1, 0, 'C', '0', '0', 'system:tenantPackage:list', 'form', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '租户套餐管理菜单');
INSERT INTO `sys_menu` VALUES (123, '客户端管理', 1, 11, 'client', 'system/client/index', '', 1, 0, 'C', '0', '1', 'system:client:list', 'international', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-02 15:14:27', '客户端管理菜单');
INSERT INTO `sys_menu` VALUES (130, '分配用户', 1, 2, 'role-auth/user/:roleId', 'system/role/authUser', '', 1, 1, 'C', '1', '0', 'system:role:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '/system/role');
INSERT INTO `sys_menu` VALUES (131, '分配角色', 1, 1, 'user-auth/role/:userId', 'system/user/authRole', '', 1, 1, 'C', '1', '0', 'system:user:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '/system/user');
INSERT INTO `sys_menu` VALUES (132, '字典数据', 1, 6, 'dict-data/index/:dictId', 'system/dict/data', '', 1, 1, 'C', '1', '0', 'system:dict:list', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '/system/dict');
INSERT INTO `sys_menu` VALUES (133, '文件配置管理', 1, 10, 'oss-config/index', 'system/oss/config', '', 1, 1, 'C', '1', '0', 'system:ossConfig:list', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '/system/oss');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1001, '用户查询', 100, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户新增', 100, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户修改', 100, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户删除', 100, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导出', 100, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '用户导入', 100, 6, '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '重置密码', 100, 7, '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色查询', 101, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色新增', 101, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色修改', 101, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色删除', 101, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '角色导出', 101, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单查询', 102, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单新增', 102, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单修改', 102, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '菜单删除', 102, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门查询', 103, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门新增', 103, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门修改', 103, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '部门删除', 103, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位查询', 104, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位新增', 104, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位修改', 104, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位删除', 104, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '岗位导出', 104, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典查询', 105, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典新增', 105, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典修改', 105, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典删除', 105, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '字典导出', 105, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数查询', 106, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数新增', 106, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数修改', 106, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数删除', 106, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '参数导出', 106, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告查询', 107, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告新增', 107, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告修改', 107, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '公告删除', 107, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作查询', 500, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '操作删除', 500, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '日志导出', 500, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录查询', 501, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '登录删除', 501, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '日志导出', 501, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '账户解锁', 501, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 115, 1, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 115, 2, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 115, 3, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 115, 2, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 115, 4, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 115, 5, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1061, '客户端管理查询', 123, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:client:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1062, '客户端管理新增', 123, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:client:add', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1063, '客户端管理修改', 123, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:client:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1064, '客户端管理删除', 123, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:client:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1065, '客户端管理导出', 123, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:client:export', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1500, '测试单表', 5, 1, 'demo', 'demo/demo/index', '', 1, 0, 'C', '0', '0', 'demo:demo:list', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '测试单表菜单');
INSERT INTO `sys_menu` VALUES (1501, '测试单表查询', 1500, 1, '#', '', '', 1, 0, 'F', '0', '0', 'demo:demo:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1502, '测试单表新增', 1500, 2, '#', '', '', 1, 0, 'F', '0', '0', 'demo:demo:add', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1503, '测试单表修改', 1500, 3, '#', '', '', 1, 0, 'F', '0', '0', 'demo:demo:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1504, '测试单表删除', 1500, 4, '#', '', '', 1, 0, 'F', '0', '0', 'demo:demo:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1505, '测试单表导出', 1500, 5, '#', '', '', 1, 0, 'F', '0', '0', 'demo:demo:export', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1506, '测试树表', 5, 1, 'tree', 'demo/tree/index', '', 1, 0, 'C', '0', '0', 'demo:tree:list', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '测试树表菜单');
INSERT INTO `sys_menu` VALUES (1507, '测试树表查询', 1506, 1, '#', '', '', 1, 0, 'F', '0', '0', 'demo:tree:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1508, '测试树表新增', 1506, 2, '#', '', '', 1, 0, 'F', '0', '0', 'demo:tree:add', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1509, '测试树表修改', 1506, 3, '#', '', '', 1, 0, 'F', '0', '0', 'demo:tree:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1510, '测试树表删除', 1506, 4, '#', '', '', 1, 0, 'F', '0', '0', 'demo:tree:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1511, '测试树表导出', 1506, 5, '#', '', '', 1, 0, 'F', '0', '0', 'demo:tree:export', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1600, '文件查询', 118, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:oss:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1601, '文件上传', 118, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:oss:upload', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1602, '文件下载', 118, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:oss:download', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1603, '文件删除', 118, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:oss:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1606, '租户查询', 121, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenant:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1607, '租户新增', 121, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenant:add', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1608, '租户修改', 121, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenant:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1609, '租户删除', 121, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenant:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1610, '租户导出', 121, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenant:export', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1611, '租户套餐查询', 122, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenantPackage:query', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1612, '租户套餐新增', 122, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenantPackage:add', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1613, '租户套餐修改', 122, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenantPackage:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1614, '租户套餐删除', 122, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenantPackage:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1615, '租户套餐导出', 122, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenantPackage:export', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1620, '配置列表', 118, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:ossConfig:list', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1621, '配置添加', 118, 6, '#', '', '', 1, 0, 'F', '0', '0', 'system:ossConfig:add', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1622, '配置编辑', 118, 6, '#', '', '', 1, 0, 'F', '0', '0', 'system:ossConfig:edit', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1623, '配置删除', 118, 6, '#', '', '', 1, 0, 'F', '0', '0', 'system:ossConfig:remove', '#', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (2001316000769347585, '文件中心', 0, 0, 'filesys_user', 'filesys/user/index', NULL, 1, 0, 'C', '0', '0', NULL, 'list', 100, 1, '2025-12-17 23:38:12', 1, '2025-12-17 23:52:01', '');
INSERT INTO `sys_menu` VALUES (2001320144456486913, '文件管理', 0, 1, 'filesys_dept', 'filesys/dept/index', NULL, 1, 0, 'C', '0', '0', NULL, 'nested', 100, 1, '2025-12-17 23:54:40', 1, '2025-12-17 23:54:40', '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` bigint NOT NULL COMMENT '公告ID',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '000000' COMMENT '租户编号',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '000000', '温馨提醒：2018-07-01 新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '000000', '维护通知：2018-07-01 系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL COMMENT '日志主键',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '000000' COMMENT '租户编号',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (1995751883772280834, '000000', 'OSS对象存储', 1, 'org.dromara.system.controller.system.SysOssController.upload()', 'POST', 1, 'admin', '研发部门', '/resource/oss/upload', '0:0:0:0:0:0:0:1', '内网IP', '', '{\"code\":200,\"msg\":\"操作成功\",\"data\":{\"url\":\"http://127.0.0.1:9000/ruoyi/2025/12/02/31eeaf9ad475465992c563563e7de4c7.pdf\",\"fileName\":\"终验报告.pdf\",\"ossId\":\"1995751883440930817\"}}', 0, '', '2025-12-02 15:08:23', 4682);
INSERT INTO `sys_oper_log` VALUES (1995752101859311618, '000000', '参数管理', 2, 'org.dromara.system.controller.system.SysConfigController.updateByKey()', 'PUT', 1, 'admin', '研发部门', '/system/config/updateByKey', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"configId\":null,\"configName\":null,\"configKey\":\"sys.oss.previewListResource\",\"configValue\":\"false\",\"configType\":null,\"remark\":null}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-02 15:09:15', 40);
INSERT INTO `sys_oper_log` VALUES (1995752117592145922, '000000', '参数管理', 2, 'org.dromara.system.controller.system.SysConfigController.updateByKey()', 'PUT', 1, 'admin', '研发部门', '/system/config/updateByKey', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"configId\":null,\"configName\":null,\"configKey\":\"sys.oss.previewListResource\",\"configValue\":\"true\",\"configType\":null,\"remark\":null}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-02 15:09:19', 11);
INSERT INTO `sys_oper_log` VALUES (1995752133224316929, '000000', 'OSS对象存储', 3, 'org.dromara.system.controller.system.SysOssController.remove()', 'DELETE', 1, 'admin', '研发部门', '/resource/oss/1995751883440930817', '0:0:0:0:0:0:0:1', '内网IP', '[\"1995751883440930817\"]', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-02 15:09:23', 120);
INSERT INTO `sys_oper_log` VALUES (1995752718250033153, '000000', '对象存储配置', 3, 'org.dromara.system.controller.system.SysOssConfigController.remove()', 'DELETE', 1, 'admin', '研发部门', '/resource/oss/config/2', '0:0:0:0:0:0:0:1', '内网IP', '[2]', '', 1, '系统内置, 不可删除!', '2025-12-02 15:11:42', 1);
INSERT INTO `sys_oper_log` VALUES (1995753052435398657, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":5,\"parentId\":0,\"menuName\":\"测试菜单\",\"orderNum\":5,\"path\":\"demo\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"star\",\"remark\":\"测试菜单\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-02 15:13:02', 32);
INSERT INTO `sys_oper_log` VALUES (1995753090368684033, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":4,\"parentId\":0,\"menuName\":\"PLUS官网\",\"orderNum\":5,\"path\":\"https://gitee.com/dromara/RuoYi-Vue-Plus\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"guide\",\"remark\":\"RuoYi-Vue-Plus官网地址\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-02 15:13:11', 11);
INSERT INTO `sys_oper_log` VALUES (1995753148573040641, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":6,\"parentId\":0,\"menuName\":\"租户管理\",\"orderNum\":2,\"path\":\"tenant\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"chart\",\"remark\":\"租户管理目录\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-02 15:13:25', 14);
INSERT INTO `sys_oper_log` VALUES (1995753410792538113, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":123,\"parentId\":1,\"menuName\":\"客户端管理\",\"orderNum\":11,\"path\":\"client\",\"component\":\"system/client/index\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"system:client:list\",\"icon\":\"international\",\"remark\":\"客户端管理菜单\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-02 15:14:27', 11);
INSERT INTO `sys_oper_log` VALUES (1995753444397301762, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":107,\"parentId\":1,\"menuName\":\"通知公告\",\"orderNum\":8,\"path\":\"notice\",\"component\":\"system/notice/index\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"system:notice:list\",\"icon\":\"message\",\"remark\":\"通知公告菜单\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-02 15:14:35', 12);
INSERT INTO `sys_oper_log` VALUES (1995753663281250305, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2,\"parentId\":0,\"menuName\":\"系统监控\",\"orderNum\":3,\"path\":\"monitor\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"monitor\",\"remark\":\"系统监控目录\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-02 15:15:27', 10);
INSERT INTO `sys_oper_log` VALUES (1995764148516962305, '000000', 'OSS对象存储', 1, 'org.dromara.system.controller.system.SysOssController.upload()', 'POST', 1, 'admin', '研发部门', '/resource/oss/upload', '0:0:0:0:0:0:0:1', '内网IP', '', '{\"code\":200,\"msg\":\"操作成功\",\"data\":{\"url\":\"http://127.0.0.1:9000/ruoyi/2025/12/02/cb1429161cdb449eaca07d68bcfa8963.doc\",\"fileName\":\"联通（黑龙江）产业互联网有限公司合同管理办法.doc\",\"ossId\":\"1995764148391133186\"}}', 0, '', '2025-12-02 15:57:07', 180);
INSERT INTO `sys_oper_log` VALUES (1995766048696057857, '000000', 'OSS对象存储', 1, 'org.dromara.system.controller.system.SysOssController.upload()', 'POST', 1, 'admin', '研发部门', '/resource/oss/upload', '0:0:0:0:0:0:0:1', '内网IP', '', '{\"code\":200,\"msg\":\"操作成功\",\"data\":{\"url\":\"http://127.0.0.1:9000/ruoyi/2025/12/02/71da6b66d65c4fd48b7a147dbcc4516e.pdf\",\"fileName\":\"扫描全能王 2025-06-06 17.00.pdf\",\"ossId\":\"1995766048561840130\"}}', 0, '', '2025-12-02 16:04:40', 159);
INSERT INTO `sys_oper_log` VALUES (1995766131915243522, '000000', 'OSS对象存储', 1, 'org.dromara.system.controller.system.SysOssController.upload()', 'POST', 1, 'admin', '研发部门', '/resource/oss/upload', '0:0:0:0:0:0:0:1', '内网IP', '', '{\"code\":200,\"msg\":\"操作成功\",\"data\":{\"url\":\"http://127.0.0.1:9000/ruoyi/2025/12/02/5fad61624ba84e7d80e7c8b47fc1a186.pdf\",\"fileName\":\"终验报告.pdf\",\"ossId\":\"1995766131852328962\"}}', 0, '', '2025-12-02 16:05:00', 115);
INSERT INTO `sys_oper_log` VALUES (1998940237926072321, '000000', '角色管理', 2, 'org.dromara.system.controller.system.SysRoleController.changeStatus()', 'PUT', 1, 'admin', '研发部门', '/system/role/changeStatus', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"roleId\":1,\"roleName\":null,\"roleKey\":null,\"roleSort\":null,\"dataScope\":null,\"menuCheckStrictly\":null,\"deptCheckStrictly\":null,\"status\":\"1\",\"remark\":null,\"menuIds\":null,\"deptIds\":null,\"superAdmin\":true}', '', 1, '不允许操作超级管理员角色', '2025-12-11 10:17:46', 31);
INSERT INTO `sys_oper_log` VALUES (1998940250240548866, '000000', '角色管理', 2, 'org.dromara.system.controller.system.SysRoleController.changeStatus()', 'PUT', 1, 'admin', '研发部门', '/system/role/changeStatus', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"roleId\":3,\"roleName\":null,\"roleKey\":null,\"roleSort\":null,\"dataScope\":null,\"menuCheckStrictly\":null,\"deptCheckStrictly\":null,\"status\":\"1\",\"remark\":null,\"menuIds\":null,\"deptIds\":null,\"superAdmin\":false}', '', 1, '角色已分配，不能禁用!', '2025-12-11 10:17:49', 9);
INSERT INTO `sys_oper_log` VALUES (1998940582773358593, '000000', '角色管理', 2, 'org.dromara.system.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"roleId\":3,\"roleName\":\"子管理员\",\"roleKey\":\"subadmin\",\"roleSort\":3,\"dataScope\":\"4\",\"menuCheckStrictly\":true,\"deptCheckStrictly\":true,\"status\":\"0\",\"remark\":\"\",\"menuIds\":[],\"deptIds\":[],\"superAdmin\":false}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:19:08', 160);
INSERT INTO `sys_oper_log` VALUES (1998940609260388353, '000000', '角色管理', 2, 'org.dromara.system.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"roleId\":3,\"roleName\":\"子管理员\",\"roleKey\":\"subadmin\",\"roleSort\":2,\"dataScope\":\"4\",\"menuCheckStrictly\":true,\"deptCheckStrictly\":true,\"status\":\"0\",\"remark\":\"\",\"menuIds\":[],\"deptIds\":[],\"superAdmin\":false}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:19:14', 25);
INSERT INTO `sys_oper_log` VALUES (1998940746644815874, '000000', '角色管理', 2, 'org.dromara.system.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"roleId\":4,\"roleName\":\"普通成员\",\"roleKey\":\"common\",\"roleSort\":3,\"dataScope\":\"5\",\"menuCheckStrictly\":true,\"deptCheckStrictly\":true,\"status\":\"0\",\"remark\":\"\",\"menuIds\":[],\"deptIds\":[],\"superAdmin\":false}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:19:47', 23);
INSERT INTO `sys_oper_log` VALUES (1998941004263161857, '000000', '部门管理', 2, 'org.dromara.system.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"deptId\":100,\"parentId\":0,\"deptName\":\"联通（黑龙江）产业互联网有限公司\",\"deptCategory\":null,\"orderNum\":0,\"leader\":null,\"phone\":\"\",\"email\":\"\",\"status\":\"0\",\"belongDeptId\":null}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:20:49', 49);
INSERT INTO `sys_oper_log` VALUES (1998941111624761345, '000000', '部门管理', 2, 'org.dromara.system.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"deptId\":101,\"parentId\":100,\"deptName\":\"科创与产品管理部\",\"deptCategory\":null,\"orderNum\":1,\"leader\":null,\"phone\":\"\",\"email\":\"\",\"status\":\"0\",\"belongDeptId\":null}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:21:14', 33);
INSERT INTO `sys_oper_log` VALUES (1998941305095421954, '000000', '部门管理', 2, 'org.dromara.system.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"deptId\":103,\"parentId\":101,\"deptName\":\"平台研发中心\",\"deptCategory\":null,\"orderNum\":1,\"leader\":1,\"phone\":\"\",\"email\":\"\",\"status\":\"0\",\"belongDeptId\":null}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:22:00', 18);
INSERT INTO `sys_oper_log` VALUES (1998941345016807425, '000000', '部门管理', 2, 'org.dromara.system.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"deptId\":100,\"parentId\":0,\"deptName\":\"联通（黑龙江）产业互联网有限公司\",\"deptCategory\":null,\"orderNum\":0,\"leader\":null,\"phone\":\"\",\"email\":\"\",\"status\":\"0\",\"belongDeptId\":null}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:22:10', 19);
INSERT INTO `sys_oper_log` VALUES (1998941360497983490, '000000', '部门管理', 2, 'org.dromara.system.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"deptId\":101,\"parentId\":100,\"deptName\":\"科创与产品管理部\",\"deptCategory\":null,\"orderNum\":0,\"leader\":null,\"phone\":\"\",\"email\":\"\",\"status\":\"0\",\"belongDeptId\":null}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:22:14', 17);
INSERT INTO `sys_oper_log` VALUES (1998941376255983617, '000000', '部门管理', 2, 'org.dromara.system.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"deptId\":103,\"parentId\":101,\"deptName\":\"平台研发中心\",\"deptCategory\":null,\"orderNum\":0,\"leader\":1,\"phone\":\"\",\"email\":\"\",\"status\":\"0\",\"belongDeptId\":null}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:22:17', 17);
INSERT INTO `sys_oper_log` VALUES (1998941389593870338, '000000', '部门管理', 3, 'org.dromara.system.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/104', '0:0:0:0:0:0:0:1', '内网IP', '104', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:22:20', 67);
INSERT INTO `sys_oper_log` VALUES (1998941399140106242, '000000', '部门管理', 3, 'org.dromara.system.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/105', '0:0:0:0:0:0:0:1', '内网IP', '105', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:22:23', 16);
INSERT INTO `sys_oper_log` VALUES (1998941410573778945, '000000', '部门管理', 3, 'org.dromara.system.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/106', '0:0:0:0:0:0:0:1', '内网IP', '106', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:22:25', 17);
INSERT INTO `sys_oper_log` VALUES (1998941420166152194, '000000', '部门管理', 3, 'org.dromara.system.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/107', '0:0:0:0:0:0:0:1', '内网IP', '107', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:22:28', 17);
INSERT INTO `sys_oper_log` VALUES (1998941430291202049, '000000', '部门管理', 3, 'org.dromara.system.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/102', '0:0:0:0:0:0:0:1', '内网IP', '102', '{\"code\":601,\"msg\":\"存在下级部门,不允许删除\",\"data\":null}', 0, '', '2025-12-11 10:22:30', 3);
INSERT INTO `sys_oper_log` VALUES (1998941442639233026, '000000', '部门管理', 3, 'org.dromara.system.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/109', '0:0:0:0:0:0:0:1', '内网IP', '109', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:22:33', 16);
INSERT INTO `sys_oper_log` VALUES (1998941450788765698, '000000', '部门管理', 3, 'org.dromara.system.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/108', '0:0:0:0:0:0:0:1', '内网IP', '108', '{\"code\":601,\"msg\":\"部门存在用户,不允许删除\",\"data\":null}', 0, '', '2025-12-11 10:22:35', 6);
INSERT INTO `sys_oper_log` VALUES (1998941526537895938, '000000', '用户管理', 3, 'org.dromara.system.controller.system.SysUserController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/user/3', '0:0:0:0:0:0:0:1', '内网IP', '[3]', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:22:53', 25);
INSERT INTO `sys_oper_log` VALUES (1998941537866711041, '000000', '用户管理', 3, 'org.dromara.system.controller.system.SysUserController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/user/4', '0:0:0:0:0:0:0:1', '内网IP', '[4]', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:22:56', 13);
INSERT INTO `sys_oper_log` VALUES (1998941658260013057, '000000', '个人信息', 2, 'org.dromara.system.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '研发部门', '/system/user/profile', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"nickName\":\"超级管理员\",\"email\":\"superadmin@163.com\",\"phonenumber\":\"17388888888\",\"sex\":\"1\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:23:25', 26);
INSERT INTO `sys_oper_log` VALUES (1998941739956666370, '000000', '部门管理', 3, 'org.dromara.system.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/108', '0:0:0:0:0:0:0:1', '内网IP', '108', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:23:44', 15);
INSERT INTO `sys_oper_log` VALUES (1998941747791626241, '000000', '部门管理', 3, 'org.dromara.system.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/102', '0:0:0:0:0:0:0:1', '内网IP', '102', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:23:46', 13);
INSERT INTO `sys_oper_log` VALUES (1998941822710284289, '000000', '部门管理', 1, 'org.dromara.system.controller.system.SysDeptController.add()', 'POST', 1, 'admin', '研发部门', '/system/dept', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"deptId\":null,\"parentId\":101,\"deptName\":\"质量管理中心\",\"deptCategory\":null,\"orderNum\":0,\"leader\":null,\"phone\":null,\"email\":null,\"status\":\"0\",\"belongDeptId\":null}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:24:04', 16);
INSERT INTO `sys_oper_log` VALUES (1998941904809590785, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":3,\"parentId\":0,\"menuName\":\"系统工具\",\"orderNum\":4,\"path\":\"tool\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"tool\",\"remark\":\"系统工具目录\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:24:23', 15);
INSERT INTO `sys_oper_log` VALUES (1998941990717325313, '000000', '部门管理', 2, 'org.dromara.system.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"deptId\":100,\"parentId\":0,\"deptName\":\"龙江产互\",\"deptCategory\":null,\"orderNum\":0,\"leader\":null,\"phone\":\"\",\"email\":\"\",\"status\":\"0\",\"belongDeptId\":null}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:24:44', 16);
INSERT INTO `sys_oper_log` VALUES (1998942908259074049, '000000', 'OSS对象存储', 3, 'org.dromara.system.controller.system.SysOssController.remove()', 'DELETE', 1, 'admin', '研发部门', '/resource/oss/1995764148391133186', '0:0:0:0:0:0:0:1', '内网IP', '[\"1995764148391133186\"]', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:28:23', 1410);
INSERT INTO `sys_oper_log` VALUES (1998942928509173762, '000000', 'OSS对象存储', 3, 'org.dromara.system.controller.system.SysOssController.remove()', 'DELETE', 1, 'admin', '研发部门', '/resource/oss/1995766048561840130,1995766131852328962', '0:0:0:0:0:0:0:1', '内网IP', '[\"1995766048561840130\",\"1995766131852328962\"]', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:28:27', 18);
INSERT INTO `sys_oper_log` VALUES (1998944486659555330, '000000', '部门管理', 2, 'org.dromara.system.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"deptId\":100,\"parentId\":0,\"deptName\":\"龙江产互\",\"deptCategory\":\"ljch\",\"orderNum\":0,\"leader\":null,\"phone\":\"\",\"email\":\"\",\"status\":\"0\",\"belongDeptId\":null}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:34:39', 13);
INSERT INTO `sys_oper_log` VALUES (1998944545107181569, '000000', '部门管理', 2, 'org.dromara.system.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"deptId\":101,\"parentId\":100,\"deptName\":\"科创与产品管理部\",\"deptCategory\":\"kcycpglb\",\"orderNum\":0,\"leader\":null,\"phone\":\"\",\"email\":\"\",\"status\":\"0\",\"belongDeptId\":null}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:34:53', 15);
INSERT INTO `sys_oper_log` VALUES (1998944603995209729, '000000', '部门管理', 2, 'org.dromara.system.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"deptId\":103,\"parentId\":101,\"deptName\":\"平台研发中心\",\"deptCategory\":\"ptyfzx\",\"orderNum\":0,\"leader\":1,\"phone\":\"\",\"email\":\"\",\"status\":\"0\",\"belongDeptId\":null}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:35:07', 13);
INSERT INTO `sys_oper_log` VALUES (1998944648190590977, '000000', '部门管理', 2, 'org.dromara.system.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-11 10:24:04\",\"updateBy\":null,\"updateTime\":null,\"deptId\":\"1998941822647369730\",\"parentId\":101,\"deptName\":\"质量管理中心\",\"deptCategory\":\"zlglzx\",\"orderNum\":0,\"leader\":null,\"phone\":null,\"email\":null,\"status\":\"0\",\"belongDeptId\":null}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:35:17', 13);
INSERT INTO `sys_oper_log` VALUES (1998945737686220802, '000000', '岗位管理', 3, 'org.dromara.system.controller.system.SysPostController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/post/4', '0:0:0:0:0:0:0:1', '内网IP', '[4]', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:39:37', 11);
INSERT INTO `sys_oper_log` VALUES (1998945745965776898, '000000', '岗位管理', 3, 'org.dromara.system.controller.system.SysPostController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/post/3', '0:0:0:0:0:0:0:1', '内网IP', '[3]', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:39:39', 9);
INSERT INTO `sys_oper_log` VALUES (1998945754236944385, '000000', '岗位管理', 3, 'org.dromara.system.controller.system.SysPostController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/post/2', '0:0:0:0:0:0:0:1', '内网IP', '[2]', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:39:41', 10);
INSERT INTO `sys_oper_log` VALUES (1998945765309906945, '000000', '岗位管理', 3, 'org.dromara.system.controller.system.SysPostController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/post/1', '0:0:0:0:0:0:0:1', '内网IP', '[1]', '', 1, '董事长已分配，不能删除!', '2025-12-11 10:39:44', 3);
INSERT INTO `sys_oper_log` VALUES (1998945861602738177, '000000', '岗位管理', 2, 'org.dromara.system.controller.system.SysPostController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/post', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"postId\":1,\"deptId\":100,\"belongDeptId\":null,\"postCode\":\"superadmin\",\"postName\":\"超级管理员\",\"postCategory\":null,\"postSort\":0,\"status\":\"0\",\"remark\":\"\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:40:07', 17);
INSERT INTO `sys_oper_log` VALUES (1998945887489982466, '000000', '岗位管理', 2, 'org.dromara.system.controller.system.SysPostController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/post', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"postId\":1,\"deptId\":100,\"belongDeptId\":null,\"postCode\":\"superadmin\",\"postName\":\"超级管理员\",\"postCategory\":\"superadmin\",\"postSort\":0,\"status\":\"0\",\"remark\":\"\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:40:13', 9);
INSERT INTO `sys_oper_log` VALUES (1998946051898310657, '000000', '用户管理', 2, 'org.dromara.system.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"userId\":1,\"deptId\":null,\"userName\":\"admin\",\"nickName\":\"超级管理员\",\"userType\":\"sys_user\",\"email\":\"superadmin@163.com\",\"phonenumber\":\"17388888888\",\"sex\":\"0\",\"status\":\"0\",\"remark\":\"管理员\",\"roleIds\":null,\"postIds\":null,\"roleId\":null,\"userIds\":null,\"excludeUserIds\":null,\"superAdmin\":true}', '', 1, '不允许操作超级管理员用户', '2025-12-11 10:40:52', 1);
INSERT INTO `sys_oper_log` VALUES (1998947134485921794, '000000', '用户管理', 1, 'org.dromara.system.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"userId\":\"1998947134204903426\",\"deptId\":101,\"userName\":\"xiaobing1\",\"nickName\":\"晓冰\",\"userType\":null,\"email\":null,\"phonenumber\":null,\"sex\":null,\"status\":\"0\",\"remark\":\"\",\"roleIds\":[3],\"postIds\":[],\"roleId\":null,\"userIds\":null,\"excludeUserIds\":null,\"superAdmin\":false}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:45:10', 152);
INSERT INTO `sys_oper_log` VALUES (1998948427757617154, '000000', '用户管理', 2, 'org.dromara.system.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-11 10:45:10\",\"updateBy\":null,\"updateTime\":null,\"userId\":\"1998947134204903426\",\"deptId\":101,\"userName\":\"xiaobing1\",\"nickName\":\"晓冰（子管理员）\",\"userType\":\"sys_user\",\"email\":\"\",\"phonenumber\":\"\",\"sex\":\"0\",\"status\":\"0\",\"remark\":\"\",\"roleIds\":[3],\"postIds\":[],\"roleId\":null,\"userIds\":null,\"excludeUserIds\":null,\"superAdmin\":false}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:50:19', 109);
INSERT INTO `sys_oper_log` VALUES (1998948862191042561, '000000', '用户管理', 1, 'org.dromara.system.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"userId\":\"1998948862065213442\",\"deptId\":103,\"userName\":\"xiaolin1\",\"nickName\":\"晓琳（子管理员）\",\"userType\":null,\"email\":null,\"phonenumber\":null,\"sex\":null,\"status\":\"0\",\"remark\":\"\",\"roleIds\":[3],\"postIds\":[],\"roleId\":null,\"userIds\":null,\"excludeUserIds\":null,\"superAdmin\":false}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:52:02', 101);
INSERT INTO `sys_oper_log` VALUES (1998949045666676738, '000000', '用户管理', 1, 'org.dromara.system.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"userId\":\"1998949045536653313\",\"deptId\":\"1998941822647369730\",\"userName\":\"xiaohong1\",\"nickName\":\"晓红（子管理员）\",\"userType\":null,\"email\":null,\"phonenumber\":null,\"sex\":null,\"status\":\"0\",\"remark\":\"\",\"roleIds\":[3],\"postIds\":[],\"roleId\":null,\"userIds\":null,\"excludeUserIds\":null,\"superAdmin\":false}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:52:46', 96);
INSERT INTO `sys_oper_log` VALUES (1998949190802178050, '000000', '用户管理', 1, 'org.dromara.system.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"userId\":\"1998949190676348929\",\"deptId\":101,\"userName\":\"ceshi1\",\"nickName\":\"测试1\",\"userType\":null,\"email\":null,\"phonenumber\":null,\"sex\":null,\"status\":\"0\",\"remark\":\"\",\"roleIds\":[4],\"postIds\":[],\"roleId\":null,\"userIds\":null,\"excludeUserIds\":null,\"superAdmin\":false}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:53:20', 97);
INSERT INTO `sys_oper_log` VALUES (1998949872619847682, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":104,\"parentId\":1,\"menuName\":\"岗位管理\",\"orderNum\":5,\"path\":\"post\",\"component\":\"system/post/index\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"system:post:list\",\"icon\":\"post\",\"remark\":\"岗位管理菜单\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:56:03', 9);
INSERT INTO `sys_oper_log` VALUES (1998949898343514114, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":105,\"parentId\":1,\"menuName\":\"字典管理\",\"orderNum\":6,\"path\":\"dict\",\"component\":\"system/dict/index\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"system:dict:list\",\"icon\":\"dict\",\"remark\":\"字典管理菜单\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:56:09', 9);
INSERT INTO `sys_oper_log` VALUES (1998949926319521794, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":106,\"parentId\":1,\"menuName\":\"参数设置\",\"orderNum\":7,\"path\":\"config\",\"component\":\"system/config/index\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"system:config:list\",\"icon\":\"edit\",\"remark\":\"参数设置菜单\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:56:16', 10);
INSERT INTO `sys_oper_log` VALUES (1998949986537144321, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":118,\"parentId\":1,\"menuName\":\"文件管理\",\"orderNum\":10,\"path\":\"oss\",\"component\":\"system/oss/index\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"system:oss:list\",\"icon\":\"upload\",\"remark\":\"文件管理菜单\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:56:30', 9);
INSERT INTO `sys_oper_log` VALUES (1998950193945477121, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":103,\"parentId\":1,\"menuName\":\"部门管理\",\"orderNum\":3,\"path\":\"dept\",\"component\":\"system/dept/index\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"0\",\"status\":\"0\",\"perms\":\"system:dept:list\",\"icon\":\"tree\",\"remark\":\"部门管理菜单\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:57:20', 8);
INSERT INTO `sys_oper_log` VALUES (1998950232545656833, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":102,\"parentId\":1,\"menuName\":\"菜单管理\",\"orderNum\":4,\"path\":\"menu\",\"component\":\"system/menu/index\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"0\",\"status\":\"0\",\"perms\":\"system:menu:list\",\"icon\":\"tree-table\",\"remark\":\"菜单管理菜单\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:57:29', 9);
INSERT INTO `sys_oper_log` VALUES (1998950411269144578, '000000', '用户管理', 1, 'org.dromara.system.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"userId\":\"1998950411202035714\",\"deptId\":103,\"userName\":\"ceshi2\",\"nickName\":\"测试2\",\"userType\":null,\"email\":null,\"phonenumber\":null,\"sex\":null,\"status\":\"0\",\"remark\":\"\",\"roleIds\":[4],\"postIds\":[],\"roleId\":null,\"userIds\":null,\"excludeUserIds\":null,\"superAdmin\":false}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:58:11', 90);
INSERT INTO `sys_oper_log` VALUES (1998950480395468802, '000000', '用户管理', 1, 'org.dromara.system.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '0:0:0:0:0:0:0:1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"userId\":\"1998950480332554241\",\"deptId\":\"1998941822647369730\",\"userName\":\"ceshi3\",\"nickName\":\"测试3\",\"userType\":null,\"email\":null,\"phonenumber\":null,\"sex\":null,\"status\":\"0\",\"remark\":\"\",\"roleIds\":[4],\"postIds\":[],\"roleId\":null,\"userIds\":null,\"excludeUserIds\":null,\"superAdmin\":false}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-11 10:58:28', 93);
INSERT INTO `sys_oper_log` VALUES (2001316001138446337, '000000', '菜单管理', 1, 'org.dromara.system.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '龙江产互', '/system/menu', '127.0.0.1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"menuId\":null,\"parentId\":0,\"menuName\":\"文件中心\",\"orderNum\":1,\"path\":\"filesys_user\",\"component\":\"filesys/user/index\",\"queryParam\":null,\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"0\",\"status\":\"0\",\"icon\":\"list\",\"remark\":null}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-17 23:38:12', 97);
INSERT INTO `sys_oper_log` VALUES (2001319478350680065, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '龙江产互', '/system/menu', '127.0.0.1', '内网IP', '{\"createDept\":100,\"createBy\":null,\"createTime\":\"2025-12-17 23:38:12\",\"updateBy\":null,\"updateTime\":null,\"menuId\":\"2001316000769347585\",\"parentId\":0,\"menuName\":\"文件中心\",\"orderNum\":0,\"path\":\"filesys_user\",\"component\":\"filesys/user/index\",\"queryParam\":null,\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"0\",\"status\":\"0\",\"icon\":\"list\",\"remark\":\"\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-17 23:52:01', 35);
INSERT INTO `sys_oper_log` VALUES (2001319520734121986, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '龙江产互', '/system/menu', '127.0.0.1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":1,\"parentId\":0,\"menuName\":\"系统管理\",\"orderNum\":2,\"path\":\"system\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"0\",\"status\":\"0\",\"perms\":\"\",\"icon\":\"system\",\"remark\":\"系统管理目录\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-17 23:52:11', 23);
INSERT INTO `sys_oper_log` VALUES (2001319563117563905, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '龙江产互', '/system/menu', '127.0.0.1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":6,\"parentId\":0,\"menuName\":\"租户管理\",\"orderNum\":3,\"path\":\"tenant\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"chart\",\"remark\":\"租户管理目录\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-17 23:52:21', 26);
INSERT INTO `sys_oper_log` VALUES (2001319678003744770, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '龙江产互', '/system/menu', '127.0.0.1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":2,\"parentId\":0,\"menuName\":\"系统监控\",\"orderNum\":4,\"path\":\"monitor\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"monitor\",\"remark\":\"系统监控目录\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-17 23:52:49', 23);
INSERT INTO `sys_oper_log` VALUES (2001319720819200002, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '龙江产互', '/system/menu', '127.0.0.1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":3,\"parentId\":0,\"menuName\":\"系统工具\",\"orderNum\":5,\"path\":\"tool\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"tool\",\"remark\":\"系统工具目录\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-17 23:52:59', 17);
INSERT INTO `sys_oper_log` VALUES (2001319768873340929, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '龙江产互', '/system/menu', '127.0.0.1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":5,\"parentId\":0,\"menuName\":\"测试菜单\",\"orderNum\":6,\"path\":\"demo\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"star\",\"remark\":\"测试菜单\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-17 23:53:10', 19);
INSERT INTO `sys_oper_log` VALUES (2001319828440846337, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '龙江产互', '/system/menu', '127.0.0.1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":4,\"parentId\":0,\"menuName\":\"PLUS官网\",\"orderNum\":6,\"path\":\"https://gitee.com/dromara/RuoYi-Vue-Plus\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"guide\",\"remark\":\"RuoYi-Vue-Plus官网地址\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-17 23:53:24', 33);
INSERT INTO `sys_oper_log` VALUES (2001319865040343041, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '龙江产互', '/system/menu', '127.0.0.1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":5,\"parentId\":0,\"menuName\":\"测试菜单\",\"orderNum\":7,\"path\":\"demo\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"0\",\"status\":\"1\",\"perms\":\"\",\"icon\":\"star\",\"remark\":\"测试菜单\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-17 23:53:33', 22);
INSERT INTO `sys_oper_log` VALUES (2001320144523595778, '000000', '菜单管理', 1, 'org.dromara.system.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '龙江产互', '/system/menu', '127.0.0.1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"menuId\":null,\"parentId\":0,\"menuName\":\"文件管理\",\"orderNum\":1,\"path\":\"filesys_dept\",\"component\":\"filesys/dept/index\",\"queryParam\":null,\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"0\",\"status\":\"0\",\"icon\":\"nested\",\"remark\":null}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-17 23:54:40', 18);
INSERT INTO `sys_oper_log` VALUES (2001321587762630657, '000000', '角色管理', 2, 'org.dromara.system.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '龙江产互', '/system/role', '127.0.0.1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"roleId\":3,\"roleName\":\"子管理员\",\"roleKey\":\"subadmin\",\"roleSort\":2,\"dataScope\":\"4\",\"menuCheckStrictly\":true,\"deptCheckStrictly\":true,\"status\":\"0\",\"remark\":\"\",\"menuIds\":[\"2001316000769347585\",\"2001320144456486913\"],\"deptIds\":[],\"superAdmin\":false}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-18 00:00:24', 208);
INSERT INTO `sys_oper_log` VALUES (2001321619316379650, '000000', '角色管理', 2, 'org.dromara.system.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '龙江产互', '/system/role', '127.0.0.1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"roleId\":4,\"roleName\":\"普通成员\",\"roleKey\":\"common\",\"roleSort\":3,\"dataScope\":\"5\",\"menuCheckStrictly\":true,\"deptCheckStrictly\":true,\"status\":\"0\",\"remark\":\"\",\"menuIds\":[\"2001316000769347585\"],\"deptIds\":[],\"superAdmin\":false}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-18 00:00:31', 70);
INSERT INTO `sys_oper_log` VALUES (2001327135681777666, '000000', '菜单管理', 2, 'org.dromara.system.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '龙江产互', '/system/menu', '127.0.0.1', '内网IP', '{\"createDept\":103,\"createBy\":null,\"createTime\":\"2025-12-02 14:34:57\",\"updateBy\":null,\"updateTime\":null,\"menuId\":118,\"parentId\":1,\"menuName\":\"文件管理\",\"orderNum\":10,\"path\":\"oss\",\"component\":\"system/oss/index\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"0\",\"status\":\"0\",\"perms\":\"system:oss:list\",\"icon\":\"upload\",\"remark\":\"文件管理菜单\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-18 00:22:27', 21);
INSERT INTO `sys_oper_log` VALUES (2001327276442619906, '000000', '对象存储配置', 2, 'org.dromara.system.controller.system.SysOssConfigController.edit()', 'PUT', 1, 'admin', '龙江产互', '/resource/oss/config', '127.0.0.1', '内网IP', '{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"ossConfigId\":1,\"configKey\":\"minio\",\"accessKey\":\"minioadmin\",\"secretKey\":\"minioadmin\",\"bucketName\":\"ruoyi\",\"prefix\":\"\",\"endpoint\":\"127.0.0.1:9000\",\"domain\":\"\",\"isHttps\":\"N\",\"status\":\"0\",\"region\":\"\",\"ext1\":\"\",\"remark\":null,\"accessPolicy\":\"1\"}', '{\"code\":200,\"msg\":\"操作成功\",\"data\":null}', 0, '', '2025-12-18 00:23:00', 48);

-- ----------------------------
-- Table structure for sys_oss
-- ----------------------------
DROP TABLE IF EXISTS `sys_oss`;
CREATE TABLE `sys_oss`  (
  `oss_id` bigint NOT NULL COMMENT '对象存储主键',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '000000' COMMENT '租户编号',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文件名',
  `original_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '原名',
  `file_suffix` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文件后缀名',
  `url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'URL地址',
  `ext1` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '扩展字段',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '上传人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `service` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'minio' COMMENT '服务商',
  PRIMARY KEY (`oss_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'OSS对象存储表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oss
-- ----------------------------

-- ----------------------------
-- Table structure for sys_oss_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_oss_config`;
CREATE TABLE `sys_oss_config`  (
  `oss_config_id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '000000' COMMENT '租户编号',
  `config_key` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '配置key',
  `access_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'accessKey',
  `secret_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '秘钥',
  `bucket_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '桶名称',
  `prefix` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '前缀',
  `endpoint` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '访问站点',
  `domain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '自定义域名',
  `is_https` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '是否https（Y=是,N=否）',
  `region` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '域',
  `access_policy` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '桶权限类型(0=private 1=public 2=custom)',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '是否默认（0=是,1=否）',
  `ext1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '扩展字段',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`oss_config_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '对象存储配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oss_config
-- ----------------------------
INSERT INTO `sys_oss_config` VALUES (1, '000000', 'minio', 'minioadmin', 'minioadmin', 'ruoyi', '', '127.0.0.1:9000', '', 'N', '', '1', '0', '', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-18 00:23:00', '');
INSERT INTO `sys_oss_config` VALUES (2, '000000', 'qiniu', 'XXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXX', 'ruoyi', '', 's3-cn-north-1.qiniucs.com', '', 'N', '', '1', '1', '', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-02 14:34:57', NULL);
INSERT INTO `sys_oss_config` VALUES (3, '000000', 'aliyun', 'XXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXX', 'ruoyi', '', 'oss-cn-beijing.aliyuncs.com', '', 'N', '', '1', '1', '', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-02 14:34:57', NULL);
INSERT INTO `sys_oss_config` VALUES (4, '000000', 'qcloud', 'XXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXX', 'ruoyi-1240000000', '', 'cos.ap-beijing.myqcloud.com', '', 'N', 'ap-beijing', '1', '1', '', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-02 14:34:57', NULL);
INSERT INTO `sys_oss_config` VALUES (5, '000000', 'image', 'ruoyi', 'ruoyi123', 'ruoyi', 'image', '127.0.0.1:9000', '', 'N', '', '1', '1', '', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-02 14:34:57', NULL);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '000000' COMMENT '租户编号',
  `dept_id` bigint NOT NULL COMMENT '部门id',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位编码',
  `post_category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '岗位类别编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '岗位信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, '000000', 100, 'superadmin', 'superadmin', '超级管理员', 0, '0', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-11 10:40:13', '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '000000' COMMENT '租户编号',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限 5：仅本人数据权限 6：部门及以下或本人数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '000000', '超级管理员', 'superadmin', 1, '1', 1, 1, '0', '0', 103, 1, '2025-12-02 14:34:57', NULL, NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (3, '000000', '子管理员', 'subadmin', 2, '4', 1, 1, '0', '0', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-18 00:00:24', '');
INSERT INTO `sys_role` VALUES (4, '000000', '普通成员', 'common', 3, '5', 1, 1, '0', '0', 103, 1, '2025-12-02 14:34:57', 1, '2025-12-18 00:00:31', '');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (3, 2001316000769347585);
INSERT INTO `sys_role_menu` VALUES (3, 2001320144456486913);
INSERT INTO `sys_role_menu` VALUES (4, 2001316000769347585);

-- ----------------------------
-- Table structure for sys_social
-- ----------------------------
DROP TABLE IF EXISTS `sys_social`;
CREATE TABLE `sys_social`  (
  `id` bigint NOT NULL COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '000000' COMMENT '租户id',
  `auth_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '平台+平台唯一id',
  `source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户来源',
  `open_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '平台编号唯一id',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '登录账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户昵称',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '头像地址',
  `access_token` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户的授权令牌',
  `expire_in` int NULL DEFAULT NULL COMMENT '用户的授权令牌的有效期，部分平台可能没有',
  `refresh_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '刷新令牌，部分平台可能没有',
  `access_code` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '平台的授权信息，部分平台可能没有',
  `union_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户的 unionid',
  `scope` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '授予的权限，部分平台可能没有',
  `token_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '个别平台的授权信息，部分平台可能没有',
  `id_token` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'id token，部分平台可能没有',
  `mac_algorithm` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '小米平台用户的附带属性，部分平台可能没有',
  `mac_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '小米平台用户的附带属性，部分平台可能没有',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户的授权code，部分平台可能没有',
  `oauth_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Twitter平台用户的附带属性，部分平台可能没有',
  `oauth_token_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Twitter平台用户的附带属性，部分平台可能没有',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社会化关系表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_social
-- ----------------------------

-- ----------------------------
-- Table structure for sys_tenant
-- ----------------------------
DROP TABLE IF EXISTS `sys_tenant`;
CREATE TABLE `sys_tenant`  (
  `id` bigint NOT NULL COMMENT 'id',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '租户编号',
  `contact_user_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `company_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '企业名称',
  `license_number` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '统一社会信用代码',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
  `intro` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '企业简介',
  `domain` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '域名',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `package_id` bigint NULL DEFAULT NULL COMMENT '租户套餐编号',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '过期时间',
  `account_count` int NULL DEFAULT -1 COMMENT '用户数量（-1不限制）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '租户状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '租户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_tenant
-- ----------------------------
INSERT INTO `sys_tenant` VALUES (1, '000000', '管理组', '15888888888', 'XXX有限公司', NULL, NULL, '多租户通用后台管理管理系统', NULL, NULL, NULL, NULL, -1, '0', '0', 103, 1, '2025-12-02 14:34:56', NULL, NULL);

-- ----------------------------
-- Table structure for sys_tenant_package
-- ----------------------------
DROP TABLE IF EXISTS `sys_tenant_package`;
CREATE TABLE `sys_tenant_package`  (
  `package_id` bigint NOT NULL COMMENT '租户套餐id',
  `package_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '套餐名称',
  `menu_ids` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联菜单id',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`package_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '租户套餐表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_tenant_package
-- ----------------------------

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '000000' COMMENT '租户编号',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'sys_user' COMMENT '用户类型（sys_user系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` bigint NULL DEFAULT NULL COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, '000000', 100, 'admin', '超级管理员', 'sys_user', 'superadmin@163.com', '17388888888', '1', NULL, '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-12-17 22:38:02', 100, 1, '2025-12-02 14:34:57', -1, '2025-12-17 22:38:02', '管理员');
INSERT INTO `sys_user` VALUES (1998947134204903426, '000000', 101, 'xiaobing1', '晓冰（子管理员）', 'sys_user', '', '', '0', NULL, '$2a$10$fjXyCsbgw36J8xFkAbXm8utZbPR9rTrZXwMmyItRukH/zY/oWuhgS', '0', '0', '', NULL, 103, 1, '2025-12-11 10:45:10', 1, '2025-12-11 10:50:18', '');
INSERT INTO `sys_user` VALUES (1998948862065213442, '000000', 103, 'xiaolin1', '晓琳（子管理员）', 'sys_user', '', '', '0', NULL, '$2a$10$p5CDC/Y1/9EvjB7lZG./jOVjc9ZMyuLV3Nu39asm5u6hIFB1A6Hxy', '0', '0', '', NULL, 103, 1, '2025-12-11 10:52:02', 1, '2025-12-11 10:52:02', '');
INSERT INTO `sys_user` VALUES (1998949045536653313, '000000', 1998941822647369730, 'xiaohong1', '晓红（子管理员）', 'sys_user', '', '', '0', NULL, '$2a$10$dgc4glTIWdMXHdH5mr.5AuVW91aoobX9sSDzNb0J9vNqQOByK6Psy', '0', '0', '0:0:0:0:0:0:0:1', '2025-12-15 17:08:29', 103, 1, '2025-12-11 10:52:46', -1, '2025-12-15 17:08:29', '');
INSERT INTO `sys_user` VALUES (1998949190676348929, '000000', 101, 'ceshi1', '测试1', 'sys_user', '', '', '0', NULL, '$2a$10$1nOOz.FDkg3rXfpUWaQZU.bZb6UxKoI2lNhlnT1drzfGwSm4eOGrG', '0', '0', '', NULL, 103, 1, '2025-12-11 10:53:20', 1, '2025-12-11 10:53:20', '');
INSERT INTO `sys_user` VALUES (1998950411202035714, '000000', 103, 'ceshi2', '测试2', 'sys_user', '', '', '0', NULL, '$2a$10$o3fNMuRS./hejQeyd9eI0Oc5Exdrj3erXHPkoErPUC3qA5x7S.XmC', '0', '0', '', NULL, 103, 1, '2025-12-11 10:58:11', 1, '2025-12-11 10:58:11', '');
INSERT INTO `sys_user` VALUES (1998950480332554241, '000000', 1998941822647369730, 'ceshi3', '测试3', 'sys_user', '', '', '0', NULL, '$2a$10$33Qf3J2PuZncbcPOtwAZHuHxa5BkxDcVMrClz9DzyjzvMRbkbpJge', '0', '0', '', NULL, 103, 1, '2025-12-11 10:58:28', 1, '2025-12-11 10:58:28', '');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (1998947134204903426, 3);
INSERT INTO `sys_user_role` VALUES (1998948862065213442, 3);
INSERT INTO `sys_user_role` VALUES (1998949045536653313, 3);
INSERT INTO `sys_user_role` VALUES (1998949190676348929, 4);
INSERT INTO `sys_user_role` VALUES (1998950411202035714, 4);
INSERT INTO `sys_user_role` VALUES (1998950480332554241, 4);

-- ----------------------------
-- Table structure for test_demo
-- ----------------------------
DROP TABLE IF EXISTS `test_demo`;
CREATE TABLE `test_demo`  (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '000000' COMMENT '租户编号',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门id',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户id',
  `order_num` int NULL DEFAULT 0 COMMENT '排序号',
  `test_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'key键',
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '值',
  `version` int NULL DEFAULT 0 COMMENT '版本',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `del_flag` int NULL DEFAULT 0 COMMENT '删除标志',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '测试单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of test_demo
-- ----------------------------
INSERT INTO `test_demo` VALUES (1, '000000', 102, 4, 1, '测试数据权限', '测试', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_demo` VALUES (2, '000000', 102, 3, 2, '子节点1', '111', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_demo` VALUES (3, '000000', 102, 3, 3, '子节点2', '222', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_demo` VALUES (4, '000000', 108, 4, 4, '测试数据', 'demo', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_demo` VALUES (5, '000000', 108, 3, 13, '子节点11', '1111', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_demo` VALUES (6, '000000', 108, 3, 12, '子节点22', '2222', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_demo` VALUES (7, '000000', 108, 3, 11, '子节点33', '3333', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_demo` VALUES (8, '000000', 108, 3, 10, '子节点44', '4444', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_demo` VALUES (9, '000000', 108, 3, 9, '子节点55', '5555', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_demo` VALUES (10, '000000', 108, 3, 8, '子节点66', '6666', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_demo` VALUES (11, '000000', 108, 3, 7, '子节点77', '7777', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_demo` VALUES (12, '000000', 108, 3, 6, '子节点88', '8888', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_demo` VALUES (13, '000000', 108, 3, 5, '子节点99', '9999', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);

-- ----------------------------
-- Table structure for test_tree
-- ----------------------------
DROP TABLE IF EXISTS `test_tree`;
CREATE TABLE `test_tree`  (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '000000' COMMENT '租户编号',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父id',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门id',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户id',
  `tree_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '值',
  `version` int NULL DEFAULT 0 COMMENT '版本',
  `create_dept` bigint NULL DEFAULT NULL COMMENT '创建部门',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `del_flag` int NULL DEFAULT 0 COMMENT '删除标志',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '测试树表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of test_tree
-- ----------------------------
INSERT INTO `test_tree` VALUES (1, '000000', 0, 102, 4, '测试数据权限', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_tree` VALUES (2, '000000', 1, 102, 3, '子节点1', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_tree` VALUES (3, '000000', 2, 102, 3, '子节点2', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_tree` VALUES (4, '000000', 0, 108, 4, '测试树1', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_tree` VALUES (5, '000000', 4, 108, 3, '子节点11', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_tree` VALUES (6, '000000', 4, 108, 3, '子节点22', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_tree` VALUES (7, '000000', 4, 108, 3, '子节点33', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_tree` VALUES (8, '000000', 5, 108, 3, '子节点44', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_tree` VALUES (9, '000000', 6, 108, 3, '子节点55', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_tree` VALUES (10, '000000', 7, 108, 3, '子节点66', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_tree` VALUES (11, '000000', 7, 108, 3, '子节点77', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_tree` VALUES (12, '000000', 10, 108, 3, '子节点88', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);
INSERT INTO `test_tree` VALUES (13, '000000', 10, 108, 3, '子节点99', 0, 103, '2025-12-02 14:34:57', 1, NULL, NULL, 0);

SET FOREIGN_KEY_CHECKS = 1;

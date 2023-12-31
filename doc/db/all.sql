#
#
# --------------------测试
# drop table if exists `test`;
# CREATE TABLE `test` (
#                         `id` varchar(20) COLLATE utf8mb4_general_ci NOT NULL comment 'id',
#                         `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL comment '名称',
#                         PRIMARY KEY (`id`)
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci comment='测试';
#
# insert into `test` (id,name) values (1,'测试');
# insert into `test` (id,name) values (2,'测试2');
#
# drop table if exists `chapter`;
# create table `chapter`
# (
#     `id` char(8) not null comment 'ID',
#     `course_id` char(8) comment '课程ID',
#     `name` varchar(50) comment '名称',
#     primary key (`id`)
# )engine =innodb default charset=utf8mb4 comment '大章';
#
# insert into `chapter` (id, course_id, name) values ('00000000','0','测试大章00');
# insert into `chapter` (id, course_id, name) values ('00000001','0','测试大章01');
# insert into `chapter` (id, course_id, name) values ('00000002','0','测试大章02');
# insert into `chapter` (id, course_id, name) values ('00000003','0','测试大章03');
# insert into `chapter` (id, course_id, name) values ('00000004','0','测试大章04');
# insert into `chapter` (id, course_id, name) values ('00000005','0','测试大章05');
# insert into `chapter` (id, course_id, name) values ('00000006','0','测试大章06');
# insert into `chapter` (id, course_id, name) values ('00000007','0','测试大章07');
# insert into `chapter` (id, course_id, name) values ('00000008','0','测试大章08');
# insert into `chapter` (id, course_id, name) values ('00000009','0','测试大章09');
# insert into `chapter` (id, course_id, name) values ('00000010','0','测试大章10');
# insert into `chapter` (id, course_id, name) values ('00000011','0','测试大章11');
# insert into `chapter` (id, course_id, name) values ('00000012','0','测试大章12');
# insert into `chapter` (id, course_id, name) values ('00000013','0','测试大章13');
# insert into `chapter` (id, course_id, name) values ('00000014','0','测试大章14');
#
# -- 小节
# DROP TABLE IF EXISTS `section`;
# CREATE TABLE `section` (
#   `id` char(8) NOT NULL DEFAULT '' COMMENT 'ID',
#   `title` VARCHAR(50) NOT NULL COMMENT '标题',
#   `course_id` CHAR(8) COMMENT '课程|course.id',
#   `chapter_id` CHAR(8) COMMENT '大章|chapter.id',
#   `video` VARCHAR(200) COMMENT '视频',
#   `time` INT COMMENT '时长|单位秒',
#   `charge` CHAR(1) COMMENT '收费|C 收费; F 免费',
#   `sort` INT COMMENT '顺序',
#   `created_at` DATETIME(3) COMMENT '创建时间',
#   `updated_at` DATETIME(3) COMMENT '修改时间',
#   PRIMARY KEY (`id`)
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='小节';
# INSERT INTO `section` (id, title, course_id, chapter_id, video, time, charge, sort, created_at, updated_at)
# VALUES ('00000001','测试小节01','00000001','00000000','',500,'F',1,now(),now());

# alter table `section` add column (`vod` char(32) comment 'vod|阿里云vod');

#--课程
# drop table if exists course;
# create table course(
#     id char(8) not null default '' comment 'id',
#     name varchar(50) not null comment '名称',
#     summary varchar(2000) comment '概述',
#     time int default 0 comment '时长|单位秒',
#     price decimal(8,2) default 0.00 comment '价格（元）',
#     image varchar(100) comment '封面',
#     level char(1) comment '级别|枚举[CourseLevelEnum]: ONE("1","初级"),TWO("2","中级"),THREE("3","高级")',
#     charge char(1) comment '收费|枚举[CourseChargeEnum]: CHARGE("C","收费"),FREE("F","免费")',
#     status char(1) comment '状态|枚举[CourseStatusEnum]: PUBLISH("P","发布"),DRAFT("D","草稿")',
#     enroll integer default 0 comment '报名数',
#     sort int comment '顺序',
#     created_at datatime(3) comment '创建时间',
#     updated_at datatime(3) comment '修改时间',
#     primary key (id)
# )engine=innodb default charset=utf8mb4 comment='课程表';
#
# insert into course (id, name, summary, "time", price, image, level, charge, status, enroll, sort, created_at, updated_at)
# values ('00000001','测试课程01','这是一门测试课程',7200,19.9,'',0,'C','D',100,0,now(),now());

# --分类
# drop table if exists `category`;
# create table `category`(
#     `id` char(8) not null  default '' comment 'id',
#     `parent` char(8) not null default '' comment '父id',
#     `name` varchar(50) not null comment '名称',
#     `sort` int comment '顺序',
#     primary key (`id`)
# )engine=innodb default charset=utf8mb4 comment='分类';
#
# insert into `category` (id, parent, name, sort) values ('00000100','00000000','前端技术',100);
# insert into `category` (id, parent, name, sort) values ('00000101','00000100','html/css',101);
# insert into `category` (id, parent, name, sort) values ('00000102','00000100','javascript',102);
# insert into `category` (id, parent, name, sort) values ('00000103','00000100','vue.js',103);
# insert into `category` (id, parent, name, sort) values ('00000104','00000100','react.js',104);
# insert into `category` (id, parent, name, sort) values ('00000105','00000100','angular',105);
# insert into `category` (id, parent, name, sort) values ('00000106','00000100','node.js',106);
# insert into `category` (id, parent, name, sort) values ('00000107','00000100','jquery',107);
# insert into `category` (id, parent, name, sort) values ('00000108','00000100','小程序',108);
# insert into `category` (id, parent, name, sort) values ('00000200','00000000','后端技术',200);
# insert into `category` (id, parent, name, sort) values ('00000201','00000200','java',201);
# insert into `category` (id, parent, name, sort) values ('00000202','00000200','springboot',202);
# insert into `category` (id, parent, name, sort) values ('00000203','00000200','spring cloud',203);
# insert into `category` (id, parent, name, sort) values ('00000204','00000200','ssm',204);
# insert into `category` (id, parent, name, sort) values ('00000205','00000200','python',205);
# insert into `category` (id, parent, name, sort) values ('00000206','00000200','爬虫',206);
# insert into `category` (id, parent, name, sort) values ('00000300','00000000','移动开发',300);
# insert into `category` (id, parent, name, sort) values ('00000301','00000300','基础应用', 301);
# insert into `category` (id, parent, name, sort) values ('00000302','00000300','进阶方向应用', 302);
# insert into `category` (id, parent, name, sort) values ('00000400','00000000','数据库', 400);
# insert into `category` (id, parent, name, sort) values ('00000401','00000400','MySQL', 401);
# insert into `category` (id, parent, name, sort) values ('00000500','00000000','其它', 500);
# insert into `category` (id, parent, name, sort) values ('00000501','00000500','服务器', 501);
# insert into `category` (id, parent, name, sort) values ('00000502','00000500','开发工具', 502);
# insert into `category` (id, parent, name, sort) values ('00000503','00000500','热门服务端语言', 503);

#课程分类
# drop table if exists `course_category`;
# create table `course_category`(
#     `id` char(8) not null default '' comment 'id',
#     `course_id` char(8) comment '课程｜course.id',
#     `category_id` char(8) comment '分类｜course.id',
#     primary key (`id`)
# )engine=innodb default charset=utf8mb4 comment='课程分类';

# #课程内容
# drop table if exists `course_content`;
# create table `course_content` (
#     `id` char(8) not null default '' comment '课程id',
#     `content` mediumtext not null comment '课程内容',
#     primary key (`id`)
# )engine = innodb default charset = utf8mb4 comment = '课程内容';

# #课程内容文件
# DROP TABLE IF EXISTS `course_content_file`;
# CREATE TABLE `course_content_file`  (
#   `id` char(8) not null default '' comment 'id',
#   `course_id` char(8) not null comment '课程id',
#   `url` varchar(100) comment '地址',
#   `name` varchar(10)  comment '文件名',
#   `size` int  comment '大小|字节b',
#   primary key (`id`)
# )engine = innodb default charset = utf8mb4 comment = '课程内容文件';
# #讲师
# DROP TABLE IF EXISTS `teacher`;
# CREATE TABLE `teacher`  (
#   `id` char(8) not null default '' comment 'id',
#   `name` varchar(50) not null comment '姓名',
#   `nickname` varchar(50) comment '昵称',
#   `image` varchar(100)  comment '头像',
#   `position` varchar(50)  comment '职位',
#   `motto` varchar(50) comment '座右铭',
#   `intro` varchar(500) comment '简介',
#   primary key (`id`)
# )ENGINE = InnoDB default charset = utf8mb4 COMMENT = '讲师';
#
# alter table `course` add column (`teacher_id` char(8) comment '讲师｜teacher.id');

# #文件
# DROP TABLE IF EXISTS `file`;
# CREATE TABLE `file`  (
#   `id` char(8) not null default '' comment 'id',
#   `path` varchar(100) not null comment '相对路径',
#   `name` varchar(100) comment '文件名',
#   `suffix` varchar(10)  comment '后缀',
#   `size` int  comment '大小|字节B',
#   `use` char(1) comment '用途|枚举[FileUseEnum]:COURSE("C", "讲师"),TEACHER("T", "课程")',
#   `created_at` datetime(3) comment '创建时间',
#   `updated_at` datetime(3) comment '修改时间',
#   primary key (`id`),
#   unique key `path_unique` (`path`)
# )ENGINE = InnoDB default charset = utf8mb4 COMMENT = '文件';

# alter table `file` add column (`shard_index` int comment '已上传分片');
# alter table `file` add column (`shard_size` int comment '分片大小|B');
# alter table `file` add column (`shard_total` int comment '分片总数');
# alter table `file` add column (`key` varchar(32) comment '文件标识');
# alter table `file` add unique key key_unique(`key`);
# alter table `file` add column (`vod` varchar(32) comment 'vod|阿里云vod');

drop table if exists `user`;
create table `user` (
  `id` char(8) not null default '' comment 'id',
  `login_name` varchar(50) not null comment '登录名',
  `name` varchar(50) comment '昵称',
  `password` char(32) not null comment '密码',
  primary key (`id`),
  unique key `login_name_unique` (`login_name`)
) engine=innodb default charset=utf8mb4 comment='用户';
insert into user (id, login_name, name, password) VALUES ('10000000','test','测试','test11');


--------------------测试
drop table if exists `test`;
CREATE TABLE `test` (
                        `id` varchar(20) COLLATE utf8mb4_general_ci NOT NULL comment 'id',
                        `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL comment '名称',
                        PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci comment='测试';

insert into `test` (id,name) values (1,'测试');
insert into `test` (id,name) values (2,'测试2');

drop table if exists `chapter`;
create table `chapter`
(
    `id` char(8) not null comment 'ID',
    `course_id` char(8) comment '课程ID',
    `name` varchar(50) comment '名称',
    primary key (`id`)
)engine =innodb default charset=utf8mb4 comment '大章';

insert into `chapter` (id, course_id, name) values ('00000000','0','测试大章00');
insert into `chapter` (id, course_id, name) values ('00000001','0','测试大章01');
insert into `chapter` (id, course_id, name) values ('00000002','0','测试大章02');
insert into `chapter` (id, course_id, name) values ('00000003','0','测试大章03');
insert into `chapter` (id, course_id, name) values ('00000004','0','测试大章04');
insert into `chapter` (id, course_id, name) values ('00000005','0','测试大章05');
insert into `chapter` (id, course_id, name) values ('00000006','0','测试大章06');
insert into `chapter` (id, course_id, name) values ('00000007','0','测试大章07');
insert into `chapter` (id, course_id, name) values ('00000008','0','测试大章08');
insert into `chapter` (id, course_id, name) values ('00000009','0','测试大章09');
insert into `chapter` (id, course_id, name) values ('00000010','0','测试大章10');
insert into `chapter` (id, course_id, name) values ('00000011','0','测试大章11');
insert into `chapter` (id, course_id, name) values ('00000012','0','测试大章12');
insert into `chapter` (id, course_id, name) values ('00000013','0','测试大章13');
insert into `chapter` (id, course_id, name) values ('00000014','0','测试大章14');

-- 小节
DROP TABLE IF EXISTS `section`;
CREATE TABLE `section` (
  `id` char(8) NOT NULL DEFAULT '' COMMENT 'ID',
  `title` VARCHAR(50) NOT NULL COMMENT '标题',
  `course_id` CHAR(8) COMMENT '课程|course.id',
  `chapter_id` CHAR(8) COMMENT '大章|chapter.id',
  `video` VARCHAR(200) COMMENT '视频',
  `time` INT COMMENT '时长|单位秒',
  `charge` CHAR(1) COMMENT '收费|C 收费; F 免费',
  `sort` INT COMMENT '顺序',
  `create_at` DATETIME(3) COMMENT '创建时间',
  `updated_at` DATETIME(3) COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='小节';
INSERT INTO `section` (id, title, course_id, chapter_id, video, time, charge, sort, create_at, updated_at)
VALUES ('00000001','测试小节01','00000001','00000000','',500,'F',1,now(),now());
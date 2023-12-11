

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


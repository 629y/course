drop table if exists `chapter`;
create table `chapter`
(
    `id` char(8) not null comment 'ID',
    `course_id` char(8) comment '课程ID',
    `name` varchar(50) comment '名称',
    primary key (`id`)
)engine =innodb default charset=utf8mb4 comment '大章';

--------------------测试
drop table if exists `test`;
CREATE TABLE `test` (
                        `id` varchar(20) COLLATE utf8mb4_general_ci NOT NULL comment 'id',
                        `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL comment '名称',
                        PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci comment='测试';

insert into `test` (id,name) values (1,'测试');
insert into `test` (id,name) values (2,'测试2');


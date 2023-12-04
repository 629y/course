drop table if exists `test`;
CREATE TABLE `test` (
                        `id` varchar(20) COLLATE utf8mb4_general_ci NOT NULL comment 'id',
                        `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL comment '名称',
                        PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci comment='测试';

insert into `test` (id,name) values (1,'测试');
insert into `test` (id,name) values (2,'测试2');
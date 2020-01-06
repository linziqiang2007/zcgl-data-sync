-- ALTER TABLE `sys_dict_item`
-- ADD COLUMN `del_flag`  int(1) NULL DEFAULT NULL COMMENT '删除状态' AFTER `update_time`;

drop table IF EXISTS iam_his_trigger_record ;
CREATE TABLE `iam_his_trigger_record` (
`id`  varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键id' ,
`table_id`  varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新表id' ,
`table_name`  varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新表名' ,
`update_type`  varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '更新类型：insert/update/delete' ,
`create_time`  datetime NULL COMMENT '创建日期' ,
`deal_time`  datetime NULL COMMENT '入历史表日期' ,
PRIMARY KEY (`id`)
)
;

drop table IF EXISTS iam_trigger_record ;
CREATE TABLE `iam_trigger_record` (
`id`  varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键id' ,
`table_id`  varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新表id' ,
`table_name`  varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新表名' ,
`update_type`  varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '更新类型：insert/update/delete' ,
`create_time`  datetime NULL COMMENT '创建日期' ,
PRIMARY KEY (`id`)
)
;

-- ---------------------------------------------------------------------------


drop trigger IF EXISTS iam_trigger_sys_dict_insert ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_sys_dict_insert after insert on sys_dict for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time)  VALUES (UUID(),new.id,'sys_dict','insert',now());
end
##
delimiter ;

drop trigger IF EXISTS iam_trigger_sys_dict_update ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_sys_dict_update after update on sys_dict for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time) VALUES (UUID(),new.id,'sys_dict','update',now());
end
##
delimiter ;
-- ---------------------------------------------------------------------------


drop trigger IF EXISTS iam_trigger_sys_dict_item_insert ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_sys_dict_item_insert after insert on sys_dict_item for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time)  VALUES (UUID(),new.id,'sys_dict_item','insert',now());
end
##
delimiter ;

drop trigger IF EXISTS iam_trigger_sys_dict_item_update ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_sys_dict_item_update after update on sys_dict_item for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time) VALUES (UUID(),new.id,'sys_dict_item','update',now());
end
##
delimiter ;
-- ---------------------------------------------------------------------------



drop trigger IF EXISTS iam_trigger_sys_depart_insert ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_sys_depart_insert after insert on sys_depart for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time)  VALUES (UUID(),new.id,'sys_depart','insert',now());
end
##
delimiter ;

drop trigger IF EXISTS iam_trigger_sys_depart_update ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_sys_depart_update after update on sys_depart for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time) VALUES (UUID(),new.id,'sys_depart','update',now());
end
##
delimiter ;
-- ---------------------------------------------------------------------------

drop trigger IF EXISTS iam_trigger_depart_child_insert ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_depart_child_insert after insert on iam_depart_child for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time)  VALUES (UUID(),new.id,'iam_depart_child','insert',now());
end
##
delimiter ;

drop trigger IF EXISTS iam_trigger_depart_child_update ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_depart_child_update after update on iam_depart_child for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time) VALUES (UUID(),new.id,'iam_depart_child','update',now());
end
##
delimiter ;
-- ---------------------------------------------------------------------------

drop trigger IF EXISTS iam_trigger_computer_room_insert ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_computer_room_insert after insert on iam_computer_room for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time)  VALUES (UUID(),new.id,'iam_computer_room','insert',now());
end
##
delimiter ;

drop trigger IF EXISTS iam_trigger_computer_room_update ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_computer_room_update after update on iam_computer_room for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time) VALUES (UUID(),new.id,'iam_computer_room','update',now());
end
##
delimiter ;
-- ---------------------------------------------------------------------------

drop trigger IF EXISTS iam_trigger_cost_insert ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_cost_insert after insert on iam_cost for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time)  VALUES (UUID(),new.id,'iam_cost','insert',now());
end
##
delimiter ;

drop trigger IF EXISTS iam_trigger_cost_update ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_cost_update after update on iam_cost for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time) VALUES (UUID(),new.id,'iam_cost','update',now());
end
##
delimiter ;
-- ---------------------------------------------------------------------------

drop trigger IF EXISTS iam_trigger_depart_system_insert ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_depart_system_insert after insert on iam_depart_system for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time)  VALUES (UUID(),new.id,'iam_depart_system','insert',now());
end
##
delimiter ;

drop trigger IF EXISTS iam_trigger_depart_system_update ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_depart_system_update after update on iam_depart_system for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time) VALUES (UUID(),new.id,'iam_depart_system','update',now());
end
##
delimiter ;
-- ---------------------------------------------------------------------------

drop trigger IF EXISTS iam_trigger_network_insert ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_network_insert after insert on iam_network for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time)  VALUES (UUID(),new.id,'iam_network','insert',now());
end
##
delimiter ;

drop trigger IF EXISTS iam_trigger_network_update ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_network_update after update on iam_network for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time) VALUES (UUID(),new.id,'iam_network','update',now());
end
##
delimiter ;
-- ---------------------------------------------------------------------------

drop trigger IF EXISTS iam_trigger_storage_resources_insert ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_storage_resources_insert after insert on iam_storage_resources for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time)  VALUES (UUID(),new.id,'iam_storage_resources','insert',now());
end
##
delimiter ;

drop trigger IF EXISTS iam_trigger_storage_resources_update ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_storage_resources_update after update on iam_storage_resources for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time) VALUES (UUID(),new.id,'iam_storage_resources','update',now());
end
##
delimiter ;
-- ---------------------------------------------------------------------------

drop trigger IF EXISTS iam_trigger_sto_sys_insert ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_sto_sys_insert after insert on iam_sto_sys for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time)  VALUES (UUID(),new.id,'iam_sto_sys','insert',now());
end
##
delimiter ;

drop trigger IF EXISTS iam_trigger_sto_sys_update ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_sto_sys_update after update on iam_sto_sys for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time) VALUES (UUID(),new.id,'iam_sto_sys','update',now());
end
##
delimiter ;
-- ---------------------------------------------------------------------------

drop trigger IF EXISTS iam_trigger_system_insert ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_system_insert after insert on iam_system for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time)  VALUES (UUID(),new.id,'iam_system','insert',now());
end
##
delimiter ;

drop trigger IF EXISTS iam_trigger_system_update ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_system_update after update on iam_system for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time) VALUES (UUID(),new.id,'iam_system','update',now());
end
##
delimiter ;
-- ---------------------------------------------------------------------------

drop trigger IF EXISTS iam_trigger_system_db_insert ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_system_db_insert after insert on iam_system_db for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time)  VALUES (UUID(),new.id,'iam_system_db','insert',now());
end
##
delimiter ;

drop trigger IF EXISTS iam_trigger_system_db_update ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_system_db_update after update on iam_system_db for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time) VALUES (UUID(),new.id,'iam_system_db','update',now());
end
##
delimiter ;
-- ---------------------------------------------------------------------------

drop trigger IF EXISTS iam_trigger_system_run_insert ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_system_run_insert after insert on iam_system_run for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time)  VALUES (UUID(),new.id,'iam_system_run','insert',now());
end
##
delimiter ;

drop trigger IF EXISTS iam_trigger_system_run_update ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_system_run_update after update on iam_system_run for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time) VALUES (UUID(),new.id,'iam_system_run','update',now());
end
##
delimiter ;
-- ---------------------------------------------------------------------------

drop trigger IF EXISTS iam_trigger_vendor_insert ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_vendor_insert after insert on iam_vendor for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time)  VALUES (UUID(),new.id,'iam_vendor','insert',now());
end
##
delimiter ;

drop trigger IF EXISTS iam_trigger_vendor_update ;
delimiter ##
-- 创建触发器
create trigger iam_trigger_vendor_update after update on iam_vendor for each row
begin
    insert into iam_trigger_record (id,table_id,table_name,update_type,create_time) VALUES (UUID(),new.id,'iam_vendor','update',now());
end
##
delimiter ;
-- ---------------------------------------------------------------------------





-- drop trigger iam_trigger_computer_room_insert     ;
-- drop trigger iam_trigger_computer_room_update     ;
-- drop trigger iam_trigger_cost_insert              ;
-- drop trigger iam_trigger_cost_update              ;
-- drop trigger iam_trigger_depart_child_insert      ;
-- drop trigger iam_trigger_depart_child_update      ;
-- drop trigger iam_trigger_depart_system_insert     ;
-- drop trigger iam_trigger_depart_system_update     ;
-- drop trigger iam_trigger_network_insert           ;
-- drop trigger iam_trigger_network_update           ;
-- drop trigger iam_trigger_sto_sys_insert           ;
-- drop trigger iam_trigger_sto_sys_update           ;
-- drop trigger iam_trigger_storage_resources_insert ;
-- drop trigger iam_trigger_storage_resources_update ;
-- drop trigger iam_trigger_system_insert            ;
-- drop trigger iam_trigger_system_update            ;
-- drop trigger iam_trigger_system_db_insert         ;
-- drop trigger iam_trigger_system_db_update         ;
-- drop trigger iam_trigger_system_run_insert        ;
-- drop trigger iam_trigger_system_run_update        ;
-- drop trigger iam_trigger_vendor_insert            ;
-- drop trigger iam_trigger_vendor_update            ;
-- drop trigger iam_trigger_sys_depart_insert        ;
-- drop trigger iam_trigger_sys_depart_update        ;
-- drop trigger iam_trigger_sys_dict_insert          ;
-- drop trigger iam_trigger_sys_dict_update          ;
-- drop trigger iam_trigger_sys_dict_item_insert     ;
-- drop trigger iam_trigger_sys_dict_item_update     ;
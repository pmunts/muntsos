drop table if exists LoRaMessages;

create table LoRaMessages
(
  sender   varchar(20),
  receiver varchar(20),
  RSS      int,
  SNR      int,
  message  varchar(256)
  time     datetime default current_timestamp,
);

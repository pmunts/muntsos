drop table if exists LoRaMessages;

create table LoRaMessages
(
  time     datetime,
  sender   varchar(20),
  receiver varchar(20),
  RSS      int,
  SNR      int,
  message  varchar(256)
);

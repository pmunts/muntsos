drop table if exists LoRaMessages;

create table LoRaMessages
(
  sender   varchar(20) not null,
  receiver varchar(20) not null,
  RSS      int not null,
  SNR      int not null,
  message  varchar(256) not null,
  time     datetime not null default current_timestamp
);

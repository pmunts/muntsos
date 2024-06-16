use test1;

drop table if exists Temperature;

create table Temperature
(
  sensor varchar(30),
  temp decimal(8,1),
  time datetime
);

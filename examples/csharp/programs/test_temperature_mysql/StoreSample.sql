use test1;

drop procedure if exists StoreSample;

delimiter //

create procedure StoreSample(in sensor varchar(30), in sample decimal(8,1), in time datetime)

begin
  insert Temperature values(sensor, sample, time);
end //

delimiter ;

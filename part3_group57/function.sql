drop function if exists total_consults;
delimiter $$
create function total_consults(a_name varchar(255), vat_owner integer, year varchar(255))
returns integer
begin
  declare total integer;
  select count(*) into total
  from consult
  where name=a_name and consult.vat_owner=vat_owner and year(date_timestamp)=year;
  return total;
end$$
delimiter ;
drop procedure if exists change_ref;
delimiter $$
create procedure change_ref ()
begin
    update produced_indicator
    set produced_indicator.value=produced_indicator.value/10
    where indicator_name in (select name from indicator where units='mg');
    
    update indicator
    set reference_value=reference_value/10, units='cg'
    where units='mg';
end$$
delimiter ;
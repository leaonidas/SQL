/*trigger 1*/

drop trigger if exists animal_age;
delimiter $$
create trigger animal_age
before insert on consult
for each row
begin
  declare a_age integer;
  declare birth varchar(255);
  select birth_year from animal where animal.name=new.name into birth;
  select datediff(curdate(), birth) div 365 into a_age;
  update animal
  set age=a_age
  where animal.name=new.name and animal.vat=new.vat_owner;
end$$
delimiter ;



/*trigger 2*/

/*insert on veterinary, verifies assistants*/
drop trigger if exists only_vet;
delimiter $$
create trigger only_vet
before insert on veterinary
for each row
begin
    if(exists(select vat from assistant where assistant.vat = new.vat)) then
        signal sqlstate '45000';
    end if;
end$$
delimiter ;

/*insert on assistants, verifies veterinaries*/
drop trigger if exists only_ast;
delimiter $$
create trigger only_ast
before insert on assistant
for each row
begin
    if(exists(select vat from veterinary where veterinary.vat = new.vat)) then
        signal sqlstate '45000';
    end if;
end$$
delimiter ;




/*trigger 3*/

drop trigger if exists unique_number;
delimiter $$
create trigger unique_number
before insert on phone_number
for each row
begin
    if(exists(select phone from phone_number where phone_number.phone = new.phone))
    then
        signal sqlstate '45000';
    end if;
end$$
delimiter ;


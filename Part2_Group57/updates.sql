/*update1*/
update person set address_street='Spooner Street', address_city='Boston'
where name='John Smith';

/*update2*/
update indicator set reference_value=reference_value*1.1
where indicator.units='mg' and indicator.name in
  (select indicator_name
   from produced_indicator
   where num in
    (select num
     from test_procedures
     where type like '%blood%'));
     
/*update3*/


/*update4*/
insert into diagnosis_code(code,name) values ('esrd', 'end-state renal disease');

update consultdiagnosis set code='esrd'
where code='p' and name in
  (select name
   from procedures
   where name in
    (select name
    from test_procedures
    where type like '%blood%' and name in
      (select name
       from produced_indicator
       where indicator_name='creatinine' and value>ALL
        (select reference_value
         from indicator
         where name='creatinine'))));

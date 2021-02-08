/*view 1*/
create view dim_date as
  (select date_timestamp, year(date_timestamp) as year, month(date_timestamp) as month, day(date_timestamp) as day
   from consult
  );

/*view 2*/
create view dim_animal as
  (select name as animal_name, VAT as animal_vat, species_name as species, age
   from animal);

/*view 3*/
create view facts_concults as
    (select distinct dim_animal.animal_name, dim_animal.animal_vat, dim_date.date_timestamp,
      (select count(*)
       from procedures
       where procedures.name=consult.name and procedures.VAT_owner=consult.VAT_owner and procedures.date_timestamp=consult.date_timestamp) as num_pro,
      (select count(*)
       from prescription
       where prescription.name=consult.name and prescription.VAT_owner=consult.VAT_owner and prescription.date_timestamp=consult.date_timestamp) as num_pres
     from dim_animal, dim_date, consult
     where dim_animal.animal_name=consult.name and dim_animal.animal_vat=consult.VAT_owner and dim_date.date_timestamp=consult.date_timestamp);

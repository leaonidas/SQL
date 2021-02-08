/*query 1*/
select distinct A.name, P.name, A.species_name, A.age
from person P, animal A, consult C
where P.name in (select name from person where VAT_owner = P.VAT and VAT_vet = 583057692)
and A.name = C.name and VAT_vet in
  (select VAT
   from person
   where name='John Smith');

/*query 2*/
select name, reference_value
from indicator
where reference_value > 100 and units='mg'
order by reference_value desc;

/*query 3*/
select animal.name, person.name, animal.species_name, animal.age from animal, person
    where animal.VAT=person.VAT
    and animal.name in
    (select name from consult where consult.weight>30 group by animal.name having max(consult.date_timestamp)
     union
     select name from consult where consult.obj like '%obese%');

/*query 4*/
select P.name
from consult C, person P
where P.VAT=VAT_client and VAT_client not in (select VAT from animal);

/*query 5*/
select prescription.code, count(prescription.name_med)
from prescription
group by prescription.code
order by count(prescription.name_med) ASC;

/*query 6*/
select
(select count(*) from procedures where year(procedures.date_timestamp)='2017')/(select count(*) from consult where year(consult.date_timestamp)='2017') as avg_pro,
(select count(*) from assist_participation where year(assist_participation.date_timestamp)='2017')/(select count(*) from consult where year(consult.date_timestamp)='2017') as avg_asist,
(select count(*) from consultdiagnosis where year(consultdiagnosis.date_timestamp)='2017')/(select count(*) from consult where year(consult.date_timestamp)='2017') as avg_diag,
(select count(*) from prescription where year(prescription.date_timestamp)='2017')/(select count(*) from consult where year(consult.date_timestamp)='2017') as avg_pres;

/*query 7*/
select tab.species_name, tab.name, max(tab.cnt) 
from
    (select animal.species_name, diagnosis_code.name, count(diagnosis_code.name) as cnt
     from animal, generalization_species, consultdiagnosis, diagnosis_code
     where animal.species_name=generalization_species.name1 
     and generalization_species.name2='dog'
     and diagnosis_code.code=consultdiagnosis.code
     and consultdiagnosis.name=animal.name
     group by diagnosis_code.name, animal.species_name) as tab
group by tab.species_name;

/*query 8*/
select person.name
from person
where person.VAT in (select VAT from veterinary where VAT in
(select VAT_owner from consult union select VAT_client from consult)
union select VAT from assistant where VAT in (select VAT_owner from
consult union select VAT_client from consult));

/*query 9*/
select name, address_street, address_city, address_zip
from person
where VAT in
    (select VAT from animal where animal.species_name in
      (select name1
       from generalization_species
       where name2='bird'))
    and VAT not in
      (select VAT
       from animal
       where animal.species_name in
        (select name1
         from generalization_species
         where name2 not in
          (select name2
           from generalization_species
           where name2='bird')));

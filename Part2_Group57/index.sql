/*1*/
create index ix_consult_vet on consult (VAT_vet);

select distinct animal.name, person.name, animal.species_name, animal.age
from person, animal, consult
use index (ix_consult_vet)
where VAT_vet in (select VAT from person where name='John Smith')
and person.name in (select name from person where VAT_owner=person.VAT)
and animal.name=consult.name;

set foreign_key_checks=0;
drop index ix_consult_vet on consult;
set foreign_key_checks=1;

/*2*/
create index ix_ref_value_units on indicator (reference_value, units);

select name, reference_value
from indicator
use index (ix_ref_value_units)
where units='mg'
and reference_value>=100
order by reference_value desc;

set foreign_key_checks=0;
drop index ix_ref_value_units on indicator;
set foreign_key_checks=1;
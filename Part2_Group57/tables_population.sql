set foreign_key_checks = 0; drop table if exists person; set foreign_key_checks = 1;
drop table if exists phone_number;
set foreign_key_checks = 0; drop table if exists client; set foreign_key_checks = 1;
set foreign_key_checks = 0; drop table if exists veterinary; set foreign_key_checks = 1;
set foreign_key_checks = 0; drop table if exists assistant; set foreign_key_checks = 1;
set foreign_key_checks = 0; drop table if exists species; set foreign_key_checks = 1;
drop table if exists generalization_species;
set foreign_key_checks = 0; drop table if exists animal; set foreign_key_checks = 1;
set foreign_key_checks = 0; drop table if exists consult; set foreign_key_checks = 1;
set foreign_key_checks = 0; drop table if exists assist_participation; set foreign_key_checks = 1;
set foreign_key_checks = 0; drop table if exists diagnosis_code; set foreign_key_checks = 1;
set foreign_key_checks = 0; drop table if exists consultdiagnosis; set foreign_key_checks = 1;
set foreign_key_checks = 0; drop table if exists medication; set foreign_key_checks = 1;
set foreign_key_checks = 0; drop table if exists prescription; set foreign_key_checks = 1;
set foreign_key_checks = 0; drop table if exists indicator; set foreign_key_checks = 1;
set foreign_key_checks = 0; drop table if exists procedures; set foreign_key_checks = 1;
set foreign_key_checks = 0; drop table if exists performed; set foreign_key_checks = 1;
set foreign_key_checks = 0; drop table if exists radiography; set foreign_key_checks = 1;
set foreign_key_checks = 0; drop table if exists test_procedures; set foreign_key_checks = 1;
set foreign_key_checks = 0; drop table if exists produced_indicator; set foreign_key_checks = 1;

create table person(
  VAT integer,
  name varchar(255),
  address_street varchar(255),
  address_city varchar(255),
  address_zip char(8),
  primary key(VAT));

create table phone_number(
  VAT integer,
  phone integer,
  primary key(VAT, phone),
  foreign key(VAT) references person(VAT));

create table client(
  VAT integer,
  primary key(VAT),
  foreign key(VAT) references person(VAT));

create table veterinary(
  VAT integer,
  specialization varchar(255),
  bio varchar(255),
  primary key(VAT),
  foreign key(VAT) references person(VAT));

create table assistant(
  VAT integer,
  primary key(VAT),
  foreign key(VAT) references person(VAT));

create table species(
  name varchar(255),
  s_descprition varchar(255),
  primary key(name));

create table generalization_species(
  name1 varchar(255),
  name2 varchar(255),
  primary key(name1),
  foreign key(name1) references species(name),
  foreign key(name2) references species(name));

create table animal(
  name varchar(255),
  VAT integer,
  species_name varchar(255),
  colour varchar(255),
  gender varchar(255),
  birth_year integer,
  age integer,
  primary key(name, VAT),
  foreign key(VAT) references client(VAT),
  foreign key(species_name) references species(name));
  /*restriction*/

create table consult(
  name varchar(255),
  VAT_owner integer,
  date_timestamp varchar (255),
  sub varchar(255),
  obj varchar(255),
  asmnt varchar(255),
  pln varchar(255),
  VAT_client integer,
  VAT_vet integer,
  weight integer check (weight >= 0),
  primary key(name, VAT_owner, date_timestamp),
  foreign key(name, VAT_owner) references animal(name, VAT),
  foreign key(VAT_client) references client(VAT),
  foreign key(VAT_vet) references veterinary(VAT));

create table assist_participation(
  name varchar(255),
  VAT_owner integer,
  date_timestamp varchar(255),
  VAT_assistant integer,
  primary key(name, VAT_owner, date_timestamp, VAT_assistant),
  foreign key(name, VAT_owner, date_timestamp) references consult(name, VAT_owner, date_timestamp),
  foreign key(VAT_assistant) references assistant(VAT));

create table diagnosis_code(
  code varchar(255),
  name varchar(255),
  primary key(code));

create table consultdiagnosis(
  code varchar(255),
  name varchar(255),
  VAT_owner integer,
  date_timestamp varchar(255),
  primary key(code, name, VAT_owner, date_timestamp),
  foreign key(code) references diagnosis_code(code),
  foreign key(name, VAT_owner, date_timestamp) references consult(name, VAT_owner, date_timestamp));

create table medication(
  name varchar(255),
  lab varchar(255),
  dosage varchar(255),
  primary key(name, lab, dosage));

create table prescription(
  code varchar(255),
  name varchar(255),
  VAT_owner integer,
  date_timestamp varchar(255),
  name_med varchar(255),
  lab varchar(255),
  dosage varchar(255),
  regime varchar(255),
  primary key(code, name, VAT_owner, date_timestamp, name_med, lab, dosage),
  foreign key(code, name, VAT_owner, date_timestamp) references consultdiagnosis(code, name, VAT_owner, date_timestamp),
  foreign key(name_med, lab, dosage) references medication(name, lab, dosage));

create table indicator(
  name varchar(255),
  reference_value numeric(5,2),
  units varchar(255),
  description varchar(255),
  primary key(name));

create table procedures(
  name varchar(255),
  VAT_owner integer,
  date_timestamp varchar(255),
  num integer,
  description varchar(255) check(description like '%radiography%' or description like '%tests%' or description like '%surgical%'),
  primary key(name, VAT_owner, date_timestamp, num),
  foreign key(name, VAT_owner, date_timestamp) references consult(name, VAT_owner, date_timestamp));

create table performed(
  name varchar(255),
  VAT_owner integer,
  date_timestamp varchar(255),
  num integer,
  VAT_assistant integer,
  primary key(name, VAT_owner, date_timestamp, num, VAT_assistant),
  foreign key(name, VAT_owner, date_timestamp, num) references procedures(name, VAT_owner, date_timestamp, num),
  foreign key(VAT_assistant) references assistant(VAT));

create table radiography(
  name varchar(255),
  VAT_owner integer,
  date_timestamp varchar(255),
  num integer,
  file varchar(255),
  primary key(name, VAT_owner, date_timestamp, num),
  foreign key(name, VAT_owner, date_timestamp, num) references procedures(name, VAT_owner, date_timestamp, num));

create table test_procedures(
  name varchar(255),
  VAT_owner integer,
  date_timestamp varchar(255),
  num integer,
  type char(5) check(type='blood' or type='urine'),
  primary key(name, VAT_owner, date_timestamp, num),
  foreign key(name, VAT_owner, date_timestamp, num) references procedures(name, VAT_owner, date_timestamp, num));


create table produced_indicator(
  name varchar(255),
  VAT_owner integer,
  date_timestamp varchar(255),
  num integer,
  indicator_name varchar(255),
  value numeric(5,2),
  primary key(name, VAT_owner, date_timestamp, num, indicator_name),
  foreign key(name, VAT_owner, date_timestamp, num) references test_procedures(name, VAT_owner, date_timestamp, num),
  foreign key(indicator_name) references indicator(name));

/********************************Populate Tables**************************************/

insert into person values(673938590, 'John Wick', 'Main Street', 'Boston', '1001-123');
insert into person values(347834694, 'Harry Potter', 'Privet Drive', 'London', '1002-345');
insert into person values(294750283, 'Rubeus Hagrid', 'Hagrids Hut', 'London', '1002-392');
insert into person values(474926579, 'Shrek', 'Swamp Street', 'Lisbon', '1000-222');
insert into person values(475028667, 'Jafar', 'Pharaoh Street', 'Lisbon', '1000-671');
insert into person values(120958001, 'Luis Filipe Vieira', 'Av Eusebio da Silva Ferreira', 'Lisbon', '1000-120');
insert into person values(103957320, 'Shaggy Rogers', 'Maple Street', 'Boston', '1001-420');
insert into person values(439502753, 'Peter Griffin', 'Spooner Street', 'Boston', '1001-234');
insert into person values(292839283, 'Jon Arbuckle', 'Spooner Street', 'Boston', '1001-234');
insert into person values(239570075, 'Hermione Granger', 'Hagrids Hut', 'London', '1002-392');
insert into person values(583057692, 'John Smith', 'Main Street', 'Lisbon', '1000-123');
insert into person values(848049583, 'Lois Griffin', 'Spooner Street', 'Boston', '1001-234');

insert into phone_number values (673938590, 917838656);
insert into phone_number values (347834694, 914839302);
insert into phone_number values (294750283, 918485029);
insert into phone_number values (474926579, 915747913);
insert into phone_number values (475028667, 913875849);
insert into phone_number values (120958001, 917836433);
insert into phone_number values (103957320, 913787430);
insert into phone_number values (439502753, 917383923);
insert into phone_number values (292839283, 918484848);
insert into phone_number values (239570075, 913958582);
insert into phone_number values (583057692, 913485832);
insert into phone_number values (848049583, 917383923);

insert into client values(673938590);
insert into client values(347834694);
insert into client values(294750283);
insert into client values(474926579);
insert into client values(475028667);
insert into client values(120958001);
insert into client values(103957320);
insert into client values(439502753);
insert into client values(292839283);
insert into client values(239570075);
insert into client values(848049583);
insert into client values(583057692);

insert into veterinary values(239570075, 'Surgery', 'I am hoping to do some good in the world!');
insert into veterinary values(583057692, 'Internal Medicine', 'Make vets great again.');
insert into veterinary values(294750283, 'Large Animal', 'I am vet, Harry!');

insert into assistant values(103957320);
insert into assistant values(439502753);
insert into assistant values(474926579);

insert into species values('bird', 'Feathers, toothless beaked jaws, the laying of hard-shelled eggs');
insert into species values('mammal', 'Member of the group of vertebrate animals in which the young are nourished with milk from special mammary glands of the mother.');
insert into species values('dog', 'Domestic animal part of the wolf-like canids, and is the most widely abundant terrestrial carnivore.');
insert into species values('cat', 'Small feline, typically furry, carnivorous mammal.');
insert into species values('donkey', 'Domesticated member of the horse family.');
insert into species values('snowy owl', 'Large, white owl of the typical owl family.');
insert into species values('parrot', 'Strong, curved bill, an upright stance, strong legs, and clawed zygodactyl feet.');
insert into species values('bald eagle', 'Bird of prey found in North America');
insert into species values('hippogriff', 'Front legs, wings, and head of a giant eagle and the body, hind legs and tail of a horse.');
insert into species values('beagle', 'Breed of small hound that is similar in appearance to the much larger foxhound');
insert into species values('neapolitan mastiff', 'Large, ancient dog breed.');
insert into species values('labrador retriever', 'Retriever-gun dog. ');
insert into species values('great dane', 'Breed of domestic dog known for its giant size.');
insert into species values('exotic short hair persian', 'Breed of cat developed to be a short-haired version of the Persian.');
insert into species values('half kneazle', 'Magical feline creature.');

insert into generalization_species values('snowy owl','bird');
insert into generalization_species values('parrot','bird');
insert into generalization_species values('bald eagle','bird');
insert into generalization_species values('hippogriff','bird');
insert into generalization_species values('dog','mammal');
insert into generalization_species values('beagle','dog');
insert into generalization_species values('neapolitan mastiff','dog');
insert into generalization_species values('great dane','dog');
insert into generalization_species values('labrador retriever','dog');
insert into generalization_species values('cat','mammal');
insert into generalization_species values('exotic short hair persian','cat');
insert into generalization_species values('half kneazle','cat');
insert into generalization_species values('donkey','mammal');

insert into animal values('Daisy', 673938590, 'beagle', 'Mixed', 'F', 2014, 4);
insert into animal values('Hedwig', 347834694, 'snowy owl', 'White', 'M', 2001, 17);
insert into animal values('Fang' , 294750283, 'neapolitan mastiff', 'Black', 'M', 2001, 17);
insert into animal values('Buckbeack', 294750283, 'hippogriff', 'Grey', 'M', 2001, 17);
insert into animal values('Donkey', 474926579, 'donkey', 'Grey', 'M', 2010, 8);
insert into animal values('Iago', 475028667, 'parrot', 'Red', 'M', 1992, 26);
insert into animal values('Vitoria', 120958001, 'bald eagle', 'Mixed', 'F', 2014, 4);
insert into animal values('Scooby', 103957320, 'great dane', 'Brown', 'M', 2010, 8);
insert into animal values('Brian', 439502753, 'labrador retriever', 'White', 'M', 2010, 8);
insert into animal values('Garfield', 292839283, 'exotic short hair persian', 'Orange', 'M', 2004, 14);
insert into animal values('Odie', 292839283, 'beagle', 'Mixed', 'M', 2004, 14);
insert into animal values('Croockshanks', 239570075, 'half kneazle', 'Orange', 'M', 2001, 17);
insert into animal values('Lucky', 583057692, 'labrador retriever', 'Chocolate', 'F', 2017, 1);

insert into consult values('Daisy', 673938590, '2017-7-27 09:00:30.75', 'Routine check','Apparently no signs for concern','Apparently no signs for concern','Weighting and other standard tests', 673938590, 583057692, 5);
insert into consult values('Daisy', 673938590, '2017-11-27 09:00:30.75', 'Dog was shivering','May be sick','Fever','Vaccination, cool water on paws and ears, vitamins', 673938590, 583057692, 6);
insert into consult values('Hedwig', 347834694,'2016-7-27 09:00:30.75', 'Routine check','Apparently no signs for concern','Apparently no signs for concern','Weighting and other standard tests', 347834694,583057692, 4);
insert into consult values('Fang', 294750283,'2017-1-27 09:00:30.75', 'Routine check','Apparently no signs for concern','Apparently no signs for concern','Weighting and other standard tests', 347834694, 583057692, 30);
insert into consult values('Buckbeack', 294750283,'2018-7-27 09:00:30.75', 'Fell while flying','Obese','Fissured beack','X-rays, wraps to hold beack fix', 294750283, 239570075, 80);
insert into consult values('Buckbeack', 294750283,'2018-9-27 09:00:30.75', 'Fell while flying','Has a gash in the beack, may have broken beack','Fissured beack','X-rays, wraps to hold beack fix', 294750283, 239570075, 60);
insert into consult values('Donkey', 474926579,'2017-7-26 09:00:30.75', 'Routine check','Apparently no signs for concern','Apparently no signs for concern','Weighting and other standard tests', 474926579, 239570075, 35);
insert into consult values('Iago', 475028667,'2016-7-30 09:00:30.75', 'Routine check','Apparently no signs for concern','Apparently no signs for concern','Weighting and other standard tests', 120958001, 583057692, 3);
insert into consult values('Vitoria', 120958001,'2016-7-28 09:00:30.75', 'Eagle not behaving naturaly','Developed urinary incontinence. Old eagle, may be kidney failure','Kidney failure','Cirurgical intrevention',120958001, 239570075, 4);
insert into consult values('Scooby', 103957320,'2016-7-27 09:00:45.75', 'Lack of articulated movement in back legs','Was overweight, knee is swolen','Arthritis','X-rays, arthritis medication', 673938590, 294750283, 70);
insert into consult values('Scooby', 103957320,'2017-5-27 10:00:30.75', 'Owner thinks dog is overweight','Dog as food at disposition, obese','Obese','Special type of dog food, exercise', 673938590, 294750283, 90);
insert into consult values('Brian', 439502753, '2017-7-27 09:45:30.75', 'Cannot stand on left leg','Hit by car, cries when left leg is touched','May have broken leg','Needs x-rays, may need cast',848049583, 239570075, 15);
insert into consult values('Garfield', 292839283,'2017-7-27 09:40:30.75', 'Keeps barfing','Cat ate too much lasagna, obese','Food poisoning','Stomach clense, pills',292839283, 294750283, 20);
insert into consult values('Odie', 292839283,'2017-7-27 09:00:30.75', 'Routine check','Apparently no signs for concern','Apparently no signs for concern','Weighting and other standard tests', 347834694, 583057692, 12);
insert into consult values('Croockshanks', 239570075,'2016-7-27 10:00:30.75', 'A few scratches','Fought with another cat','Only minor scratches','Disinfect wounds, lotion, maybe some stitches, blood samples', 239570075, 294750283, 10);
insert into consult values('Lucky', 583057692, '2017-11-27 18:30:30.75', 'Bleeding from nose','Fell head first','Broken nose','X-rays, medication', 583057692, 294750283, 25);

insert into assist_participation values('Daisy', 673938590, '2017-7-27 09:00:30.75', 103957320);
insert into assist_participation values('Daisy', 673938590, '2017-11-27 09:00:30.75', 439502753);
insert into assist_participation values('Hedwig', 347834694, '2016-7-27 09:00:30.75', 439502753);
insert into assist_participation values('Fang', 294750283,'2017-1-27 09:00:30.75', 103957320);
insert into assist_participation values('Buckbeack', 294750283,'2018-7-27 09:00:30.75', 103957320);
insert into assist_participation values('Donkey', 474926579, '2017-7-26 09:00:30.75', 103957320);
insert into assist_participation values('Iago', 475028667,'2016-7-30 09:00:30.75', 103957320);
insert into assist_participation values('Vitoria', 120958001, '2016-7-28 09:00:30.75', 439502753);
insert into assist_participation values('Scooby', 103957320, '2016-7-27 09:00:45.75', 439502753);
insert into assist_participation values('Scooby', 103957320,'2017-5-27 10:00:30.75', 439502753);
insert into assist_participation values('Brian', 439502753, '2017-7-27 09:45:30.75', 103957320);
insert into assist_participation values('Garfield', 292839283, '2017-7-27 09:40:30.75', 103957320);
insert into assist_participation values('Odie', 292839283,'2017-7-27 09:00:30.75', 439502753);
insert into assist_participation values('Croockshanks', 239570075, '2016-7-27 10:00:30.75', 439502753);
insert into assist_participation values('Lucky', 583057692, '2017-11-27 18:30:30.75', 439502753);


insert into diagnosis_code values('r','something broken');
insert into diagnosis_code values('o','obese');
insert into diagnosis_code values('y','gastro-intestinal problems');
insert into diagnosis_code values('g','everything ok');
insert into diagnosis_code values('b','sick');
insert into diagnosis_code values('p','kidney failure');
insert into diagnosis_code values('blk','superficial injuries');
insert into diagnosis_code values('a','articulations problems');

insert into consultdiagnosis values('g','Daisy', 673938590,'2017-7-27 09:00:30.75');
insert into consultdiagnosis values('b','Daisy', 673938590,'2017-11-27 09:00:30.75');
insert into consultdiagnosis values('g','Hedwig', 347834694,'2016-7-27 09:00:30.75');
insert into consultdiagnosis values('g','Fang' , 294750283,'2017-1-27 09:00:30.75');
insert into consultdiagnosis values('r','Buckbeack', 294750283,'2018-7-27 09:00:30.75');
insert into consultdiagnosis values('g','Donkey', 474926579,'2017-7-26 09:00:30.75');
insert into consultdiagnosis values('g','Iago', 475028667,'2016-7-30 09:00:30.75');
insert into consultdiagnosis values('p','Vitoria', 120958001,'2016-7-28 09:00:30.75');
insert into consultdiagnosis values('o','Scooby', 103957320,'2016-7-27 09:00:45.75');
insert into consultdiagnosis values('a','Scooby', 103957320,'2017-5-27 10:00:30.75');
insert into consultdiagnosis values('r','Brian', 439502753,'2017-7-27 09:45:30.75');
insert into consultdiagnosis values('y','Garfield', 292839283,'2017-7-27 09:40:30.75');
insert into consultdiagnosis values('g','Odie', 292839283,'2017-7-27 09:00:30.75');
insert into consultdiagnosis values('blk','Croockshanks', 239570075,'2016-7-27 10:00:30.75');
insert into consultdiagnosis values('p','Croockshanks', 239570075,'2016-7-27 10:00:30.75');
insert into consultdiagnosis values('r','Lucky', 583057692, '2017-11-27 18:30:30.75');

insert into medication values('Winterfell','Heisenberg Co','100ml');
insert into medication values('The Wall','Heisenberg Co','100ml');
insert into medication values('Casterly Rock','Heisenberg Co','100ml');
insert into medication values('Storms End','Heisenberg Co','100ml');
insert into medication values('Highgarden','Heisenberg Co','100ml');
insert into medication values('The Eyrie','Potion Lab Lda.','100ml');
insert into medication values('Sunspear','Potion Lab Lda.','100ml');
insert into medication values('The Citadel','Potion Lab Lda.','100ml');
insert into medication values('Riverrun','Potion Lab Lda.','100ml');
insert into medication values('Dragonstone','Potion Lab Lda.','100ml');

insert into prescription values('b','Daisy', 673938590,'2017-11-27 09:00:30.75','The Citadel','Potion Lab Lda.','100ml', 'interval 4h -4xday- 3days');
insert into prescription values('a','Scooby', 103957320,'2017-5-27 10:00:30.75','Winterfell','Heisenberg Co','100ml', 'interval 6h -3xday- 5days');
insert into prescription values('y','Garfield', 292839283,'2017-7-27 09:40:30.75','Casterly Rock','Heisenberg Co','100ml','interval 12h -2xday- 2days');
insert into prescription values('blk','Croockshanks', 239570075,'2016-7-27 10:00:30.75','The Wall','Heisenberg Co','100ml', 'interval 8h -3xday- 7days');
insert into prescription values('r','Lucky', 583057692, '2017-11-27 18:30:30.75','Dragonstone','Potion Lab Lda.','100ml', 'interval 8h -3xday- 7days');

insert into indicator values('temperature','38','celcius','Higher than reference value, fever.');
insert into indicator values('red blood cells', '300', 'cells/L', 'Higher limit');
insert into indicator values('glucose', '130', 'mg', 'Ideal value.');
insert into indicator values('protein', '90', 'mg', 'Ideal value.');
insert into indicator values('hemoglobine', '200', 'mg', 'Ideal value.');
insert into indicator values('creatinine', '1','mg/mol', 'Ideal value.');

insert into procedures values('Buckbeack', 294750283,'2018-7-27 09:00:30.75', 1, 'Fell while flying broke beack');
insert into procedures values('Vitoria', 120958001,'2016-7-28 09:00:30.75', 2, 'Cirurgical intrevention');
insert into procedures values('Vitoria', 120958001,'2016-7-28 09:00:30.75', 7, 'Blood work to test kidney failure');
insert into procedures values('Scooby', 103957320, '2017-5-27 10:00:30.75', 3, 'Radiography to confirm arthritis');
insert into procedures values('Brian', 439502753, '2017-7-27 09:45:30.75', 4, 'Ran over by car.');
insert into procedures values('Garfield', 292839283,'2017-7-27 09:40:30.75', 5, 'Food poisoning, too much lasagna. Stomach clense');
insert into procedures values('Croockshanks', 239570075,'2016-7-27 10:00:30.75', 6, 'Fight with cat, blood samples');
insert into procedures values('Croockshanks', 239570075,'2016-7-27 10:00:30.75', 7, 'Blood work to test kidney failure');
insert into procedures values('Lucky', 583057692, '2017-11-27 18:30:30.75', 8, 'Fell head first');

insert into performed values('Buckbeack', 294750283,'2018-7-27 09:00:30.75', 1, 103957320);
insert into performed values('Vitoria', 120958001,'2016-7-28 09:00:30.75', 2, 439502753);
insert into performed values('Vitoria', 120958001,'2016-7-28 09:00:30.75', 7, 439502753);
insert into performed values('Scooby', 103957320, '2017-5-27 10:00:30.75', 3, 439502753);
insert into performed values('Brian', 439502753, '2017-7-27 09:45:30.75', 4, 103957320);
insert into performed values('Garfield', 292839283,'2017-7-27 09:40:30.75', 5, 103957320);
insert into performed values('Croockshanks', 239570075, '2016-7-27 10:00:30.75', 6, 439502753);
insert into performed values('Croockshanks', 239570075, '2016-7-27 10:00:30.75', 7, 439502753);
insert into performed values('Lucky', 583057692, '2017-11-27 18:30:30.75', 8, 439502753);

insert into radiography values('Buckbeack', 294750283,'2018-7-27 09:00:30.75', 1, 'home/radiographys/hippogriff');
insert into radiography values('Scooby', 103957320, '2017-5-27 10:00:30.75', 3, 'home/radiographys/scoobs');
insert into radiography values('Brian', 439502753, '2017-7-27 09:45:30.75', 4, 'home/radiographys/brian');
insert into radiography values('Lucky', 583057692, '2017-11-27 18:30:30.75', 8, 'home/radiographys/lucky');

insert into test_procedures values('Vitoria', 120958001,'2016-7-28 09:00:30.75', 2, 'urine');
insert into test_procedures values('Vitoria', 120958001,'2016-7-28 09:00:30.75', 7, 'blood');
insert into test_procedures values('Garfield', 292839283,'2017-7-27 09:40:30.75', 5, 'blood');
insert into test_procedures values('Croockshanks', 239570075, '2016-7-27 10:00:30.75', 6,'blood');
insert into test_procedures values('Croockshanks', 239570075, '2016-7-27 10:00:30.75', 7,'blood');

insert into produced_indicator values('Vitoria', 120958001,'2016-7-28 09:00:30.75', 2, 'protein', 30);
insert into produced_indicator values('Vitoria', 120958001,'2016-7-28 09:00:30.75', 7, 'creatinine', 1.50);
insert into produced_indicator values('Garfield', 292839283, '2017-7-27 09:40:30.75', 5, 'hemoglobine', 250.00);
insert into produced_indicator values('Croockshanks', 239570075, '2016-7-27 10:00:30.75', 6, 'hemoglobine', 210.00);
insert into produced_indicator values('Croockshanks', 239570075, '2016-7-27 10:00:30.75', 7, 'creatinine', 0.90);

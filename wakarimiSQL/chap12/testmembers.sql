create table testmembers (
  id serial primary key
  , name text not null
, height integer not null
, gender char(1) not null
);

insert into testmembers(name, height, gender)
select 'メンバー#' || x.n
  , 160 + floor(random() * 20)::integer
  , case when x.n % 2 = 0 then 'M' else 'F' end
   from generate_series(1, 1000000) x(n);
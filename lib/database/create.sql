create table if not exists ia_representatives (
  id serial primary key,
  name varchar,
  crd int unique,
  last_updated date,
  current_employers varchar,
  current_qualifications json,
  registration_history json,
  disclosure_information json,
  broker_dealer_information varchar
);

create table if not exists brokers (
  id serial primary key,
  crd int unique,
  is_licensed boolean,
  disclosures json,
  years_in_securities_industry int,
  passed_exams json,
  current_registrations json,
  past_registrations json,
  alternate_names json
);

create table if not exists ia_firms (
  id serial primary key,
  name varchar,
  crd int unique,
  jurisdictions json,
  notice_filings json,
  exempt_reporting_advisers json
);

create table if not exists broker_firms (
  id serial primary key,
  name varchar,
  crd int unique,
  sec json,
  business_types json,
  disclosures json,
  firm_details json
);
--Create temperatures table
begin;
create table temperatures (rDatetime datetime, sensorID text, temp numeric);
--insert into temperatures values (datetime(CURRENT_TIMESTAMP),"1",25);
--insert into temperatures values (datetime(CURRENT_TIMESTAMP),"1",25.10);
commit;

--Create humidities table
begin;
create table humidities (rDatetime datetime, sensorID text, hum numeric);
--insert into humidities values (datetime(CURRENT_TIMESTAMP),"1",51);
--insert into humidities values (datetime(CURRENT_TIMESTAMP),"1",51.10);
commit;
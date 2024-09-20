SET SQL_SAFE_UPDATES = 0;
UPDATE hot100 SET Duration = SEC_TO_TIME(Duration /1000);

SELECT * from hot100;

ALTER TABLE hot100
RENAME COLUMN ï»¿Track TO Track;

SELECT sec_to_time(Duration/1000) as tempo_novo from hot100;

ALTER TABLE hot100
ADD COLUMN Duration_t time;

insert into hot100 (Duration_t)
Values (SEC_TO_TIME(Duration/1000));

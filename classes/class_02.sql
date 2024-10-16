DROP DATABASE IF EXISTS CL2;
CREATE DATABASE CL2;
USE CL2;

DROP TABLE IF EXISTS film,actor,film_actor;

CREATE TABLE film(
	film_id int NOT NULL auto_increment,
    descrip varchar(500),
    release_year date,
    constraint film_pk
    primary key(film_id)
);
CREATE TABLE actor(
	actor_id int NOT NULL auto_increment,
    first_name varchar(20),
    last_name varchar(20),
    constraint actor_pk
    primary key(actor_id)
);
CREATE TABLE film_actor(
	actor_id int not null,
    film_id int not null,
    constraint filmActor_pk
    primary key(actor_id,film_id)
);

ALTER TABLE film
ADD last_update datetime;
ALTER TABLE actor
ADD last_update datetime;

ALTER TABLE film_actor
ADD CONSTRAINT filmActor_film_fk
FOREIGN KEY(film_id) REFERENCES film(film_id);

ALTER TABLE film_actor
ADD CONSTRAINT filmActor_actor_fk
FOREIGN KEY(actor_id) REFERENCES actor(actor_id);
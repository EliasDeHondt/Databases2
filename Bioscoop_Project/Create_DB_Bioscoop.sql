-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 1.0.5
-- PostgreSQL version: 15.0
-- Project Site: pgmodeler.io
-- Model Author: ---
-- -- object: pg_database_owner | type: ROLE --
-- -- DROP ROLE IF EXISTS pg_database_owner;
-- CREATE ROLE pg_database_owner WITH 
-- 	INHERIT
-- 	 PASSWORD '********';
-- -- ddl-end --
-- 

-- Database creation must be performed outside a multi lined SQL file. 
-- These commands were put in this file only as a convenience.
-- 
-- object: "Bioscoop" | type: DATABASE --
-- DROP DATABASE IF EXISTS "Bioscoop";
CREATE DATABASE "Bioscoop"
	ENCODING = 'UTF8'
	LC_COLLATE = 'Dutch_Belgium.1252'
	LC_CTYPE = 'Dutch_Belgium.1252'
	TABLESPACE = pg_default
	OWNER = postgres;
-- ddl-end --


-- object: public.cinema_complex | type: TABLE --
-- DROP TABLE IF EXISTS public.cinema_complex CASCADE;
CREATE TABLE public.cinema_complex (
	complexid numeric(2) NOT NULL,
	name varchar(25),
	house_nr numeric(3),
	zip_code numeric(4),
	street_name varchar(25),
	ticket_sales_points numeric(2),
	CONSTRAINT cinema_complexes_pk PRIMARY KEY (complexid)
)
PARTITION BY LIST (complexid);
-- ddl-end --
ALTER TABLE public.cinema_complex OWNER TO postgres;
-- ddl-end --

-- object: complexid_index | type: INDEX --
-- DROP INDEX IF EXISTS public.complexid_index CASCADE;
CREATE INDEX complexid_index ON public.cinema_complex
USING btree
(
	complexid
);
-- ddl-end --

-- object: public.hall | type: TABLE --
-- DROP TABLE IF EXISTS public.hall CASCADE;
CREATE TABLE public.hall (
	hallid numeric(2) NOT NULL,
	complexid numeric(2),
	capacity numeric(4),
	characteristics varchar(25),
	CONSTRAINT halls_pk PRIMARY KEY (hallid)
)
PARTITION BY LIST (hallid);
-- ddl-end --
ALTER TABLE public.hall OWNER TO postgres;
-- ddl-end --

-- object: hallid_index | type: INDEX --
-- DROP INDEX IF EXISTS public.hallid_index CASCADE;
CREATE INDEX hallid_index ON public.hall
USING btree
(
	hallid
);
-- ddl-end --

-- object: public.type | type: TYPE --
-- DROP TYPE IF EXISTS public.type CASCADE;
CREATE TYPE public.type AS
ENUM ('3d','dutch_translation','dutch_subtitles','uhd');
-- ddl-end --
ALTER TYPE public.type OWNER TO postgres;
-- ddl-end --

-- object: public.version | type: TABLE --
-- DROP TABLE IF EXISTS public.version CASCADE;
CREATE TABLE public.version (
	versionid numeric(4) NOT NULL,
	movieid numeric(10),
	rateid numeric(2),
	type public.type,
	surcharge numeric(8),
	CONSTRAINT versions_pk PRIMARY KEY (versionid)
)
PARTITION BY LIST (versionid);
-- ddl-end --
ALTER TABLE public.version OWNER TO postgres;
-- ddl-end --

-- object: public.scheduling | type: TABLE --
-- DROP TABLE IF EXISTS public.scheduling CASCADE;
CREATE TABLE public.scheduling (
	schedulingid numeric(10) NOT NULL,
	complexid numeric(2),
	movieid numeric(10),
	date date,
	"time" time,
	CONSTRAINT scheduling_pk PRIMARY KEY (schedulingid)
)
PARTITION BY LIST (schedulingid);
-- ddl-end --
ALTER TABLE public.scheduling OWNER TO postgres;
-- ddl-end --

-- object: schedulingid | type: INDEX --
-- DROP INDEX IF EXISTS public.schedulingid CASCADE;
CREATE INDEX schedulingid ON public.scheduling
USING btree
(
	schedulingid
);
-- ddl-end --

-- object: public.customer | type: TABLE --
-- DROP TABLE IF EXISTS public.customer CASCADE;
CREATE TABLE public.customer (
	customerid numeric(10) NOT NULL,
	first_name varchar(25),
	last_name varchar(25),
	email varchar(25),
	username varchar(25),
	password varchar(25),
	CONSTRAINT customers_pk PRIMARY KEY (customerid)
)
PARTITION BY LIST (customerid);
-- ddl-end --
ALTER TABLE public.customer OWNER TO postgres;
-- ddl-end --

-- object: customerid_index | type: INDEX --
-- DROP INDEX IF EXISTS public.customerid_index CASCADE;
CREATE INDEX customerid_index ON public.customer
USING btree
(
	customerid
);
-- ddl-end --

-- object: public.payment_method | type: TYPE --
-- DROP TYPE IF EXISTS public.payment_method CASCADE;
CREATE TYPE public.payment_method AS
ENUM ('maestro','mastercard','visa','cash');
-- ddl-end --
ALTER TYPE public.payment_method OWNER TO postgres;
-- ddl-end --

-- object: public.ticket_reservation | type: TABLE --
-- DROP TABLE IF EXISTS public.ticket_reservation CASCADE;
CREATE TABLE public.ticket_reservation (
	reservationid numeric(10) NOT NULL,
	customerid numeric(10),
	schedulingid numeric(10),
	confirmation_email_sent boolean,
	payment_method public.payment_method,
	price numeric(5,2),
	CONSTRAINT ticket_reservations_pk PRIMARY KEY (reservationid)
)
PARTITION BY LIST (reservationid);
-- ddl-end --
ALTER TABLE public.ticket_reservation OWNER TO postgres;
-- ddl-end --

-- object: public.seat_zone | type: TYPE --
-- DROP TYPE IF EXISTS public.seat_zone CASCADE;
CREATE TYPE public.seat_zone AS
ENUM ('normal_zone','cosyseat_zone','wheelchair_zone');
-- ddl-end --
ALTER TYPE public.seat_zone OWNER TO postgres;
-- ddl-end --

-- object: public.seat_reservation | type: TABLE --
-- DROP TABLE IF EXISTS public.seat_reservation CASCADE;
CREATE TABLE public.seat_reservation (
	seat_reservationid numeric(5) NOT NULL,
	reservationid numeric(10),
	price numeric(5,2),
	seat_zone public.seat_zone,
	CONSTRAINT seat_reservations_pk PRIMARY KEY (seat_reservationid)
)
PARTITION BY LIST (seat_reservationid);
-- ddl-end --
ALTER TABLE public.seat_reservation OWNER TO postgres;
-- ddl-end --

-- object: public.ticket | type: TABLE --
-- DROP TABLE IF EXISTS public.ticket CASCADE;
CREATE TABLE public.ticket (
	ticketid numeric(10) NOT NULL,
	reservationid numeric(10),
	barcode numeric(15),
	CONSTRAINT tickets_pk PRIMARY KEY (ticketid)
)
PARTITION BY LIST (ticketid);
-- ddl-end --
ALTER TABLE public.ticket OWNER TO postgres;
-- ddl-end --

-- object: ticketid_index | type: INDEX --
-- DROP INDEX IF EXISTS public.ticketid_index CASCADE;
CREATE INDEX ticketid_index ON public.ticket
USING btree
(
	ticketid
);
-- ddl-end --

-- object: versionid_index | type: INDEX --
-- DROP INDEX IF EXISTS public.versionid_index CASCADE;
CREATE INDEX versionid_index ON public.version
USING btree
(
	versionid
);
-- ddl-end --

-- object: reservationid_index | type: INDEX --
-- DROP INDEX IF EXISTS public.reservationid_index CASCADE;
CREATE INDEX reservationid_index ON public.ticket_reservation
USING btree
(
	reservationid
);
-- ddl-end --

-- object: seatreservationid_index | type: INDEX --
-- DROP INDEX IF EXISTS public.seatreservationid_index CASCADE;
CREATE INDEX seatreservationid_index ON public.seat_reservation
USING btree
(
	seat_reservationid
);
-- ddl-end --

-- object: public.customer_type | type: TYPE --
-- DROP TYPE IF EXISTS public.customer_type CASCADE;
CREATE TYPE public.customer_type AS
ENUM ('students','retirees','disabled');
-- ddl-end --
ALTER TYPE public.customer_type OWNER TO postgres;
-- ddl-end --

-- object: public.movie_genre | type: TYPE --
-- DROP TYPE IF EXISTS public.movie_genre CASCADE;
CREATE TYPE public.movie_genre AS
ENUM ('romantisch','actiefilm','science_fiction','drama','comedy','thriller','fantasy','horror','adventure','mystery','animation','musical','crime','historical','documentary','western','war','superhero','family','suspense','fantasy-adventure');
-- ddl-end --
ALTER TYPE public.movie_genre OWNER TO postgres;
-- ddl-end --

-- object: public.movie | type: TABLE --
-- DROP TABLE IF EXISTS public.movie CASCADE;
CREATE TABLE public.movie (
	"movieIid" numeric(10) NOT NULL,
	"pre-rollid" numeric(3),
	cast_or_directorid numeric(8),
	title varchar(25),
	genre public.movie_genre,
	duration time(2),
	children_allowed boolean,
	movie_company varchar(25),
	country_of_origin varchar(25),
	oscar_best_actor boolean,
	oscar_best_music boolean,
	oscar_best_director boolean,
	archive boolean,
	CONSTRAINT movies_pk PRIMARY KEY ("movieIid")
)
PARTITION BY LIST ("movieIid");
-- ddl-end --
ALTER TABLE public.movie OWNER TO postgres;
-- ddl-end --

-- object: public.reduced_rate | type: TABLE --
-- DROP TABLE IF EXISTS public.reduced_rate CASCADE;
CREATE TABLE public.reduced_rate (
	rateid numeric(2) NOT NULL,
	discount_percentage numeric(5,2),
	customer_type public.customer_type,
	CONSTRAINT rateid_pk PRIMARY KEY (rateid)
)
PARTITION BY LIST (rateid);
-- ddl-end --
ALTER TABLE public.reduced_rate OWNER TO postgres;
-- ddl-end --

-- object: rateid_index | type: INDEX --
-- DROP INDEX IF EXISTS public.rateid_index CASCADE;
CREATE INDEX rateid_index ON public.reduced_rate
USING btree
(
	rateid
);
-- ddl-end --

-- object: movieid_index | type: INDEX --
-- DROP INDEX IF EXISTS public.movieid_index CASCADE;
CREATE INDEX movieid_index ON public.movie
USING btree
(
	"movieIid"
);
-- ddl-end --

-- object: public."pre-roll" | type: TABLE --
-- DROP TABLE IF EXISTS public."pre-roll" CASCADE;
CREATE TABLE public."pre-roll" (
	"pre-rollid" numeric(3) NOT NULL,
	trailer varchar(25),
	description varchar(50),
	CONSTRAINT "pre-roll_pk" PRIMARY KEY ("pre-rollid")
)
PARTITION BY LIST ("pre-rollid");
-- ddl-end --
ALTER TABLE public."pre-roll" OWNER TO postgres;
-- ddl-end --

-- object: "pre-rollid_index" | type: INDEX --
-- DROP INDEX IF EXISTS public."pre-rollid_index" CASCADE;
CREATE INDEX "pre-rollid_index" ON public."pre-roll"
USING btree
(
	"pre-rollid"
);
-- ddl-end --

-- object: public."cast" | type: TABLE --
-- DROP TABLE IF EXISTS public."cast" CASCADE;
CREATE TABLE public."cast" (
	castid numeric(8) NOT NULL,
	first_name varchar(25),
	last_name varchar(25),
	role varchar(25),
	CONSTRAINT cast_pk PRIMARY KEY (castid)
);
-- ddl-end --
ALTER TABLE public."cast" OWNER TO postgres;
-- ddl-end --

-- object: castid_index | type: INDEX --
-- DROP INDEX IF EXISTS public.castid_index CASCADE;
CREATE INDEX castid_index ON public."cast"
USING btree
(
	castid
);
-- ddl-end --

-- object: public.director | type: TABLE --
-- DROP TABLE IF EXISTS public.director CASCADE;
CREATE TABLE public.director (
	directorid numeric(8) NOT NULL,
	first_name varchar(25),
	last_name varchar(25),
	function varchar(25),
	CONSTRAINT "director_PK" PRIMARY KEY (directorid)
);
-- ddl-end --
ALTER TABLE public.director OWNER TO postgres;
-- ddl-end --

-- object: directorid_index | type: INDEX --
-- DROP INDEX IF EXISTS public.directorid_index CASCADE;
CREATE INDEX directorid_index ON public.director
USING btree
(
	directorid
);
-- ddl-end --

-- object: public.cast_or_director | type: TABLE --
-- DROP TABLE IF EXISTS public.cast_or_director CASCADE;
CREATE TABLE public.cast_or_director (
	cast_or_directorid numeric(8) NOT NULL,
	directorid numeric(8),
	castid numeric(8),
	CONSTRAINT cast_or_director_pk PRIMARY KEY (cast_or_directorid)
);
-- ddl-end --
ALTER TABLE public.cast_or_director OWNER TO postgres;
-- ddl-end --

-- object: cast_or_directorid_index | type: INDEX --
-- DROP INDEX IF EXISTS public.cast_or_directorid_index CASCADE;
CREATE INDEX cast_or_directorid_index ON public.cast_or_director
USING btree
(
	cast_or_directorid
);
-- ddl-end --

-- object: public.programming_managers_view | type: VIEW --
-- DROP VIEW IF EXISTS public.programming_managers_view CASCADE;
CREATE VIEW public.programming_managers_view
AS 

SELECT
   public.scheduling.*
FROM
   public.scheduling
WHERE;
-- ddl-end --
ALTER VIEW public.programming_managers_view OWNER TO postgres;
-- ddl-end --

-- object: public.webapplication_mobileapp_view | type: VIEW --
-- DROP VIEW IF EXISTS public.webapplication_mobileapp_view CASCADE;
CREATE VIEW public.webapplication_mobileapp_view
AS 

SELECT
   public.ticket_reservation.payment_method,
   public.ticket_reservation.price,
   public.ticket.barcode,
   public.seat_reservation.seat_zone,
   public.scheduling.date,
   public.scheduling."time",
   public.customer.email,
   public.customer.first_name,
   public.customer.last_name,
   public.customer.password,
   public.customer.username
FROM
   public.ticket_reservation,
   public.ticket_reservation,
   public.ticket,
   public.seat_reservation,
   public.scheduling,
   public.scheduling,
   public.customer,
   public.customer,
   public.customer,
   public.customer,
   public.customer
WHERE
   public.ticket_reservation.payment_method   public.ticket_reservation.price   public.ticket.barcode   public.seat_reservation.seat_zone   public.scheduling.date   public.scheduling."time"   public.customer.email   public.customer.first_name   public.customer.last_name   public.customer.password   public.customer.username
   public.ticket_reservation.payment_method   public.ticket_reservation.price   public.ticket.barcode   public.seat_reservation.seat_zone   public.scheduling.date   public.scheduling."time"   public.customer.email   public.customer.first_name   public.customer.last_name   public.customer.password   public.customer.username;
-- ddl-end --
ALTER VIEW public.webapplication_mobileapp_view OWNER TO postgres;
-- ddl-end --

-- object: public.sales_terminal_cp | type: VIEW --
-- DROP VIEW IF EXISTS public.sales_terminal_cp CASCADE;
CREATE VIEW public.sales_terminal_cp
AS 

SELECT
   public.ticket_reservation.payment_method,
   public.ticket_reservation.price,
   public.ticket.barcode,
   public.seat_reservation.seat_zone,
   public.scheduling.date,
   public.scheduling."time"
FROM
   public.ticket_reservation,
   public.ticket_reservation,
   public.ticket,
   public.seat_reservation,
   public.scheduling,
   public.scheduling
WHERE
   public.ticket_reservation.payment_method   public.ticket_reservation.price   public.ticket.barcode   public.seat_reservation.seat_zone   public.scheduling.date   public.scheduling."time"
   public.ticket_reservation.payment_method   public.ticket_reservation.price   public.ticket.barcode   public.seat_reservation.seat_zone   public.scheduling.date   public.scheduling."time";
-- ddl-end --
ALTER VIEW public.sales_terminal_cp OWNER TO postgres;
-- ddl-end --

-- object: public.hall_attendant_view | type: VIEW --
-- DROP VIEW IF EXISTS public.hall_attendant_view CASCADE;
CREATE VIEW public.hall_attendant_view
AS 

SELECT
   public.ticket.barcode
FROM
   public.ticket
WHERE
   public.ticket.barcode
   public.ticket.barcode;
-- ddl-end --
ALTER VIEW public.hall_attendant_view OWNER TO postgres;
-- ddl-end --

-- object: public.content_managers_view | type: VIEW --
-- DROP VIEW IF EXISTS public.content_managers_view CASCADE;
CREATE VIEW public.content_managers_view
AS 

SELECT
   public."pre-roll".*
FROM
   public."pre-roll"
WHERE;
-- ddl-end --
ALTER VIEW public.content_managers_view OWNER TO postgres;
-- ddl-end --

-- object: cinema_complexes_fk | type: CONSTRAINT --
-- ALTER TABLE public.hall DROP CONSTRAINT IF EXISTS cinema_complexes_fk CASCADE;
ALTER TABLE public.hall ADD CONSTRAINT cinema_complexes_fk FOREIGN KEY (complexid)
REFERENCES public.cinema_complex (complexid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: movieid_fk | type: CONSTRAINT --
-- ALTER TABLE public.version DROP CONSTRAINT IF EXISTS movieid_fk CASCADE;
ALTER TABLE public.version ADD CONSTRAINT movieid_fk FOREIGN KEY (movieid)
REFERENCES public.movie ("movieIid") MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: rateid | type: CONSTRAINT --
-- ALTER TABLE public.version DROP CONSTRAINT IF EXISTS rateid CASCADE;
ALTER TABLE public.version ADD CONSTRAINT rateid FOREIGN KEY (rateid)
REFERENCES public.reduced_rate (rateid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: cinema_complexes_fk | type: CONSTRAINT --
-- ALTER TABLE public.scheduling DROP CONSTRAINT IF EXISTS cinema_complexes_fk CASCADE;
ALTER TABLE public.scheduling ADD CONSTRAINT cinema_complexes_fk FOREIGN KEY (complexid)
REFERENCES public.cinema_complex (complexid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: movies_fk | type: CONSTRAINT --
-- ALTER TABLE public.scheduling DROP CONSTRAINT IF EXISTS movies_fk CASCADE;
ALTER TABLE public.scheduling ADD CONSTRAINT movies_fk FOREIGN KEY (movieid)
REFERENCES public.movie ("movieIid") MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: customers_fk | type: CONSTRAINT --
-- ALTER TABLE public.ticket_reservation DROP CONSTRAINT IF EXISTS customers_fk CASCADE;
ALTER TABLE public.ticket_reservation ADD CONSTRAINT customers_fk FOREIGN KEY (customerid)
REFERENCES public.customer (customerid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: scheduling_fk | type: CONSTRAINT --
-- ALTER TABLE public.ticket_reservation DROP CONSTRAINT IF EXISTS scheduling_fk CASCADE;
ALTER TABLE public.ticket_reservation ADD CONSTRAINT scheduling_fk FOREIGN KEY (schedulingid)
REFERENCES public.scheduling (schedulingid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: ticket_reservations_fk | type: CONSTRAINT --
-- ALTER TABLE public.seat_reservation DROP CONSTRAINT IF EXISTS ticket_reservations_fk CASCADE;
ALTER TABLE public.seat_reservation ADD CONSTRAINT ticket_reservations_fk FOREIGN KEY (reservationid)
REFERENCES public.ticket_reservation (reservationid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: ticket_reservations_fk | type: CONSTRAINT --
-- ALTER TABLE public.ticket DROP CONSTRAINT IF EXISTS ticket_reservations_fk CASCADE;
ALTER TABLE public.ticket ADD CONSTRAINT ticket_reservations_fk FOREIGN KEY (reservationid)
REFERENCES public.ticket_reservation (reservationid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: "pre-rollid_fk" | type: CONSTRAINT --
-- ALTER TABLE public.movie DROP CONSTRAINT IF EXISTS "pre-rollid_fk" CASCADE;
ALTER TABLE public.movie ADD CONSTRAINT "pre-rollid_fk" FOREIGN KEY ("pre-rollid")
REFERENCES public."pre-roll" ("pre-rollid") MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: cast_or_director_fk | type: CONSTRAINT --
-- ALTER TABLE public.movie DROP CONSTRAINT IF EXISTS cast_or_director_fk CASCADE;
ALTER TABLE public.movie ADD CONSTRAINT cast_or_director_fk FOREIGN KEY (cast_or_directorid)
REFERENCES public.cast_or_director (cast_or_directorid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: director_fk | type: CONSTRAINT --
-- ALTER TABLE public.cast_or_director DROP CONSTRAINT IF EXISTS director_fk CASCADE;
ALTER TABLE public.cast_or_director ADD CONSTRAINT director_fk FOREIGN KEY (directorid)
REFERENCES public.director (directorid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: cast_fk | type: CONSTRAINT --
-- ALTER TABLE public.cast_or_director DROP CONSTRAINT IF EXISTS cast_fk CASCADE;
ALTER TABLE public.cast_or_director ADD CONSTRAINT cast_fk FOREIGN KEY (castid)
REFERENCES public."cast" (castid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: "grant_CU_26541e8cda" | type: PERMISSION --
GRANT CREATE,USAGE
   ON SCHEMA public
   TO pg_database_owner;
-- ddl-end --

-- object: "grant_U_cd8e46e7b6" | type: PERMISSION --
GRANT USAGE
   ON SCHEMA public
   TO PUBLIC;
-- ddl-end --



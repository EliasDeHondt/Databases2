/***************************************
 *                                     *
 *   Created by Elias & Kobe           *
 *   Visit https://eliasdh.com         *
 *                                     *
 ***************************************/


-- **************************************** --
-- DROP Tables                              --
-- **************************************** --
DROP TABLE IF EXISTS public.cinema_complex CASCADE;                 -- Table: cinema_complex
DROP TABLE IF EXISTS public.hall CASCADE;                           -- Table: hall
DROP TABLE IF EXISTS public.version CASCADE;                        -- Table: version
DROP TABLE IF EXISTS public.scheduling CASCADE;                     -- Table: scheduling
DROP TABLE IF EXISTS public.customer CASCADE;                       -- Table: customer
DROP TABLE IF EXISTS public.ticket_reservation CASCADE;             -- Table: ticket_reservation
DROP TABLE IF EXISTS public.seat_reservation CASCADE;               -- Table: seat_reservation
DROP TABLE IF EXISTS public.ticket CASCADE;                         -- Table: ticket
DROP TABLE IF EXISTS public.movie CASCADE;                          -- Table: movie
DROP TABLE IF EXISTS public.reduced_rate CASCADE;                   -- Table: reduced_rate
DROP TABLE IF EXISTS public."pre-roll" CASCADE;                     -- Table: pre-roll
DROP TABLE IF EXISTS public."cast" CASCADE;                         -- Table: cast
DROP TABLE IF EXISTS public.director CASCADE;                       -- Table: director
DROP TABLE IF EXISTS public.cast_or_director CASCADE;               -- Table: cast_or_director

-- **************************************** --
-- DROP View                                --
-- **************************************** --
DROP VIEW IF EXISTS public.programming_managers_view CASCADE;       -- View: programming_managers_view
DROP VIEW IF EXISTS public.webapplication_mobileapp_view CASCADE;   -- View: webapplication_mobileapp_view
DROP VIEW IF EXISTS public.sales_terminal_cp CASCADE;               -- View: sales_terminal_cp
DROP VIEW IF EXISTS public.hall_attendant_view CASCADE;             -- View: hall_attendant_view
DROP VIEW IF EXISTS public.content_managers_view CASCADE;           -- View: content_managers_view

-- **************************************** --
-- DROP Type                                --
-- **************************************** --
DROP TYPE IF EXISTS public.type CASCADE;                            -- Type: type
DROP TYPE IF EXISTS public.payment_method CASCADE;                  -- Type: payment_method
DROP TYPE IF EXISTS public.seat_zone CASCADE;                       -- Type: seat_zone
DROP TYPE IF EXISTS public.customer_type CASCADE;                   -- Type: customer_type
DROP TYPE IF EXISTS public.movie_genre CASCADE;                     -- Type: movie_genre

-- **************************************** --
-- CREATE Tables                            --
-- **************************************** --
CREATE TABLE public.cinema_complex (
	complexid numeric(2) NOT NULL,
	name varchar(25),
	house_nr numeric(3),
	zip_code numeric(4),
	street_name varchar(25),
	ticket_sales_points numeric(2),
	CONSTRAINT cinema_complexes_pk PRIMARY KEY (complexid)
);

CREATE INDEX complexid_index ON public.cinema_complex
USING btree ( complexid );

CREATE TABLE public.hall (
	hallid numeric(2) NOT NULL,
	complexid numeric(2),
	capacity numeric(4),
	characteristics varchar(25),
	CONSTRAINT halls_pk PRIMARY KEY (hallid)
);

CREATE INDEX hallid_index ON public.hall
USING btree ( hallid );

CREATE TYPE public.type AS ENUM ('3d','dutch_translation','dutch_subtitles','uhd');

CREATE TABLE public.version (
	versionid numeric(4) NOT NULL,
	movieid numeric(10),
	rateid numeric(2),
	type public.type,
	surcharge numeric(8),
	CONSTRAINT versions_pk PRIMARY KEY (versionid)
);

CREATE TABLE public.scheduling (
	schedulingid numeric(10) NOT NULL,
	complexid numeric(2),
	movieid numeric(10),
	date date,
	"time" time,
	CONSTRAINT scheduling_pk PRIMARY KEY (schedulingid)
);

CREATE INDEX schedulingid ON public.scheduling
USING btree ( schedulingid );

CREATE TABLE public.customer (
	customerid numeric(10) NOT NULL,
	first_name varchar(50),
	last_name varchar(50),
	email varchar(50),
	username varchar(50),
	password varchar(50),
	CONSTRAINT customers_pk PRIMARY KEY (customerid)
);

CREATE INDEX customerid_index ON public.customer
USING btree ( customerid );

CREATE TYPE public.payment_method AS ENUM ('maestro','mastercard','visa','cash');

CREATE TABLE public.ticket_reservation (
	reservationid numeric(10) NOT NULL,
	customerid numeric(10),
	schedulingid numeric(10),
	confirmation_email_sent boolean,
	payment_method public.payment_method,
	price numeric(5,2) CHECK ( price > 0 ),
	CONSTRAINT ticket_reservations_pk PRIMARY KEY (reservationid)
);

CREATE TYPE public.seat_zone AS ENUM ('normal_zone','cosyseat_zone','wheelchair_zone');

CREATE TABLE public.seat_reservation (
	seat_reservationid numeric(5) NOT NULL,
	reservationid numeric(10),
    price numeric(5,2) CHECK ( price > 0 ),
	seat_zone public.seat_zone,
	CONSTRAINT seat_reservations_pk PRIMARY KEY (seat_reservationid)
);

CREATE TABLE public.ticket (
	ticketid numeric(10) NOT NULL,
	reservationid numeric(10),
	barcode numeric(15),
	CONSTRAINT tickets_pk PRIMARY KEY (ticketid)
);

CREATE INDEX ticketid_index ON public.ticket
USING btree ( ticketid );

CREATE INDEX versionid_index ON public.version
USING btree ( versionid );

CREATE INDEX reservationid_index ON public.ticket_reservation
USING btree ( reservationid );

CREATE INDEX seatreservationid_index ON public.seat_reservation
USING btree ( seat_reservationid );

CREATE TYPE public.customer_type AS ENUM ('students','retirees','disabled');

CREATE TYPE public.movie_genre AS ENUM ('romantisch','actiefilm','science_fiction','drama','comedy','thriller','fantasy');

CREATE TABLE public.movie (
	"movieId" numeric(10) NOT NULL,
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
	CONSTRAINT movies_pk PRIMARY KEY ("movieId")
);

CREATE TABLE public.reduced_rate (
	rateid numeric(2) NOT NULL,
	discount_percentage numeric(5,2),
	customer_type public.customer_type,
	CONSTRAINT rateid_pk PRIMARY KEY (rateid)
);

CREATE INDEX rateid_index ON public.reduced_rate
USING btree ( rateid );

CREATE INDEX movieid_index ON public.movie
USING btree ( "movieId" );

CREATE TABLE public."pre-roll" (
	"pre-rollid" numeric(3) NOT NULL,
	trailer varchar(25),
	description varchar(50),
	CONSTRAINT "pre-roll_pk" PRIMARY KEY ("pre-rollid")
);

CREATE INDEX "pre-rollid_index" ON public."pre-roll"
USING btree ( "pre-rollid" );

CREATE TABLE public."cast" (
	castid numeric(8) NOT NULL,
	first_name varchar(25),
	last_name varchar(25),
	role varchar(25),
	CONSTRAINT cast_pk PRIMARY KEY (castid)
);

CREATE INDEX castid_index ON public."cast"
USING btree ( castid );

CREATE TABLE public.director (
	directorid numeric(8) NOT NULL,
	first_name varchar(25),
	last_name varchar(25),
	function varchar(25),
	CONSTRAINT "director_PK" PRIMARY KEY (directorid)
);

CREATE INDEX directorid_index ON public.director
USING btree ( directorid );

CREATE TABLE public.cast_or_director (
	cast_or_directorid numeric(8) NOT NULL,
	directorid numeric(8),
	castid numeric(8),
	CONSTRAINT cast_or_director_pk PRIMARY KEY (cast_or_directorid)
);

CREATE INDEX cast_or_directorid_index ON public.cast_or_director
USING btree ( cast_or_directorid );

-- **************************************** --
-- CREATE View                              --
-- **************************************** --
CREATE VIEW public.programming_managers_view AS SELECT public.scheduling.* FROM public.scheduling;

CREATE VIEW public.webapplication_mobileapp_view AS SELECT
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
   public.customer;

CREATE VIEW public.sales_terminal_cp AS SELECT
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
   public.scheduling;

CREATE VIEW public.hall_attendant_view AS SELECT public.ticket.barcode FROM public.ticket;

CREATE VIEW public.content_managers_view AS SELECT public."pre-roll".* FROM public."pre-roll";


-- **************************************** --
-- CREATE Constraint                        --
-- **************************************** --
ALTER TABLE public.hall ADD CONSTRAINT cinema_complexes_fk FOREIGN KEY (complexid)
REFERENCES public.cinema_complex (complexid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.version ADD CONSTRAINT movieid_fk FOREIGN KEY (movieid)
REFERENCES public.movie ("movieId") MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.version ADD CONSTRAINT rateid FOREIGN KEY (rateid)
REFERENCES public.reduced_rate (rateid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.scheduling ADD CONSTRAINT cinema_complexes_fk FOREIGN KEY (complexid)
REFERENCES public.cinema_complex (complexid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.scheduling ADD CONSTRAINT movies_fk FOREIGN KEY (movieid)
REFERENCES public.movie ("movieId") MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.ticket_reservation ADD CONSTRAINT customers_fk FOREIGN KEY (customerid)
REFERENCES public.customer (customerid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.ticket_reservation ADD CONSTRAINT scheduling_fk FOREIGN KEY (schedulingid)
REFERENCES public.scheduling (schedulingid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.seat_reservation ADD CONSTRAINT ticket_reservations_fk FOREIGN KEY (reservationid)
REFERENCES public.ticket_reservation (reservationid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.ticket ADD CONSTRAINT ticket_reservations_fk FOREIGN KEY (reservationid)
REFERENCES public.ticket_reservation (reservationid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.movie ADD CONSTRAINT "pre-rollid_fk" FOREIGN KEY ("pre-rollid")
REFERENCES public."pre-roll" ("pre-rollid") MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.movie ADD CONSTRAINT cast_or_director_fk FOREIGN KEY (cast_or_directorid)
REFERENCES public.cast_or_director (cast_or_directorid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.cast_or_director ADD CONSTRAINT director_fk FOREIGN KEY (directorid)
REFERENCES public.director (directorid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.cast_or_director ADD CONSTRAINT cast_fk FOREIGN KEY (castid)
REFERENCES public."cast" (castid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
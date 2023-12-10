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
DROP TABLE IF EXISTS public.pre_roll CASCADE;                       -- Table: pre-roll
DROP TABLE IF EXISTS public.ensemble CASCADE;                       -- Table: ensemble
DROP TABLE IF EXISTS public.director CASCADE;                       -- Table: director
DROP TABLE IF EXISTS public.ensemble_or_director CASCADE;           -- Table: ensemble_or_director

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
    complexid numeric(2, 0) NOT NULL,
    name varchar(50) NOT NULL,
    house_nr numeric(4, 0),
    zip_code numeric(5, 0),
    street_name varchar(50) NOT NULL,
    ticket_sales_points numeric(2) CHECK (ticket_sales_points >= 0), -- Ticket sales points must be positive
    CONSTRAINT cinema_complexes_pk PRIMARY KEY (complexid), -- Primary key
    CONSTRAINT cinema_complex_name_uk UNIQUE (name) -- Name must be unique
);

CREATE INDEX complexid_index ON public.cinema_complex USING btree ( complexid );

CREATE TABLE public.hall (
    hallid numeric(2, 0) NOT NULL,
    complexid numeric(2, 0),
    capacity numeric(4, 0),
    characteristics varchar(50),
    CONSTRAINT halls_pk PRIMARY KEY (hallid), -- Primary key
    CHECK (capacity >= 0) -- Capacity must be positive
);

CREATE INDEX hallid_index ON public.hall USING btree ( hallid );

CREATE TYPE public.type AS ENUM ('3d','dutch_translation','dutch_subtitles','uhd');

CREATE TABLE public.version (
    versionid numeric(4, 0) NOT NULL,
    movieid numeric(10, 0),
    rateid numeric(2, 0),
    type public.type NOT NULL,
    surcharge numeric(8, 2) CHECK (surcharge >= 0), -- Surcharge must be positive
    CONSTRAINT versions_pk PRIMARY KEY (versionid) -- Primary key
);

CREATE TABLE public.scheduling (
	schedulingid numeric(10) NOT NULL,
	complexid numeric(2),
	movieid numeric(10),
	start_date date NOT NULL,
	start_time time NOT NULL,
    end_date date NOT NULL,
    end_time time NOT NULL,
	CONSTRAINT scheduling_pk PRIMARY KEY (schedulingid)
);

CREATE INDEX schedulingid ON public.scheduling USING btree ( schedulingid );

CREATE TABLE public.customer (
	customerid numeric(10) NOT NULL,
	first_name varchar(50),
	last_name varchar(50),
	email varchar(50) NOT NULL,
	username varchar(50) NOT NULL,
	password varchar(50) NOT NULL,
	CONSTRAINT customers_pk PRIMARY KEY (customerid)
);

CREATE INDEX customerid_index ON public.customer USING btree ( customerid );

CREATE TYPE public.payment_method AS ENUM ('maestro','mastercard','visa','cash');

CREATE TABLE public.ticket_reservation (
	reservationid numeric(10) NOT NULL,
	customerid numeric(10),
	schedulingid numeric(10),
	confirmation_email_sent boolean,
	payment_method public.payment_method NOT NULL,
	price numeric(5,2) CHECK ( price > 0 ) NOT NULL,
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

CREATE INDEX ticketid_index ON public.ticket USING btree ( ticketid );

CREATE INDEX versionid_index ON public.version USING btree ( versionid );

CREATE INDEX reservationid_index ON public.ticket_reservation USING btree ( reservationid );

CREATE INDEX seatreservationid_index ON public.seat_reservation USING btree ( seat_reservationid );

CREATE TYPE public.customer_type AS ENUM ('students','retirees','disabled');

CREATE TYPE public.movie_genre AS ENUM ('romantisch','actiefilm','science_fiction','drama','comedy','thriller','fantasy');

CREATE TABLE public.movie (
	movieId numeric(10) NOT NULL,
    pre_rollid numeric(3),
	ensemble_or_directorid numeric(8),
    oscarsid numeric(10),
	title varchar(25),
	genre public.movie_genre,
	duration time(2),
	children_allowed boolean,
	movie_company varchar(25),
	country_of_origin varchar(25) NOT NULL,
	archive boolean,
	CONSTRAINT movies_pk PRIMARY KEY (movieId)
);

CREATE TABLE public.reduced_rate (
	rateid numeric(2) NOT NULL,
    discount_percentage numeric(5,2) CHECK (discount_percentage >= 0),
	customer_type public.customer_type,
	CONSTRAINT rateid_pk PRIMARY KEY (rateid)
);

CREATE INDEX rateid_index ON public.reduced_rate USING btree ( rateid );

CREATE INDEX movieid_index ON public.movie USING btree ( movieId );

CREATE TABLE public.pre_roll (
    pre_rollid numeric(3) NOT NULL,
	trailer varchar(100) NOT NULL,
	description TEXT,
	CONSTRAINT "pre-roll_pk" PRIMARY KEY (pre_rollid)
);

CREATE INDEX pre_rollid_index ON public.pre_roll USING btree ( pre_rollid );

CREATE TABLE public.ensemble (
	ensembleid numeric(8) NOT NULL,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	role varchar(50),
	CONSTRAINT ensemble_pk PRIMARY KEY (ensembleid)
);

CREATE INDEX ensembleid_index ON public.ensemble USING btree ( ensembleid );

CREATE TABLE public.director (
	directorid numeric(8) NOT NULL,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
	function varchar(50),
	CONSTRAINT "director_PK" PRIMARY KEY (directorid)
);

CREATE INDEX directorid_index ON public.director USING btree ( directorid );

CREATE TABLE public.ensemble_or_director (
	ensemble_or_directorid numeric(8) NOT NULL,
	directorid numeric(8),
	ensembleid numeric(8),
	CONSTRAINT ensemble_or_director_pk PRIMARY KEY (ensemble_or_directorid)
);

CREATE INDEX ensemble_or_directorid_index ON public.ensemble_or_director USING btree ( ensemble_or_directorid );

CREATE TYPE public.oscar_category AS ENUM ('best_picture','best_director','best_actor','best_actress','best_supporting_actor','best_supporting_actress','best_original_screenplay','best_adapted_screenplay','best_cinematography','best_costume_design','best_film_editing','best_visual_effects','best_original_score','best_original_song','best_production_design','best_makeup_and_hairstyling','best_sound_editing','best_sound_mixing','best_foreign_language_film','best_animated_feature_film','best_documentary_feature','best_documentary_short_subject','best_animated_short_film','best_live_action_short_film');

CREATE TABLE public.oscars (
    oscarsid numeric(10) NOT NULL,
    oscar_category public.oscar_category,
    winner boolean,
    nominee varchar(100),
    CONSTRAINT oscarsid_pk PRIMARY KEY (oscarsid)
);

CREATE INDEX oscarsid_index ON public.oscars USING btree ( oscarsid ) INCLUDE (oscarsid);

-- **************************************** --
-- CREATE View                              --
-- **************************************** --
CREATE VIEW public.programming_managers_view AS SELECT public.scheduling.* FROM public.scheduling;

CREATE VIEW public.webapplication_mobileapp_view AS
SELECT
    tr.payment_method,
    tr.price,
    t.barcode,
    sr.seat_zone,
    s.start_date,
    s.start_time,
    s.end_date,
    s.end_time,
    c.email,
    c.first_name,
    c.last_name,
    c.password,
    c.username
FROM public.ticket_reservation tr
    JOIN public.ticket t ON tr.reservationid = t.reservationid
    JOIN public.seat_reservation sr ON t.ticketid = sr.reservationid
    JOIN public.scheduling s ON sr.seat_reservationid = s.schedulingid
    JOIN public.customer c ON tr.customerid = c.customerid;

CREATE VIEW public.sales_terminal_cp AS
SELECT
    tr.payment_method,
    tr.price,
    t.barcode,
    sr.seat_zone,
    s.start_date,
    s.start_time,
    s.end_date,
    s.end_time
FROM public.ticket_reservation tr
    JOIN public.ticket t ON tr.reservationid = t.reservationid
    JOIN public.seat_reservation sr ON t.ticketid = sr.reservationid
    JOIN public.scheduling s ON sr.seat_reservationid = s.schedulingid;


CREATE VIEW public.hall_attendant_view AS SELECT public.ticket.barcode FROM public.ticket;

CREATE VIEW public.content_managers_view AS SELECT public.pre_roll.* FROM public.pre_roll;

-- **************************************** --
-- CREATE Constraint                        --
-- **************************************** --
ALTER TABLE public.hall ADD CONSTRAINT cinema_complexes_fk FOREIGN KEY (complexid)
REFERENCES public.cinema_complex (complexid) MATCH SIMPLE ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.version ADD CONSTRAINT movieid_fk FOREIGN KEY (movieid)
REFERENCES public.movie (movieId) MATCH SIMPLE ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.version ADD CONSTRAINT rateid FOREIGN KEY (rateid)
REFERENCES public.reduced_rate (rateid) MATCH SIMPLE ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.scheduling ADD CONSTRAINT cinema_complexes_fk FOREIGN KEY (complexid)
REFERENCES public.cinema_complex (complexid) MATCH SIMPLE ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.scheduling ADD CONSTRAINT movies_fk FOREIGN KEY (movieid)
REFERENCES public.movie (movieId) MATCH SIMPLE ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.ticket_reservation ADD CONSTRAINT customers_fk FOREIGN KEY (customerid)
REFERENCES public.customer (customerid) MATCH SIMPLE ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.ticket_reservation ADD CONSTRAINT scheduling_fk FOREIGN KEY (schedulingid)
REFERENCES public.scheduling (schedulingid) MATCH SIMPLE ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.seat_reservation ADD CONSTRAINT ticket_reservations_fk FOREIGN KEY (reservationid)
REFERENCES public.ticket_reservation (reservationid) MATCH SIMPLE ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.ticket ADD CONSTRAINT ticket_reservations_fk FOREIGN KEY (reservationid)
REFERENCES public.ticket_reservation (reservationid) MATCH SIMPLE ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.movie ADD CONSTRAINT pre_rollid_fk FOREIGN KEY (pre_rollid)
REFERENCES public.pre_roll (pre_rollid) MATCH SIMPLE ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.movie ADD CONSTRAINT ensemble_or_director_fk FOREIGN KEY (ensemble_or_directorid)
REFERENCES public.ensemble_or_director (ensemble_or_directorid) MATCH SIMPLE ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.ensemble_or_director ADD CONSTRAINT director_fk FOREIGN KEY (directorid)
REFERENCES public.director (directorid) MATCH SIMPLE ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.ensemble_or_director ADD CONSTRAINT ensemble_fk FOREIGN KEY (ensembleid)
REFERENCES public.ensemble (ensembleid) MATCH SIMPLE ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.movie ADD CONSTRAINT oscars_fk FOREIGN KEY (oscarsid)
REFERENCES public.oscars (oscarsid) MATCH SIMPLE ON DELETE NO ACTION ON UPDATE NO ACTION;

-- **************************************** --
-- CREATE Users                             --
-- **************************************** --
CREATE USER programming_manager PASSWORD '123';
GRANT ALL ON TABLE programming_managers_view TO programming_manager;

CREATE USER webapplication_mobileapp PASSWORD '123';
GRANT ALL ON TABLE webapplication_mobileapp_view TO webapplication_mobileapp;

CREATE USER sales_terminal PASSWORD '123';
GRANT ALL ON TABLE sales_terminal_cp TO sales_terminal;

CREATE USER hall_attendant PASSWORD '123';
GRANT ALL ON TABLE hall_attendant_view TO hall_attendant;

CREATE USER content_managers PASSWORD '123';
GRANT ALL ON TABLE content_managers_view TO content_managers;
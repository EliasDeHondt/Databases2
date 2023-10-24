/***************************************
 *                                     *
 *   Created by Elias & Kobe           *
 *   Visit https://eliasdh.com         *
 *                                     *
 ***************************************/


-- **************************************** --
-- INSERT Cinema Complexes                  --
-- **************************************** --
INSERT INTO public.cinema_complex (complexid, name, house_nr, zip_code, street_name, ticket_sales_points)
VALUES
    (1, 'The Silver Screen', 123, 5432, 'Main Street', 5),
    (2, 'StarCineplex', 456, 1234, 'Broadway', 4),
    (3, 'City Cinemas', 789, 9865, 'Elm Street', 6),
    (4, 'Movie Magic', 101, 2346, 'Oak Avenue', 3),
    (5, 'CineWorld', 111, 6532, 'Highway Road', 4),
    (6, 'Golden Theatres', 222, 8754, 'Park Lane', 5),
    (7, 'MegaPlex', 333, 4320, 'Sunset Blvd', 7),
    (8, 'Film Haven', 444, 5689, 'Cinema Lane', 4),
    (9, 'Hollywood Cinema', 555, 3467, 'Movie Street', 6),
    (10, 'Filmopolis', 666, 7653, 'Silver Screen Avenue', 3);

-- **************************************** --
-- INSERT Hall                              --
-- **************************************** --
INSERT INTO public.hall (hallid, complexid, capacity, characteristics)
VALUES
    (1, 1, 150, 'Dolby Atmos, 3D'),
    (2, 1, 100, 'Standard'),
    (3, 2, 120, 'Standard'),
    (4, 2, 80, 'IMAX, 3D'),
    (5, 3, 200, 'Standard'),
    (6, 3, 90, 'Standard'),
    (7, 4, 120, 'IMAX'),
    (8, 4, 70, '3D'),
    (9, 5, 180, 'Standard'),
    (10, 5, 110, '3D');

-- **************************************** --
-- INSERT Ensemble                          --
-- **************************************** --
INSERT INTO public.ensemble (ensembleid, first_name, last_name, role)
VALUES
    (1, 'John', 'Doe', 'Lead Actor'),
    (2, 'Jane', 'Smith', 'Supporting Actress'),
    (3, 'Michael', 'Johnson', 'Supporting Actor'),
    (4, 'Emily', 'Brown', 'Lead Actress'),
    (5, 'Robert', 'Lee', 'Supporting Actor'),
    (6, 'Olivia', 'Davis', 'Lead Actress'),
    (7, 'William', 'Martin', 'Supporting Actor'),
    (8, 'Sophia', 'Wilson', 'Lead Actress'),
    (9, 'James', 'Taylor', 'Lead Actor'),
    (10, 'Ella', 'White', 'Supporting Actress');

-- **************************************** --
-- INSERT Director                          --
-- **************************************** --
INSERT INTO public.director (directorid, first_name, last_name, function)
VALUES
    (1, 'Christopher', 'Nolan', 'Director'),
    (2, 'Steven', 'Spielberg', 'Director'),
    (3, 'Quentin', 'Tarantino', 'Director'),
    (4, 'Martin', 'Scorsese', 'Director'),
    (5, 'Greta', 'Gerwig', 'Director'),
    (6, 'Sofia', 'Coppola', 'Director'),
    (7, 'David', 'Fincher', 'Director'),
    (8, 'Ava', 'DuVernay', 'Director'),
    (9, 'Wes', 'Anderson', 'Director'),
    (10, 'Spike', 'Lee', 'Director');

-- **************************************** --
-- INSERT Ensemble Or Director              --
-- **************************************** --
INSERT INTO public.ensemble_or_director (ensemble_or_directorid, directorid, ensembleid)
VALUES
    (1, 1, 2), -- John Doe directed Jane Smith
    (2, 1, 3), -- John Doe directed Michael Johnson
    (3, 4, 5), -- Emily Brown directed Robert Lee
    (4, 4, 6), -- Emily Brown directed Olivia Davis
    (5, 7, 8), -- William Martin directed Sophia Wilson
    (6, 9, 10), -- James Taylor directed Ella White
    (7, 9, 7), -- James Taylor directed William Martin
    (8, 6, 2), -- Olivia Davis directed Jane Smith
    (9, 3, 4), -- Michael Johnson directed Emily Brown
    (10, 5, 8); -- Robert Lee directed Sophia Wilson

-- **************************************** --
-- INSERT Customer                          --
-- **************************************** --
INSERT INTO public.customer (customerid, first_name, last_name, email, username, password)
VALUES
    (1, 'John', 'Doe', 'john.doe@example.com', 'johndoe', 'password123'),
    (2, 'Jane', 'Smith', 'jane.smith@example.com', 'janesmith', 'securepass'),
    (3, 'Michael', 'Johnson', 'michael.johnson@example.com', 'michaelj', 'secret123'),
    (4, 'Emily', 'Brown', 'emily.brown@example.com', 'emilyb', 'password456'),
    (5, 'Robert', 'Lee', 'robert.lee@example.com', 'robertl', 'mysecretpass'),
    (6, 'Olivia', 'Davis', 'olivia.davis@example.com', 'oliviad', 'secure12345'),
    (7, 'William', 'Martin', 'william.martin@example.com', 'williamm', 'password789'),
    (8, 'Sophia', 'Wilson', 'sophia.wilson@example.com', 'sophiaw', 'mypassword123'),
    (9, 'James', 'Taylor', 'james.taylor@example.com', 'jamest', 'mypassword456'),
    (10, 'Ella', 'White', 'ella.white@example.com', 'ellaw', 'mypassword789');

-- **************************************** --
-- INSERT Pre-roll                          --
-- **************************************** --
INSERT INTO public.pre_roll (pre_rollid, trailer, description)
VALUES
    (1, 'pre-roll1.mp4', 'Exciting Upcoming Movies'),
    (2, 'pre-roll2.mp4', 'Special Offers and Promotions'),
    (3, 'pre-roll3.mp4', 'Behind the Scenes of Upcoming Films'),
    (4, 'pre-roll4.mp4', 'Movie Trivia and Fun Facts'),
    (5, 'pre-roll5.mp4', 'Sneak Peek of Upcoming Blockbusters'),
    (6, 'pre-roll6.mp4', 'Film Industry News and Updates'),
    (7, 'pre-roll7.mp4', 'Exclusive Interviews with Celebrities'),
    (8, 'pre-roll8.mp4', 'Cinema Complex Special Events'),
    (9, 'pre-roll9.mp4', 'Film Festival Highlights'),
    (10, 'pre-roll10.mp4', 'Local Community Spotlight');

-- **************************************** --
-- INSERT Oscars                            --
-- **************************************** --
INSERT INTO public.oscars (oscarsid, oscar_category, winner, nominee)
VALUES
    (1, 'best_picture', true, 'The Masterpiece'),
    (2, 'best_director', true, 'Visionary Director'),
    (3, 'best_actor', true, 'Outstanding Actor'),
    (4, 'best_actress', true, 'Talented Actress'),
    (5, 'best_supporting_actor', true, 'Exceptional Supporting Actor'),
    (6, 'best_supporting_actor', true, 'Remarkable Supporting Actor'),
    (7, 'best_supporting_actor', true, 'Incredible Supporting Actor'),
    (8, 'best_supporting_actor', true, 'Outstanding Supporting Actor'),
    (9, 'best_supporting_actor', true, 'Exceptional Supporting Actor'),
    (10, 'best_supporting_actor', true, 'Talented Supporting Actor');


-- **************************************** --
-- INSERT Movie                             --
-- **************************************** --
INSERT INTO public.movie (movieId, pre_rollid, ensemble_or_directorid, oscarsid, title, genre, duration, children_allowed, movie_company, country_of_origin, archive)
VALUES
    (1, 1, 1, 1,'Inception', 'science_fiction', '02:28:00', false, 'Warner Bros.', 'USA', false),
    (2, 2, 2, 2,'Jurassic Park', 'drama', '02:07:00', true, 'Universal Pictures', 'USA', false),
    (3, 3, 3, 3,'Pulp Fiction', 'drama', '02:34:00', false, 'Miramax Films', 'USA', true),
    (4, 4, 4, 4,'Goodfellas', 'drama', '02:26:00', false, 'Warner Bros.', 'USA', true),
    (5, 5, 5, 5,'Little Women', 'drama', '02:14:00', true, 'Columbia Pictures', 'USA', true),
    (6, 6, 6, 6,'Lost in Translation', 'drama', '01:42:00', false, 'Focus Features', 'USA', true),
    (7, 7, 7, 7,'Fight Club', 'drama', '02:19:00', false, '20th Century Fox', 'USA', false),
    (8, 8, 8, 8,'Selma', 'fantasy', '02:08:00', false, 'Paramount Pictures', 'USA', true),
    (9, 9, 9, 9,'The Grand Budapest Hotel', 'comedy', '01:39:00', false, 'Fox Searchlight Pictures', 'USA', true),
    (10, 10, 10, 10,'Do the Right Thing', 'actiefilm', '02:00:00', false, 'Universal Pictures', 'USA', true);

-- **************************************** --
-- INSERT Reduced Rate                      --
-- **************************************** --
INSERT INTO public.reduced_rate (rateid, discount_percentage, customer_type)
VALUES
    (1, 10.00, 'students'),
    (2, 15.00, 'retirees'),
    (3, 5.00, 'disabled'),
    (4, 10.00, 'students'),
    (5, 15.00, 'retirees'),
    (6, 5.00, 'disabled'),
    (7, 10.00, 'students'),
    (8, 15.00, 'retirees'),
    (9, 5.00, 'disabled'),
    (10, 10.00, 'students');

-- **************************************** --
-- INSERT Scheduling                        --
-- **************************************** --
INSERT INTO public.scheduling (schedulingid, complexid, movieid, start_date, start_time, end_date, end_time)
VALUES
    (1, 1, 1, '2023-10-15', '14:00:00','2023-10-15', '14:00:00'),
    (2, 2, 2, '2023-10-15', '15:30:00','2023-10-15', '17:00:00'),
    (3, 3, 3, '2023-10-15', '16:00:00','2023-10-15', '18:00:00'),
    (4, 4, 4, '2023-10-15', '18:00:00','2023-10-15', '19:00:00'),
    (5, 5, 5, '2023-10-15', '19:30:00','2023-10-15', '20:00:00'),
    (6, 6, 6, '2023-10-15', '20:00:00','2023-10-15', '22:00:00'),
    (7, 7, 7, '2023-10-16', '14:00:00','2023-10-16', '17:00:00'),
    (8, 8, 8, '2023-10-16', '15:30:00','2023-10-16', '19:00:00'),
    (9, 9, 9, '2023-10-16', '16:00:00','2023-10-16', '18:00:00'),
    (10, 10, 10, '2023-10-16', '18:00:00','2023-10-16', '20:00:00');

-- **************************************** --
-- INSERT Ticket Reservation                --
-- **************************************** --
INSERT INTO public.ticket_reservation (reservationid, customerid, schedulingid, confirmation_email_sent, payment_method, price)
VALUES
    (1, 1, 1, true, 'visa', 30.00),
    (2, 2, 2, true, 'mastercard', 25.00),
    (3, 3, 3, false, 'cash', 20.00),
    (4, 4, 4, true, 'maestro', 35.00),
    (5, 5, 5, false, 'visa', 28.00),
    (6, 6, 6, true, 'mastercard', 22.00),
    (7, 7, 7, true, 'maestro', 32.00),
    (8, 8, 8, false, 'cash', 18.00),
    (9, 9, 9, true, 'visa', 27.00),
    (10, 10, 10, true, 'mastercard', 24.00);

-- **************************************** --
-- INSERT Ticket                            --
-- **************************************** --
INSERT INTO public.ticket (ticketid, reservationid, barcode)
VALUES
    (1, 1, 098693858674921),
    (2, 2, 098909765434567),
    (3, 3, 248595959594949),
    (4, 4, 996763432454566),
    (5, 5, 342879934903434),
    (6, 6, 234456787655454),
    (7, 7, 435346768546543),
    (8, 8, 937645454546786),
    (9, 9, 489859549548955),
    (10, 10, 145678568364646);

-- **************************************** --
-- INSERT Seat Reservation                  --
-- **************************************** --
INSERT INTO public.seat_reservation (seat_reservationid, reservationid, price, seat_zone)
VALUES
    (1, 1, 10.00, 'normal_zone'),
    (2, 2, 12.00, 'normal_zone'),
    (3, 3, 15.00, 'cosyseat_zone'),
    (4, 4, 8.00, 'normal_zone'),
    (5, 5, 10.00, 'cosyseat_zone'),
    (6, 6, 12.00, 'normal_zone'),
    (7, 7, 15.00, 'cosyseat_zone'),
    (8, 8, 8.00, 'normal_zone'),
    (9, 9, 10.00, 'cosyseat_zone'),
    (10, 10, 12.00, 'normal_zone');

-- **************************************** --
-- INSERT Version                           --
-- **************************************** --
INSERT INTO public.version (versionid, movieid, rateid, type, surcharge)
VALUES
    (1, 1, 1, '3d', 5.00),
    (2, 2, 2, 'dutch_translation', 3.00),
    (3, 3, 3, 'dutch_subtitles', 2.00),
    (4, 4, 4, 'uhd', 6.00),
    (5, 5, 5, '3d', 5.00),
    (6, 6, 6, 'dutch_translation', 3.00),
    (7, 7, 7, 'dutch_subtitles', 2.00),
    (8, 8, 8, 'uhd', 6.00),
    (9, 9, 9, '3d', 5.00),
    (10, 10, 10, 'dutch_translation', 3.00);
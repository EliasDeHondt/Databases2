/***************************************
 *                                     *
 *   Created by Elias & Kobe           *
 *   Visit https://eliasdh.com         *
 *                                     *
 ***************************************/

-- Drop tables
/*
DROP TABLE WeatherHistory;
DROP TABLE dimDay;
DROP TABLE dimUser;
DROP TABLE dimRain;
DROP TABLE dimTreasureType;
DROP TABLE TreasureFound;
*/

/*********************************************************************/
/********************* Creation Of Datawarehouse *********************/
/*********************************************************************/
CREATE TABLE "dimDay" (
    dimDay_key INT PRIMARY KEY,
    date DATE,
    day INT,
    hour INT,
    week INT,
    month INT,
    year INT,
    season VARCHAR(20)
);

CREATE TABLE "dimUser" (
    dimUser_key INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    streetnumber INT,
    street VARCHAR(255),
    city VARCHAR(400),
    country VARCHAR(255),
    experience_level VARCHAR(50),
    dedicator VARCHAR(50),
    dimUser_SK INT,             -- Auto Generated Talend
    scd_start DATETIME,         -- Auto Generated Talend
    scd_end DATETIME,           -- Auto Generated Talend
    scd_version INT,            -- Auto Generated Talend
    scd_active BIT              -- Auto Generated Talend
);

CREATE TABLE "dimRain" (
    dimRain_key INT PRIMARY KEY,
    weather_type VARCHAR(10)
);

CREATE TABLE "dimTreasureType" (
    dimTreasureType_key INT PRIMARY KEY,
    difficulty INT,
    terrain INT,
    amountOfStages INT
);

CREATE TABLE "TreasureFound" (
    TreasureFound_key INT PRIMARY KEY,
    dimDay_key INT,
    dimUser_key INT,
    dimRain_key INT,
    dimTreasureType_key INT,
    
    FOREIGN KEY (dimDay_key) REFERENCES "dimDay"(dimDay_key),
    FOREIGN KEY (dimUser_key) REFERENCES "dimUser"(dimUser_key),
    FOREIGN KEY (dimRain_key) REFERENCES "dimRain"(dimRain_key),
    FOREIGN KEY (dimTreasureType_key) REFERENCES "dimTreasureType"(dimTreasureType_key)
);

CREATE TABLE "WeatherHistory" ( --  (Dit is geen dimensie!)
    city VARCHAR(100),
    weatherCode INT,
    weatherType VARCHAR(100),
    humidity INT,
    hour INT,
    day INT
);
/*********************************************************************/



/*********************************************************************/
/************************** Talend Queries ***************************/
/*********************************************************************/

-- Dimension "User"
SELECT id, first_name, last_name, number, street, 
(SELECT city_name FROM city WHERE city_id = user_table.city_city_id) AS "City",
(SELECT name FROM country WHERE code = (SELECT country_code FROM city WHERE city_id = user_table.city_city_id)) AS "Country",
(SELECT COUNT(*) FROM treasure_log WHERE user_table.id = treasure_log.hunter_id) AS "ExperienceLevel",
(SELECT COUNT(*) FROM treasure WHERE user_table.id = treasure.owner_id) AS "Dedicator"
FROM user_table;

-- Dimension "TreasureType"
SELECT DISTINCT t.difficulty, t.terrain,
    (SELECT COUNT(ts2.stages_id) FROM treasure_stages ts2 WHERE ts2.treasure_id = t.id) AS "Amount Of Stages"
FROM treasure t
LEFT JOIN treasure_stages ts ON t.id = ts.treasure_id
WHERE t.id IN (SELECT treasure_id FROM treasure_log WHERE log_type = 2) -- 2 = found

-- WeatherHistory
SELECT TOP 10 latitude, longitude FROM city;

-- TreasureFound
SELECT dimDay_key FROM "dimDay";
SELECT dimUser_key FROM "dimUser";
SELECT dimRain_key FROM "dimRain";
SELECT dimTreasureType_key FROM "dimTreasureType";
/*********************************************************************/
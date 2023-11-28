/***************************************
 *                                     *
 *   Created by Elias & Kobe           *
 *   Visit https://eliasdh.com         *
 *                                     *
 ***************************************/

-- [S1] Welke rol hebben datumparameters (dagen, weken, maanden, seizoen) op het aantal caches?
SELECT day, week, month, season, COUNT(*) AS number_of_caches
FROM TreasureFound TF
JOIN dimDay DD ON TF.dimDay_key = DD.dimDay_key
GROUP BY day, week, month, season;

-- [S1] Worden er gemiddeld minder caches gezocht op moeilijker terrein als het regent?
SELECT TT.difficulty, COUNT(*) AS number_of_caches
FROM TreasureFound TF
JOIN dimRain DR ON TF.dimRain_key = DR.dimRain_key
JOIN dimTreasureType TT ON TF.dimTreasureType_key = TT.dimTreasureType_key
WHERE DR.weather_type = 'rain'
GROUP BY TT.difficulty;

-- [S1] Worden er in weekends meer moeilijkere caches gedaan?
SELECT TT.difficulty, COUNT(*) AS number_of_caches
FROM TreasureFound TF
JOIN dimDay DD ON TF.dimDay_key = DD.dimDay_key
JOIN dimTreasureType TT ON TF.dimTreasureType_key = TT.dimTreasureType_key
WHERE DD.day IN (5, 6) -- Assuming 5 and 6 represent Saturday and Sunday
GROUP BY TT.difficulty;

-- [S1] Heeft het ervaringsniveau van gebruikers invloed op de tijd die nodig is om de schat te vinden? 
SELECT DU.experience_level, AVG(TF.search_time) AS average_search_time
FROM TreasureFound TF
JOIN dimUser DU ON TF.dimUser_key = DU.dimUser_key
GROUP BY DU.experience_level;

-- [S1] Vinden gebruikers schatten doorgaans sneller in de regen dan in droog weer?
SELECT 'rain' AS weather_type, AVG(TF.search_time) AS average_search_time
FROM TreasureFound TF
JOIN dimRain DR ON TF.dimRain_key = DR.dimRain_key
WHERE DR.weather_type = 'rain'
UNION
SELECT 'dry' AS weather_type, AVG(TF.search_time) AS average_search_time
FROM TreasureFound TF
JOIN dimRain DR ON TF.dimRain_key = DR.dimRain_key
WHERE DR.weather_type = 'dry';



-- [S2] Wat is de invloed van het type user op de duur van de treasurehunt? Doet een beginner er langer over?
SELECT 
    CASE 
        WHEN DU.experience_level = 'beginner' THEN 'Beginner'
        ELSE 'Ervaren' 
    END AS user_type,
    AVG(TF.search_time) AS average_search_time
FROM TreasureFound TF
JOIN dimUser DU ON TF.dimUser_key = DU.dimUser_key
GROUP BY 
    CASE 
        WHEN DU.experience_level = 'beginner' THEN 'Beginner'
        ELSE 'Ervaren' 
    END;

-- [S2] Vinden users de cache gemiddeld sneller in de regen?
SELECT DR.weather_type, AVG(TF.search_time) AS average_search_time
FROM TreasureFound TF
JOIN dimRain DR ON TF.dimRain_key = DR.dimRain_key
GROUP BY DR.weather_type;

-- [S2] Zoeken beginnende users gemiddeld naar grotere caches?
SELECT DU.experience_level, AVG(TT.amountOfStages) AS average_cache_size
FROM TreasureFound TF
JOIN dimUser DU ON TF.dimUser_key = DU.dimUser_key
JOIN dimTreasureType TT ON TF.dimTreasureType_key = TT.dimTreasureType_key
GROUP BY DU.experience_level;

-- [S2] Zijn beginnende gebruikers geneigd om naar grotere caches te zoeken vergeleken met meer ervaren gebruikers?
SELECT DU.experience_level, AVG(TT.amountOfStages) AS average_cache_size
FROM TreasureFound TF
JOIN dimUser DU ON TF.dimUser_key = DU.dimUser_key
JOIN dimTreasureType TT ON TF.dimTreasureType_key = TT.dimTreasureType_key
GROUP BY DU.experience_level;

-- [S2] Hoe varieert het aantal caches dat gezocht wordt op basis van verschillende datumparameters (dagen, weken, maanden, seizoenen)?
SELECT day, week, month, season, COUNT(*) AS number_of_caches
FROM TreasureFound TF
JOIN dimDay DD ON TF.dimDay_key = DD.dimDay_key
GROUP BY day, week, month, season;
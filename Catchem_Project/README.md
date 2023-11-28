![Alt-tekst](/images/Database%20warehouse%20icon.png)
# Catchem - TreasureHunt System

## Introduction

Catchem is a worldwide treasure hunt organizer allowing volunteers to hide treasures with online instructions for seekers. This project aims to create a system akin to GeoCache, focusing primarily on data management and providing necessary artifacts to implement the system.


## Problem Description

Catchem manages registered users, treasures, and stages for treasure hunts. Key elements include:

- User data: firstname, lastname, street, number, city, email.
- Treasures: containing difficulty, terrain, size, and stages.
- Two types of treasures: "DirectTargetTreasure" and "MultiStageTreasure."
- Stages: physical or virtual with varying visibility levels.
- Logs: found, not found, or general messages.

## Scope of Work

- **Phase 1: Data Management**
  - XML Data Transformation using XSLT and Talend.
  - Schema modification for tables `Country2` and `City2`.
  - Integration of validated Foreign Keys.
  
- **Phase 2: Data Warehouse**
  - Creation of a star schema around "TreasureFound" subject area.
  - Populate the schema using ETL processes.
  - Analytical queries for various insights.

- **Phase 3: Database Optimization**
  - Implementing performance optimizations such as logical indexed views, partitioning, column storage, and compression.

## Getting Started

To start this project:

1. Clone the repository.
2. Install the required dependencies listed in `requirements.txt`.
3. Review the `docs` directory for detailed instructions for each phase.
4. Follow the outlined steps in the project directory for each phase.

## Documentation

In the `docs` directory, you'll find comprehensive guides and explanations for:

- Phase-wise project setup.
- Usage instructions.
- Data transformation processes.
- Data warehouse schema and ETL procedures.
- Database optimization approaches and results.

## Evaluation Criteria

Evaluation will be based on:

- Adherence to provided instructions.
- Correctness and efficiency of implemented functionalities.
- Clarity and completeness of documentation.
- Demonstration of optimized database performance.

## Deadline

How to deliver before a deadline?
Delivery must take place at the following times.
This means that at that moment you make a commit and push and provide that commit with a tag:
- Tuesday 28/11 3:45 PM: tag `v1`
- Tuesday 12/19 3:45 PM: tag `v2`
- Sunday 7/01/2023 23:59: tag `v3`
In addition to that commit, you must also always complete the reflection document `/reflection.md` and add it to the repository.


## Analysis Optimization (optimalisatie dossier)
### Index
Indexering verbetert de ophaalsnelheid van gegevens door structuren te optimaliseren op basis van specifieke velden of kolommen.

```sql
SET STATISTICS TIME ON;
GO

SELECT experience_level, dedicator
FROM dimUser
WHERE dimUser_key = 0x00001CBFA8E546C1BAA621DE39F4E2D4;

SET STATISTICS TIME OFF;
GO
```
<br>

| Experience Level | Dedicaton |
|------------------|-----------|
| Amateur          | No        |
<br>

- (Before index creation)
  - Evidence

  ![Alt-tekst](/images/before-index.png)


- (After index creation)
  - Index creation
  ```sql
  CREATE NONCLUSTERED INDEX dimUser_key_index
  ON dimUser (dimUser_key);
  ```

  - Evidence
  
  ![Alt-tekst](/images/after-index.png)


### Partitionering
Partitioneren verdeelt grote databasetabellen in kleinere, beter beheersbare segmenten.

- (Before partitionering)
  - /

- (After partitionering)
  - /

### Column storage
Kolomopslag herstructureert de gegevensorganisatie door informatie op te slaan in kolommen in plaats van rijen, waardoor de prestaties van zoekopdrachten worden verbeterd, vooral voor analyses.

- (Before column storage)
  - /

- (After column storage)
  - /

### Compressie
Compressie minimaliseert de opslagvereisten door de gegevensgrootte te gebruiken met behulp van technieken zoals run-length-codering, woordenboekcodering of gzip-compressie.

- (Before compression)
  ```sql
  SELECT OBJECT_NAME(object_id) AS "Table Name",
    SUM(reserved_page_count) * 8 AS "Total Size KB",
    SUM(reserved_page_count) * 8 / 1024.0 AS "Total Size MB"
  FROM sys.dm_db_partition_stats
  WHERE OBJECT_NAME(object_id) = 'dimUser'
  GROUP BY object_id;
  ```
  | Table Name | Total Size KB | Total Size MB |
  |------------|---------------|---------------|
  | dimUser    | 86896         | 84.859375     |

- Compression
  ```sql
  ALTER TABLE dimUser
  REBUILD WITH (DATA_COMPRESSION = PAGE);
  ```
  - __PAGE__ = Row compression + Prefix compression
  - __ROW__ = Row compression
  - __NONE__ = No compression
  - __COLUMNSTORE__ = Columnstore compression

- (After compression)
  ```sql
  SELECT OBJECT_NAME(object_id) AS "Table Name",
    SUM(reserved_page_count) * 8 AS "Total Size KB",
    SUM(reserved_page_count) * 8 / 1024.0 AS "Total Size MB"
  FROM sys.dm_db_partition_stats
  WHERE OBJECT_NAME(object_id) = 'dimUser'
  GROUP BY object_id;
  ```
  | Table Name | Total Size KB | Total Size MB |
  |------------|---------------|---------------|
  | dimUser    | 39248         | 38.328125     |

## Talend Java Code

### DimDay-Season
```Java
int month = Integer.parseInt(TalendDate.formatDate("M", input_row.date));
int day =  Integer.parseInt(TalendDate.formatDate("dd", input_row.date));

if ((month == 12 && day >= 21) || (month >= 1 && month <= 2) || (month == 3 && day < 20)) {
  output_row.season = "Winter";
}

else if ((month == 3 && day >= 20) || (month >= 4 && month <= 5) || (month == 6 && day < 21)) {
  output_row.season = "Spring";
}

else if ((month == 6 && day >= 21) || (month >= 7 && month <= 8) || (month == 9 && day < 23)) {
  output_row.season = "Summer";
}

else if ((month == 9 && day >= 23) || (month >= 10 && month <= 11) || (month == 12 && day < 21)) {
	output_row.season = "Fall";
}

output_row.date=input_row.date;
```

### DimTreasureType-PK
```Java
output_row.dimTreasureType_key=context.Iterator;
context.Iterator=context.Iterator+1;

output_row.difficulty=input_row.difficulty;
output_row.terrain=input_row.terrain;
output_row.amountOfStages=input_row.amountOfStages;
```

### DimUser-ExperienceLevel + PK
```Java
if (input_row.experience_level == 0) output_row.experience_level = "Starter";
else if (input_row.experience_level < 4) output_row.experience_level = "Amateur";
else if (input_row.experience_level >= 4 && input_row.experience_level <= 10) output_row.experience_level = "Professional";
else output_row.experience_level = "Pirate";

if (input_row.dedicator > 0) output_row.dedicator = "Yes";
else output_row.dedicator = "No";

output_row.dimUser_key=input_row.dimUser_key;
output_row.first_name=input_row.first_name;
output_row.last_name=input_row.last_name;
output_row.streetnumber=input_row.streetnumber;
output_row.street=input_row.street;
output_row.city=input_row.city;
output_row.country=input_row.country;
```

## Auteur
```JSON
{
  "auteurs": [
    {
      "first_name": "Elias",
      "last_name": "De Hondt",
      "leeftijd": 22,
      "email": "elias.dehondt@student.kdg.be",
      "passie": "Alchemist van elektronica",
      "superkracht": "Transformeert koffie in code!",
      "favoriete_programmeertaal": "C# en Python",
      "levensmotto": "Perfection is everything.",
      "uitdaging": "Leren van nieuwe technologieën voor kunstmatige intelligentie en machine learning"
    },
    {
      "first_name": "Kobe",
      "last_name": "Wijnants",
      "email": "kobe.wijnants@student.kdg.be",
      "leeftijd": 19,
      "passie": "Avonturen beleven in de digitale wildernis",
      "superkracht": "Code kloppen met ogen dicht!",
      "favoriete_programmeertaal": "Java en Python",
      "levensmotto": "Leef elke dag alsof het een nieuw avontuur is.",
      "uitdaging": "Werken aan een open-sourceproject"
    }
  ]
}
```
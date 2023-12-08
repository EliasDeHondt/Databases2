![database-warehouse-icon](/images/database-warehouse-icon.png)

# Neo4J Rides Graph Dossier


## <span style="color:#42f542">Deel 1: Neo4J Rides Graph installeren<span>
### Installatie van Neo4J met Docker

- docker installatie
```powershell
docker run --name neo4j-container --volume $HOME/neo4j/data:/data  --publish=7474:7474 --publish=7687:7687 neo4j:latest
```

### inloggen op Neo4j browser

- browse naar de Neo4j browser op "http://localhost:7474"
- standaard username/paswoord zijn neo4j/neo4j

- standaard is de neo4j databank is beschikbaar op "http://localhost:7687"

## <span style="color:#42f542">Deel 2: Importeren van de catchem tabellen<span>
### Exporteer je tabellen naar csv

Gebruik export data in sql management studio om volgende tabellen om te zetten naar csv:
- user_table
- treasure
- city
- country

### csv's importeren in neo4j

1. plaats de csv's in je directory die je hebt verbonden aan je docker container
2. gebruik mv om ze in de import directory van je docker container te zetten
```bash
mv /data/CSV /var/lib/neo4j/import
```
3. voeg de waarde dbms.memory.transaction.total.max=4G toe in /var/lib/neo4j/conf/neo4j.conf om de maximale transactie memory usage te verhogen (anders zal user_table niet lukken)
4. importeer user_table in neo4j (gebruik makende van de neo4j browser)
```sql
LOAD CSV WITH HEADERS FROM 'file:///csv/Neo4J-Dataset-user_table.csv' AS row

CREATE (u:User {
  id: toInteger(row.id),
  first_name: row.first_name,
  last_name: row.last_name,
  mail: row.mail,
  number: row.number,
  street: row.street,
  city_id: toInteger(row.city_city_id)
});
```
5. importeer treasure in neo4j (gebruik makende van de neo4j browser)
```sql
LOAD CSV WITH HEADERS FROM 'file:///csv/Neo4J-Dataset-treasure.csv' AS row

CREATE (t:Treasure {
  id: toInteger(row.id),
  difficulty: row.difficulty,
  terrain: row.terrain,
  city_id: toInteger(row.city_city_id),
  owner_id: toInteger(row.owner_id)
});
```

6. importeer city in neo4j (gebruik makende van de neo4j browser)
```sql
LOAD CSV WITH HEADERS FROM 'file:///csv/Neo4J-Dataset-city.csv' AS row

CREATE (c:City {
  city_id: toInteger(row.city_id),
  city_name: row.city_name,
  latitude: row.latitude,
  longitude: row.longitude,
  postal_code: row.postal_code,
  country_code: row.country_code
});
```

6. importeer country in neo4j (gebruik makende van de neo4j browser)
```sql
LOAD CSV WITH HEADERS FROM 'file:///csv/Neo4J-Dataset-country.csv' AS row

CREATE (co:Country {
  code: row.code,
  code3: row.code3,
  name: row.name
})
```

// Chạy riêng từng truy vấn trong Neo4j Browser.
MATCH p=(t:DiabetesTopic)<-[:ABOUT]-(f:DiabetesFact)-[:CITES]->(s:DiabetesSource)
RETURN p LIMIT 50;

MATCH (f:DiabetesFact)-[:ABOUT]->(:DiabetesTopic {id:'food'}),
      (f)-[:CITES]->(s:DiabetesSource)
RETURN f.text AS noi_dung, s.title AS tai_lieu, s.url AS nguon, f.section AS muc;

MATCH (s:DiabetesSource)<-[:CITES]-(f:DiabetesFact)
RETURN s.format AS dinh_dang, count(DISTINCT s) AS so_nguon, count(f) AS so_menh_de;


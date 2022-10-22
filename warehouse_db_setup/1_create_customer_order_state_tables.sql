/*
 DROP SCHEMA IF EXISTS store;
 CREATE SCHEMA store;
 DROP TABLE IF EXISTS store.customers;
 CREATE TABLE store.customers (
 customer_id INTEGER,
 first_name VARCHAR(100),
 last_name VARCHAR(100),
 state_code VARCHAR(2),
 datetime_created VARCHAR(100),
 datetime_updated VARCHAR(100),
 datetime_inserted TIMESTAMP not null default CURRENT_TIMESTAMP
 );
 DROP TABLE IF EXISTS store.customer_risk_score;
 CREATE TABLE store.customer_risk_score(
 customer_id INTEGER,
 risk_score INTEGER,
 datetime_inserted TIMESTAMP not null default CURRENT_TIMESTAMP
 );
 DROP TABLE IF EXISTS store.orders;
 CREATE TABLE store.orders(
 order_id VARCHAR(50), 
 customer_id INTEGER,
 item_id VARCHAR(50), 
 item_name VARCHAR(150), 
 delivered_on VARCHAR(50)
 );
 DROP TABLE IF EXISTS store.states ;
 CREATE TABLE store.states  (
 state_identifier INTEGER,
 state_code VARCHAR(2),
 st_name VARCHAR(30)
 );
 INSERT INTO store.states (state_identifier, state_code, st_name)
 VALUES
 (1,'AC','Acre'),
 (2,'AL','Alagoas'),
 (3,'AP','Amapa'),
 (4,'AM','Amazonas'),
 (5,'BA','Bahia'),
 (6,'CE','Ceara'),
 (7,'DF','Distrito Federal'),
 (8,'ES','Espirito Santo'),
 (9,'GO','Goias'),
 (10,'MA','Maranhao'),
 (11,'MT','MatoGrosso'),
 (12,'MS','MatoGrosso do Sul'),
 (13,'MG','Minas Gerais'),
 (14,'PA','Para'),
 (15,'PB','Paraiba'),
 (16,'PR','Parana'),
 (17,'PE','Pernambuco'),
 (18,'PI','Piaui'),
 (19,'RJ','Rio de Janeiro'),
 (20,'RN','Rio Grande do Norte'),
 (21,'RS','Rio Grande do Sul'),
 (22,'RO','Rondonia'),
 (23,'RR','Roraima'),
 (24,'SC','Santa Catarina'),
 (25,'SP','Sao Paulo'),
 (26,'SE','Sergipe'),
 (27,'TO','Tocantins');
 */
create database o;
use o;
create table Zones (
zone_id VARCHAR(5) primary key ,
zone_name VARCHAR(100) not null,
area_square_meters DECIMAL(10,2) not null,
light_condition VARCHAR(50) not null,
status VARCHAR(20) not null
);
create table Crops (
crop_id VARCHAR(5) primary key ,
crop_name VARCHAR(100) not null unique,
growth_time_days int not null,
water_requirement VARCHAR(50) not null,
expected_yield DECIMAL(10,2) null
);
create table Planting_Logs(
log_id int primary key auto_increment ,
zone_id VARCHAR(5) not null,
crop_id VARCHAR(5)not null,
planting_date DATE not null,
last_watered DATETIME ,
foreign key (zone_id) references Zones(zone_id),
foreign key (crop_id) references Crops(crop_id),
is_automated BOOLEAN NOT NULL DEFAULT 0
);
create table Harvests (
harvest_id INT primary key auto_increment,
log_id INT not null,
harvest_date DATE not null,
actual_yield DECIMAL(10,2) not null,
quality_grade VARCHAR(10) not null,
foreign key (log_id) references Planting_Logs(log_id)
);
insert into Zones
values ('Z01', 'Khu nhà màng 01', 50.5, 'Full Sun', 'Occupied'),
		('Z02', 'Khu thủy canh 02', 30.0, 'Partial Shade', 'Occupied'),
		('Z03', 'Vườn rau gia vị', 15.0, 'Full Sun', 'Available'),
		('Z04', 'Nhà kính trung tâm', 100.0, 'Full Sun', 'Occupied'),
		('Z05', 'Khu thực nghiệm', 25.0, 'Shade', 'Maintenance');
insert into Crops 
values ('C01', 'Xà lách thủy tinh', 45, 'High', 2.5),
('C02', 'Cà chua Cherry', 90, 'Medium', 5.0),
('C03', 'Cải bó xôi', 35, 'High', 1.8),
('C04', 'Dưa lưới Nhật', 85, 'Medium', 4.0),
('C05', 'Ớt chuông', 110, 'Medium', 3.5);
insert into Planting_Logs
values (1, 'Z01', 'C02', '2025-10-01', '2025-11-10 08:00:00', 1),
       (2, 'Z02', 'C01', '2025-11-05', '2025-11-10 17:30:00', 1),
       (3, 'Z01', 'C03', '2025-11-08', NULL, 0),
       (4, 'Z04', 'C04', '2025-09-15', '2025-11-11 09:00:00', 1),
       (5, 'Z04', 'C05', '2025-11-01', '2025-11-11 10:00:00', 1),
       (6, 'Z03', 'C03', '2025-11-15', NULL, 0);
insert into Harvests
values (1, 1, '2025-12-30', 250.0, 'A'),
(2, 4, '2025-12-10', 380.5, 'A'),
(3, 6, '2025-11-25', 65.0, 'B'),
(4, 2, '2025-12-20', 0.0, 'C');
update Crops
set expected_yield = expected_yield * 1.1
where crop_id = 'C01';
 update Zones
set status = 'Maintenance'
where zone_id ='Z03';
delete from Harvests
where actual_yield = 0 or quality_grade = 'C' ;
ALTER TABLE Zones
ADD CONSTRAINT chk_area_positive CHECK (area_square_meters > 0);
ALTER TABLE Planting_Logs
ALTER COLUMN is_automated SET DEFAULT 1;
ALTER TABLE Crops
ADD fertilizer_type VARCHAR(50);
-- 10 
select * from Crops
where growth_time_days < 50;
-- 11 
select zone_name,area_square_meters from Zones
where light_condition = 'Full Sun';
-- 12 
select crop_name,expected_yield from Crops
order by expected_yield desc ;
-- 13 
select * from Planting_Logs
order by planting_date desc
LIMIT 3;
-- 14 
select zone_name,status from Zones 
limit 2 offset 1;
-- 15 
update Planting_Logs
set last_watered = now()
where is_automated = 1;
-- 16 
update Crops 
set crop_name = upper(crop_name);
-- 17 
delete from Harvests
where log_id in (
    select log_id from Planting_Logs
    where zone_id in (
        select zone_id FROM Zones where status = 'Maintenance')
);
delete from Planting_Logs
where zone_id in (
    select zone_id from Zones where status = 'Maintenance');
delete from Zones
where status = 'Maintenance';
-- 18
select log_id,zone_name,crop_name,planting_date from Planting_Logs as p
join Crops as c
on c.crop_id = p.crop_id
join Zones as z
on z.zone_id = p.zone_id
where status = 'Occupied';
-- 19
select zone_name,count(zone_name) as số_lần_đã_được_trồng_trọt from  Zones as z
left join Planting_Logs as p
on p.zone_id = z.zone_id
group by zone_name;
-- 20 
select c.crop_name, SUM(h.actual_yield) as tong_san_luong_thuc_te
from Harvests as h
join Planting_Logs p 
on h.log_id = p.log_id
join Crops c 
on p.crop_id = c.crop_id
group by c.crop_name;
-- 21
select z.zone_name, COUNT(p.crop_id) as so_loai_cay_trong
from Zones z
join Planting_Logs p 
on z.zone_id = p.zone_id
group by z.zone_name
having COUNT(p.crop_id) >= 2;
 -- 22
 select * from Crops
 where expected_yield > (select avg(expected_yield) from Crops);


 
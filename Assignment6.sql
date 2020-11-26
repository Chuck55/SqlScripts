drop schema if exists bowling; 
create schema if not exists bowling;
set search_path to 'bowling';
create table Alley (
	PhoneNum text,
	Name text,
	constraint pk_Alley primary key (PhoneNum)
);
insert into Alley (PhoneNum, Name) values ('763-503-2695','‘Brunswick Zone Brooklyn Park');

create table bowling.Game (
	AlleyPhoneNum text,
	times int not null,
	lanenum int not null,
	constraint pk_game_key primary key (AlleyPhoneNum, times, lanenum),
	constraint fk_game_alley foreign key (AlleyPhoneNum) references Alley(PhoneNum)
);
insert into bowling.Game (AlleyPhoneNum, times, lanenum) values ('763-503-2695',1567952467, 43);

create table bowling.Line (
	GameAlleyPhoneNum text,
	gametime int not null,
	gamelanenum int not null,
	playernum int not null,
	playername text not null,
	constraint pk_line_key primary key (GameAlleyPhoneNum, gametime, gamelanenum, playernum),
	constraint fk_line_key1 foreign key (GameAlleyPhoneNum) references Game(AlleyPhoneNum),
	constraint fk_line_key2 foreign key (gametime, gamelanenum) references Game(times),
	constraint fk_line_key3 foreign key (gamelanenum) references Game(lanenum)
);
insert into bowling.Line (GameAlleyPhoneNum, gametime, gamelanenum, playernum, playername) values 
('763-503-2695',1567952467, 43, 2, 'MADDIE'),
('763-503-2695',1567952467, 43, 1, 'COOPER'),
('763-503-2695',1567952467, 43, 3, 'DAD');

create table bowling.Frame (
	LineAlleyPhoneNum text,
	lineLanetime int not null,
	linegamelanenum int not null,
	lineplayernum int not null,
	FrameNum int not null,
	Roll1Score int not null,
	Roll2Score int null,
	Roll3Score int null,
	isSplit bool,
	constraint pk_frame_key primary key (LineAlleyPhoneNum, lineLanetime, linegamelanenum, lineplayernum, FrameNum),
	constraint fk_frame_key1 foreign key (LineAlleyPhoneNum) references Line(GameAlleyPhoneNum),
	constraint fk_frame_key2 foreign key (lineLanetime) references Line(gametime),
	constraint fk_frame_key3 foreign key (linegamelanenum) references Line(gamelanenum),
	constraint fk_frame_key4 foreign key (lineplayernum) references Line(playernum),
);
insert into bowling.Frame (LineAlleyPhoneNum, lineLanetime, linegamelanenum, lineplayernum, FrameNum, Roll1Score, Roll2Score, Roll3Score, isSplit) values 
('763-503-2695',1567952467, 43,2, 2,0,9, NULL, 'FALSE'),
('763-503-2695',1567952467, 43,2, 8,10,NULL, NULL, 'FALSE'),
('763-503-2695',1567952467, 43,1,6,8,0, NULL, 'TRUE'),
('763-503-2695',1567952467, 43,3,10,10,8, 0, 'FALSE'),
('763-503-2695',1567952467, 43,1,1,3,7, NULL, 'FALSE');



drop schema if exists MenuBase cascade; 
create schema if not exists MenuBase;
set search_path to 'MenuBase';
create table Menu (
	Restaurant_name text,
	URL text,
	description text,
	constraint pk_menu primary key (Restaurant_name)
);
insert into Menu (Restaurant_name, URL, description) values ('Sally’’s', 'http://sallyssaloon.net/menu/', 'Thanks for dining with us! 700 Wash Ave');

create table MenuBase.category (
	R_Name text,
	Name text not null,
	Descriptions text null,
	constraint pk_category_name primary key (name, R_Name),
	constraint fk_category_key foreign key (R_Name) references Menu(Restaurant_name)
);
insert into MenuBase.category (R_Name, Name, Descriptions) values 
('Sally’’s', 'Appetizers', NULL),
('Sally’’s', 'Sandwiches & Wraps', 'Served with kettle chips (unless otherwise noted)'),
('Sally’’s', 'Saloon Daily Specials', 'Subject to Change on Event Days');

create table MenuBase.upgrade (
	R_Name text,
	Names text not null,
	cost int not null,
	constraint pk_upgrade_name primary key (Names,R_Name),
	constraint fk_upgrade_key foreign key (R_Name) references Menu(R_Name)
);
insert into MenuBase.upgrade (R_Name, Names, cost) values 
('Sally’’s', 'Fries', 2),
('Sally’’s', 'Tater Tots', 2),
('Sally’’s', 'House Salad', 3),
('Sally’’s', 'Cup of Soup', 3),
('Sally’’s', 'Chicken', 1),
('Sally’’s', 'Taco beef', 1);


create table MenuBase.dish (
	R_Name text,
	CategoryName text,
	Title text,
	descriptions text not null,
	options text null,
	cost int null,
	constraint ck_dish_options check (options in ('red','yellow','blue')),
	constraint pk_dish_name primary key (CategoryName, Title, R_Name),
	constraint fk_dish_key foreign key (R_Name) references category(R_Name),
	constraint fk_dish_key2 foreign key (CategoryName) references category(Name)
);
insert into MenuBase.dish (R_Name, CategoryName, Title, descriptions, options, cost) values 
('Sally’’s', 'Appetizers', 'Sally’’s Wings', 'oven baked...bleu cheese.', NULL),
('Sally’’s', 'Appetizers', 'Nachos', 'cheese...friendly.', NULL),
('Sally’’s', 'Sandwiches & Wraps', 'Smoked Pork Sandwich', 'smoked...bun.',NULL),
('Sally’’s', 'Saloon Daily Specials', 'Street Taco Tuesday', NULL, NULL);


create table MenuBase.dishprice (
	R_Name text,
	CategoryName text,
	DishTitle text,
	Size text,
	cost int not null,
	constraint pk_dishprice_name primary key (CategoryName, DishTitle, R_Name, Size),
	constraint fk_dish_key1 foreign key (R_Name) references dish(R_Name),
	constraint fk_dish_key2 foreign key (CategoryName) references dish(CategoryName),
	constraint fk_dish_key3 foreign key (DishTitle) references dish(Title)
);
insert into MenuBase.dishprice (R_Name, CategoryName, DishTitle, Size, cost) values 
('Sally’’s', 'Appetizers', 'Sally’’s Wings', '6 pc', 7),
('Sally’’s', 'Appetizers', 'Sally’’s Wings', '12 pc', 12),
('Sally’’s', 'Appetizers', 'Nachos', '', 12),
('Sally’’s', 'Sandwiches & Wraps', 'Smoked Pork Sandwich', '', 10),
('Sally’’s', 'Saloon Daily Specials', 'Street Taco Tuesday', '', 5);

create table MenuBase.special (
	R_Name text,
	CategoryName text,
	DishTitle text,
	WeekDay text not null,
	startTime text not null,
	endTime text not null,
	constraint ck_special_WeekDay check (WeekDay in ('Monday','Tuesday','Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')),

	constraint pk_special_name primary key (CategoryName, DishTitle, R_Name),
	constraint fk_special_dish_key1 foreign key (R_Name) references dish(R_Name),
	constraint fk_special_dish_key2 foreign key (CategoryName) references dish(CategoryName),
	constraint fk_special_dish_key3 foreign key (DishTitle) references dish(Title),

	constraint fk_special_category_key1 foreign key (R_Name) references category(R_Name),
	constraint fk_special_category_key2 foreign key (CategoryName) references category(Name)
);
insert into MenuBase.special (R_Name, CategoryName, DishTitle, WeekDay, startTime, endTime) values ('Sally’’s', 'Saloon Daily Specials', 'Street Taco Tuesday', 'Tuesday', '5pm', 'Midnight');

create table MenuBase.categoryupgrade (
	R_Name text,
	CategoryName text,
	UpgradeName text,
	constraint pk_categoryupgrade_name primary key (CategoryName, R_Name, UpgradeName),
	constraint fk_categoryupgrade_category_key1 foreign key (R_Name) references category(R_Name),
	constraint fk_categoryupgrade_category_key2 foreign key (CategoryName) references category(CategoryName),

	constraint fk_categoryupgrade_upgrade_key1 foreign key (R_Name) references upgrade(R_Name),
	constraint fk_categoryupgrade_upgrade_key2 foreign key (UpgradeName) references upgrade(Names),
);
insert into MenuBase.categoryupgrade (R_Name, CategoryName, UpgradeName) values ('Sally’’s', 'Sandwiches & Wraps', 'Tater Tots'),
('Sally’’s', 'Sandwiches & Wraps', 'House Salad');



create table MenuBase.dishupgrade (
	R_Name text,
	CategoryName text,
	DishTitle text,
	UpgradeName text,
	constraint pk_dishupgrade_name primary key (CategoryName, R_Name, UpgradeName),
	constraint fk_dishupgrade_category_key1 foreign key (R_Name) references dish(R_Name),
	constraint fk_dishupgrade_category_key2 foreign key (CategoryName) references dish(CategoryName),
	constraint fk_dishupgrade_category_key3 foreign key (DishTitle) references dish(Title),

	constraint fk_dishupgrade_upgrade_key1 foreign key (R_Name) references upgrade(R_Name),
	constraint fk_dishupgrade_upgrade_key2 foreign key (UpgradeName) references upgrade(Names),
);
insert into MenuBase.dishupgrade (R_Name, CategoryName, UpgradeName) values 
('Sally’’s', 'Appetizers', 'Nachos', 'Chicken'),
('Sally’’s', 'Appetizers', 'Nachos', 'Taco beef');

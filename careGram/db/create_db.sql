CREATE DATABASE careGram;
#CREATE USER 'webapp'@'%' IDENTIFIED BY 'abc123';
GRANT ALL PRIVILEGES ON careGram.* TO 'webapp'@'%';
FLUSH PRIVILEGES;

USE careGram;

create table moderator (
	emp_id INT NOT NULL auto_increment,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL,
	mod_password VARCHAR(50) NOT NULL,
	hours_worked INT DEFAULT 0,
	date_hired DATETIME DEFAULT current_timestamp,
	phone VARCHAR(50) NOT NULL,
	salary VARCHAR(50) DEFAULT 31200,
	birthday DATETIME NOT NULL,
	age INT DEFAULT NULL,
	CONSTRAINT pk PRIMARY KEY (emp_id)
);

create table organization (
	org_id INT NOT NULL auto_increment,
	username VARCHAR(50) NOT NULL,
	org_name VARCHAR(50) NOT NULL,
	verified BOOLEAN DEFAULT FALSE,
	num_following INT DEFAULT 0,
	num_followers INT DEFAULT 0,
	org_password VARCHAR(50) NOT NULL,
	date_joined DATETIME DEFAULT current_timestamp,
	email VARCHAR(50) NOT NULL,
	phone VARCHAR(50),
	profile_pic BLOB DEFAULT NULL,
	mod_id INT DEFAULT NULL,
	CONSTRAINT pk PRIMARY KEY (org_id),
	CONSTRAINT fk_01 FOREIGN KEY (mod_id)
        REFERENCES moderator (emp_id)
        ON UPDATE cascade
        ON DELETE RESTRICT
);

create table generic_user (
	user_id INT NOT NULL auto_increment,
	username VARCHAR(50) NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	num_following INT DEFAULT 0,
	user_password VARCHAR(50) NOT NULL,
	birthday DATETIME NOT NULL,
	profile_pic MEDIUMBLOB DEFAULT NULL,
	location VARCHAR(50),
	num_followers INT DEFAULT 0,
	email VARCHAR(50) NOT NULL,
	phone VARCHAR(50),
	volunteer_hours DECIMAL(5,2) DEFAULT 0,
	date_joined DATETIME DEFAULT current_timestamp,
	mod_id INT DEFAULT NULL,
	age INT DEFAULT NULL,
	CONSTRAINT pk PRIMARY KEY (user_id),
	CONSTRAINT fk_02 FOREIGN KEY (mod_id)
	    #SET DEFAULT NULL
        REFERENCES moderator (emp_id)
        ON UPDATE SET NULL
        ON DELETE restrict
);

create table event (
	event_id INT NOT NULL AUTO_INCREMENT,
	posted_on DATETIME DEFAULT current_timestamp,
	event_name VARCHAR(50),
	updated_on DATETIME DEFAULT current_timestamp
                 ON UPDATE current_timestamp,
	num_reposts INT DEFAULT 0,
	image MEDIUMBLOB NOT NULL,
	link VARCHAR(1000),
	descr TEXT NOT NULL,
	event_time DATETIME NOT NULL,
	location VARCHAR(50) NOT NULL,
	age_restriction INT DEFAULT NULL,
	num_volunteers INT,
	mod_id INT DEFAULT NULL,
	CONSTRAINT pk PRIMARY KEY (event_id),
	CONSTRAINT fk_03 FOREIGN KEY (mod_id)
        REFERENCES moderator (emp_id)
        ON UPDATE cascade
        ON DELETE restrict
);

CREATE TABLE sign_in_sheet (
    sheet_id INT NOT NULL auto_increment,
    event_name VARCHAR(50),
    total_volunteers INT DEFAULT 0,
    event_id INT NOT NULL,
    CONSTRAINT pk PRIMARY KEY (sheet_id),
    CONSTRAINT fk_04 FOREIGN KEY (event_id)
        REFERENCES event (event_id)
        ON UPDATE cascade
        ON DELETE RESTRICT
);

create table sheet_line (
   last_name varchar(50) NOT NULL,
   first_name varchar(50) NOT NULL,
   email varchar(50) NOT NULL,
   phone varchar(50),
   checked_in boolean DEFAULT FALSE,
   sheet_id INT NOT NULL,
   user_id INT NOT NULL,
   constraint pk primary key (last_name, first_name, sheet_id),
   constraint fk_05 Foreign key (sheet_id)
       references sign_in_sheet (sheet_id)
       on update cascade
       on delete restrict,
   constraint fk_06 Foreign key (user_id)
       references generic_user (user_id)
       on update cascade
       on delete restrict
);

CREATE TABLE user_follow_user (
    user_id INT NOT NULL,
    follow_id INT NOT NULL,
    CONSTRAINT pk PRIMARY KEY (user_id, follow_id),
    CONSTRAINT fk_07 FOREIGN KEY (user_id)
        REFERENCES generic_user (user_id)
        ON UPDATE cascade
        ON DELETE RESTRICT,
    CONSTRAINT fk_08 FOREIGN KEY (follow_id)
        REFERENCES generic_user (user_id)
        ON UPDATE cascade
        ON DELETE RESTRICT
);

CREATE TABLE user_follow_org (
    user_id INT NOT NULL,
    follow_id INT NOT NULL,
    CONSTRAINT pk PRIMARY KEY (user_id, follow_id),
    CONSTRAINT fk_09 FOREIGN KEY (user_id)
        REFERENCES generic_user (user_id)
        ON UPDATE cascade
        ON DELETE RESTRICT,
    CONSTRAINT fk_10 FOREIGN KEY (follow_id)
        REFERENCES organization (org_id)
        ON UPDATE cascade
        ON DELETE RESTRICT
);

CREATE TABLE org_follow_org (
    org_id INT NOT NULL,
    follow_id INT NOT NULL,
    CONSTRAINT pk PRIMARY KEY (org_id, follow_id),
    CONSTRAINT fk_11 FOREIGN KEY (org_id)
        REFERENCES organization (org_id)
        ON UPDATE cascade
        ON DELETE RESTRICT,
    CONSTRAINT fk_12 FOREIGN KEY (follow_id)
        REFERENCES organization (org_id)
        ON UPDATE cascade
        ON DELETE RESTRICT
);

CREATE TABLE org_type (
    org_id INT NOT NULL,
    type VARCHAR(50) NOT NULL,
    CONSTRAINT pk PRIMARY KEY (org_id, type),
    CONSTRAINT fk_018 FOREIGN KEY (org_id)
        REFERENCES organization (org_id)
        ON UPDATE cascade
        ON DELETE RESTRICT
);

CREATE TABLE org_location (
    org_id INT NOT NULL,
    location VARCHAR(100) NOT NULL,
    CONSTRAINT pk PRIMARY KEY (org_id, location),
    CONSTRAINT fk_13 FOREIGN KEY (org_id)
        REFERENCES organization (org_id)
        ON UPDATE cascade
        ON DELETE RESTRICT
);

CREATE TABLE user_event(
    event_id INT NOT NULL,
    user_id INT NOT NULL,
    availability INT NOT NULL,
    CONSTRAINT pk PRIMARY KEY (event_id, user_id),
    CONSTRAINT fk_14 FOREIGN KEY (event_id)
        REFERENCES event (event_id)
        ON UPDATE cascade
        ON DELETE RESTRICT,
    CONSTRAINT fk_15 FOREIGN KEY (user_id)
        REFERENCES generic_user (user_id)
        ON UPDATE cascade
        ON DELETE RESTRICT
);

CREATE TABLE org_event(
    event_id INT NOT NULL,
    org_id INT NOT NULL,
    CONSTRAINT pk PRIMARY KEY (event_id, org_id),
    CONSTRAINT fk_16 FOREIGN KEY (event_id)
        REFERENCES event (event_id)
        ON UPDATE cascade
        ON DELETE RESTRICT,
    CONSTRAINT fk_17 FOREIGN KEY (org_id)
        REFERENCES organization (org_id)
        ON UPDATE cascade
        ON DELETE RESTRICT
);

insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('abrittoner0', 'Andrea', 'Brittoner', 8198, 'wT2hOc86Qkw', '1986-11-02 05:32:07', 'abrittoner0@dot.gov', 782, '2022-10-05 19:51:03', '473-361-0609', 78, '91');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('ckittoe1', 'Carole', 'Kittoe', 1966, '7GFgu1AfCr', '2003-01-29 03:16:16', 'ckittoe1@amazon.co.uk', 141, '2022-04-13 10:12:03', '660-619-5939', 599, '66715');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('mmagister2', 'Mable', 'Magister', 3396, 'NonEIm6ieB', '2004-09-21 23:48:27', 'mmagister2@nymag.com', 588, '2022-02-15 19:06:27', '964-988-9664', 110, '6814');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('mpinnock3', 'Mart', 'Pinnock', 7204, '4KVpwgv42a4', '1995-07-06 23:21:35', 'mpinnock3@webnode.com', 591, '2021-12-28 15:40:10', '630-833-7522', 565, '11');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('amccroary4', 'Andeee', 'McCroary', 1217, 'XfFEA7CKF8l', '1998-03-08 01:09:33', 'amccroary4@spiegel.de', 26, '2021-01-24 21:37:51', '878-772-4851', 283, '9931');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('jmenico5', 'Jessamine', 'Menico', 1364, 'olWHsntgz', '1968-07-17 23:05:51', 'jmenico5@china.com.cn', 275, '2021-08-16 10:56:39', '635-718-7834', 828, '68');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('aburgill6', 'Alis', 'Burgill', 1007, 'kCBHvo8xe', '1981-01-01 20:38:48', 'aburgill6@nsw.gov.au', 57, '2021-04-06 19:10:41', '489-989-7437', 579, '31');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('opawel7', 'Odella', 'Pawel', 8269, 'jwtxRBxa6', '2001-01-12 04:42:28', 'opawel7@icio.us', 838, '2022-02-04 14:15:04', '909-465-3561', 65, '7308');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('bseary8', 'Biron', 'Seary', 5817, '5wwiJ248', '1984-02-24 05:25:16', 'bseary8@csmonitor.com', 627, '2022-11-01 19:32:02', '157-255-6027', 196, '624');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('gmcleman9', 'Geraldine', 'McLeman', 4235, '7QaSvvSxv8v3', '2003-09-01 08:49:57', 'gmcleman9@latimes.com', 665, '2021-12-09 18:46:14', '196-838-3923', 30, '14');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('falfonsinia', 'Franky', 'Alfonsini', 525, 'CAoGFZi', '1985-07-13 02:47:32', 'falfonsinia@4shared.com', 589, '2022-07-12 21:49:59', '353-171-0346', 89, '6');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('bmcwilliamsb', 'Bette', 'McWilliams', 433, 'DaQah0oWc', '1973-07-29 10:38:38', 'bmcwilliamsb@google.com.au', 502, '2022-05-12 03:39:18', '301-744-4543', 505, '0');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('kleucharsc', 'Kizzie', 'Leuchars', 8045, '87qiYk5C5L', '1981-10-01 03:16:30', 'kleucharsc@godaddy.com', 805, '2022-11-04 19:42:26', '741-865-0422', 120, '3468');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('hkeslaked', 'Hamlin', 'Keslake', 3886, 'azossg3H', '2010-12-21 19:06:17', 'hkeslaked@1und1.de', 623, '2022-08-30 23:35:12', '767-873-5026', 725, '53');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('fimesene', 'Freddie', 'Imesen', 5301, 'kGQOaCp', '2009-09-05 13:41:59', 'fimesene@narod.ru', 716, '2021-10-14 00:43:43', '827-926-0810', 733, '50');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('xhunsworthf', 'Xymenes', 'Hunsworth', 2949, '5jcwYZU7toGR', '1977-02-11 17:24:09', 'xhunsworthf@google.es', 412, '2021-11-26 11:23:12', '235-643-0100', 728, '660');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('nwimburyg', 'Nanette', 'Wimbury', 3130, 'XjImnQH', '2000-04-09 11:29:22', 'nwimburyg@goo.gl', 125, '2021-02-26 11:13:16', '634-733-4673', 737, '319');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('gwinmanh', 'Genvieve', 'Winman', 2449, 'tBPJWhJE5m3', '1990-09-10 23:37:20', 'gwinmanh@whitehouse.gov', 770, '2021-11-14 20:31:20', '390-532-1425', 625, '426');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('rhacaudi', 'Rosmunda', 'Hacaud', 7864, 'KLgMaqFG6KAD', '1989-08-04 03:37:54', 'rhacaudi@bbb.org', 288, '2021-06-25 04:44:02', '602-425-6153', 152, '06902');
insert into generic_user (username, first_name, last_name, num_following, user_password, birthday, email, volunteer_hours, date_joined, phone, num_followers, location) values ('gscutchingsj', 'Genni', 'Scutchings', 5227, 'hOALEB', '1991-02-28 16:56:26', 'gscutchingsj@webs.com', 397, '2022-10-14 21:15:19', '220-271-2922', 888, '53541');

insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Tamar', 'Dmitrievski', 'tdmitrievski0@msn.com', '6HLe0yqF33', 172, '2022-11-05 07:45:05', '186-900-1132', 48688, '1972-05-26 01:30:26');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Zechariah', 'Menzies', 'zmenzies1@hp.com', 'g71CuHCDhyLb', 331, '2021-11-19 10:26:03', '387-360-9975', 35907, '1987-03-16 16:08:45');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Zora', 'Kubal', 'zkubal2@mozilla.org', 'Ulwv7rbdiWvZ', 537, '2021-11-06 03:30:45', '215-308-1354', 49043, '1977-07-17 16:50:50');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Eli', 'O''Kelly', 'eokelly3@disqus.com', 'wETtVLnxy', 426, '2021-12-08 23:59:05', '773-532-6671', 54112, '1988-07-27 08:35:39');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Kamilah', 'Backshell', 'kbackshell4@usgs.gov', 'IKpbbxnS4S', 237, '2021-03-07 13:39:35', '765-978-2552', 49057, '1982-07-24 11:42:04');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Berty', 'Glaves', 'bglaves5@hostgator.com', 'M36omigO7T', 772, '2021-10-24 19:34:12', '799-639-3486', 50009, '1982-01-09 09:49:49');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Bernelle', 'Andriolli', 'bandriolli6@sfgate.com', 'fFGH4fi6x4FQ', 219, '2020-11-21 03:04:00', '159-825-1821', 46484, '1974-08-17 19:38:34');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Issie', 'Reddell', 'ireddell7@infoseek.co.jp', 'zgBQn3IICGY', 589, '2021-06-06 17:02:48', '352-795-4129', 45043, '1968-09-27 07:18:38');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Carine', 'Miner', 'cminer8@homestead.com', 'BmEGEa63CMs', 948, '2022-04-11 05:46:52', '481-876-2242', 42539, '1971-12-14 09:13:46');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Katherina', 'Jandera', 'kjandera9@simplemachines.org', 'q8ysMTEiC', 416, '2022-04-16 19:07:06', '680-303-7699', 62241, '1987-12-17 16:59:54');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Jana', 'Dufaire', 'jdufairea@state.tx.us', 'FJg0a06B2uSW', 371, '2022-10-03 08:54:22', '759-531-0900', 57533, '1980-08-27 23:09:48');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Townie', 'Yurlov', 'tyurlovb@ning.com', 'i7oCGFkIgj', 189, '2021-09-30 03:49:38', '335-152-2329', 58408, '1992-06-21 06:20:36');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Minor', 'Rigmand', 'mrigmandc@over-blog.com', 'jHjNuYp', 44, '2021-04-08 15:31:54', '494-804-0610', 44230, '1984-09-18 21:49:19');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Dominica', 'Faunch', 'dfaunchd@house.gov', 'ALP1O2xQW', 417, '2021-08-17 01:58:13', '794-886-1873', 40137, '1991-01-29 22:05:02');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Roland', 'Wodham', 'rwodhame@jugem.jp', 'KLSCNLSYHF5b', 234, '2022-10-12 04:58:04', '968-567-2394', 61981, '1971-07-30 05:29:56');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Jeana', 'Wabersich', 'jwabersichf@omniture.com', 'MUFKA1tpW', 585, '2022-08-27 21:20:23', '255-597-7226', 34907, '1976-08-30 23:33:20');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Dode', 'Castanie', 'dcastanieg@pinterest.com', 'xQsrmqp', 199, '2022-08-02 13:54:50', '389-302-7016', 51456, '1991-03-15 17:53:43');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Armando', 'Hars', 'aharsh@cpanel.net', 'aYSHiT', 182, '2021-05-31 03:18:46', '624-823-2687', 41356, '2000-01-29 04:31:08');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Gerianna', 'Debrett', 'gdebretti@goo.ne.jp', 'u1l6WpD7J', 76, '2022-07-16 08:14:17', '211-369-8966', 56105, '1969-02-06 06:44:36');
insert into moderator (first_name, last_name, email, mod_password, hours_worked, date_hired, phone, salary, birthday) values ('Dag', 'Brantl', 'dbrantlj@princeton.edu', 'HaZqKIGwhL3K', 952, '2021-01-02 13:26:13', '373-532-0008', 44741, '1982-04-25 11:19:56');

insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (1, 'rmarquez0', 'Crona, Dooley and Roberts', false, 975, 914, 'FGztt9ARz9Z1', '2021-05-23 13:23:38', 'cgrelka0@merriam-webster.com', '(522) 3831251', 8);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (2, 'dpashen1', 'Herman-Prohaska', false, 583, 413, 's84OAP', '2022-05-07 00:41:04', 'hsilversmid1@icio.us', '(524) 7018255', 8);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (3, 'noshiel2', 'Rath, Roob and Rice', false, 754, 948, 'K0at73l', '2021-02-09 19:41:03', 'weaster2@tuttocitta.it', '(767) 5913989', 18);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (4, 'bmotto3', 'Goodwin Group', true, 200, 120, 'ZwRsSDTC1LCF', '2022-02-17 06:03:29', 'hkeith3@archive.org', '(679) 7236926', 9);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (5, 'mgilbertson4', 'Senger, Bernier and Tromp', false, 581, 742, 'o1oUuqv53PC', '2022-01-28 09:08:27', 'rpritchard4@smh.com.au', '(334) 3954805', 8);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (6, 'dtattam5', 'Towne, Hyatt and Rohan', true, 464, 443, 'swdmAQ', '2021-11-18 13:04:59', 'jattree5@wordpress.org', '(449) 4744485', 16);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (7, 'lkilbourne6', 'Hoeger, Shields and Macejkovic', false, 340, 138, 'BqMGILK', '2021-06-05 17:30:55', 'olerer6@marriott.com', '(370) 9693503', 2);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (8, 'pcappineer7', 'Hudson-Nitzsche', false, 421, 841, 'Ur1whGJ', '2021-04-05 22:20:21', 'wblease7@vkontakte.ru', '(821) 3276380', 7);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (9, 'slancett8', 'Mraz-Bradtke', false, 725, 425, 'mFRJlAXVHLW', '2022-07-18 15:00:53', 'rhenner8@cnbc.com', '(714) 8516373', 8);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (10, 'dselway9', 'Corkery and Sons', true, 22, 884, 'q9cu69TlStq', '2022-04-27 17:25:41', 'fshepeard9@cafepress.com', '(155) 3558075', 13);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (11, 'africka', 'Wolff, Murazik and Marks', false, 13, 617, 'dAPVXas', '2022-07-19 21:34:18', 'cishchenkoa@vinaora.com', '(819) 4883082', 12);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (12, 'hstanhopeb', 'Turcotte Group', true, 371, 468, 'xScZlpoHimpq', '2021-12-28 17:54:01', 'wtuffb@about.me', '(944) 4807710', 10);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (13, 'rbradburyc', 'Maggio LLC', false, 868, 81, 'WiYOMrM9wh', '2021-01-06 21:36:00', 'rstenetc@tuttocitta.it', '(385) 7552876', 20);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (14, 'epirisd', 'Murazik, Robel and Schneider', false, 786, 69, 'I6P8h4S3Ap4d', '2021-02-15 12:01:42', 'gerreyd@pinterest.com', '(307) 9066130', 5);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (15, 'jisgatee', 'Shields Inc', true, 710, 314, 'DnlqXVo', '2022-09-14 02:41:24', 'jbettenaye@ebay.com', '(534) 6368671', 14);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (16, 'saistropf', 'Moen-Sawayn', false, 970, 93, 'GbXxVCMPOD0', '2021-08-09 03:06:13', 'sblondellf@shutterfly.com', '(588) 8927564', 18);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (17, 'tbrewg', 'Parisian and Sons', false, 80, 856, 'eGLfWGjoWMZk', '2021-10-24 12:58:18', 'dczajkowskig@unesco.org', '(795) 4383568', 12);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (18, 'jhuoth', 'Schmeler LLC', true, 374, 431, 'tOos8l', '2021-11-29 08:58:40', 'saymesh@e-recht24.de', '(663) 6530919', 6);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (19, 'fdissi', 'Osinski-Tromp', true, 434, 632, 'TRsbcXmvn', '2022-08-05 14:53:53', 'bbaguleyi@squarespace.com', '(845) 5390174', 17);
insert into organization (org_id, username, org_name, verified, num_following, num_followers, org_password, date_joined, email, phone, mod_id) values (20, 'ufennej', 'Schimmel and Sons', true, 397, 851, 'REDz9NL5iFf', '2022-10-07 08:25:34', 'mkeenerj@amazon.co.uk', '(174) 3405690', 3);

insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Hermiston LLC', 903, 'http://dummyimage.com/184x100.png/ff4444/ffffff', 'https://woothemes.com/quis/turpis/eget/elit/sodales/scelerisque.html', 'Oth inflammatory and immune myopathies, NEC', '3129 Sycamore Hill', 37, 166, '2020-12-03 16:17:46');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Rice-O''Connell', 613, 'http://dummyimage.com/150x100.png/5fa2dd/ffffff', 'http://biglobe.ne.jp/massa/id.aspx', 'Hematoma of pinna, left ear', '3 Pleasure Avenue', 66, 635, '2020-11-01 18:21:11');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Wolff-Gottlieb', 993, 'http://dummyimage.com/166x100.png/ff4444/ffffff', 'http://google.ca/volutpat/dui/maecenas/tristique/est.png', 'Toxic effect of carb monx from mtr veh exhaust, acc, subs', '65 Thompson Circle', 52, 27, '2020-12-31 13:31:16');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Tremblay and Sons', 519, 'http://dummyimage.com/178x100.png/dddddd/000000', 'http://posterous.com/justo.jsp', 'Pigmentary glaucoma, bilateral, indeterminate stage', '4 Harper Junction', 91, 298, '2022-02-25 11:49:20');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Ferry, Ankunding and Gorczany', 280, 'http://dummyimage.com/250x100.png/ff4444/ffffff', 'http://t.co/elit/proin/interdum/mauris.jsp', 'Pregnancy related exhaustion and fatigue, first trimester', '61477 Pleasure Drive', 40, 989, '2022-07-24 23:00:04');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Goldner, Johnson and Collier', 404, 'http://dummyimage.com/169x100.png/5fa2dd/ffffff', 'https://chronoengine.com/pellentesque/quisque/porta.html', 'Furuncle unspecified hand', '7124 Graedel Terrace', 27, 349, '2022-04-12 06:59:58');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Huels-Greenholt', 876, 'http://dummyimage.com/119x100.png/5fa2dd/ffffff', 'https://psu.edu/adipiscing/lorem/vitae/mattis/nibh.aspx', 'Prsn brd/alit a car injured in collision w SUV', '4288 La Follette Street', 67, 176, '2022-07-16 07:19:17');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Bergstrom and Sons', 496, 'http://dummyimage.com/150x100.png/dddddd/000000', 'https://infoseek.co.jp/volutpat/convallis.xml', 'Unspecified injury of thigh', '2375 Sommers Hill', 45, 360, '2021-07-14 21:56:44');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Kovacek-Collins', 580, 'http://dummyimage.com/222x100.png/5fa2dd/ffffff', 'http://msn.com/pretium/iaculis/diam/erat/fermentum/justo/nec.js', 'Type 1 diab with severe nonp rtnop with macular edema, unsp', '9389 Golf Parkway', 54, 70, '2020-11-11 07:36:12');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Corkery Group', 263, 'http://dummyimage.com/191x100.png/cc0000/ffffff', 'http://themeforest.net/elementum/eu/interdum/eu/tincidunt/in/leo.html', 'Unspecified sprain of right foot', '43 Brentwood Park', 88, 789, '2022-08-30 15:57:31');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Schoen and Sons', 139, 'http://dummyimage.com/247x100.png/5fa2dd/ffffff', 'https://biblegateway.com/sit/amet/diam/in/magna/bibendum/imperdiet.jsp', 'Poisoning by lysergide [LSD], accidental (unintentional)', '7849 Roth Junction', 45, 181, '2021-05-19 01:30:43');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('McClure-Carroll', 620, 'http://dummyimage.com/214x100.png/5fa2dd/ffffff', 'https://cocolog-nifty.com/lorem/ipsum/dolor/sit/amet/consectetuer.aspx', 'Nondisp fx of med phalanx of unsp less toe(s), 7thB', '090 North Terrace', 66, 665, '2021-09-14 09:57:49');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Ruecker, Senger and Lubowitz', 455, 'http://dummyimage.com/110x100.png/cc0000/ffffff', 'http://nasa.gov/in/tempor/turpis.xml', 'Injury of msl/tnd lng flexor muscle of toe at ank/ft level', '56553 Pierstorff Terrace', 17, 749, '2021-08-06 02:16:00');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Walker LLC', 172, 'http://dummyimage.com/133x100.png/dddddd/000000', 'http://amazon.com/vestibulum/quam/sapien/varius.png', 'Undrdose of unsp drugs aff the autonomic nervous sys, subs', '348 Monica Way', 45, 465, '2022-09-05 12:52:56');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Schowalter, Lang and Jones', 790, 'http://dummyimage.com/220x100.png/5fa2dd/ffffff', 'http://ovh.net/sapien/urna/pretium/nisl/ut/volutpat.jsp', 'Burn of third degree of unspecified foot, initial encounter', '5937 Londonderry Park', 7, 396, '2020-11-07 02:22:49');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Stoltenberg and Sons', 925, 'http://dummyimage.com/242x100.png/cc0000/ffffff', 'https://google.com/et/commodo/vulputate/justo.aspx', 'Juvenile rheumatoid polyarthritis (seronegative)', '893 Arapahoe Drive', 70, 778, '2021-12-23 03:17:05');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Lesch, Kertzmann and Kling', 612, 'http://dummyimage.com/181x100.png/dddddd/000000', 'https://marriott.com/congue/risus/semper/porta/volutpat/quam.xml', 'Sltr-haris Type III physeal fx phalanx of left toe, 7thD', '59752 Mariners Cove Circle', 10, 286, '2021-07-04 00:47:37');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Goyette-Dickinson', 659, 'http://dummyimage.com/172x100.png/ff4444/ffffff', 'https://oaic.gov.au/sed/ante/vivamus/tortor.json', 'Foreign body in other parts of genitourinary tract', '6309 Morning Lane', 56, 327, '2022-01-25 17:41:09');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('O''Hara LLC', 14, 'http://dummyimage.com/208x100.png/ff4444/ffffff', 'http://godaddy.com/elit/proin/interdum/mauris/non/ligula/pellentesque.png', 'Intentional self-harm by drown in natural water, sequela', '559 Doe Crossing Hill', 27, 423, '2020-11-29 09:12:17');
insert into event (event_name, num_reposts, image, link, descr, location, age_restriction, num_volunteers, event_time) values ('Kutch, Robel and Hahn', 843, 'http://dummyimage.com/133x100.png/dddddd/000000', 'https://bbb.org/donec/diam.js', 'Chronic lacrimal canaliculitis of unsp lacrimal passage', '0 Eliot Way', 86, 800, '2021-07-20 02:53:25');


insert into sign_in_sheet (sheet_id, event_id, event_name) values (1, 1, 'Y-Solowarm');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (2, 2, 'Daltfresh');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (3, 3, 'Sonsing');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (4, 4, 'Sonair');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (5, 5, 'Asoka');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (6, 6, 'Alpha');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (7, 7, 'Lotlux');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (8, 8, 'Alpha');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (9, 9, 'Daltfresh');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (10, 10, 'Zaam-Dox');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (11, 11, 'Namfix');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (12, 12, 'Cardify');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (13, 13, 'Bitchip');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (14, 14, 'Lotstring');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (15, 15, 'Sonsing');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (16, 16, 'Sub-Ex');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (17, 17, 'Quo Lux');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (18, 18, 'Cookley');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (19, 19, 'Span');
insert into sign_in_sheet (sheet_id, event_id, event_name) values (20, 20, 'Toughjoyfax');

insert into org_type (org_id, type) values (1, 'Consumer Durables');
insert into org_type (org_id, type) values (2, 'Consumer Services');
insert into org_type (org_id, type) values (3, 'Health Care');
insert into org_type (org_id, type) values (4, 'Animal Care');
insert into org_type (org_id, type) values (5, 'Education');
insert into org_type (org_id, type) values (6, 'Energy');
insert into org_type (org_id, type) values (7, 'Health Care');
insert into org_type (org_id, type) values (8, 'Basic Industries');
insert into org_type (org_id, type) values (9, 'Finance');
insert into org_type (org_id, type) values (10, 'Animal Care');
insert into org_type (org_id, type) values (11, 'Energy');
insert into org_type (org_id, type) values (12, 'Health Care');
insert into org_type (org_id, type) values (13, 'Transportation');
insert into org_type (org_id, type) values (14, 'Consumer Services');
insert into org_type (org_id, type) values (15, 'Energy');
insert into org_type (org_id, type) values (16, 'Health Care');
insert into org_type (org_id, type) values (17, 'Technology');
insert into org_type (org_id, type) values (18, 'Health Care');
insert into org_type (org_id, type) values (19, 'Finance');
insert into org_type (org_id, type) values (20, 'Education');

insert into org_location (org_id, location) values (1, 'Huaishu');
insert into org_location (org_id, location) values (2, 'Filabusi');
insert into org_location (org_id, location) values (3, 'Vysotskoye');
insert into org_location (org_id, location) values (4, 'Huangwan');
insert into org_location (org_id, location) values (5, 'Masatepe');
insert into org_location (org_id, location) values (6, 'Limboto');
insert into org_location (org_id, location) values (7, 'Bulag');
insert into org_location (org_id, location) values (8, 'Kamyanyuki');
insert into org_location (org_id, location) values (9, 'Stoszowice');
insert into org_location (org_id, location) values (10, 'Casais');
insert into org_location (org_id, location) values (11, 'Slawharad');
insert into org_location (org_id, location) values (12, 'Brumadinho');
insert into org_location (org_id, location) values (13, 'Oibioin');
insert into org_location (org_id, location) values (14, 'Waturoka');
insert into org_location (org_id, location) values (15, 'Gävle');
insert into org_location (org_id, location) values (16, 'Palmira');
insert into org_location (org_id, location) values (17, 'San Antonio de los Baños');
insert into org_location (org_id, location) values (18, 'Zaandam');
insert into org_location (org_id, location) values (19, 'Jiatou');
insert into org_location (org_id, location) values (20, 'Trai Ngau');

insert into user_event (event_id, user_id, availability) values (17, 14, 55);
insert into user_event (event_id, user_id, availability) values (13, 15, 52);
insert into user_event (event_id, user_id, availability) values (12, 2, 90);
insert into user_event (event_id, user_id, availability) values (18, 4, 100);
insert into user_event (event_id, user_id, availability) values (16, 11, 4);
insert into user_event (event_id, user_id, availability) values (15, 12, 29);
insert into user_event (event_id, user_id, availability) values (1, 18, 35);
insert into user_event (event_id, user_id, availability) values (7, 5, 46);
insert into user_event (event_id, user_id, availability) values (9, 11, 35);
insert into user_event (event_id, user_id, availability) values (8, 2, 91);
insert into user_event (event_id, user_id, availability) values (6, 17, 32);
insert into user_event (event_id, user_id, availability) values (5, 12, 24);
insert into user_event (event_id, user_id, availability) values (1, 5, 69);
insert into user_event (event_id, user_id, availability) values (10, 1, 82);
insert into user_event (event_id, user_id, availability) values (13, 11, 81);
insert into user_event (event_id, user_id, availability) values (20, 1, 10);
insert into user_event (event_id, user_id, availability) values (14, 20, 76);
insert into user_event (event_id, user_id, availability) values (13, 5, 80);
insert into user_event (event_id, user_id, availability) values (1, 13, 63);
insert into user_event (event_id, user_id, availability) values (13, 18, 56);

insert into org_event (event_id, org_id) values (4, 19);
insert into org_event (event_id, org_id) values (10, 7);
insert into org_event (event_id, org_id) values (19, 13);
insert into org_event (event_id, org_id) values (8, 4);
insert into org_event (event_id, org_id) values (17, 3);
insert into org_event (event_id, org_id) values (15, 9);
insert into org_event (event_id, org_id) values (1, 11);
insert into org_event (event_id, org_id) values (9, 3);
insert into org_event (event_id, org_id) values (12, 16);
insert into org_event (event_id, org_id) values (17, 18);
insert into org_event (event_id, org_id) values (12, 13);
insert into org_event (event_id, org_id) values (3, 1);
insert into org_event (event_id, org_id) values (14, 2);
insert into org_event (event_id, org_id) values (20, 15);
insert into org_event (event_id, org_id) values (6, 6);
insert into org_event (event_id, org_id) values (4, 8);
insert into org_event (event_id, org_id) values (6, 5);
insert into org_event (event_id, org_id) values (20, 8);
insert into org_event (event_id, org_id) values (3, 11);
insert into org_event (event_id, org_id) values (2, 10);

insert into user_follow_user (user_id, follow_id) values (4, 9);
insert into user_follow_user (user_id, follow_id) values (16, 20);
insert into user_follow_user (user_id, follow_id) values (4, 10);
insert into user_follow_user (user_id, follow_id) values (15, 15);
insert into user_follow_user (user_id, follow_id) values (10, 9);
insert into user_follow_user (user_id, follow_id) values (2, 1);
insert into user_follow_user (user_id, follow_id) values (18, 17);
insert into user_follow_user (user_id, follow_id) values (15, 16);
insert into user_follow_user (user_id, follow_id) values (5, 16);
insert into user_follow_user (user_id, follow_id) values (6, 1);
insert into user_follow_user (user_id, follow_id) values (4, 16);
insert into user_follow_user (user_id, follow_id) values (18, 16);
insert into user_follow_user (user_id, follow_id) values (20, 13);
insert into user_follow_user (user_id, follow_id) values (3, 12);
insert into user_follow_user (user_id, follow_id) values (7, 8);
insert into user_follow_user (user_id, follow_id) values (13, 20);
insert into user_follow_user (user_id, follow_id) values (16, 13);
insert into user_follow_user (user_id, follow_id) values (20, 6);
insert into user_follow_user (user_id, follow_id) values (7, 1);
insert into user_follow_user (user_id, follow_id) values (15, 8);

insert into user_follow_org (user_id, follow_id) values (19, 8);
insert into user_follow_org (user_id, follow_id) values (9, 5);
insert into user_follow_org (user_id, follow_id) values (19, 5);
insert into user_follow_org (user_id, follow_id) values (2, 13);
insert into user_follow_org (user_id, follow_id) values (9, 15);
insert into user_follow_org (user_id, follow_id) values (19, 18);
insert into user_follow_org (user_id, follow_id) values (12, 11);
insert into user_follow_org (user_id, follow_id) values (12, 7);
insert into user_follow_org (user_id, follow_id) values (2, 14);
insert into user_follow_org (user_id, follow_id) values (18, 14);
insert into user_follow_org (user_id, follow_id) values (13, 18);
insert into user_follow_org (user_id, follow_id) values (3, 19);
insert into user_follow_org (user_id, follow_id) values (7, 11);
insert into user_follow_org (user_id, follow_id) values (1, 20);
insert into user_follow_org (user_id, follow_id) values (10, 11);
insert into user_follow_org (user_id, follow_id) values (10, 14);
insert into user_follow_org (user_id, follow_id) values (13, 1);
insert into user_follow_org (user_id, follow_id) values (4, 19);
insert into user_follow_org (user_id, follow_id) values (13, 19);
insert into user_follow_org (user_id, follow_id) values (14, 15);

insert into org_follow_org (org_id, follow_id) values (14, 6);
insert into org_follow_org (org_id, follow_id) values (3, 9);
insert into org_follow_org (org_id, follow_id) values (15, 18);
insert into org_follow_org (org_id, follow_id) values (4, 14);
insert into org_follow_org (org_id, follow_id) values (5, 4);
insert into org_follow_org (org_id, follow_id) values (15, 4);
insert into org_follow_org (org_id, follow_id) values (5, 6);
insert into org_follow_org (org_id, follow_id) values (20, 8);
insert into org_follow_org (org_id, follow_id) values (8, 14);
insert into org_follow_org (org_id, follow_id) values (18, 16);
insert into org_follow_org (org_id, follow_id) values (11, 4);
insert into org_follow_org (org_id, follow_id) values (3, 19);
insert into org_follow_org (org_id, follow_id) values (1, 10);
insert into org_follow_org (org_id, follow_id) values (3, 20);
insert into org_follow_org (org_id, follow_id) values (12, 10);
insert into org_follow_org (org_id, follow_id) values (6, 15);
insert into org_follow_org (org_id, follow_id) values (6, 13);
insert into org_follow_org (org_id, follow_id) values (1, 15);
insert into org_follow_org (org_id, follow_id) values (9, 8);
insert into org_follow_org (org_id, follow_id) values (4, 9);

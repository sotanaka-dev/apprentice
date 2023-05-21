CREATE TABLE channels (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE programs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL
);

CREATE TABLE genres (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE seasons (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    season_num INT,
    is_single_episode BOOLEAN NOT NULL DEFAULT FALSE,
    program_id BIGINT REFERENCES programs(id)
);

CREATE TABLE channel_programs (
    channel_id BIGINT REFERENCES channels(id),
    program_id BIGINT REFERENCES programs(id),
    PRIMARY KEY (channel_id, program_id)
);

CREATE TABLE program_genres (
    genre_id BIGINT REFERENCES genres(id),
    program_id BIGINT REFERENCES programs(id),
    PRIMARY KEY (genre_id, program_id)
);

CREATE TABLE episodes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    episode_num INT,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    duration TIME NOT NULL,
    release_date DATE NOT NULL,
    season_id BIGINT NOT NULL REFERENCES seasons(id)
);

CREATE TABLE program_slots (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    channel_id BIGINT NOT NULL REFERENCES channels(id)
);

CREATE TABLE broadcast_episodes (
    program_slot_id BIGINT REFERENCES program_slots(id),
    episode_id BIGINT REFERENCES episodes(id),
    view_count BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (program_slot_id, episode_id)
);

INSERT INTO channels (name) VALUES
('チャンネル1'),
('チャンネル2'),
('チャンネル3'),
('チャンネル4'),
('チャンネル5');

INSERT INTO programs (title, description) VALUES
('番組1', '詳細'),
('番組2', '詳細'),
('番組3', '詳細'),
('番組4', '詳細'),
('番組5', '詳細');

INSERT INTO genres (name) VALUES
('ジャンル1'),
('ジャンル2'),
('ジャンル3'),
('ジャンル4'),
('ジャンル5'),
('ジャンル6');

INSERT INTO seasons (season_num, is_single_episode, program_id) VALUES
(1, false, 1),
(2, false, 1),
(1, false, 2),
(NULL, true, 3),
(NULL, true, 4),
(NULL, true, 5);

INSERT INTO channel_programs (channel_id, program_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO program_genres (genre_id, program_id) VALUES
(1, 1),
(3, 1),
(5, 1),
(2, 2),
(3, 3),
(4, 4),
(6, 4),
(5, 5);

INSERT INTO episodes (episode_num, title, description, duration, release_date, season_id) VALUES
(1, '番組1 シーズン1 エピソード1', '詳細', '01:00:00', '2023-02-02', 1),
(2, '番組1 シーズン1 エピソード2', '詳細', '01:00:00', '2023-02-09', 1),
(3, '番組1 シーズン1 エピソード3', '詳細', '01:00:00', '2023-02-16', 1),
(4, '番組1 シーズン1 エピソード4', '詳細', '01:00:00', '2023-02-23', 1),
(5, '番組1 シーズン1 エピソード5', '詳細', '01:00:00', '2023-03-02', 1),
(6, '番組1 シーズン1 エピソード6', '詳細', '01:00:00', '2023-03-09', 1),
(7, '番組1 シーズン1 エピソード7', '詳細', '01:00:00', '2023-03-16', 1),
(8, '番組1 シーズン1 エピソード8', '詳細', '01:00:00', '2023-03-23', 1),
(1, '番組1 シーズン2 エピソード1', '詳細', '01:00:00', '2023-05-11', 2),
(2, '番組1 シーズン2 エピソード2', '詳細', '01:00:00', '2023-05-18', 2),
(3, '番組1 シーズン2 エピソード3', '詳細', '01:00:00', '2023-05-25', 2),
(4, '番組1 シーズン2 エピソード4', '詳細', '01:00:00', '2023-06-01', 2),
(5, '番組1 シーズン2 エピソード5', '詳細', '01:00:00', '2023-06-08', 2),
(6, '番組1 シーズン2 エピソード6', '詳細', '01:00:00', '2023-06-15', 2),
(7, '番組1 シーズン2 エピソード7', '詳細', '01:00:00', '2023-06-22', 2),
(8, '番組1 シーズン2 エピソード8', '詳細', '01:00:00', '2023-06-29', 2),
(1, '番組2 シーズン1 エピソード1', '詳細', '01:30:00', '2023-04-29', 3),
(2, '番組2 シーズン1 エピソード2', '詳細', '01:30:00', '2023-05-06', 3),
(3, '番組2 シーズン1 エピソード3', '詳細', '01:30:00', '2023-05-13', 3),
(4, '番組2 シーズン1 エピソード4', '詳細', '01:30:00', '2023-05-20', 3),
(NULL, '番組3', '詳細', '02:00:00', '2023-05-20', 4),
(NULL, '番組4', '詳細', '02:00:00', '2023-05-21', 5),
(NULL, '番組5', '詳細', '02:30:00', '2023-05-28', 6);

INSERT INTO program_slots (start_time, end_time, channel_id) VALUES
('2023-02-02 20:00:00', '2023-02-02 21:00:00', 1),
('2023-02-09 20:00:00', '2023-02-09 21:00:00', 1),
('2023-02-16 20:00:00', '2023-02-16 21:00:00', 1),
('2023-02-23 20:00:00', '2023-02-23 21:00:00', 1),
('2023-03-02 20:00:00', '2023-03-02 21:00:00', 1),
('2023-03-09 20:00:00', '2023-03-09 21:00:00', 1),
('2023-03-16 20:00:00', '2023-03-16 21:00:00', 1),
('2023-03-23 20:00:00', '2023-03-23 21:00:00', 1),
('2023-05-11 20:00:00', '2023-05-11 21:00:00', 1),
('2023-05-18 20:00:00', '2023-05-18 21:00:00', 1),
('2023-05-25 20:00:00', '2023-05-25 21:00:00', 1),
('2023-06-01 20:00:00', '2023-06-01 21:00:00', 1),
('2023-06-08 20:00:00', '2023-06-08 21:00:00', 1),
('2023-06-15 20:00:00', '2023-06-15 21:00:00', 1),
('2023-06-22 20:00:00', '2023-06-22 21:00:00', 1),
('2023-06-29 20:00:00', '2023-06-29 21:00:00', 1),
('2023-04-29 22:00:00', '2023-04-29 22:00:00', 2),
('2023-05-06 22:00:00', '2023-05-06 22:00:00', 2),
('2023-05-13 22:00:00', '2023-05-13 22:00:00', 2),
('2023-05-20 22:00:00', '2023-05-20 22:00:00', 2),
('2023-05-20 21:00:00', '2023-05-20 23:00:00', 3),
('2023-05-21 21:00:00', '2023-05-21 23:00:00', 4),
('2023-05-28 21:00:00', '2023-05-28 23:30:00', 5);

INSERT INTO broadcast_episodes (program_slot_id, episode_id, view_count) VALUES
(1, 1, 1000),
(2, 2, 12000),
(3, 3, 1500),
(4, 4, 1700),
(5, 5, 20000),
(6, 6, 2200),
(7, 7, 2500),
(8, 8, 2700),
(9, 9, 3000),
(10, 10, 35000),
(11, 11, 4000),
(12, 12, 3500),
(13, 13, 5000),
(14, 14, 5500),
(15, 15, 20000),
(16, 16, 6500),
(17, 17, 3000),
(18, 18, 5500),
(19, 19, 2000),
(20, 20, 8500),
(21, 21, 50000),
(22, 22, 9500),
(23, 23, 2000);

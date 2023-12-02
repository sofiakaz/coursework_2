CREATE TABLE IF NOT EXISTS genre (
    genre_id SERIAL PRIMARY KEY,
    title VARCHAR(60) NOT NULL
);

CREATE TABLE IF NOT EXISTS artist (
    artist_id SERIAL PRIMARY KEY,
    nickname VARCHAR(60) NOT NULL
);

CREATE TABLE IF NOT EXISTS album (
    album_id SERIAL PRIMARY KEY,
    title VARCHAR(60) NOT NULL,
    year_of_issue INTEGER CHECK (year_of_issue >= 1000 AND year_of_issue <= 2023)
);

CREATE TABLE IF NOT EXISTS song (
    song_id SERIAL PRIMARY KEY,
    song_name VARCHAR(60) NOT NULL,
    year_of_issue INTEGER CHECK (year_of_issue >= 1000 AND year_of_issue <= 2023),
    album_id INTEGER NOT NULL REFERENCES album(album_id)
);

CREATE TABLE IF NOT EXISTS songbook (
    songbook_id SERIAL PRIMARY KEY,
    title VARCHAR(60) NOT NULL,
    year_of_issue INTEGER CHECK (year_of_issue >= 1000 AND year_of_issue <= 2023)
);

CREATE TABLE IF NOT EXISTS chosen_genre (
    genre_id INTEGER NOT NULL REFERENCES genre(genre_id),
    artist_id INTEGER NOT NULL REFERENCES artist(artist_id)
);

CREATE TABLE IF NOT EXISTS albums_and_artists (
    album_id INTEGER NOT NULL REFERENCES album(album_id),
    artist_id INTEGER NOT NULL REFERENCES artist(artist_id)
);

CREATE TABLE IF NOT EXISTS songs_in_songbooks (
    song_id INTEGER NOT NULL REFERENCES song(song_id),
    songbook_id INTEGER NOT NULL REFERENCES songbook(songbook_id)
);

INSERT INTO genre (genre_id, title)
VALUES
(1,'Alternative'),
(2,'Pop music'),
(3,'Rock');

INSERT INTO artist (artist_id, nickname)
VALUES
(1,'Radiohead'),
(2,'Coldplay'),
(3,'Novo Amor'),
(4,'Conan Gray'),
(5,'The Neighbourhood'),
(6,'The Beatles');

INSERT INTO chosen_genre (genre_id, artist_id)
VALUES
(1,1),
(1,3),
(1,5),
(2,2),
(2,4),
(3,6);

INSERT INTO album (album_id, title, year_of_issue)
VALUES
(1,'Pablo Honey', 1993),
(2,'Parachutes', 2000),
(3,'Bathing Beach', 2017),
(4,'Kid Krow', 2020),
(5,'I Love You', 2013),
(6,'Live From Las Vegas!', 2007);

INSERT INTO song (song_id, song_name, year_of_issue, album_id)
VALUES
(1,'Creep', 1993, 1),
(2,'Yellow', 2000, 2),
(3,'Anchor', 2017, 3),
(4,'Heather', 2020, 4),
(5,'Sweater Weather', 2013, 5),
(6,'Here comes the sun', 2009, 6);

INSERT INTO albums_and_artists (album_id, artist_id)
VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6);

INSERT INTO songbook (songbook_id, title, year_of_issue)
VALUES
(1,'Best albums of the 20th century', 2000),
(2,'Best albums of the 21th century', 2023),
(3,'Best songs in the alternative genre', 2018),
(4,'Best modern albums', 2021);

INSERT INTO songs_in_songbooks (song_id, songbook_id)
VALUES
(1,1),
(2,2),
(5,2),
(6,2),
(1,3),
(3,3),
(5,3),
(4,4);

ALTER TABLE song
ADD COLUMN duration VARCHAR(10);

UPDATE song
SET duration = 
    CASE
        WHEN song_name = 'Creep' THEN '03:57'
        WHEN song_name = 'Yellow' THEN '04:33' 
        WHEN song_name = 'Anchor' THEN '04:16' 
        WHEN song_name = 'Heather' THEN '03:26'
        WHEN song_name = 'Sweater Weather' THEN '04:01' 
        WHEN song_name = 'Here comes the sun' THEN '03:12' 
    END;
 
SELECT song_name, duration
FROM song
ORDER BY 
    (SPLIT_PART(duration, ':', 1)::INT * 60 + SPLIT_PART(duration, ':', 2)::INT) DESC
LIMIT 1;

SELECT song_name, duration
FROM song
WHERE 
    (SPLIT_PART(duration, ':', 1)::INT * 60 + SPLIT_PART(duration, ':', 2)::INT) >= 3.5 * 60;
   
SELECT title
FROM songbook
WHERE year_of_issue BETWEEN 2018 AND 2020;

SELECT nickname
FROM artist
WHERE POSITION(' ' IN nickname) = 0;

SELECT song_name, duration
FROM song
WHERE LOWER(song_name) LIKE '%мой%' OR LOWER(song_name) LIKE '%my%';

SELECT g.title AS genre, COUNT(cg.artist_id) AS number_of_artists
FROM genre g
LEFT JOIN chosen_genre cg ON g.genre_id = cg.genre_id
GROUP BY g.title;

SELECT COUNT(*) AS number_of_tracks
FROM song s
JOIN album a ON s.album_id = a.album_id
WHERE a.year_of_issue BETWEEN 2019 AND 2020;

SELECT a.title AS album_title, AVG((SPLIT_PART(s.duration, ':', 1)::INT * 60 + SPLIT_PART(s.duration, ':', 2)::INT)::NUMERIC) AS average_duration
FROM album a
JOIN song s ON a.album_id = s.album_id
GROUP BY a.title;

SELECT a.nickname AS artist_name
FROM artist a
LEFT JOIN albums_and_artists aa ON a.artist_id = aa.artist_id
LEFT JOIN album al ON aa.album_id = al.album_id
WHERE al.year_of_issue IS NULL OR al.year_of_issue <> 2020;

SELECT sb.title AS songbook_title
FROM songbook sb
JOIN songs_in_songbooks ss ON sb.songbook_id = ss.songbook_id
JOIN song s ON ss.song_id = s.song_id
JOIN albums_and_artists aa ON s.album_id = aa.album_id
JOIN artist a ON aa.artist_id = a.artist_id
WHERE a.nickname = 'Radiohead'; 















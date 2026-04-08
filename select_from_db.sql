SELECT name AS track_name
FROM tracks
WHERE duration = (SELECT MAX(duration) FROM tracks);

SELECT name AS track_name
FROM tracks
WHERE duration >= 210
ORDER BY duration DESC;

SELECT name AS collection_name, release_date
FROM collections
WHERE EXTRACT(YEAR FROM release_date) BETWEEN 2018 AND 2020
ORDER BY release_date;

SELECT name AS artist_name
FROM artists
WHERE POSITION(' ' IN name) = 0;

SELECT name AS track_name
FROM tracks
WHERE LOWER(name) LIKE '%my%' OR LOWER(name) LIKE '%мой%';

SELECT g.name AS genre, COUNT(ag.artist_id) AS artist_count
FROM genres g
LEFT JOIN artist_genres ag ON g.genre_id = ag.genre_id
GROUP BY g.genre_id, g.name
ORDER BY artist_count DESC;

SELECT COUNT(t.track_id) AS tracks_count
FROM tracks t
JOIN albums a ON t.album_id = a.album_id
WHERE EXTRACT(YEAR FROM a.release_date) BETWEEN 2019 AND 2020;

SELECT a.name AS album_name, AVG(t.duration) AS avg_duration_seconds
FROM albums a
JOIN tracks t ON a.album_id = t.album_id
GROUP BY a.album_id, a.name
ORDER BY a.release_date;

SELECT ar.name AS artist_name
FROM artists ar
WHERE ar.artist_id NOT IN (
    SELECT DISTINCT aa.artist_id
    FROM artist_albums aa
    JOIN albums a ON aa.album_id = a.album_id
    WHERE EXTRACT(YEAR FROM a.release_date) = 2020
)
ORDER BY ar.name;

SELECT DISTINCT c.name AS collection_name
FROM collections c
JOIN collection_tracks ct ON c.collection_id = ct.collection_id
JOIN tracks t ON ct.track_id = t.track_id
JOIN artist_albums aa ON t.album_id = aa.album_id
JOIN artists ar ON aa.artist_id = ar.artist_id
WHERE ar.name = 'Queen'
ORDER BY c.name;
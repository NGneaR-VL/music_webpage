-- 1. Заполнение справочных таблиц

-- Жанры (не менее 3)
INSERT INTO genres (name) VALUES
    ('Rock'),
    ('Pop'),
    ('Electronic')
ON CONFLICT (name) DO NOTHING;

-- Исполнители (не менее 4)
INSERT INTO artists (name) VALUES
    ('The Beatles'),
    ('Taylor Swift'),
    ('Daft Punk'),
    ('Queen')
ON CONFLICT (name) DO NOTHING;

-- Альбомы (не менее 4, чтобы каждый исполнитель имел хотя бы один альбом)
INSERT INTO albums (name, release_date) VALUES
    ('Abbey Road', '1969-09-26'),
    ('1989', '2014-10-27'),
    ('Random Access Memories', '2013-05-17'),
    ('A Night at the Opera', '1975-11-21')
ON CONFLICT DO NOTHING;

-- Добавляем альбомы 2019 и 2020 годов
INSERT INTO albums (name, release_date) VALUES
    ('Random Access Memories 2', '2019-01-01'),
    ('Folklore', '2020-07-24')
ON CONFLICT DO NOTHING;

-- Треки (не менее 8 – по 2 на альбом)
INSERT INTO tracks (name, duration, album_id) VALUES
    -- Abbey Road (album_id = 1, но используем подзапросы для надёжности)
    ('Come Together', 259, (SELECT album_id FROM albums WHERE name = 'Abbey Road')),
    ('Here Comes the Sun', 223, (SELECT album_id FROM albums WHERE name = 'Abbey Road')),
    -- 1989
    ('Shake It Off', 219, (SELECT album_id FROM albums WHERE name = '1989')),
    ('Blank Space', 231, (SELECT album_id FROM albums WHERE name = '1989')),
    -- Random Access Memories
    ('Get Lucky', 368, (SELECT album_id FROM albums WHERE name = 'Random Access Memories')),
    ('Lose Yourself to Dance', 353, (SELECT album_id FROM albums WHERE name = 'Random Access Memories')),
    -- A Night at the Opera
    ('Bohemian Rhapsody', 354, (SELECT album_id FROM albums WHERE name = 'A Night at the Opera')),
    ('You''re My Best Friend', 172, (SELECT album_id FROM albums WHERE name = 'A Night at the Opera'));

-- Добавляем треки для альбомов 2019 и 2020 годов (не менее 2 на альбом, чтобы было)
INSERT INTO tracks (name, duration, album_id) VALUES
    ('New Wave', 300, (SELECT album_id FROM albums WHERE name = 'Random Access Memories 2')),
    ('Electro Dream', 240, (SELECT album_id FROM albums WHERE name = 'Random Access Memories 2')),
    ('Cardigan', 240, (SELECT album_id FROM albums WHERE name = 'Folklore')),
    ('Exile', 270, (SELECT album_id FROM albums WHERE name = 'Folklore'))
ON CONFLICT DO NOTHING;


-- 2. Связи исполнителей с жанрами (многие ко многим)

INSERT INTO artist_genres (artist_id, genre_id)
VALUES
    ((SELECT artist_id FROM artists WHERE name = 'The Beatles'), (SELECT genre_id FROM genres WHERE name = 'Rock')),
    ((SELECT artist_id FROM artists WHERE name = 'Taylor Swift'), (SELECT genre_id FROM genres WHERE name = 'Pop')),
    ((SELECT artist_id FROM artists WHERE name = 'Daft Punk'), (SELECT genre_id FROM genres WHERE name = 'Electronic')),
    ((SELECT artist_id FROM artists WHERE name = 'Queen'), (SELECT genre_id FROM genres WHERE name = 'Rock'))
ON CONFLICT (artist_id, genre_id) DO NOTHING;


-- 3. Связи исполнителей с альбомами

INSERT INTO artist_albums (artist_id, album_id)
VALUES
    ((SELECT artist_id FROM artists WHERE name = 'The Beatles'), (SELECT album_id FROM albums WHERE name = 'Abbey Road')),
    ((SELECT artist_id FROM artists WHERE name = 'Taylor Swift'), (SELECT album_id FROM albums WHERE name = '1989')),
    ((SELECT artist_id FROM artists WHERE name = 'Daft Punk'), (SELECT album_id FROM albums WHERE name = 'Random Access Memories')),
    ((SELECT artist_id FROM artists WHERE name = 'Queen'), (SELECT album_id FROM albums WHERE name = 'A Night at the Opera'))
ON CONFLICT (artist_id, album_id) DO NOTHING;

-- Добавляем связь исполнителей с альбомами 2019 и 2020 годов (artist_albums)
INSERT INTO artist_albums (artist_id, album_id) VALUES
    ((SELECT artist_id FROM artists WHERE name = 'Daft Punk'), (SELECT album_id FROM albums WHERE name = 'Random Access Memories 2')),
    ((SELECT artist_id FROM artists WHERE name = 'Taylor Swift'), (SELECT album_id FROM albums WHERE name = 'Folklore'))
ON CONFLICT DO NOTHING;


-- 4. Сборники (не менее 4)

INSERT INTO collections (name, release_date) VALUES
    ('Greatest Rock Hits', '2020-01-01'),
    ('Pop Party', '2021-06-15'),
    ('Electronic Beats', '2019-11-20'),
    ('Classic Anthems', '2022-03-10')
ON CONFLICT DO NOTHING;


-- 5. Связи сборников с треками (каждый сборник содержит 2-3 трека)

-- Greatest Rock Hits: Rock-треки
INSERT INTO collection_tracks (collection_id, track_id)
VALUES
    ((SELECT collection_id FROM collections WHERE name = 'Greatest Rock Hits'), (SELECT track_id FROM tracks WHERE name = 'Come Together')),
    ((SELECT collection_id FROM collections WHERE name = 'Greatest Rock Hits'), (SELECT track_id FROM tracks WHERE name = 'Here Comes the Sun')),
    ((SELECT collection_id FROM collections WHERE name = 'Greatest Rock Hits'), (SELECT track_id FROM tracks WHERE name = 'Bohemian Rhapsody'))
ON CONFLICT (collection_id, track_id) DO NOTHING;

-- Pop Party: поп-треки + немного диско
INSERT INTO collection_tracks (collection_id, track_id)
VALUES
    ((SELECT collection_id FROM collections WHERE name = 'Pop Party'), (SELECT track_id FROM tracks WHERE name = 'Shake It Off')),
    ((SELECT collection_id FROM collections WHERE name = 'Pop Party'), (SELECT track_id FROM tracks WHERE name = 'Blank Space')),
    ((SELECT collection_id FROM collections WHERE name = 'Pop Party'), (SELECT track_id FROM tracks WHERE name = 'Get Lucky'))
ON CONFLICT (collection_id, track_id) DO NOTHING;

-- Electronic Beats: электронные треки
INSERT INTO collection_tracks (collection_id, track_id)
VALUES
    ((SELECT collection_id FROM collections WHERE name = 'Electronic Beats'), (SELECT track_id FROM tracks WHERE name = 'Get Lucky')),
    ((SELECT collection_id FROM collections WHERE name = 'Electronic Beats'), (SELECT track_id FROM tracks WHERE name = 'Lose Yourself to Dance'))
ON CONFLICT (collection_id, track_id) DO NOTHING;

-- Classic Anthems: классика рока и поп-хиты
INSERT INTO collection_tracks (collection_id, track_id)
VALUES
    ((SELECT collection_id FROM collections WHERE name = 'Classic Anthems'), (SELECT track_id FROM tracks WHERE name = 'Bohemian Rhapsody')),
    ((SELECT collection_id FROM collections WHERE name = 'Classic Anthems'), (SELECT track_id FROM tracks WHERE name = 'Come Together')),
    ((SELECT collection_id FROM collections WHERE name = 'Classic Anthems'), (SELECT track_id FROM tracks WHERE name = 'Shake It Off'))
ON CONFLICT (collection_id, track_id) DO NOTHING;
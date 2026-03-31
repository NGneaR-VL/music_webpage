-- 1. Жанры
CREATE TABLE IF NOT EXISTS genres (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(60) NOT NULL UNIQUE
);

-- 2. Исполнители
CREATE TABLE IF NOT EXISTS artists (
    artist_id SERIAL PRIMARY KEY,
    name VARCHAR(60) NOT NULL UNIQUE
);

-- 3. Альбомы
CREATE TABLE IF NOT EXISTS albums (
    album_id SERIAL PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    release_date DATE NOT NULL
);

-- 4. Треки
CREATE TABLE IF NOT EXISTS tracks (
    track_id SERIAL PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    duration INTEGER NOT NULL,
    album_id INTEGER NOT NULL REFERENCES albums(album_id) ON DELETE CASCADE
);

-- 5. Связь исполнителей с жанрами (многие ко многим)
CREATE TABLE IF NOT EXISTS artist_genres (
    artist_id INTEGER NOT NULL REFERENCES artists(artist_id) ON DELETE CASCADE,
    genre_id INTEGER NOT NULL REFERENCES genres(genre_id) ON DELETE CASCADE,
    PRIMARY KEY (artist_id, genre_id)
);

-- 6. Связь исполнителей с альбомами (многие ко многим)
CREATE TABLE IF NOT EXISTS artist_albums (
    artist_id INTEGER NOT NULL REFERENCES artists(artist_id) ON DELETE CASCADE,
    album_id INTEGER NOT NULL REFERENCES albums(album_id) ON DELETE CASCADE,
    PRIMARY KEY (artist_id, album_id)
);

-- 7. Коллекции (сборники)
CREATE TABLE IF NOT EXISTS collections (
    collection_id SERIAL PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    release_date DATE NOT NULL
);

-- 8. Связь треков с коллекциями (многие ко многим)
CREATE TABLE IF NOT EXISTS collection_tracks (
    collection_id INTEGER NOT NULL REFERENCES collections(collection_id) ON DELETE CASCADE,
    track_id INTEGER NOT NULL REFERENCES tracks(track_id) ON DELETE CASCADE,
    PRIMARY KEY (collection_id, track_id)
);
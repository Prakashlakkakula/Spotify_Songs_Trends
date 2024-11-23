CREATE DATABASE spotify_data

CREATE TABLE spotify_songs (
    song_id VARCHAR(20) PRIMARY KEY,    -- Unique identifier for each song
    song_title VARCHAR(255),            -- Title of the song
    artist VARCHAR(255),                -- Artist of the song
    album VARCHAR(255),                 -- Album the song belongs to
    genre VARCHAR(50),                  -- Genre of the song
    release_date DATE,                  -- Release date of the song
    duration INT,                       -- Duration of the song in seconds
    popularity INT,                     -- Popularity score of the song
    stream INT,                         -- Number of streams
    language VARCHAR(50),               -- Language of the song
    explicit_content VARCHAR(3),        -- Explicit content (Yes/No)
    label VARCHAR(255)                  -- Music label associated with the song
);


-- This query selects all the columns and rows from the spotify_songs table.
SELECT * 
FROM spotify_songs;


-- Categorizes songs into 'High', 'Medium', or 'Low' based on their popularity score.
SELECT
    song_id,
    song_title,
    CASE
        WHEN popularity >= 50 THEN 'High'
        WHEN popularity >= 30 THEN 'Medium'
        ELSE 'Low'
    END AS popularity_category
FROM spotify_songs;


-- Groups songs by genre and counts how many songs there are in each genre.
SELECT genre, COUNT(song_id) AS song_count
FROM spotify_songs
GROUP BY genre;


-- Groups songs by genre and filters to only include genres with more than 10 songs.
SELECT genre, COUNT(song_id) AS song_count
FROM spotify_songs
GROUP BY genre
HAVING COUNT(song_id) > 10;


-- Retrieves the average popularity for each artist using a subquery in the SELECT clause.
SELECT 
    artist,
    (SELECT AVG(popularity) FROM spotify_songs WHERE artist = s.artist) AS avg_popularity
FROM spotify_songs s
ORDER BY artist;


-- Uses a subquery in the FROM clause to filter songs with popularity greater than 50.
SELECT artist, COUNT(song_id) AS high_popularity_songs
FROM (
    SELECT song_id, artist
    FROM spotify_songs
    WHERE popularity > 50
) AS high_popularity
GROUP BY artist;


-- Retrieves all songs where the genre is either 'Pop' or 'Electronic'.
SELECT song_id, song_title, genre
FROM spotify_songs
WHERE genre IN ('Pop', 'Electronic');


-- Retrieves all songs where the genre is neither 'Pop' nor 'Electronic'.
SELECT song_id, song_title, genre
FROM spotify_songs
WHERE genre NOT IN ('Pop', 'Electronic');


-- Retrieves songs that have NULL values for the album column.
SELECT song_id, song_title, album
FROM spotify_songs
WHERE album IS NULL;


-- Retrieves songs with popularity between 30 and 60.
SELECT song_id, song_title, popularity
FROM spotify_songs
WHERE popularity BETWEEN 30 AND 60;


-- Retrieves all songs and sorts them by popularity in descending order.
SELECT song_id, song_title, popularity
FROM spotify_songs
ORDER BY popularity DESC;


-- Retrieves a list of distinct genres in the dataset.
SELECT DISTINCT genre
FROM spotify_songs;


-- Retrieves the first 5 songs from the dataset.
SELECT song_id, song_title, popularity
FROM spotify_songs
LIMIT 5;


-- Renames the popularity column to 'song_popularity' for clarity.
SELECT song_id, song_title, popularity AS song_popularity
FROM spotify_songs;


-- Extracts the year from the release_date of the songs.
SELECT song_id, song_title, EXTRACT(YEAR FROM release_date) AS release_year
FROM spotify_songs;


-- Retrieves all songs and converts the artist names to uppercase.
SELECT song_id, song_title, UPPER(artist) AS artist_upper
FROM spotify_songs;


-- Retrieves all songs and the length of their song titles.
SELECT song_id, song_title, LENGTH(song_title) AS title_length
FROM spotify_songs;


-- Retrieves songs and trims any leading or trailing spaces from the song titles.
SELECT song_id, TRIM(song_title) AS trimmed_title
FROM spotify_songs;


-- Concatenates song title and artist name into one string.
SELECT song_id, CONCAT(song_title, ' - ', artist) AS song_artist
FROM spotify_songs;


-- Retrieves songs with popularity greater than 50 and explicit content marked as 'Yes'.
SELECT song_id, song_title, popularity, explicit_content
FROM spotify_songs
WHERE popularity > 50 AND explicit_content = 'Yes';


-- Retrieves all songs whose titles contain the word 'Space'.
SELECT song_id, song_title
FROM spotify_songs
WHERE song_title LIKE '%Space%';


-- Creates a summary of song categories ('High', 'Medium', 'Low') based on popularity and year.
SELECT 
    EXTRACT(YEAR FROM release_date) AS release_year,
    CASE 
        WHEN popularity >= 50 THEN 'High'
        WHEN popularity >= 30 THEN 'Medium'
        ELSE 'Low'
    END AS popularity_category,
    COUNT(song_id) AS song_count
FROM spotify_songs
GROUP BY release_year, popularity_category
ORDER BY release_year DESC;


-- Assuming there is a `spotify_labels` table with a `label` column, this joins the song data with label information.
SELECT s.song_id, s.song_title, s.artist, l.label
FROM spotify_songs s
JOIN spotify_labels l ON s.label = l.label_name;


-- Retrieves songs with popularity > 50 and songs with explicit content marked as 'Yes', using UNION.
SELECT song_id, song_title, popularity
FROM spotify_songs
WHERE popularity > 50
UNION
SELECT song_id, song_title, popularity
FROM spotify_songs
WHERE explicit_content = 'Yes';



-- For Visualizations
SELECT 
    genre,
    SUM(stream) AS total_streams
FROM spotify_songs
GROUP BY genre
ORDER BY total_streams DESC
LIMIT 10;

--Average Popularity Over Time
SELECT 
    EXTRACT(YEAR FROM release_date) AS release_year,
    AVG(popularity) AS avg_popularity
FROM spotify_songs
WHERE release_date IS NOT NULL
GROUP BY release_year
ORDER BY release_year;

-- Explicit Content Proportion by Genre
SELECT 
    genre,
    COUNT(CASE WHEN explicit_content = 'Yes' THEN 1 END) AS explicit_count,
    COUNT(*) AS total_songs,
    ROUND(100.0 * COUNT(CASE WHEN explicit_content = 'Yes' THEN 1 END) / COUNT(*), 2) AS explicit_percentage
FROM spotify_songs
GROUP BY genre
HAVING COUNT(*) > 10
ORDER BY explicit_percentage DESC;






WITH PlaylistGenreArtists AS (
    -- Get all unique genre-artist combinations for each playlist
    SELECT 
        p.PlaylistId,
        p.Name AS PlaylistName,
        g.Name AS GenreName,
        a.Name AS ArtistName,
        COUNT(DISTINCT t.TrackId) AS TrackCount
    FROM Playlist p
    JOIN PlaylistTrack pt ON p.PlaylistId = pt.PlaylistId
    JOIN Track t ON pt.TrackId = t.TrackId
    JOIN Genre g ON t.GenreId = g.GenreId
    JOIN Album al ON t.AlbumId = al.AlbumId
    JOIN Artist a ON al.ArtistId = a.ArtistId
    GROUP BY p.PlaylistId, g.GenreId, a.ArtistId
),
PlaylistStats AS (
    -- Count distinct genres and artists in each playlist
    SELECT 
        PlaylistId,
        PlaylistName,
        COUNT(DISTINCT GenreName) AS GenreCount,
        COUNT(DISTINCT ArtistName) AS ArtistCount
    FROM PlaylistGenreArtists
    GROUP BY PlaylistId, PlaylistName
),
GenreArtistString AS (
    -- Create the genre-artist combination string for qualifying playlists
    SELECT 
        ps.PlaylistId,
        ps.PlaylistName,
        ps.GenreCount,
        STRING_AGG(DISTINCT pga.GenreName || ' by ' || pga.ArtistName, '; ') AS genre_artist_combinations
    FROM PlaylistStats ps
    JOIN PlaylistGenreArtists pga ON ps.PlaylistId = pga.PlaylistId
    WHERE ps.GenreCount >= 3 AND ps.ArtistCount >= 3
    GROUP BY ps.PlaylistId, ps.PlaylistName, ps.GenreCount
)
-- Final result
SELECT 
    PlaylistId AS playlistId,
    PlaylistName AS Name,
    genre_artist_combinations
FROM GenreArtistString
ORDER BY GenreCount DESC, PlaylistId;
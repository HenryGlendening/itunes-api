tell application "iTunes"
    set playlist_name to "Now Playing - API"

    if not (exists playlist playlist_name) then
	    make new playlist with properties {name:playlist_name}
	else
        delete tracks of playlist playlist_name
    end if
end tell
on run argv
	if (count of argv) > 0 then
		set genre_name to item 1 of argv
        tell application "iTunes"
            set nowPlayingPlaylist to playlist "Now Playing - API"
            duplicate (shared tracks whose genre is genre_name) to nowPlayingPlaylist
            play nowPlayingPlaylist
            set shuffle enabled to true
            set shuffle mode to songs
        end tell
    end if
end run
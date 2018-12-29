on run argv
	if (count of argv) > 0 then
		set filter_type to item 1 of argv
        set filter_query to item 2 of argv

        tell application "iTunes"
            set nowPlayingPlaylist to playlist "Now Playing - API"

            if filter_type is equal to "genre" then
                duplicate (shared tracks of playlist "3+ Stars" whose genre is filter_query) to nowPlayingPlaylist
                duplicate (shared tracks of playlist "Unrated" whose genre is filter_query) to nowPlayingPlaylist
            else if filter_type is equal to "artist" then
                duplicate (shared tracks of playlist "3+ Stars" whose artist contains filter_query) to nowPlayingPlaylist
                duplicate (shared tracks of playlist "Unrated" whose artist contains filter_query) to nowPlayingPlaylist
            end if

            play nowPlayingPlaylist
            set shuffle enabled to true
            set shuffle mode to songs
        end tell
    end if
end run
on run argv
	if (count of argv) > 0 then
		set update_type to item 1 of argv
		tell application "iTunes"
			if update_type = "artists" then
				set list_manager's unfiltered_artists to (get album artist of (tracks whose EQ is not "Spoken Word" and genre is not "Podcast" and genre is not "Audiobook" and genre is not "News" and compilation is false and album artist is not ""))
				set tempFilePath to "/tmp/artists.txt"
			else if update_type = "genres" then
				set list_manager's unfiltered_genres to (get genre of (tracks whose EQ is not "Spoken Word" and genre is not "Podcast" and genre is not "Audiobook" and genre is not "News" and genre is not ""))
				set tempFilePath to "/tmp/genres.txt"
			end if
			
			set unique_data to my filter_data(update_type)
			my write_to_file(unique_data, tempFilePath, false)
		end tell
	end if
end run

script list_manager
	property unfiltered_artists : ""
	property unfiltered_genres : ""
end script

on filter_data(filter_type)
	set filtered_data to {}
	
	if filter_type is "artists" then
		repeat with i from 1 to count list_manager's unfiltered_artists
			set current_item to item i of list_manager's unfiltered_artists
			if current_item is not in filtered_data then
				set end of filtered_data to current_item
			end if
		end repeat
	else if filter_type is "genres" then
		repeat with i from 1 to count list_manager's unfiltered_genres
			set current_item to item i of list_manager's unfiltered_genres
			if current_item is not in filtered_data then
				set end of filtered_data to current_item
			end if
		end repeat
	end if
	
	return filtered_data
end filter_data

on write_to_file(this_data, target_file, append_data)
	try
		set full_text to ""
		
		repeat with i from 1 to number of items in this_data
			set this_item to item i of this_data
			set full_text to full_text & this_item
			if i is not number of items in this_data then set full_text to full_text & "\n"
		end repeat
		
		set the target_file to the target_file as string
		set the open_target_file to open for access target_file with write permission
		
		if append_data is false then set eof of the open_target_file to 0
		write full_text to the open_target_file starting at eof as Çclass utf8È
		close access the open_target_file
		
		return true
	on error
		try
			close access file target_file
		end try
		return false
	end try
end write_to_file
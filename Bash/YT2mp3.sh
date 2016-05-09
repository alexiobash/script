#!/bin/bash
# < me (at) alexiobash (dot) com >
# https://alexiobash.com
#
# Simple Download mp3 music from YouTube
#
# zenity and youtube-dl required
#
# *** Resolve: Signature extraction failed: Traceback
# Run: 
# sudo wget https://yt-dl.org/latest/youtube-dl -O /usr/local/bin/youtube-dl
# sudo chmod a+x /usr/local/bin/youtube-dl
# hash -r

error_msg () {
	zenity --error --title "ERROR DOWNLOAD" --text "Download not completed"
}

ok_msg () {
	zenity --info --title "DOWNLOAD" --text "Download completed"
}

main () {
	string_elab=$(zenity --forms --text="Download mp3 music from YouTube" --title="YouTube 2 MP3" --add-entry="URL:" --add-combo="Format" --combo-values="mp3|mp4|allformat")
	case $? in 
		0)
			url=$(echo $string_elab | sed -e 's/|/ /g' | awk '{print $1}')
			types=$(echo $string_elab | sed -e 's/|/ /g' | awk '{print $2}')
			if [[ (-z "$url") || (-z "$types") ]]; then exit 1; fi
			dir_download=$(zenity --title="Select the folder to save the file" --file-selection --directory)
			case $? in
				0)
					cd "$dir_download"
					case $types in
						mp3) 
							youtube-dl -t --extract-audio --audio-format mp3 "$url" | zenity --progress --pulsate --title "Download" --text "Please Wait..." --no-cancel --auto-close
							case $? in 0) ok_msg;; *) error_msg;; esac
							#exit 0
							main
						;;
						mp4)
							youtube-dl "$url" | zenity --progress --pulsate --title "Download" --text "Please Wait..." --no-cancel --auto-close
							case $? in 0) ok_msg;; *) error_msg;; esac
							#exit 0
							main
						;;
						allformat) 
							youtube-dl --all-formats "$url" | zenity --progress --pulsate --title "Download" --text "Please Wait..." --no-cancel --auto-close
							case $? in 0) ok_msg;; *) error_msg;; esac
							#exit 0
							main
						;;
						*) main;;
					esac
				;;
				*) main;;
			esac
		;;
		*) exit 1;;
	esac
}
main
# end script

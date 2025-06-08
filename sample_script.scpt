use framework "AppKit"

on run
	set MediaRemote to current application's NSBundle's bundleWithPath:"/System/Library/PrivateFrameworks/MediaRemote.framework/"
	MediaRemote's load()
	
	set MRNowPlayingRequest to current application's NSClassFromString("MRNowPlayingRequest")
	
	set appName to MRNowPlayingRequest's localNowPlayingPlayerPath()'s client()'s displayName()
	set infoDict to MRNowPlayingRequest's localNowPlayingItem()'s nowPlayingInfo()
	
	set title to (infoDict's valueForKey:"kMRMediaRemoteNowPlayingInfoTitle") as text
	set album to (infoDict's valueForKey:"kMRMediaRemoteNowPlayingInfoAlbum") as text
	set artist to (infoDict's valueForKey:"kMRMediaRemoteNowPlayingInfoArtist") as text
	
	return title & " - " & album & " - " & artist & " | " & appName
end run
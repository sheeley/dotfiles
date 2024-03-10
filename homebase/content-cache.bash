HN=$(hostname_wrapper)
if [[ "$HN" = "homebase" ]]; then
	sudo -u _assetcache defaults write /Library/Preferences/com.apple.AssetCache.plist Active -bool YES
	sudo -u _assetcache defaults write /Library/Preferences/com.apple.AssetCache.plist CacheLimit -int 50000000000
	sudo -u _assetcache defaults write /Library/Preferences/com.apple.AssetCache.plist KeepAwake -bool YES
	sudo AssetCacheManagerUtil reloadSettings
fi

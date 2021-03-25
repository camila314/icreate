main:
	zip -r GJ.zip iTunesArtkork iTunesMetadata.plist Payload
	mv GJ.zip GJ.ipa
	zip iCreate.zip GJ.ipa
	mv iCreate.zip /Library/WebServer/Documents/
	rm GJ.ipa
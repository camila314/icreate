
INCL=CacaoTouch/ CacaoTouch/cocos2dx CacaoTouch/cocos2dx/include CacaoTouch/cocos2dx/kazmath/include CacaoTouch/cocos2dx/platform/ios CacaoTouch/cocos2dx/platform/third_party/ios CacaoTouch/cocos2dx/platform/third_party/ios/OGLES CacaoTouch/cocos2dext CacaoTouch/cocos2dx/custom/Sprites/CCMenuItemSpriteExtra
CXX_INCL=$(INCL:%=-I%)
main:
	clang++ -isysroot `xcrun --sdk iphoneos --show-sdk-path` -arch arm64 CacaoTouch/lib/addrs.cpp main.mm ioslib.mm SongBypass.m AntiPiracy.m LoadSongView.m -framework UIKit -framework AVFoundation -framework Foundation -dynamiclib -Wno-deprecated-declarations -Wno-c++11-extensions -o hook.dylib -DCC_TARGET_OS_IPHONE $(CXX_INCL)
asm:
	clang++ -isysroot `xcrun --sdk iphoneos --show-sdk-path` -arch arm64 cacaotouch/lib/addrs.cpp  -framework UIKit -fobjc-arc -S -fno-asynchronous-unwind-tables -fno-dwarf2-cfi-asm -o main.asm -DCC_TARGET_OS_IPHONE $(CXX_INCL)
release:
	mv hook.dylib ../Payload/GeometryJump.app/hook.dylib
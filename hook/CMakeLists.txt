cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)

set(CMAKE_CXX_STANDARD 17)

add_definitions(-DCC_TARGET_OS_IPHONE)
execute_process(COMMAND xcrun --show-sdk-path --sdk iphoneos
	OUTPUT_VARIABLE IOS_SDK
	OUTPUT_STRIP_TRAILING_WHITESPACE
)
set(CMAKE_OSX_ARCHITECTURES arm64)
set(CMAKE_OSX_SYSROOT ${IOS_SDK})


add_library(iCreateHook SHARED SongBypass.m ioslib.mm main.mm CacaoTouch/lib/addrs.cpp AntiPiracy.m)

target_include_directories(iCreateHook PUBLIC
	CacaoTouch/
	CacaoTouch/cocos2dx
	CacaoTouch/cocos2dx/include
	CacaoTouch/cocos2dx/kazmath/include
	CacaoTouch/cocos2dx/platform/ios
	CacaoTouch/cocos2dx/platform/third_party/ios
	CacaoTouch/cocos2dx/platform/third_party/ios/OGLES
	CacaoTouch/cocos2dext
	CacaoTouch/cocos2dx/custom/Sprites/CCMenuItemSpriteExtra
)

target_link_libraries(iCreateHook "-framework UIKit -framework AVFoundation -framework Foundation")
target_compile_definitions(iCreateHook PUBLIC -DCC_TARGET_OS_IPHONE)
target_compile_options(iCreateHook PUBLIC -Wno-deprecated-declarations -Wno-c++11-extensions)
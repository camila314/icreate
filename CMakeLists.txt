project(iCreate)
cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)

add_subdirectory(hook) # iCreateHook

add_custom_target(iCreateCopyIPA
	DEPENDS ${CMAKE_SOURCE_DIR}/Patched
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/Patched ${CMAKE_BINARY_DIR}/Patched
)

add_custom_target(iCreateCopyHook
	DEPENDS iCreateHook iCreateCopyIPA
	COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:iCreateHook> ${CMAKE_BINARY_DIR}/Patched/Payload/GeometryJump.app/hook.dylib
)

add_custom_target(iCreatePackage ALL
	BYPRODUCTS ${CMAKE_BINARY_DIR}/GJ.ipa ${CMAKE_BINARY_DIR}/iCreate.zip
	DEPENDS iCreateCopyHook
	COMMAND ${CMAKE_COMMAND} -E tar "cfv" "${CMAKE_BINARY_DIR}/GJ.ipa" --format=zip *
	COMMAND cd .. && ${CMAKE_COMMAND} -E tar "cfv" "${CMAKE_BINARY_DIR}/iCreate.zip" --format=zip ${CMAKE_BINARY_DIR}/GJ.ipa
	WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/Patched
)

install(FILES "${CMAKE_BINARY_DIR}/iCreate.zip" DESTINATION "/Library/WebServer/Documents/")
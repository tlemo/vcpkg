include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Microsoft/cpprestsdk
    REF v2.10.14
    SHA512 7208b8c31e42a9bda2bf1d5c65527e54e3f946ec57743aaf7058c12a311de78de354d5ff859f35b3a8936c8964ac5695a692e234f3365edc426cf9580f76cd4f
    HEAD_REF master
)

set(OPTIONS)
if(NOT VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    SET(WEBSOCKETPP_PATH "${CURRENT_INSTALLED_DIR}/share/websocketpp")
    list(APPEND OPTIONS
        -DWEBSOCKETPP_CONFIG=${WEBSOCKETPP_PATH}
        -DWEBSOCKETPP_CONFIG_VERSION=${WEBSOCKETPP_PATH})
endif()

set(CPPREST_EXCLUDE_WEBSOCKETS ON)
if("websockets" IN_LIST FEATURES)
    set(CPPREST_EXCLUDE_WEBSOCKETS OFF)
endif()

set(CPPREST_EXCLUDE_BROTLI ON)
if ("brotli" IN_LIST FEATURES)
    set(CPPREST_EXCLUDE_BROTLI OFF)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/Release
    PREFER_NINJA
    OPTIONS
        ${OPTIONS}
        -DBUILD_TESTS=OFF
        -DBUILD_SAMPLES=OFF
        -DCPPREST_EXCLUDE_WEBSOCKETS=${CPPREST_EXCLUDE_WEBSOCKETS}
        -DCPPREST_EXPORT_DIR=share/cpprestsdk
        -DWERROR=OFF
    OPTIONS_DEBUG
        -DCPPREST_INSTALL_HEADERS=OFF
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/share/cpprestsdk)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/share ${CURRENT_PACKAGES_DIR}/lib/share)

file(INSTALL
    ${SOURCE_PATH}/license.txt
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/cpprestsdk RENAME copyright)

vcpkg_copy_pdbs()

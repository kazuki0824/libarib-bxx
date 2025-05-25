find_package(PkgConfig)

# ── クロスコンパイル時の pkg-config 自動設定 ──────────────────────
if(CMAKE_CROSSCOMPILING)
	find_program(PKG_CONFIG_EXECUTABLE
		NAMES
			${CMAKE_SYSTEM_PROCESSOR}-pkg-config
			${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}-pkg-config
			pkg-config
		HINTS
			ENV PATH
			${CMAKE_SYSROOT}/usr/bin
		NO_DEFAULT_PATH
	)
	if(PKG_CONFIG_EXECUTABLE)
		set(ENV{PKG_CONFIG_SYSROOT_DIR} ${CMAKE_SYSROOT})
		set(ENV{PKG_CONFIG_LIBDIR}      ${CMAKE_SYSROOT}/usr/lib/pkgconfig)
	endif()
endif()

# ── pkg-config を使った検索 ────────────────────────────────────────
if(PKG_CONFIG_FOUND AND WITH_PCSC_PACKAGE)
	if(WITH_PCSC_PACKAGE STREQUAL "libpcsclite")
		pkg_check_modules(PCSC ${WITH_PCSC_PACKAGE})
	else()
		pkg_check_modules(PCSC REQUIRED ${WITH_PCSC_PACKAGE})
	endif()
endif()

# ── pkg-config に引っかからなかったらヘッダ／ライブラリを sysroot 下で検索 ────
if(NOT PCSC_FOUND)
	find_path(PCSC_INCLUDE_DIRS
		NAMES WinSCard.h winscard.h
		PATH_SUFFIXES PCSC
		HINTS ${CMAKE_SYSROOT}/usr/include
	)

	if(WITH_PCSC_LIBRARY)
		find_library(PCSC_LIBRARIES
			NAMES ${WITH_PCSC_LIBRARY}
			HINTS ${CMAKE_SYSROOT}/usr/lib ${CMAKE_SYSROOT}/lib
		)
	else()
		find_library(PCSC_LIBRARIES
			NAMES pcsclite PCSC WinSCard winscard
			HINTS ${CMAKE_SYSROOT}/usr/lib ${CMAKE_SYSROOT}/lib
		)
	endif()

	if(PCSC_LIBRARIES)
		set(PCSC_FOUND True)
	endif()
endif()

# ── Windows クロスターゲット向けフォールバック ───────────────────────
if(NOT PCSC_FOUND AND NOT WITH_PCSC_LIBRARY AND WIN32)
	set(PCSC_LIBRARIES winscard)
	set(PCSC_FOUND True)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PCSC DEFAULT_MSG PCSC_LIBRARIES)

mark_as_advanced(PCSC_INCLUDE_DIRS PCSC_LIBRARIES)

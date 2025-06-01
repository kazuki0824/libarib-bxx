# Toolchain file for cross-compiling to i686-linux-gnu
# Usage: cmake -DCMAKE_TOOLCHAIN_FILE=cmake/Toolchain-i686-linux-gnu.cmake

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR i686)

# Specify the cross compiler
#set(CMAKE_C_COMPILER i686-linux-gnu-gcc)
#set(CMAKE_CXX_COMPILER i686-linux-gnu-g++)

# Specify the target environment (optional)
set(CMAKE_FIND_ROOT_PATH /usr/i686-linux-gnu)

# Search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# For libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Set pkg-config for cross compilation
#set(PKG_CONFIG_EXECUTABLE i686-linux-gnu-pkg-config)

# PC/SC library configuration for cross compilation
set(WITH_PCSC_PACKAGE "libpcsclite" CACHE STRING "pkg-config package name for PC/SC")

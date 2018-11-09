# this one is important
set(CMAKE_SYSTEM_NAME Linux)
# name of the platform
set(SDK_PLATFORM_NAME linux)
set(CMAKE_SYSTEM_PROCESSOR armv7-a)

# set this to the folder containing the beaglebone toolchain
if (EXISTS $ENV{SYSROOTS})
    # toolchain is configured by env variable
    set(BASE_PATH $ENV{SYSROOTS}/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi)
    # Target sysroot
    set(CMAKE_SYSROOT $ENV{SYSROOTS}/cortexa9hf-neon-poky-linux-gnueabi)
else ()
    message(FATAL_ERROR "Please set the environment variable SYSROOTS")
endif ()

# specify the cross compiler
set(CMAKE_C_COMPILER ${BASE_PATH}/arm-poky-linux-gnueabi-gcc)
set(CMAKE_CXX_COMPILER ${BASE_PATH}/arm-poky-linux-gnueabi-g++)

# use a static library for compiler test
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# where is the target environment
set(CMAKE_FIND_ROOT_PATH ${BASE_PATH})

# search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Set compiler flags
set(COMPILER_FLAGS "-march=armv7-a -marm -mfpu=neon  -mfloat-abi=hard -mcpu=cortex-a9 --sysroot=${CMAKE_SYSROOT}")
set(CMAKE_C_FLAGS "${COMPILER_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "${COMPILER_FLAGS}" CACHE STRING "" FORCE)

# linker settings
set(CMAKE_EXE_LINKER_FLAGS "--sysroot=${CMAKE_SYSROOT}")
set(CMAKE_SHARED_LINKER_FLAGS "--sysroot=${CMAKE_SYSROOT}")

# Original compiler settings from environment-setup-cortexa9hf-neon-poky-linux-gnueabi
#export CC="arm-poky-linux-gnueabi-gcc  -march=armv7-a -marm -mfpu=neon  -mfloat-abi=hard -mcpu=cortex-a9 --sysroot=$SDKTARGETSYSROOT"
#export CXX="arm-poky-linux-gnueabi-g++  -march=armv7-a -marm -mfpu=neon  -mfloat-abi=hard -mcpu=cortex-a9 --sysroot=$SDKTARGETSYSROOT"
#export CPP="arm-poky-linux-gnueabi-gcc -E  -march=armv7-a -marm -mfpu=neon  -mfloat-abi=hard -mcpu=cortex-a9 --sysroot=$SDKTARGETSYSROOT"
#export AS="arm-poky-linux-gnueabi-as "
#export LD="arm-poky-linux-gnueabi-ld  --sysroot=$SDKTARGETSYSROOT"

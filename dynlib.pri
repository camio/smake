include( common.pri )

##################
## Build Options
##################

TEMPLATE = lib

BUILD_DLL_DEF = $$upper($${TARGET}_BUILD_SHARED_LIB)

message( $$BUILD_DLL_DEF )
DEFINES += $$BUILD_DLL_DEF

######################
## Output File Options
######################

DESTDIR = lib

win32-msvc2010:QMAKE_CXXFLAGS_RELEASE += /Fdlib/$${TARGET}.pdb
win32-msvc2010:QMAKE_CFLAGS_RELEASE += /Fdlib/$${TARGET}.pdb

win32-msvc2010:QMAKE_CXXFLAGS_DEBUG += /Fdlib/$${TARGET}.pdb
win32-msvc2010:QMAKE_CFLAGS_DEBUG += /Fdlib/$${TARGET}.pdb

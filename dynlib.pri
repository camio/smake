include( common.pri )

##################
## Build Options
##################

TEMPLATE = lib

BUILD_DLL_DEF = $$upper($${TARGET}_BUILD_SHARED_LIB)

DEFINES += $$BUILD_DLL_DEF

######################
## Output File Options
######################

DESTDIR = lib
win32-msvc2010|win32-msvc2012 {
    QMAKE_CXXFLAGS_RELEASE += /Fdlib/$${TARGET}.pdb
    QMAKE_CFLAGS_RELEASE += /Fdlib/$${TARGET}.pdb
    QMAKE_CXXFLAGS_DEBUG += /Fdlib/$${TARGET}.pdb
    QMAKE_CFLAGS_DEBUG += /Fdlib/$${TARGET}.pdb
}

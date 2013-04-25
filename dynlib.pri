include( common.pri )

# addStaticLibDependency(library_path,library_name)
defineTest(addStaticLibDependency) {
  INCLUDEPATH += $${1}/include $${1}/build/include
  DEPENDPATH  += $${1}/include $${1}/build/include

  CONFIG(debug, debug|release) {
      LIB_PATH = ../$${1}/build/lib/$${2}d.lib
  } else {
      LIB_PATH = ../$${1}/build/lib/$${2}.lib
  }
  LIBS += $$LIB_PATH
  # Without this append, changes in the library will not trigger a new link.
  POST_TARGETDEPS += $$LIB_PATH
  
  export(INCLUDEPATH)
  export(DEPENDPATH)
  export(POST_TARGETDEPS)
  export(LIBS)
}

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

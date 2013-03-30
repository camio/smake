include( common.pri )
##################
## Useful Macros
##################

# addStaticLibDependency(library_path,library_name)
defineTest(addStaticLibDependency) {
  INCLUDEPATH += $${1}/include $${1}/build/include
  DEPENDPATH  += $${1}/include $${1}/build/include

  CONFIG(debug, debug|release) {
      LIB_PATH = ../$${1}/build/lib/$${2}d.lib
  } else {
      LIB_PATH = ../$${1}/build/lib/$${2}.lib
  }
  # Although we aren't actually linking to other static libraries when we
  # create a static library, the following line will help libraries that
  # link to this library link to the others using the link_prl mechanism.
  LIBS += $$LIB_PATH
  
  export(INCLUDEPATH)
  export(DEPENDPATH)
  export(LIBS)
}

##################
## Build Options
##################

TEMPLATE = lib
CONFIG += staticlib create_prl

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

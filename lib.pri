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
  # TODO: remove these comments (and the export) if true.
  # Hrm, I think the following line is only necessary for applications
  # LIBS += $$LIB_PATH
  POST_TARGETDEPS += $$LIB_PATH
  
  export(INCLUDEPATH)
  export(DEPENDPATH)
#  export(LIBS)
  export(POST_TARGETDEPS)
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

win32-msvc2010:QMAKE_CXXFLAGS_RELEASE += /Fdlib/$${TARGET}.pdb
win32-msvc2010:QMAKE_CFLAGS_RELEASE += /Fdlib/$${TARGET}.pdb

win32-msvc2010:QMAKE_CXXFLAGS_DEBUG += /Fdlib/$${TARGET}.pdb
win32-msvc2010:QMAKE_CFLAGS_DEBUG += /Fdlib/$${TARGET}.pdb

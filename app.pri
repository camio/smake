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
  
  export(INCLUDEPATH)
  export(DEPENDPATH)
  export(LIBS)
}

##################
## Build Options
##################

TEMPLATE = app
CONFIG += link_prl
win32-msvc2010:CONFIG -= embed_manifest_exe

######################
## Output File Options
######################

DESTDIR = bin

win32-msvc2010:QMAKE_CXXFLAGS_RELEASE += /Fdbin/$${TARGET}.pdb
win32-msvc2010:QMAKE_CFLAGS_RELEASE += /Fdbin/$${TARGET}.pdb

win32-msvc2010:QMAKE_CXXFLAGS_DEBUG += /Fdbin/$${TARGET}.pdb
win32-msvc2010:QMAKE_CFLAGS_DEBUG += /Fdbin/$${TARGET}.pdb

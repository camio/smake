##################
## Useful Macros
##################

# addBoostDependency(boost_path)
defineTest(addBoostDependency) {
  INCLUDEPATH += $${1}
  LIBS += -L../$${1}/stage/lib
  export(INCLUDEPATH)
  export(LIBS)
}

# addSharedLibDependency(library_path,library_name)
defineTest(addSharedLibDependency) {
  # Like addStaticLibDependency, but no POST_TARGETDEPS is necessary
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

# addHeaderLibDependency(library_path)
defineTest(addHeaderLibDependency) {
  INCLUDEPATH += $${1}/include $${1}/build/include
  DEPENDPATH  += $${1}/include $${1}/build/include
  export(INCLUDEPATH)
  export(DEPENDPATH)
  return(true)
}

#########################
## This module's includes
#########################

# We include the "src" folder which can be used for include files that should
# not be visible to dependents.
INCLUDEPATH += src include ../build/include
DEPENDPATH  += src include ../build/include

##################
## Build Options
##################

win32-msvc2010|win32-msvc2012 {
    # We disable Qt's warnings because, otherwise, they come after our warning
    # suppressions on the command line and override them. This is technically only
    # necessary for vs2012.
    QMAKE_CXXFLAGS_WARN_ON = ""
    QMAKE_CXXFLAGS += -W3

    # Suppress spurious warnings
    QMAKE_CXXFLAGS += /wd4100 /wd4800 /wd4345

    # Increase the heap space of the compiler 200=twice as much. 
    # QMAKE_CXXFLAGS -= -Zm200
    # QMAKE_CXXFLAGS += /Zm1000

    # Enables debugging symbols in release mode (vs2008 doesn't support this)
    release:QMAKE_CXXFLAGS += /Zi
    release:QMAKE_CFLAGS += /Zi
    release:QMAKE_LFLAGS_RELEASE += /DEBUG

    # Enables incremental linking in release mode
    release:QMAKE_LFLAGS_RELEASE += /INCREMENTAL
    # As an alternative, this makes the executable 10-20% smaller, but linking takes
    # longer.
    # release:QMAKE_LFLAGS_RELEASE += /OPT:REF /OPT:ICF

    # Speedup builds on multicore computers
    QMAKE_CXXFLAGS += /MP
    QMAKE_CFLAGS += /MP

    # Enables "large object file" mode which is required for certain source files.
    QMAKE_CXXFLAGS += /bigobj

    # Removes more spurious warnings when compiling
    DEFINES += _CRT_SECURE_NO_WARNINGS

    # This disables checked iterators. It shouldn't be enabled unless _all_ linked
    # libraries do the same.
    # release:DEFINES += _SECURE_SCL=0
}

# This works around a bug in moc that conflicts with qt. See:
# http://bugreports.qt-project.org//browse/QTBUG-22829
QMAKE_MOC = $$QMAKE_MOC -DBOOST_TT_HAS_OPERATOR_HPP_INCLUDED -DBOOST_MPL_BITAND_HPP_INCLUDED -DBOOST_MATH_CONSTANTS_CONSTANTS_INCLUDED -DBOOST_LEXICAL_CAST_INCLUDED

DEFINES += QT_NO_KEYWORDS

######################
## Output File Options
######################

TARGET = $$NAME

CONFIG(debug, debug|release) {
    TARGET = $${NAME}d
}

UI_DIR = include/
RCC_DIR=rcc
MOC_DIR=moc

CONFIG(debug, debug|release) {
    OBJECTS_DIR = objs_debug
} else {
    OBJECTS_DIR = objs_release
}

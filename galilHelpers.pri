# addGalilDependency(libgalil_path)
defineTest(addGalilDependency) {
  win32-msvc2003:contains(QMAKE_TARGET.arch,x86):LIBGALIL_SPEC_PATH = $${1}/vs2003-x86
  win32-msvc2005:contains(QMAKE_TARGET.arch,x86):LIBGALIL_SPEC_PATH = $${1}/vs2005-x86
  win32-msvc2008:contains(QMAKE_TARGET.arch,x86_64):LIBGALIL_SPEC_PATH = $${1}/vs2008-x64
  win32-msvc2008:contains(QMAKE_TARGET.arch,x86):LIBGALIL_SPEC_PATH = $${1}/vs2008-x86
  win32-msvc2010:contains(QMAKE_TARGET.arch,x86):LIBGALIL_SPEC_PATH = $${1}/vs2010-x86
  win32-msvc2010:contains(QMAKE_TARGET.arch,x86_64):LIBGALIL_SPEC_PATH = $${1}/vs2010-x64

  CONFIG(debug, debug|release) {
      LIBS += -L../$$LIBGALIL_SPEC_PATH/debug
  } else {
      LIBS += -L../$$LIBGALIL_SPEC_PATH/release
  }
  INCLUDEPATH += $$LIBGALIL_SPEC_PATH
  LIBS += -lGalil2
  export(INCLUDEPATH)
  export(LIBS)
}

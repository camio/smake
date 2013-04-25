# addGalilDependency(libgalil_path)
defineTest(addGalilDependency) {
  win32-msvc2010:contains(QMAKE_TARGET.arch,x86):LIBGALIL_SPEC_PATH = $${1}/vs2010-x86
  win32-msvc2010:contains(QMAKE_TARGET.arch,x86_64):LIBGALIL_SPEC_PATH = $${1}/vs2010-x64
  win32-msvc2012:contains(QMAKE_TARGET.arch,x86):LIBGALIL_SPEC_PATH = $${1}/vs2012-x86
  win32-msvc2012:contains(QMAKE_TARGET.arch,x86_64):LIBGALIL_SPEC_PATH = $${1}/vs2012-x64

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

# addDMCWin32Dependency(DMCWin32_path)
defineTest(addDMCWin32Dependency) {
  # We don't include the CPP path because the C interface is generally
  # superior.
  INCLUDEPATH += ../$$DMCWIN32_PATH/INCLUDE
  win32 {
    LIBS += -L../$$DMCWIN32_PATH/LIB -lDMCMLIB -lDMC32
    win32-msvc2008|win32-msvc2010|win32-msvc2012:LIBS += -luser32
  }
  export(INCLUDEPATH)
  export(LIBS)
}

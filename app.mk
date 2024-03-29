include $(dir $(lastword $(MAKEFILE_LIST)))common-c++.mk

.PHONY: debug
debug: build/bin/$(NAME)d.exe

.PHONY: release
release: build/bin/$(NAME).exe

#Note: the Entering/Leaving echos are for helping vim figure out which file
#      the compiler is referring to in the event of a warning or error.
.PHONY: build/bin/$(NAME).exe
build/bin/$(NAME).exe: $$(RELEASE_DEPS) build/$(NAME).mak
	@echo "Entering dir 'build'"
	cd build; $(NMAKE) -F $(NAME).mak release
	@echo "Leaving dir"

#Note: the Entering/Leaving echos are for helping vim figure out which file
#      the compiler is referring to in the event of a warning or error.
.PHONY: build/bin/$(NAME)d.exe
build/bin/$(NAME)d.exe: $$(DEBUG_DEPS) build/$(NAME).mak
	@echo "Entering dir 'build'"
	cd build; $(NMAKE) -F $(NAME).mak debug
	@echo "Leaving dir"

# Use this to note a dll dependency that is required to run the application.
# The dll may be part of a binary only repository with the dll in
# <library-path>/lib/<library-name>.dll or be source buildable with the dll
# residing in <library-path>/build/lib/<library-name>.dll.
#
# If it is source buildable, the system will attempt to build the file if it
# doesn't not already exist. Also, it will attempt to update the file unless 
# SMAKE_USE_EXPLICITLY_CHECKED_DEPENDENCIES is enabled and this repository is
# not in the SMAKE_EXPLICITLY_CHECKED_DEPENDENCIES list.
#
# $(call add-dll-dependency, library-path, library-name )
define add-dll-dependency
  RELEASE_RUN_DEPS += build/bin/$2.dll
  DEBUG_RUN_DEPS += build/bin/$2d.dll

  $(if $(wildcard $1/lib/$2.dll)
   , build/bin/$2.dll : $1/lib/$2.dll
	     cp $$< $$@

     build/bin/$2d.dll : $1/lib/$2d.dll
	      cp $$< $$@

     RELEASE_DEPS += $1/lib/$2.lib
     DEBUG_DEPS += $1/lib/$2d.lib
   , $(if $(SMAKE_USE_EXPLICITLY_CHECKED_DEPENDENCIES)
      , $(if $(filter $2,$(SMAKE_EXPLICITLY_CHECKED_DEPENDENCIES))
         , .PHONY: $1/build/lib/$2.dll
           .PHONY: $1/build/lib/$2d.dll
           .PHONY: $1/build/lib/$2.lib
           .PHONY: $1/build/lib/$2d.lib
         ,
         )
      , .PHONY: $1/build/lib/$2.dll
        .PHONY: $1/build/lib/$2d.dll
        .PHONY: $1/build/lib/$2.lib
        .PHONY: $1/build/lib/$2d.lib
      )
     $1/build/lib/$2.dll:
	     $(MAKE) --directory=$1 build/lib/$2.lib

     $1/build/lib/$2d.dll:
	     $(MAKE) --directory=$1 build/lib/$2d.lib

     build/bin/$2.dll : $1/build/lib/$2.dll
	     cp $$< $$@

     build/bin/$2d.dll : $1/build/lib/$2d.dll
	     cp $$< $$@

     $1/build/lib/$2.lib:
	     $(MAKE) --directory=$1 build/lib/$2.lib

     $1/build/lib/$2d.lib:
	     $(MAKE) --directory=$1 build/lib/$2d.lib

     RELEASE_DEPS += $1/build/lib/$2.lib
     DEBUG_DEPS += $1/build/lib/$2d.lib
   )
endef

# Creates a new run target given command line arguments to the executable.
#
# $(call add-run-target,name,args)
#
# Note that we need to use secondary expansion for the dependencies
# because of the $(call add-run-target,run) immediately following
# this call. After the application includes this Makefile, it
# may add more runtime dependencies.
#
# The x/fast rules allow one to run their application while
# eliding all the dependency analysis.
define add-run-target
  .PHONY: $1
  $1: build/bin/$(NAME).exe $$$$(RELEASE_RUN_DEPS)
	  $$< $2 2>&1 | tee build/$1-output.txt
  .PHONY: $1d
  $1d: build/bin/$(NAME)d.exe $$$$(DEBUG_RUN_DEPS)
	  $$< $2 2>&1 | tee build/$1d-output.txt

  .PHONY: $1/fast
  $1/fast:
	  build/bin/$(NAME).exe $2 | tee build/$1-output.txt
  .PHONY: $1d/fast
  $1d/fast:
	  build/bin/$(NAME)d.exe $2 | tee build/$1d-output.txt
endef

$(eval $(call add-run-target,run) )

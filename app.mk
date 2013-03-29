include $(dir $(lastword $(MAKEFILE_LIST)))common.mk

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

# Use this to note a dll dependency that is required to run the application
#
# $(call add-dll-dependency, library-path, library-name )
define add-dll-dependency
  RELEASE_RUN_DEPS += build/bin/$2.dll
  DEBUG_RUN_DEPS += build/bin/$2d.dll

  .PHONY: $1/build/lib/$2.dll
  $1/build/lib/$2.dll:
	  $(MAKE) --directory=$1 build/lib/$2.lib

  .PHONY: $1/build/lib/$2d.dll
  $1/build/lib/$2d.dll:
	  $(MAKE) --directory=$1 build/lib/$2d.lib

  build/bin/$2.dll : $1/build/lib/$2.dll
	  cp $$< $$@

  build/bin/$2d.dll : $1/build/lib/$2d.dll
	  cp $$< $$@
endef

# Creates a new run target given command line arguments to the executable.
#
# $(call add-run-target,name,args)
define add-run-target
  # Note that we need to use secondary expansion for the dependencies
  # because of the $(call add-run-target,run) immediately following
  # this call. After the application includes this Makefile, it
  # may add more runtime dependencies.
  .PHONY: $1
  $1: build/bin/$(NAME).exe $$$$(RELEASE_RUN_DEPS)
	  $$< $2
  .PHONY: $1d
  $1d: build/bin/$(NAME)d.exe $$$$(DEBUG_RUN_DEPS)
	  $$< $2
endef

$(eval $(call add-run-target,run) )

# Use this to add boost dependencies
#
# $(call add-boost-dependency,lib)
define add-boost-dependency
  QMAKE_DEPS += boost_$1
  .PHONY: boost_$1
  boost_$1:
	  $(MAKE) --directory=$(BOOST_MAKE_PATH) $1
endef

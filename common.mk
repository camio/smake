.SECONDEXPANSION:

# Use RELEASE_DEPS, and DEBUG_DEPS to add dependencies to the nmake process
# that builds the target.
#
# Use QMAKE_DEPS to add a dependency to the .mak generation from the .pro file.
#
# Generally, you use add-library-dependency to depend on a library that is
# created in the smake way.

#The L here is for no-logo
NMAKE=MAKEFLAGS="CL" nmake
# NMAKE=MAKEFLAGS="CL" jom

-include $(dir $(firstword $(MAKEFILE_LIST)))config.mk
-include $(dir $(firstword $(MAKEFILE_LIST)))local-config.mk

release:

.PHONY: all
all: release debug

build/$(NAME).mak build/$(NAME).mak.Debug build/$(NAME).mak.Release : $(NAME).pro $$(QMAKE_DEPS) $(dir config.mk) $(dir local-config.mk) | $$(@D)/.f
	qmake $(NAME).pro -o build/$(NAME).mak $(QMAKEDEFS)

%.obj: build/$(NAME).mak
	@echo "Entering dir 'build'"
	cd build; $(NMAKE) -F $(NAME).mak.Debug "build\\debug_objs\\$@"
	@echo "Leaving dir"

.PHONY: clean
clean:
	$(RM) -r build

.PHONY: cleanmak
cleanmak:
	$(RM) build/$(NAME).mak*

.PHONY: tags
tags:
	ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++,c include src build/ui

# Folder Creation
PRECIOUS: %/.f
%/.f:
	@echo Making $(dir $@)
	@mkdir -p $(dir $@)
	@touch $@

# $(call add-library-dependency, library-path, library-name )
define add-library-dependency
  RELEASE_DEPS += $1/build/lib/$2.lib
  DEBUG_DEPS += $1/build/lib/$2d.lib

  .PHONY: $1/build/lib/$2.lib
  $1/build/lib/$2.lib:
	  $(MAKE) --directory=$1 build/lib/$2.lib

  .PHONY: $1/build/lib/$2d.lib
  $1/build/lib/$2d.lib:
	  $(MAKE) --directory=$1 build/lib/$2d.lib
endef

# Adds a png generation from an svg file as a dependency of QMAKE_DEPS
#
# $(call add-pngFromSvg-dependency,name,width,extraargs)
define add-pngFromSvg-dependency
  QMAKE_DEPS += build/img/$1.png
  build/img/$1.png: src/$1.svg | $$$$(@D)/.f
	  $(INKSCAPE_EXE) --export-width=$2 $3 --export-png="$$@" "$$<"
endef

# Essentially the same as the above function, but with a particular target name
#
# $(call add-target-pngFromSvg-dependency,targetName,sourceName,width,extraargs)
define add-target-pngFromSvg-dependency
  QMAKE_DEPS += build/img/$1.png
  build/img/$1.png: src/$2.svg | $$$$(@D)/.f
	  $(INKSCAPE_EXE) --export-width=$3 $4 --export-png="$$@" "$$<"
endef
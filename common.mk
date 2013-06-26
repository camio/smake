.SECONDEXPANSION:

-include $(dir $(firstword $(MAKEFILE_LIST)))config.mk
-include $(dir $(firstword $(MAKEFILE_LIST)))../config.mk
-include $(dir $(firstword $(MAKEFILE_LIST)))../local-config.mk
-include $(dir $(firstword $(MAKEFILE_LIST)))local-config.mk

.PHONY: clean
clean:
	$(RM) -r build

# Folder Creation
PRECIOUS: %/.f
%/.f:
	@echo Making $(dir $@)
	@mkdir -p $(dir $@)
	@touch $@

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

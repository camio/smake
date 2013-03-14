include $(dir $(lastword $(MAKEFILE_LIST)))common.mk

.PHONY: debug
debug: build/lib/$(NAME)d.lib

.PHONY: release
release: build/lib/$(NAME).lib

#Note: the Entering/Leaving echos are for helping vim figure out which file
#      the compiler is referring to in the event of a warning or error.

.PHONY: build/lib/$(NAME).lib
build/lib/$(NAME).lib: $$(RELEASE_DEPS) build/$(NAME).mak
	@echo "Entering dir 'build'"
	cd build; $(NMAKE) -F $(NAME).mak release
	@echo "Leaving dir"

#Note: the Entering/Leaving echos are for helping vim figure out which file
#      the compiler is referring to in the event of a warning or error.
.PHONY: build/lib/$(NAME)d.lib
build/lib/$(NAME)d.lib: $$(DEBUG_DEPS) build/$(NAME).mak
	@echo "Entering dir 'build'"
	cd build; $(NMAKE) -F $(NAME).mak debug
	@echo "Leaving dir"

TOPTARGETS := all test

SUBDIRS := $(wildcard */test/.)

$(TOPTARGETS): $(SUBDIRS)
$(SUBDIRS):
	@echo " == Testing $@ == "
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: $(TOPTARGETS) $(SUBDIRS)

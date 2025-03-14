
target =

.PHONY: all 0 1

all: 0 1
	@echo "Successfully End."

0: build_01
	@echo "Done run $(target)..."
1: build_02
	@echo "done run $(target)..."

build_01:
	$(eval target=01Helloworld)
	cd $(target) && $(MAKE)

build_02:
	$(eval target=02Basic_Additional)
	cd $(target) && $(MAKE)


target =

.PHONY: all 1 2 3

all: 1 2 3 4 5
	@echo "Successfully End."

1: build_01
	@echo "Done run $(target)..."
2: build_02
	@echo "done run $(target)..."
3: build_03
	@echo "done run $(target)..."
4: build_04
	@echo "done run $(target)..."
5: build_05
	@echo "done run $(target)..."

build_01:
	$(eval target=01Helloworld)
	cd $(target) && $(MAKE)

build_02:
	$(eval target=02Basic_Additional)
	cd $(target) && $(MAKE)

build_03:
	$(eval target=03Stack_Program)
	cd $(target) && $(MAKE)

build_04:
	$(eval target=04Stack_Program)
	cd $(target) && $(MAKE)

build_05:
	$(eval target=05Combo_Gcc)
	cd $(target) && $(MAKE)


target =

.PHONY: all 0 1

all: 0 1

0: build_01
	@echo "Runing $(target)..."
	cd $(target) && ./main
1: build_02
	@echo "$(target)"
	@echo "Successfully End."

build_01:
	$(eval target=01Helloworld)
	@echo "Building $(target)..."
	cd $(target) && $(MAKE)

build_02:
	$(eval target=02)
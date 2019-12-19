APPS=get_container_id.out
#ARGS=$(shell pkg-config --cflags --libs opencv)
ARGS= --std=c++11 -pthread

all: $(APPS)

%.out: %.cpp
	@echo "Compile the cpp files."
	g++ -o $@ $< $(ARGS)

.PHONY: clean
clean:
	@echo "Clean the project."
	-rm -rf $(APPS)


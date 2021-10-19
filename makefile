NAUTY_ARCHIVE_BASENAME=nauty26r12

NAUTY_ARCHIVE=$(NAUTY_ARCHIVE_BASENAME).tar.gz
NAUTY_URL=https://users.cecs.anu.edu.au/~bdm/nauty/$(NAUTY_ARCHIVE)
NAUTY_DIR=nauty/$(NAUTY_ARCHIVE_BASENAME)

nauty/$(NAUTY_ARCHIVE):
	wget -O nauty/$(NAUTY_ARCHIVE) $(NAUTY_URL)

$(NAUTY_DIR)/configure:nauty/$(NAUTY_ARCHIVE)
	tar -xf nauty/$(NAUTY_ARCHIVE) --directory nauty/

$(NAUTY_DIR)/makefile:$(NAUTY_DIR)/configure
	cd $(NAUTY_DIR);./configure;

nauty $(NAUTY_DIR)/dreadnaut $(NAUTY_DIR)/nauty.a $(NAUTY_DIR)/nauty1.a $(NAUTY_DIR)/nautyW.a $(NAUTY_DIR)/nautyW1.a $(NAUTY_DIR)/nautyL.a $(NAUTY_DIR)/nautyL1.a:$(NAUTY_DIR)/makefile
	make -C $(NAUTY_DIR) checks

main.o:main.cpp
	g++ -c -O3 -std=c++11 -Wno-deprecated -Wcpp `wx-config --cxxflags` main.cpp

graph64.o:graph64.cpp
	g++ -c -O3 -std=c++11 -Wno-deprecated -Wcpp `wx-config --cxxflags` graph64.cpp 

output.o:output.cpp
	g++ -c -O3 -std=c++11 -Wno-deprecated -Wcpp `wx-config --cxxflags` output.cpp 

random.o:random.cpp
	g++ -c -O3 -std=c++11 -Wno-deprecated -Wcpp `wx-config --cxxflags` random.cpp

maingraph.o:maingraph.cpp
	g++ -c -O3 -std=c++11 -Wno-deprecated -Wcpp `wx-config --cxxflags` maingraph.cpp 

fanmod_cmd:main.o graph64.o output.o random.o maingraph.o
	g++ -ggdb -o fanmod_cmd main.o graph64.o output.o random.o maingraph.o nauty/nauty26r12/nautyL1.a `wx-config --libs` -lboost_program_options
	strip fanmod_cmd

fanmod:fanmod_cmd

all:nauty fanmod

clean:
	rm *.o
	make -C $(NAUTY_DIR) clean

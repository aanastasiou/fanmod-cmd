NAUTY_ARCHIVE_BASE=nauty27r3
NAUTY_URL_BASE=https://pallini.di.uniroma1.it

NAUTY_ARCHIVE=$(NAUTY_ARCHIVE_BASE).tar.gz
NAUTY_URL=$(NAUTY_URL_BASE)/$(NAUTY_ARCHIVE)
NAUTY_DIR=nauty/$(NAUTY_ARCHIVE_BASE)

nauty/$(NAUTY_ARCHIVE):
	wget -O nauty/$(NAUTY_ARCHIVE) $(NAUTY_URL)

$(NAUTY_DIR)/nauty.h:nauty/$(NAUTY_ARCHIVE)
	tar -xf nauty/$(NAUTY_ARCHIVE) --directory nauty/

$(NAUTY_DIR)/config.status:
	cd $(NAUTY_DIR);./configure;

nauty $(NAUTY_DIR)/dreadnaut $(NAUTY_DIR)/nauty.a $(NAUTY_DIR)/nauty1.a $(NAUTY_DIR)/nautyW.a $(NAUTY_DIR)/nautyW1.a $(NAUTY_DIR)/nautyL.a $(NAUTY_DIR)/nautyL1.a:$(NAUTY_DIR)/config.status
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
	g++ -ggdb -o fanmod_cmd main.o graph64.o output.o random.o maingraph.o $(NAUTY_DIR)/nautyL1.a `wx-config --libs` -lboost_program_options
	strip fanmod_cmd

fanmod:fanmod_cmd

all:nauty fanmod

clean:clean_fanmod clean_nauty

clean_fanmod:
	rm *.o
	rm fanmod_cmd

clean_nauty:
	make -C $(NAUTY_DIR) clean

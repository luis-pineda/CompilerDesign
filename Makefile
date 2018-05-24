# ------------------------------------------------------------------------- #
# ---									--- #
# ---		Makefile						--- #
# ---									--- #
# ---	    This file details the dependencies upon the source, object	--- #
# ---	and executable files of the baking language program.		--- #
# ---									--- #
# ---	----	----	----	----	----	----	----	----	--- #
# ---									--- #
# ---	Version 1a		2018 February 18	Joseph Phillips	--- #
# ---									--- #
# ------------------------------------------------------------------------- #

bakingLang		: bakingLang.tab.o bakingLang.o
			g++ -o $@ bakingLang.tab.o bakingLang.o -g

bakingLang.o		: bakingLang.cpp bakingLang.h bakingLang.tab.h BakingNode.h
			g++ -c bakingLang.cpp -g

bakingLang.tab.o	: bakingLang.tab.c bakingLang.h bakingLang.tab.h BakingNode.h
			g++ -c bakingLang.tab.c -g

bakingLang.cpp		: bakingLang.lex
			flex -o $@ bakingLang.lex

bakingLang.tab.c	: bakingLang.y
			bison -d bakingLang.y --debug --verbose

bakingLang.tab.h	: bakingLang.y
			bison -d bakingLang.y --debug --verbose

clean			:
			rm bakingLang.tab.? bakingLang.cpp bakingLang.o \
			   bakingLang bakingLang.output
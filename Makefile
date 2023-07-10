# FLP: Spanning tree
# Aneta Dufkova (xdufko02)
# 2022

TARGET=flp21-log
SOURCE_FILES=flp21-log.pl
EXECUTABLE=flp21-log
ZIP=flp-log-xdufko02.zip
FOLDERS=test/*.*
OTHER_FILES=README.md

default:
	swipl -q -g start -o ${TARGET} -c ${SOURCE_FILES}

zip:
	zip ${ZIP} ${FOLDERS} ${OTHER_FILES} Makefile ${SOURCE_FILES}

clear:
	rm -rf  ${EXECUTABLE} ${ZIP}

run:
	./flp21-log < test/test1.in





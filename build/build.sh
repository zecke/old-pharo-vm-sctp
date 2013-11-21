#!bash

if [ ! -e vmVersionInfo.h ]; then
	../codegen-scripts/extract-commit-info.sh
fi
cmake .
make


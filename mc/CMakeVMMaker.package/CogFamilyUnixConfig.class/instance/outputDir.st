directories
outputDir

	"the directory where built binaries will be stored"
	^ outputDir ifNil: [ outputDir := '${CMAKE_SOURCE_DIR}/../', self outputDirName ]
directories
setupDirectories: gen
	| dirsInclude |

	" write the directories in separate include file"
	dirsInclude := gen captureOutputDuring: [
		gen
			set: #topDir toString: '${CMAKE_SOURCE_DIR}/..'; 
			set: #buildDir toString: '${CMAKE_SOURCE_DIR}/../build';
			set: #thirdpartyDir toString: '${buildDir}/thirdParty';
			set: #platformsDir toString: '${CMAKE_SOURCE_DIR}/../platforms';
			set: #srcDir toString: '${CMAKE_SOURCE_DIR}/../src';
			set: #srcPluginsDir toString: (pluginsDir ifNil: [ '${srcDir}/plugins' ]);
			set: #srcVMDir toString: '${srcDir}/vm';
			set: #platformName toString: self platformName;
			set: #targetPlatform to: '${platformsDir}/${platformName}';
			set: #crossDir toString: '${platformsDir}/Cross';
			set: #platformVMDir toString: '${targetPlatform}/vm';
			set: #outputDir toString: self outputDir.
	].

	self write: dirsInclude toFile: 'directories.cmake'.
	
	gen include: 'directories.cmake'.

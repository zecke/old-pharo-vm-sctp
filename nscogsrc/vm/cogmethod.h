/* Automatically generated by
	CCodeGenerator VMMaker.oscog-eem.114 uuid: c9755705-e606-4e32-92f1-228c68774f30
 */

typedef struct {
	unsigned short	homeOffset;
	unsigned short	startpc;
	unsigned		cmNumArgs : 8;
	unsigned		cmType : 3;
	unsigned		cmRefersToYoung : 1;
	unsigned		cmIsUnlinked : 1;
	unsigned		cmUsageCount : 3;
	unsigned		stackCheckOffset : 16;
 } CogBlockMethod;

typedef struct {
	sqInt	objectHeader;
	unsigned		cmNumArgs : 8;
	unsigned		cmType : 3;
	unsigned		cmRefersToYoung : 1;
	unsigned		cmIsUnlinked : 1;
	unsigned		cmUsageCount : 3;
	unsigned		stackCheckOffset : 16;
	unsigned short	blockSize;
	unsigned short	blockEntryOffset;
	sqInt	methodObject;
	sqInt	methodHeader;
	sqInt	selector;
 } CogMethod;

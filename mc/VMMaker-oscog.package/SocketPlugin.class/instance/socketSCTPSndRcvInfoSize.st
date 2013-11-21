primitives
socketSCTPSndRcvInfoSize
	"We can not include netinet/sctp.h directly so we need to go via a primitive"
	^ self cCode: 'sqSocketSCTPSndRcvInfoSize()' inSmalltalk: [32]
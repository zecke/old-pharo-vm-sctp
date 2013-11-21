primitives
primitiveSocketSCTP: socket receiveUDPDataBuf: array start: startIndex count: count 
	| s byteSize arrayBase bufStart bytesReceived results address port  stream ssn assoc ppid |
	<var: #s type: 'SocketPtr'>
	<var: #arrayBase type: 'char *'>
	<var: #bufStart type: 'char *'>
	self primitive: 'primitiveSocketSCTPReceive'
		parameters: #(Oop Oop SmallInteger SmallInteger ).
	s := self socketValueOf: socket.

	"buffer can be any indexable words or bytes object"
	interpreterProxy success: (interpreterProxy isWordsOrBytes: array).
	(interpreterProxy isWords: array)
		ifTrue: [byteSize := 4]
		ifFalse: [byteSize := 1].
	interpreterProxy success: (startIndex >= 1
			and: [count >= 0 and: [startIndex + count - 1 <= (interpreterProxy slotSizeOf: array)]]).
	interpreterProxy failed
		ifFalse: ["Note: adjust bufStart for zero-origin indexing"
			arrayBase := self cCoerce: (interpreterProxy firstIndexableField: array) to: 'char *'.
			bufStart := arrayBase + (startIndex - 1 * byteSize).
			"allocate storage for results, remapping newly allocated
			 oops in case GC happens during allocation"
			address		  := 0.
			port			  := 0.
			ssn 			  := 0.
			stream               := 0.
			ppid 			  := 0.
			assoc                 := 0.
			
			bytesReceived := self
						sqSocketSCTP: s
						Receive: bufStart
						Count: count * byteSize
						Address: (self cCode: '&address')
						Port: (self cCode: '&port')
						Stream: (self cCode: '&stream')
						AssocId: (self cCode: '&assoc')
						Ppid: (self cCode: '&ppid')
						Ssn: (self cCode: '&ssn').

			interpreterProxy pushRemappableOop: ssn asSmallIntegerObj.
			interpreterProxy pushRemappableOop: ppid asSmallIntegerObj.
			interpreterProxy pushRemappableOop: assoc asSmallIntegerObj.
			interpreterProxy pushRemappableOop: stream asSmallIntegerObj.				
			interpreterProxy pushRemappableOop: port asSmallIntegerObj.
			interpreterProxy pushRemappableOop: (self intToNetAddress: address).
			interpreterProxy pushRemappableOop: (bytesReceived // byteSize) asSmallIntegerObj.
			interpreterProxy pushRemappableOop:
				(interpreterProxy instantiateClass: (interpreterProxy classArray) indexableSize: 7).
			results         := interpreterProxy popRemappableOop.
			interpreterProxy storePointer: 0 ofObject: results withValue: interpreterProxy popRemappableOop.
			interpreterProxy storePointer: 1 ofObject: results withValue: interpreterProxy popRemappableOop.
			interpreterProxy storePointer: 2 ofObject: results withValue: interpreterProxy popRemappableOop.
			interpreterProxy storePointer: 3 ofObject: results withValue: interpreterProxy popRemappableOop.
			interpreterProxy storePointer: 4 ofObject: results withValue: interpreterProxy popRemappableOop.
			interpreterProxy storePointer: 5 ofObject: results withValue: interpreterProxy popRemappableOop.
			interpreterProxy storePointer: 6 ofObject: results withValue: interpreterProxy popRemappableOop. 
			].
	^ results
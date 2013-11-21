primitives
primitiveSocketSCTPEnableDataIOEvent: socket enable: aFlag
	| s done |
	<var: #s type: 'SocketPtr'>
	self primitive: 'primitiveSocketSCTPEnableDataIOEvent'
		parameters: #(Oop SmallInteger).
	s := self socketValueOf: socket.
	done := self sqSocketSCTPEnableDataIOEvent: s enable: aFlag.
	^done asBooleanObj
as yet unclassified
executeActionRemotelyOn: aSettingNode
	| vmLocation cmd res |
	vmLocation := CRDeploymentSettings current vmFolder.
	cmd := String
		streamContents: [ :stream | 
			stream << 'cd "' << vmLocation pathString << '" && '.
			Smalltalk os isUnix
				ifTrue: [ stream << 'export SQUEAK_PLUGINS="" && ' ].
			stream << $" << (vmLocation allChildrenMatching: 'Pharo.exe') first pathString << $"
				<<
					(Smalltalk os isUnix
						ifTrue: [ ' --nodisplay ' ]
						ifFalse: [ ' --headless ' ]) << $" << (vmLocation allChildrenMatching: '*.image') first pathString << '" '.
			stream << '--no-default-preferences eval --save ' << $" << (self script: aSettingNode) << $" ].
	res := PhLProcessWrapper waitForCommand: cmd.
	self halt.
	1 seconds wait
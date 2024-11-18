AggLayerURL = {{ .Values.config.agglayerURL | quote }}
ContractVersions = {{ .Values.config.contractsVersion | quote }}
ForkId = {{ .Values.config.forkId | int }}
genesisBlockNumber = {{ .Values.config.l1.rollupManagerBlockNumber | int }}
IsValidiumMode = {{ .Values.config.isValidium | bool }}
L1URL = {{ .Values.config.l1.rpcURL | quote }}
L2Coinbase = {{ .Values.config.l2.sequencerAddress | quote }}
L2URL = {{ .Values.config.l2.rpcURL | quote }}
PathRWData = {{ .Values.storage.path | quote }}
polygonBridgeAddr = {{ .Values.config.bridgeAddress | quote }}
RPCURL = {{ .Values.config.l2.rpcURL | quote }}
rollupCreationBlockNumber = {{ .Values.config.l1.rollupManagerBlockNumber | int }}
rollupManagerCreationBlockNumber = {{ .Values.config.l1.rollupManagerBlockNumber | int }}
SenderProofToL1Addr = {{ .Values.config.l2.agglayerAddress | quote }}
WitnessURL = {{ .Values.config.l2.rpcURL | quote }}

[L1Config]
chainId = {{ .Values.config.l1.chainId | int }}
polygonZkEVMGlobalExitRootAddress = {{ .Values.config.l1.globalExitRootAddress | quote }}
polygonRollupManagerAddress = {{ .Values.config.l1.rollupManagerAddress | quote }}
polTokenAddress = {{ .Values.config.l1.polTokenAddress | quote }}
polygonZkEVMAddress = {{ .Values.config.l1.rollupAddress | quote }}
	
[L2Config]
GlobalExitRootAddr = {{ .Values.config.l2.globalExitRootAddress | quote }}

[Log]
Environment = {{ .Values.config.log.environment | quote }}
Level = {{ .Values.config.log.level | quote }}
Outputs = ["stderr"]
       
[AggSender]
CertificateSendInterval = {{ .Values.config.aggSender.certificateSendInterval | quote }}
CheckSettledInterval = {{ .Values.config.aggSender.checkSettledInterval | quote }}

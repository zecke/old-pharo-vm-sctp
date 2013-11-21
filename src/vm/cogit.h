
/*** Function Prototypes ***/
EXPORT(sqInt) abortOffset(void);
EXPORT(void) addCogMethodsToHeapMap(void);
EXPORT(sqInt) bytecodePCForstartBcpcin(sqInt mcpc, sqInt startbcpc, CogBlockMethod *cogMethod);
EXPORT(sqInt) canLinkToYoungClasses(void);
extern void (*ceCaptureCStackPointers)();
EXPORT(sqInt) ceCPICMissreceiver(CogMethod *cPIC, sqInt receiver);
extern void (*ceEnter0ArgsPIC)();
extern void (*ceEnter1ArgsPIC)();
extern void (*ceEnter2ArgsPIC)();
extern void (*ceEnterCogCodePopReceiverAndClassRegs)();
extern void (*ceEnterCogCodePopReceiverArg0Regs)();
extern void (*ceEnterCogCodePopReceiverArg1Arg0Regs)();
extern void (*ceEnterCogCodePopReceiverReg)();
EXPORT(sqInt) ceSICMiss(sqInt receiver);
EXPORT(void) checkAssertsEnabledInCogit(void);
EXPORT(sqInt) checkIntegrityOfObjectReferencesInCode(sqInt fullGCFlag);
EXPORT(char *) codeEntryFor(char *address);
EXPORT(char *) codeEntryNameFor(char *address);
EXPORT(sqInt) cogCodeBase(void);
EXPORT(sqInt) cogCodeConstituents(void);
EXPORT(void) cogitPostGCAction(sqInt gcMode);
EXPORT(sqInt) cogMethodDoesntLookKosher(CogMethod *cogMethod);
EXPORT(CogMethod *) cogMNUPICSelectormethodOperandnumArgs(sqInt selector, sqInt methodOperand, sqInt numArgs);
EXPORT(CogMethod *) cogselector(sqInt aMethodObj, sqInt aSelectorOop);
EXPORT(void) compactCogCompiledCode(void);
EXPORT(void) enterCogCodePopReceiver(void);
EXPORT(void) enterCogCodePopReceiverAndClassRegs(void);
EXPORT(void) enterCogCodePopReceiverArg0Regs(void);
EXPORT(void) enterCogCodePopReceiverArg1Arg0Regs(void);
EXPORT(CogBlockMethod *) findEnclosingMethodForinHomeMethod(sqInt mcpc, CogMethod *cogMethod);
EXPORT(CogBlockMethod *) findMethodForStartBcpcinHomeMethod(sqInt startbcpc, CogMethod *cogMethod);
EXPORT(sqInt) genQuickReturnConst(void);
EXPORT(sqInt) genQuickReturnInstVar(void);
EXPORT(sqInt) genQuickReturnSelf(void);
EXPORT(void) initializeCodeZoneFromupTo(sqInt startAddress, sqInt endAddress);
EXPORT(sqInt) interpretOffset(void);
EXPORT(sqInt) isPCWithinMethodZone(char *address);
EXPORT(sqInt) isSendReturnPC(sqInt retpc);
EXPORT(void) linkSendAtintooffsetreceiver(sqInt callSiteReturnAddress, CogMethod *sendingMethod, CogMethod *targetMethod, sqInt theEntryOffset, sqInt receiver);
EXPORT(void) mapObjectReferencesInMachineCode(sqInt gcMode);
EXPORT(void) markAndTraceObjectsOrFreeMachineCode(sqInt inFullGC);
EXPORT(void) markMethodAndReferents(CogBlockMethod *aCogMethod);
EXPORT(usqInt) maxCogMethodAddress(void);
EXPORT(sqInt) mcPCForstartBcpcin(sqInt bcpc, sqInt startbcpc, CogBlockMethod *cogMethod);
EXPORT(CogMethod *) methodFor(void *address);
EXPORT(sqInt) minCogMethodAddress(void);
EXPORT(sqInt) mnuOffset(void);
EXPORT(sqInt) numMethodsOfType(sqInt cogMethodType);
EXPORT(sqInt) patchToOpenPICFornumArgsreceiver(sqInt selector, sqInt numArgs, sqInt receiver);
EXPORT(sqInt) pcisWithinMethod(char *address, CogMethod *cogMethod);
EXPORT(void) printCogMethodFor(void *address);
EXPORT(void) printCogMethods(void);
EXPORT(void) printCogMethodsOfType(sqInt cmType);
EXPORT(void) printCogMethodsWithMethod(sqInt methodOop);
EXPORT(void) printCogMethodsWithSelector(sqInt selectorOop);
EXPORT(void) printTrampolineTable(void);
EXPORT(void) recordCallOffsetInof(CogMethod *cogMethod, void *callLabelArg);
EXPORT(sqInt) recordPrimTraceFunc(void);
EXPORT(void) rewritePrimInvocationInto(CogMethod *cogMethod, void (*primFunctionPointer)(void));
EXPORT(void) setBreakMethod(sqInt anObj);
EXPORT(void) setPostCompileHook(void (*aFunction)(CogMethod *, void *));
EXPORT(void) setSelectorOfto(CogMethod *cogMethod, sqInt aSelectorOop);
EXPORT(sqInt) traceLinkedSendOffset(void);
EXPORT(void) unlinkAllSends(void);
EXPORT(void) unlinkSendsOfisMNUSelector(sqInt selector, sqInt isMNUSelector);
EXPORT(void) unlinkSendsToFree(void);
EXPORT(void) unlinkSendsToandFreeIf(sqInt targetMethodObject, sqInt freeIfTrue);
EXPORT(void) voidCogCompiledCode(void);


/*** Global Variables ***/
VM_EXPORT sqInt blockNoContextSwitchOffset;
VM_EXPORT sqInt breakPC;
VM_EXPORT void * CFramePointer;
VM_EXPORT void * CStackPointer;
VM_EXPORT sqInt ceBaseFrameReturnTrampoline;
VM_EXPORT sqInt ceCannotResumeTrampoline;
VM_EXPORT void (*ceCaptureCStackPointers)(void);
VM_EXPORT sqInt ceCheckForInterruptTrampoline;
VM_EXPORT void (*ceEnter0ArgsPIC)(void);
VM_EXPORT void (*ceEnter1ArgsPIC)(void);
VM_EXPORT void (*ceEnter2ArgsPIC)(void);
VM_EXPORT void (*ceEnterCogCodePopReceiverAndClassRegs)(void);
VM_EXPORT void (*ceEnterCogCodePopReceiverArg0Regs)(void);
VM_EXPORT void (*ceEnterCogCodePopReceiverArg1Arg0Regs)(void);
VM_EXPORT void (*ceEnterCogCodePopReceiverReg)(void);
VM_EXPORT unsigned long (*ceGetSP)(void);
VM_EXPORT sqInt ceReturnToInterpreterTrampoline;
VM_EXPORT unsigned long (*ceTryLockVMOwner)(void);
VM_EXPORT void (*ceUnlockVMOwner)(void);
VM_EXPORT sqInt cFramePointerInUse;
VM_EXPORT sqInt cmEntryOffset;
VM_EXPORT sqInt cmNoCheckEntryOffset;
VM_EXPORT unsigned long debugPrimCallStackOffset;
VM_EXPORT void (*realCEEnterCogCodePopReceiverAndClassRegs)(void);
VM_EXPORT void (*realCEEnterCogCodePopReceiverArg0Regs)(void);
VM_EXPORT void (*realCEEnterCogCodePopReceiverArg1Arg0Regs)(void);
VM_EXPORT void (*realCEEnterCogCodePopReceiverReg)(void);
VM_EXPORT int traceFlags ;
VM_EXPORT sqInt traceStores;


/*** Macros ***/
#define breakOnImplicitReceiver() (traceFlags & 64)
#define ceBaseFrameReturnPC() ceBaseFrameReturnTrampoline
#define ceCannotResumePC() ((usqInt)ceCannotResumeTrampoline)
#define ceReturnToInterpreterPC() ((usqInt)ceReturnToInterpreterTrampoline)
#define dynSuperEntryOffset() cmDynSuperEntryOffset
#define entryOffset() cmEntryOffset
#define getCFramePointer() CFramePointer
#define getCStackPointer() CStackPointer
#define noCheckEntryOffset() cmNoCheckEntryOffset
#define noContextSwitchBlockEntryOffset() blockNoContextSwitchOffset
#define numRegArgs() 1
#define printOnTrace() (traceFlags & 1)
#define recordBlockTrace() (traceFlags & 4)
#define recordEventTrace() (traceFlags & 16)
#define recordOverflowTrace() (traceFlags & 32)
#define recordPrimTrace() (traceFlags & 8)
#define recordSendTrace() (traceFlags & 2)
#define setCFramePointer(theFP) (CFramePointer = (void *)(theFP))
#define setCStackPointer(theSP) (CStackPointer = (void *)(theSP))
#define tryLockVMOwner() (ceTryLockVMOwner() != 0)
#define unlockVMOwner() ceUnlockVMOwner()


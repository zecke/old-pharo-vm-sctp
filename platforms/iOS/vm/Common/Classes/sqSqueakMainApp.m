/*
 *  sqSqueakMainApp.m
 *  
 *
 *  Created by John M McIntosh on 5/15/08.
 *
 */
/*
 Some of this code was funded via a grant from the European Smalltalk User Group (ESUG)
 Copyright (c) 2008 Corporate Smalltalk Consulting Ltd. All rights reserved.
 *   Small parts of this code is 
 *   Copyright (C) 1996-2007 by Ian Piumarta and other authors/contributors
 *                              listed elsewhere in this file.
 *   All rights reserved.
 MIT License
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

The end-user documentation included with the redistribution, if any, must include the following acknowledgment: 
"This product includes software developed by Corporate Smalltalk Consulting Ltd (http://www.smalltalkconsulting.com) 
and its contributors", in the same place and form as other third-party acknowledgments. 
Alternately, this acknowledgment may appear in the software itself, in the same form and location as other 
such third-party acknowledgments.
*/
//

#import "sqSqueakAppDelegate.h"

#import "sq.h"
#import "sqSqueakMainApp.h"
#import "sqMacV2Memory.h"
#import <limits.h>

#warning what about these guyes?
/*** Variables -- globals for access from pluggable primitives ***/
EXPORT(int)		argCnt= 0;
EXPORT(char**)	argVec= 0;
EXPORT(char**)	envVec= 0;

extern sqSqueakAppDelegate *gDelegateApp;

BOOL			gQuitNowRightNow=NO;
BOOL            gSqueakHeadless=NO;
int				gSqueakUseFileMappedMMAP=0;
char            gSqueakUntrustedDirectoryName[PATH_MAX];
char            gSqueakTrustedDirectoryName[PATH_MAX];

extern sqInt printAllStacks(void);
extern sqInt printCallStack(void);
extern void dumpPrimTraceLog(void);
extern BOOL NSApplicationLoad(void);

#if COGVM || STACKVM 
/* Print an error message, possibly a stack trace, and exit. */
/* Disable Intel compiler inlining of error which is used for breakpoints */
#pragma auto_inline off
void
error(char *msg)
{
	/* flag prevents recursive error when trying to print a broken stack */
	static sqInt printingStack = false;
	
	printf("\n%s\n\n", msg);
	
	if (ioOSThreadsEqual(ioCurrentOSThread(),getVMOSThread())) {
		if (!printingStack) {
			printingStack = true;
			printf("\n\nSmalltalk stack dump:\n");
			printCallStack();
		}
	}
	else
		printf("\nCan't dump Smalltalk stack. Not in VM thread\n");
	printf("\nMost recent primitives\n");
	dumpPrimTraceLog();
	abort();
}
#pragma auto_inline on

void sigsegv(int ignore)
{
#pragma unused(ignore)
	
	error("Segmentation fault");
}
#else
void sigsegv(int ignore)
{
#pragma unused(ignore)
	
	/* error("Segmentation fault"); */
	static int printingStack= 0;
	
	printf("\nSegmentation fault\n\ns");
	if (!printingStack)
	{
		printingStack= 1;
		printAllStacks();
	}
	abort();
}
#endif

sqInt ioExit(void) {
	//API Documented
 	[gDelegateApp.squeakApplication ioExit];
 	return 0;
}

sqInt ioExitWithErrorCode(int ec) {
	//API Documented
 	[gDelegateApp.squeakApplication ioExitWithErrorCode: ec];
 	return 0;
}

sqInt ioDisablePowerManager(sqInt disableIfNonZero) {
	//API Documented
	return 0;
}	

#if COGVM
/*
 * Support code for Cog.
 * a) Answer whether the C frame pointer is in use, for capture of the C stack
 *    pointers.
 */
# if defined(i386) || defined(__i386) || defined(__i386__)
/*
 * Cog has already captured CStackPointer  before calling this routine.  Record
 * the original value, capture the pointers again and determine if CFramePointer
 * lies between the two stack pointers and hence is likely in use.  This is
 * necessary since optimizing C compilers for x86 may use %ebp as a general-
 * purpose register, in which case it must not be captured.
 */
int
isCFramePointerInUse()
{
	extern unsigned long CStackPointer, CFramePointer;
	extern void (*ceCaptureCStackPointers)(void);
	unsigned long currentCSP = CStackPointer;
	
	currentCSP = CStackPointer;
	ceCaptureCStackPointers();
	assert(CStackPointer < currentCSP);
	return CFramePointer >= CStackPointer && CFramePointer <= currentCSP;
}
# endif /* defined(i386) || defined(__i386) || defined(__i386__) */


/* Answer an approximation of the size of the redzone (if any).  Do so by
 * sending a signal to the process and computing the difference between the
 * stack pointer in the signal handler and that in the caller. Assumes stacks
 * descend.
 */

#if !defined(min)
# define min(x,y) (((x)>(y))?(y):(x))
#endif
static char *p = 0;

static void
sighandler(int sig) { p = (char *)&sig; }

static int
getRedzoneSize()
{
	struct sigaction handler_action, old;
	handler_action.sa_sigaction = sighandler;
	handler_action.sa_flags = SA_NODEFER | SA_SIGINFO;
	sigemptyset(&handler_action.sa_mask);
	(void)sigaction(SIGPROF, &handler_action, &old);

	do kill(getpid(),SIGPROF); while (!p);
	(void)sigaction(SIGPROF, &old, 0);
	return (char *)min(&old,&handler_action) - sizeof(struct sigaction) - p;
}

sqInt reportStackHeadroom;
static int stackPageHeadroom;

/* Answer the redzone size plus space for any signal handlers to run in.
 * N.B. Space for signal handers may include space for the dynamic linker to
 * run in since signal handlers may reference other functions, and linking may
 * be lazy.  The reportheadroom switch can be used to check empirically that
 * there is sufficient headroom.  At least on Mac OS X we see no large stack
 * usage that would indicate e.g. dynamic linking in signal handlers.
 * So answer only the redzone size and likely get small (2048 byte) pages.
 */
int
osCogStackPageHeadroom()
{
	if (!stackPageHeadroom)
		stackPageHeadroom = getRedzoneSize();
	return stackPageHeadroom;
}

#endif /* COGVM */

/* Andreas' stubs */
char* ioGetLogDirectory(void) { return ""; };
sqInt ioSetLogDirectoryOfSize(void* lblIndex, sqInt sz){ return 1; }


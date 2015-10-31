/*
 * Portable Object Compiler (c) 1997,98,2000,03,14.  All Rights Reserved.
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Library General Public License as published
 * by the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#ifndef __BLOCK_H__
#define __BLOCK_H__

#include "Object.h" /* Stepstone Object.h assumes #import */

#ifndef EXPORT
#define EXPORT /* empty */
#endif

#include <stdio.h> /* because Object.h can be from another runtime */
#include "objcrt.h"

/* allows "manual" construction of Blocks, ie. without compiler support */
extern id EXPORT newBlock (int n, IMP fn, void * data, IMP dtor);

@interface Block : Object
{
    IMP fn;   /* it's not _really_ an IMP, it's just a func pointer */
    IMP dtor; /* idem */
    int nVars;
    void ** data;
    id nextBlock;
}

+ errorHandler;
+ errorHandler:aHandler;
+ halt:message value:receiver;
- ifError:aHandler;
- value:anObject ifError:aHandler;
- on:aClassOfExceptions do:aHandler;
- value:anObject on:aClassOfExceptions do:aHandler;

- value;
- (int)intvalue;
- atExit;
- value:anObject;
- (int)intvalue:anObject;
- value:firstObject value:secondObject;
- (int)intvalue:firstObject value:secondObject;

- repeatTimes:(int)n;

/* private */

/* Blocks are not manually created or deleted; the compiler automatically
 * handles them, including automatic referencecounting memory management. */
- blkc:(int)n blkfn:(IMP)f blkv:(void **)d blkdtor:(IMP)c;
+ new;
- copy;
- deepCopy;
+ blkc:(int)n blkfn:(IMP)f blkv:(void **)d blkdtor:(IMP)c;
- free;
- ARC_dealloc;

- push:aBlock;
- pop;

- errorNumArgs;
- errorGoodHandler;

- shouldNotImplement;
- printOn:(IOD)anIod;
@end

#endif /* __BLOCK_H__ */
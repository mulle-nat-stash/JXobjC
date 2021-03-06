/*
 * Portable Object Compiler (c) 1997,98,2003.  All Rights Reserved.
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

#ifndef __OBJTREE_H__
#define __OBJTREE_H__

#include "cltn.h"

/* full name */
#define SortedCollection SortCltn

typedef struct objbbt
{
    struct objbbt * ulink;
    struct objbbt * rlink;
    struct objbbt * llink;
    int balance;
    id key;
} * objbbt_t;

/*!
 * @abstract Sorted collection of objects.
 * @discussion Stores objects in an AVL Tree. Invented in the USSR, AVL Trees
 * are self-balancing binary trees allowing fast manipulation of data.
 * Objects are ordered according to their @link compare: @/link message
 * responses.
 * @see Cltn
 * @indexgroup Collection
 */
@interface SortCltn : Cltn
{
    struct objbbt value;
    SEL cmpSel;
    id cmpBlk;
}

+ new;
+ new:(unsigned)n;
+ newDictCompare;
+ sortBy:sortBlock;
+ sortBlock:sortBlock;
+ newCmpSel:(SEL)aSel;
+ with:(int)nArgs, ...;
+ with:firstObject with:nextObject;
+ add:firstObject;
- copy;
- deepCopy;
- emptyYourself;
- freeContents;
- free;

- (unsigned)size;
- (BOOL)isEmpty;
- eachElement;

- (uintptr_t)hash;
- (BOOL)isEqual:aSort;

- add:anObject;
- addNTest:anObject;
- filter:anObject;
- replace:anObject;

- remove:oldObject;

- (BOOL)includesAllOf:aCltn;
- (BOOL)includesAnyOf:aCltn;

- addAll:aCltn;
- addContentsOf:aCltn;
- addContentsTo:aCltn;
- removeAll:aCltn;
- removeContentsFrom:aCltn;
- removeContentsOf:aCltn;

- intersection:bag;
- union:bag;
- difference:bag;

- asSet;
- asOrdCltn;

- detect:aBlock;
- detect:aBlock ifNone:noneBlock;
- select:testBlock;
- reject:testBlock;
- collect:transformBlock;
- (unsigned)count:aBlock;

- elementsPerform:(SEL)aSelector;
- elementsPerform:(SEL)aSelector with:anObject;
- elementsPerform:(SEL)aSelector with:anObject with:otherObject;
- elementsPerform:(SEL)aSelector with:anObject with:otherObject with:thirdObj;

- do:aBlock;
- do:aBlock until:(BOOL *)flag;

- find:anObject;
- (BOOL)contains:anObject;

- printOn:(IOD)aFile;

- fileOutOn:aFiler;
- fileInFrom:aFiler;

/* private */
- setupcmpblock:sortBlock;
- setupcmpsel:(SEL)aSel;
- ARC_dealloc;

- (objbbt_t)objbbtTop;
- (SEL)comparisonSelector;
@end

#endif /* __OBJTREE_H__ */

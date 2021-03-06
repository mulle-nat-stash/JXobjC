/*
 * Copyright (c) 1998 David Stes.
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

#ifndef TRLUNIT_H_
#define TRLUNIT_H_

#include "Dictionary.h"
#include "OCString.h"
#include "OrdCltn.h"
#include "Set.h"
#include "node.h"

extern id trlunit;

@class Symbol, Type;

@interface TranslationUnit : Node
{
    int msgcount;
    int icachecount;
    int blockcount;
    int heapvarcount;
    int retlabelcount;
    Set<Symbol> types;
    Dictionary<Symbol, Type> typedic;
    Dictionary defdic;
    id classfwds;
    id globals, globaldic, globalvals;
    id builtinfuns, builtintypes;
    id clsimpl;  /* one per file case */
    id clsimpls; /* more than one per file */
    id seldic, selcltn;
    id msgdic, fwdcltn;
    id protocols;
    id cats;
    Dictionary stringLits; /* Variable name as value, string as value */
    char * modname;
    char * modversion;
    char * bindfunname;
    char * moddescname;
    id usesentries;
    id definesentries;
    id methods;
    Dictionary classdefs;
    id structdefs;
    id gentypes;
    id enumtors;
    OrdCltn code;
    BOOL usingblocks;
    BOOL usingselfassign;
}

- browse;
- reset;

- (int)msgcount;
- (int)icachecount;
- (int)blockcount;
- (int)heapvarcount;
- returnlabel;
- gettmpvar;
- (BOOL)usingblocks;
- (BOOL)usingselfassign;
- usingblocks:(BOOL)x;
- usingselfassign:(BOOL)x;

- (char *)moddescname;
- setmodversion:(char *)v;
- setmodname:(char *)filename;

- prologue;
- epilogue;

- allclsimpls;
- addclsimpl:c;
- genglobfuncall;
- addCode:(Node)someCode;

- usesentry:name;
- definesentry:name;

- (int)seloffset:selector;
- (int)fwdoffset:message;

- (BOOL)istypeword:node;
- (BOOL)isbuiltinfun:node;
- defcat:cat;
- defbuiltinfun:node;
- defbuiltintype:node;
- def:(Symbol)sym astype:(Type)aType;
- undefSym:node asType:atype;
- defdata:node astype:aType;
- def:sym asprotocol:protodef;
- def:sym asclass:classdef;
- def:sel asmethod:method;
- def:sym as:def;
/* Returns the name of this string literal's associated variable. */
- (String)defStringLit:(String)aStr;
- defasclassfwd:sym;
- defenumtor:e;
- lookupprotocol:sym;
- lookupclass:sym;
- (BOOL)lookupclassfwd:sym;
- lookupglobal:sym;
- lookupmethod:sel;
- lookuptype:sym;
- lookupenumtor:sym;
- lookupstruct:s;
- lookupdef:sym;
- defstruct:s;

- addgentype:s;
- (BOOL)isgentype:s;

@end

#endif

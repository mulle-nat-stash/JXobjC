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

#include <stdlib.h>
#include <assert.h>
#include "Block.h"
#include "Object.h"
#include "OrdCltn.h"
#include "node.h"
#include "decl.h"
#include "precdecl.h"
#include "expr.h"
#include "listxpr.h"

@implementation PrecDecl

- abstrdecl
{
    if (decl)
    {
        id x = [decl abstrdecl];

        if (x)
            return [[PrecDecl new] decl:x];
    }
    return nil;
}

- decl:aRcvr
{
    assert ([aRcvr isKindOf:(id)[Decl class]]);
    decl = aRcvr;
    return self;
}

- typequals:aList
{
    assert ([aList isKindOf:(id)[OrdCltn class]]);
    typequals = aList;
    return self;
}

- identifier { return (decl) ? [decl identifier] : nil; }

- (BOOL)isfunproto { return (decl) ? [decl isfunproto] : NO; }

- hide:x rename:y
{
    if (decl)
        [decl hide:x rename:y];
    return self;
}

- star
{
    id r = [decl star];

    return (r) ? [[self copy] decl:r] : nil;
}

- funcall
{
    id r = [decl funcall];

    return (r) ? [[self copy] decl:r] : nil;
}

- synth
{
    if (typequals)
        [typequals collect:{ : each | [each perform:_cmd]}];
    if (decl)
        decl = [decl synth];
    return self;
}

- gendef:sym
{
    gc ('(');
    if (typequals)
        [typequals elementsPerform:_cmd with:sym];
    if (decl)
        [decl gendef:sym];
    gc (')');
    return self;
}

- gen
{
    gc ('(');
    if (typequals)
        [typequals elementsPerform:_cmd];
    if (decl)
        [decl gen];
    gc (')');
    return self;
}

- st80
{
    gc ('(');
    if (decl)
        [decl st80];
    gc (')');
    return self;
}

@end

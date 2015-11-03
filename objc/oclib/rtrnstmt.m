/*
 * Copyright (c) 1998,1999 David Stes.
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
 *
 */

#include <stdlib.h>
#include <assert.h>
#include <stdio.h> /* FILE */
#include "Object.h"
#include "node.h"
#include "stmt.h"
#include "expr.h"
#include "type.h"
#include "rtrnstmt.h"
#include "compstmt.h"
#include "classdef.h"
#include "options.h"
#include "def.h"
#include "methdef.h"
#include "stkframe.h"
#include "binxpr.h"
#include "dotxpr.h"
#include "arrowxpr.h"

@implementation ReturnStmt

- keyw:aKeyw
{
    keyw = aKeyw;
    return self;
}

- expr:anExpr
{
    expr = anExpr;
    return self;
}

- synth
{
    id c;

    for (c = curcompound; c; c = [c enclosing])
    {
        if ([c isblockexpr])
        {
            fatalat (keyw,
                     "non-local return from within block not yet supported");
        }
    }
    expr   = [expr synth];
    cmpdef = curcompound;
    if (o_refcnt)
    {
        if (expr)
        {
            id t = [expr type];

            if (![expr isconstexpr] && [t isid])
                incretval++;
            /* self is a bit special but must also be incref'ed */
            else if (curclassdef)
            {
                /* the following works in factory and instance case */
                if (curdef && [curdef ismethdef])
                {
                    if ([t isEqual:[curclassdef selftype]])
                        incretval++;
                }
            }
        }

        compound = curcompound;
        [compound usereturnflag];
    }

    return self;
}

- gen
{
    id label;
    if (o_refcnt && (label = [compound nextreturnlabel]) != nil)
    {
        if (keyw)
        {
            gl ([keyw lineno], [[keyw filename] str]);
        }
        gs ("if (_returnflag==0) {_returnflag++;");
        if (expr)
        {
            short shouldBracket = 0;
            gs ("_returnval=(");
            if ([compound restype] && [[compound restype] isid] &&
                (shouldBracket = 1))
            {
                gs ("((");
                [[compound restype] genabstrtype];
                gs (")(");
            }
            [expr gen];
            if (shouldBracket)
                gs ("))");
            gs (");");
        }
        if (incretval)
        {
            gs ("idincref((id)_returnval);");
        }
        gf ("goto %s;}", [label str]);
    }
    else
    {
        if (keyw)
            [keyw gen];
        else
            gs ("return");
        if (expr)
        {
            short shouldBracket = 0;
            /* FIXME */
            if ([cmpdef restype] && [[cmpdef restype] isid] &&
                !([expr isKindOf:ArrowExpr] || [expr isKindOf:DotExpr]) &&
                [[expr type] isid] && (shouldBracket = 1))
            {
                gs ("((");
                [[cmpdef restype] genabstrtype];
                gs (")(");
            }
            [expr gen];
            if (shouldBracket == 1)
                gs ("))");
        }
        gc (';');
    }
    return self;
}

- st80
{
    gc ('^');
    if (expr)
        [expr st80];
    else
        [e_self st80];
    gs (".\n");
    return self;
}

- go
{
    [topframe quitframe:YES];
    if (expr)
        [topframe returnval:[expr go]];
    return self;
}

@end

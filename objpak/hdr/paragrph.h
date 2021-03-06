/*
 * Portable Object Compiler (c) 1997,98.  All Rights Reserved.
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

#ifndef __PARAGRPH_H__
#define __PARAGRPH_H__

#include <stdio.h>
#include "Object.h"

@interface Paragraph : Object
{
    id text;
    id textStyle;
    id offset;
}

+ new;
+ withText:aText;
+ withText:aText style:aStyle;
- copy;
- free;

- text;
- textStyle;
- text:v;
- textStyle:v;

- asString;
- asText;

- printOn:(IOD)aFile;

/* private */
- withText:r style:v;
@end

#endif /* __PARAGRPH_H__ */

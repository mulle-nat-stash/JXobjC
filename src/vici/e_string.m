
/* 
 * VICI Copyright (c) 1999 David Stes
 *
 * $Id: e_string.m,v 1.1.1.1 2000/06/07 21:09:26 stes Exp $
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published 
 * by the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#ifndef __OBJECT_INCLUDED__
#define __OBJECT_INCLUDED__
#include <stdio.h> /* FILE */
#include "Object.h" /* Stepstone Object.h assumes #import */
#endif

#include <ordcltn.h>
#include <node.h>
#include <def.h>
#include <var.h>
#include <scalar.h>
#include <type.h>
#include "funwrap.h"
#include "globwrap.h"

static id e_strlen(id aList)
{
   char *dst = [[aList at:0] u_str];
   return [[Scalar new] u_int:strlen(dst)];
}

static id e_strcpy(id aList)
{
   char *dst = [[aList at:0] u_str];
   char *src = [[aList at:1] u_str];
   return [[Scalar new] u_str:strcpy(dst,src)];
}

static id e_strncpy(id aList)
{
   char *dst = [[aList at:0] u_str];
   char *src = [[aList at:1] u_str];
   size_t n = [[aList at:2] u_int];
   return [[Scalar new] u_str:strncpy(dst,src,n)];
}

FUNWRAP stringfunwraps[] = {
  {"strlen",e_strlen},
  {"strcpy",e_strcpy},
  {"strncpy",e_strncpy},
  {NULL,NULL},
};


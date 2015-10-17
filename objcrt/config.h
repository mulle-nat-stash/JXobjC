#ifndef OBJCRT_CONFIG_H
#define OBJCRT_CONFIG_H

#include "stdarg.h"
#define OC_VA_LIST va_list
#define OC_VA_START(ap, larg) va_start (ap, larg)
#define OC_VA_ARG(ap, type) va_arg (ap, type)
#define OC_VA_END(ap) va_end (ap)

/*
 * stes 11/97
 * Define (on WIN32) as __declspec(dllexport) or similar,
 * when building an OBJCRT.DLL (compile with -DOBJCRTDLL)
 */

#ifdef OBJCRTDLL
#define EXPORT
#else
#define EXPORT /* null */
#endif         /* OBJCRTDLL */

/*
 * See comment in objcrt.m.  For compilers that do not support common
 * storage of globals at all, this must be defined as '1'.
 */

#define OBJCRT_SCOPE_OBJCMODULES_EXTERN 0

/*
 * Compiled in path separator. (Module.m and objc.m)
 */

#define OBJCRT_DEFAULT_PATHSEPC "/"

#endif /* OBJCRT_CONFIG_H */

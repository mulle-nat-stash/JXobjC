/* Copyright (c) 2015 D. Mackay. All rights reserved. */

#import <Number.h>
#import <OCString.h>

@implementation Number

+ true
{
    static Number aNum = 0;
    if (!aNum)
        aNum = [self numberWithBool:YES];
    return aNum;
}

+ false
{
    static Number aNum = 0;
    if (!aNum)
        aNum = [self numberWithBool:NO];
    return aNum;
}

- (uintptr_t)hash { return (type * 4) % value.I; }

- (BOOL)isEqual:anObject
{
    if (!anObject || ![anObject isKindOf:Number])
        return NO;
    return [anObject doubleValue] == [self doubleValue];
}

- (BOOL)isTrue
{
    if ([self isFloat] && [self valueAsDouble])
        return YES;
    else if ([self isInteger] && [self valueAsLong])
        return YES;
    else
        return NO;
}

- (BOOL)isInteger { return ![self isFloat]; }

- (BOOL)isFloat
{
    switch (type)
    {
    case NUMBER_BOOL:
    case NUMBER_CHAR:
    case NUMBER_UCHAR:
    case NUMBER_USHORT:
    case NUMBER_INT:
    case NUMBER_UINT:
    case NUMBER_LONG:
    case NUMBER_ULONG:
    case NUMBER_LONGLONG:
    case NUMBER_ULONGLONG: return NO;

    default: return YES;
    }
}

- (long)valueAsLong
{
    /* clang-format off */
    return
        type == NUMBER_BOOL         ? value.b
      : type == NUMBER_CHAR         ? value.c
      : type == NUMBER_UCHAR        ? value.C
      : type == NUMBER_SHORT        ? value.s
      : type == NUMBER_USHORT       ? value.S
      : type == NUMBER_INT          ? value.i
      : type == NUMBER_UINT         ? value.I
      : type == NUMBER_LONG         ? value.l
      : type == NUMBER_ULONG        ? value.L
      : type == NUMBER_LONGLONG     ? value.q
      : type == NUMBER_ULONGLONG    ? value.Q
      : type == NUMBER_FLOAT        ? value.f
      : type == NUMBER_DOUBLE       ? value.d
      : /* _ */                       0;
    /* clang-format on */
}

- (double)valueAsDouble
{
    /* clang-format off */
    return
        type == NUMBER_BOOL         ? value.b
      : type == NUMBER_CHAR         ? value.c
      : type == NUMBER_UCHAR        ? value.C
      : type == NUMBER_SHORT        ? value.s
      : type == NUMBER_USHORT       ? value.S
      : type == NUMBER_INT          ? value.i
      : type == NUMBER_UINT         ? value.I
      : type == NUMBER_LONG         ? value.l
      : type == NUMBER_ULONG        ? value.L
      : type == NUMBER_LONGLONG     ? value.q
      : type == NUMBER_ULONGLONG    ? value.Q
      : type == NUMBER_FLOAT        ? value.f
      : type == NUMBER_DOUBLE       ? value.d
      : /* _ */                       0;
    /* clang-format on */
}

- (String)fmt
{
    if ([self isFloat])
        return [String sprintf:"%G", [self valueAsDouble]];
    else if ([self isInteger] && [self valueAsLong])
        return [String sprintf:"%li", [self valueAsLong]];
    else
        return 0;
}

- (number_type_e)type { return type; }

#define NumSet(typ, nam, ch, te)                                               \
    -initWith##nam : (typ)val                                                  \
    {                                                                          \
        value.ch = val;                                                        \
        type     = te;                                                         \
        return self;                                                           \
    }                                                                          \
    +numberWith##nam : (typ)val { return [[super new] initWith##nam:val]; }
NumSet (BOOL, Bool, b, NUMBER_BOOL);
NumSet (char, Char, c, NUMBER_CHAR);
NumSet (unsigned char, UChar, C, NUMBER_UCHAR);
NumSet (short, Short, s, NUMBER_SHORT);
NumSet (unsigned short, UShort, S, NUMBER_USHORT);
NumSet (int, Int, i, NUMBER_INT);
NumSet (unsigned int, UInt, I, NUMBER_UINT);
NumSet (long, Long, l, NUMBER_LONG);
NumSet (unsigned long, ULong, L, NUMBER_ULONG);
NumSet (long long, LongLong, q, NUMBER_LONGLONG);
NumSet (unsigned long long, ULongLong, Q, NUMBER_ULONGLONG);
NumSet (float, Float, f, NUMBER_FLOAT);
NumSet (double, Double, d, NUMBER_DOUBLE);
#undef NumFrom

#define NumVal(typ, nam, ch)                                                   \
    -(typ)nam##Value { return value.ch; }
NumVal (BOOL, bool, b);
NumVal (char, char, c);
NumVal (unsigned char, uChar, C);
NumVal (short, short, s);
NumVal (unsigned short, uShort, S);
NumVal (int, int, i);
NumVal (unsigned int, uInt, I);
NumVal (long, long, l);
NumVal (unsigned long, uLong, L);
NumVal (long long, longLong, q);
NumVal (unsigned long long, uLongLong, Q);
NumVal (float, float, f);
NumVal (double, double, d);
#undef NumVal

@end

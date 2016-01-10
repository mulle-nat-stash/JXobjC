#!/usr/bin/env sh

genDocs () # $1: output directory; $2: input directory
{
    mkdir -p $1
    headerdoc2html -o `pwd`/$1 -p `pwd`/$2
    gatherheaderdoc `pwd`/$1 index.html
}


kmk cleandoc
cd doc
genDocs Runtime ../objcrt/hdr
genDocs ObjectKit ../objpak/hdr
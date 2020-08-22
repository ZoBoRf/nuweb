# Nuweb

This is **not** the "official" `nuweb` repository.

Here I make available some small enhancements I made.

The official web site is http://nuweb.sourceforge.net/.

`Nuweb` is a [literate programming](http://www.literateprogramming.com/) tool like [Knuth's `WEB`](http://www.literateprogramming.com/knuthweb.pdf) only simpler. More on *literate programming* you can find on [Wikipedia](https://en.wikipedia.org/wiki/Literate_programming).

A `nuweb` file contains program source code interleaved with documentation.  

Knuth describes the system as follows:

> A WEB user writes a program that serves as the source
> language for two different system routines.
>
> ```
>                 TeX
>          [TeX] -----> [DVI]
>   WEAVE /
>        /
>   [WEB]
>        \
>  TANGLE \
>          [PAS] -----> [REL]
>                PASCAL
> ```
> 
> One line of processing is called **weaving** the web; 
> it produces a document that describes the program clearly
> and that facilitates program maintenance.
> The other line of processing is called **tangling** the web;
> it produces a machine-executable program. The program
> and its documentation are both generated from
> the same source, so they are consistent with each other.

When `nuweb` is given `nuweb` a file, it writes the program file(s), 
and also produces `LaTeX` source for typeset documentation, i.e. `nuweb` tangles and
weaves at the same time.

# Prerequisites

Prerequisites for building and using `nuweb`:

* GNU C Compiler `gcc`
  - On Windows I use [MinGW](http://www.mingw.org/wiki/MSYS), the *Minimalist GNU for Windows*.
* A TeX distribution
  - On Windows I use [MikTeX](https://miktex.org/howto/install-miktex)

# Bootstrap `nuweb`

Use already tangled sources to build the initial `nuweb.exe`.

```
$ cd nuweb
$ make nuweb
cc -g   -c -o main.o main.c
cc -g   -c -o pass1.o pass1.c
cc -g   -c -o latex.o latex.c
cc -g   -c -o html.o html.c
cc -g   -c -o output.o output.c
cc -g   -c -o input.o input.c
cc -g   -c -o scraps.o scraps.c
cc -g   -c -o names.o names.c
cc -g   -c -o arena.o arena.c
cc -g   -c -o global.o global.c
cc -o nuweb main.o pass1.o latex.o html.o output.o input.o scraps.o names.o arena.o global.o
```

# Rebuild from `nuweb.w`

The current directory and TeX must be in your `PATH`:

```
$ export PATH=.:$PATH
$ export PATH=/C/Program\ Files\ \(x86\)/MiKTeX\ 2.9/miktex/bin:$PATH
```

Now use `nuweb.exe` to rebuild itself from it's `nuweb.w` source.

```
$ make
make nuweb.tex
make[1]: Entering directory '.../nuweb'
nuweb -r nuweb.w
nuweb: you'll need to rerun nuweb after running latex
nuweb -r nuweb.w
nuweb: you'll need to rerun nuweb after running latex
make[1]: Leaving directory '.../nuweb'
make nuweb
make[1]: Entering directory '.../nuweb'
cc -g   -c -o main.o main.c
cc -g   -c -o pass1.o pass1.c
cc -g   -c -o latex.o latex.c
cc -g   -c -o html.o html.c
cc -g   -c -o output.o output.c
cc -g   -c -o input.o input.c
cc -g   -c -o scraps.o scraps.c
cc -g   -c -o names.o names.c
cc -g   -c -o arena.o arena.c
cc -g   -c -o global.o global.c
cc -o nuweb main.o pass1.o latex.o html.o output.o input.o scraps.o names.o arena.o global.o
make[1]: Leaving directory '.../nuweb'
```

## Check the Build

Optionally test the build

```
$ make check
...
Testing test/00/t0001a.sh
/c/storage/project/nuweb.github/nuweb/./nuweb: you'll need to rerun nuweb after running latex
/c/storage/project/nuweb.github/nuweb/./nuweb: <Test with parameter> never referenced.
Testing test/00/t0002a.sh
...
Output written on test.dvi (1 page, 1752 bytes).
Transcript written on test.log.
35 done
0 failed

```

## Build the `weave`d literate program PDF

```
$ cd nuweb
$ make nuweb.pdf
```
If the references in the PDF file are not right (i.e. are shown as `[?]`),
repeat the following steps up to three times (TeX generates different 
intermediate files, which it includes in later runs):

```
$ touch nuweb.w
$ make nuweb.tex
$ make nuweb.pdf
```

## Build the `nuweb` documentation PDF

Make the `nuweb` docs `nuwebdoc.pdf`:

```
$ make nuwebdoc.pdf
sed -e '/^\\ifshowcode$/,/^\\fi$/d' nuweb.tex > nuwebdoc.tex
pdflatex nuwebdoc
This is pdfTeX, Version 3.14159265-2.6-1.40.21 (MiKTeX 2.9.7400)
...
...
mtt10.pfb>
Output written on nuwebdoc.pdf (12 pages, 300734 bytes).
Transcript written on nuwebdoc.log.
```

# RTFM

Read the fine manuals.

## How to Read a Weaved Nuweb Document

Keith Harwood, one of the developers and users of `nuweb` suggests in his [z-vimes](https://sourceforge.net/projects/z-vimes/files/) project's weaved documentation (file `z.pdf`), how to read a weaved nuweb document:

> This document is written using the literate programming style. The program is
> presented in a form which can, in principle, be read as a continuous narrative.
> Within the narrative the program code is presented as fragments. Each fragment
> is given a title which describes the action of the fragment. The bodies of the
> fragments contain code in the source language interspersed with references to
> other fragments. This allows us to describe the essential structure of the
> program, but defer details until later.
> 
> Each fragment is given an index indicating the page on which it occurs and, if
> there are more than one fragment on a page, a letter indicating which one.
> These indexes form cross-references between the definition and use of
> fragments. These cross-references are implemented as hyperlinks. The same
> cross-references also appear as comments in the code.
> 
> (If you are viewing this document with a pdf reader the coloured section names
> and fragment cross-references are hyperlinks. Click on them to switch attention
> to where they reference. If you are reading it on paper you have to turn the
> pages yourself. I apologise for that.)


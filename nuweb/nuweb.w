%
% Copyright (c) 1996, Preston Briggs
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions
% are met:
%
% Redistributions of source code must retain the above copyright notice,
% this list of conditions and the following disclaimer.
%
% Redistributions in binary form must reproduce the above copyright notice,
% this list of conditions and the following disclaimer in the documentation
% and/or other materials provided with the distribution.
%
% Neither name of the product nor the names of its contributors may
% be used to endorse or promote products derived from this software without
% specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
% ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
% FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHORS
% OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
% OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%

% Notes:
% Update on 2011-12-16 from Keith Harwood.
% -- @@s in scrap supresses indent of following fragment expansion
% -- @@<Name@@> in text is expanded
% Update on 2011-04-20 from Keith Harwood.
% -- @@t provide fragment title in output 
% Changes from 2010-03-11 in the Sourceforge revision history. -- sjw
% Updates on 2004-02-23 from Gregor Goldbach
% <glauschwuffel@@users.sourceforge.net>
% -- new command line option -r which will make nuweb typeset each
% NWtarget and NWlink instance with \LaTeX-commands from the hyperref
% package. This gives clickable scrap numbers which is very useful
% when viewing the document on-line.

% Updates on 2004-02-13 from Gregor Goldbach
% <glauschwuffel@@users.sourceforge.net>
% -- new command line option -l which will make nuweb typeset scraps
%    with the help of LaTeX's listings packages instead or pure
%    verbatim.
% -- man page corrections and additions.

% Updates on 2003-04-24 from Keith Harwood <Keith.Harwood@@vitalmis.com>
% -- sectioning commands (@@s and global-plus-sign in scrap names)
% -- @@x..@@x labelling
% -- @@f current file
% -- @@\# suppress indent

% This file has been changed by Javier Goizueta <jgoizueta@@jazzfree.es>
% on 2001-02-15.
% These are the changes:
% LANG  -- Introduction of \NW macros to substitue language dependent text
% DIAM  -- Introduction of \NWsep instead of the \diamond separator
% HYPER -- Introduction of hyper-references
% NAME  -- LaTeX formatting of macro names in HTML output
% ADJ   -- Adjust of the spacing between < and a fragment name
% TEMPN -- Fix of the use of tempnam
% LINE  -- Synchronizing #lines when @@% is used
% MAC   -- definition of the macros used by LANG,DIAM,HYPER
% CHAR  -- Introduce @@r to change the nuweb meta character (@@)
% TIE   -- Replacement of ~ by "\nobreak\ "
% SCRAPs-- Elimination of s
% DNGL  -- Correction: option -d was not working and was misdocumented
%  --after the CHAR modifications, to be able to specify non-ascii characters
%    for the scape character, the program must be compiled with the -K
%    option in Borland compilers or the -funsigned-char in GNU's gcc
%    to treat char as an unsigned value when converted to int.
%    To make the program independent of those options, either char
%    should be changed to unsigned char (bad solution, since unsigned
%    char should be used for numerical purposes) or attention should
%    be payed to all char-int conversions. (including comparisons)

% --2002-01-15: the TILDE modificiation is necessary because some ties
%   have been introduced in version 0.93 in troublesome places when
%   the babel package is used with the spanish.ldf option (which makes
%   ~ an active character).

% --2002-01-15: an ``s'' was being added to the NWtxtDefBy and
%   NWtxtDefBy messages when followed by more than one reference.

\documentclass[a4paper]{report}
\newif\ifshowcode
\showcodetrue

\usepackage{latexsym}
%\usepackage{html}

\usepackage{listings}

\usepackage{color}
\definecolor{linkcolor}{rgb}{0, 0, 0.7}

\usepackage[%
backref,%
raiselinks,%
pdfhighlight=/O,%
pagebackref,%
hyperfigures,%
breaklinks,%
colorlinks,%
pdfpagemode=None,%
pdfstartview=FitBH,%
linkcolor={linkcolor},%
anchorcolor={linkcolor},%
citecolor={linkcolor},%
filecolor={linkcolor},%
menucolor={linkcolor},%
pagecolor={linkcolor},%
urlcolor={linkcolor}%
]{hyperref}

\setlength{\oddsidemargin}{0in}
\setlength{\evensidemargin}{0in}
\setlength{\topmargin}{0in}
\addtolength{\topmargin}{-\headheight}
\addtolength{\topmargin}{-\headsep}
\setlength{\textheight}{8.9in}
\setlength{\textwidth}{6.5in}
\setlength{\marginparwidth}{0.5in}

\title{Nuweb Version 1.58 \\ A Simple Literate Programming Tool}
\date{}
\author{Preston Briggs\thanks{This work has been supported by ARPA,
through ONR grant N00014-91-J-1989.}
\\ {\sl preston@@tera.com}
\\ HTML scrap generator by John D. Ramsdell
\\ {\sl ramsdell@@mitre.org}
\\ Scrap formatting by Marc W. Mengel
\\ {\sl mengel@@fnal.gov}
\\ Continuing maintenance by Simon Wright
\\ {\sl simon@@pushface.org}
\\ and Keith Harwood
\\ {\sl Keith.Harwood@@vitalmis.com}}

\begin{document}
\pagenumbering{roman}
\maketitle
\tableofcontents

\chapter{Introduction}
\pagenumbering{arabic}

In 1984, Knuth introduced the idea of {\em literate programming\/} and
described a pair of tools to support the practise~\cite{Knuth:CJ-27-2-97}.
His approach was to combine Pascal code with \TeX\ documentation to
produce a new language, \verb|WEB|, that offered programmers a superior
approach to programming. He wrote several programs in \verb|WEB|,
including \verb|weave| and \verb|tangle|, the programs used to support
literate programming.
The idea was that a programmer wrote one document, the web file, that
combined documentation (written in \TeX~\cite{Knuth:ct-a}) with code
(written in Pascal).

Running \verb|tangle| on the web file would produce a complete
Pascal program, ready for compilation by an ordinary Pascal compiler.
The primary function of \verb|tangle| is to allow the programmer to
present elements of the program in any desired order, regardless of
the restrictions imposed by the programming language. Thus, the
programmer is free to present his program in a top-down fashion,
bottom-up fashion, or whatever seems best in terms of promoting
understanding and maintenance.

Running \verb|weave| on the web file would produce a \TeX\ file, ready
to be processed by \TeX\@@. The resulting document included a variety of
automatically generated indices and cross-references that made it much
easier to navigate the code. Additionally, all of the code sections
were automatically prettyprinted, resulting in a quite impressive
document.

Knuth also wrote the programs for \TeX\ and {\small\sf METAFONT}
entirely in \verb|WEB|, eventually publishing them in book
form~\cite{Knuth:ct-b,Knuth:ct-d}. These are probably the
largest programs ever published in a readable form.

Inspired by Knuth's example, many people have experimented with
\verb|WEB|\@@. Some people have even built web-like tools for their
own favorite combinations of programming language and typesetting
language. For example, \verb|CWEB|, Knuth's current system of choice,
works with a combination of C (or C++) and \TeX~\cite{Levy:TB8-1-12}.
Another system, FunnelWeb, is independent of any programming language
and only mildly dependent on \TeX~\cite{Williams:FUM92}. Inspired by the
versatility of FunnelWeb and by the daunting size of its
documentation, I decided to write my own, very simple, tool for
literate programming.%
\footnote{There is another system similar to
mine, written by Norman Ramsey, called {\em noweb}~\cite{Ramsey:LPT92}. It
perhaps suffers from being overly Unix-dependent and requiring several
programs to use. On the other hand, its command syntax is very nice.
In any case, nuweb certainly owes its name and a number of features to
his inspiration.}


\section{Nuweb}

Nuweb works with any programming language and \LaTeX~\cite{Lamport:LDP85}. I
wanted to use \LaTeX\ because it supports a multi-level sectioning
scheme and has facilities for drawing figures. I wanted to be able to
work with arbitrary programming languages because my friends and I
write programs in many languages (and sometimes combinations of
several languages), {\em e.g.,} C, Fortran, C++, yacc, lex, Scheme,
assembly, Postscript, and so forth. The need to support arbitrary
programming languages has many consequences:
\begin{description}
\item[No prettyprinting] Both \verb|WEB| and \verb|CWEB| are able to
  prettyprint the code sections of their documents because they
  understand the language well enough to parse it. Since we want to use
  {\em any\/} language, we've got to abandon this feature.
  However, we do allow particular individual formulas or fragments
  of \LaTeX\ code to be formatted and still be parts of output files.
  Also, keywords in scraps can be surrounded by \verb|@@_| to
  have them be bold in the output.
\item[No index of identifiers] Because \verb|WEB| knows about Pascal,
  it is able to construct an index of all the identifiers occurring in
  the code sections (filtering out keywords and the standard type
  identifiers). Unfortunately, this isn't as easy in our case. We don't
  know what an identifier looks like in each language and we certainly
  don't know all the keywords. (On the other hand, see the end of
  Section~\ref{minorcommands})
\end{description}
Of course, we've got to have some compensation for our losses or the
whole idea would be a waste. Here are the advantages I can see:
\begin{description}
\item[Simplicity] The majority of the commands in \verb|WEB| are
  concerned with control of the automatic prettyprinting. Since we
  don't prettyprint, many commands are eliminated. A further set of
  commands is subsumed by \LaTeX\  and may also be eliminated. As a
  result, our set of commands is reduced to only four members (explained
  in the next section). This simplicity is also reflected in
  the size of this tool, which is quite a bit smaller than the tools
  used with other approaches.
\item[No prettyprinting] Everyone disagrees about how their code
  should look, so automatic formatting annoys many people. One approach
  is to provide ways to control the formatting. Our approach is
  simpler---we perform no automatic formatting and therefore allow the
  programmer complete control of code layout.
  We do allow individual scraps to be presented in either verbatim,
  math, or paragraph mode in the \TeX\ output.
\item[Control] We also offer the programmer complete control of the
  layout of his output files (the files generated during tangling). Of
  course, this is essential for languages that are sensitive to layout;
  but it is also important in many practical situations, {\em e.g.,}
  debugging.
\item[Speed] Since nuweb doesn't do too much, the nuweb tool runs
  quickly. I combine the functions of \verb|tangle| and \verb|weave| into
  a single program that performs both functions at once.
\item[Page numbers] Inspired by the example of noweb, nuweb refers to
  all scraps by page number to simplify navigation. If there are
  multiple scraps on a page (say, page~17), they are distinguished by
  lower-case letters ({\em e.g.,} 17a, 17b, and so forth).
\item[Multiple file output] The programmer may specify more than one
  output file in a single nuweb file. This is required when constructing
  programs in a combination of languages (say, Fortran and C)\@@. It's also
  an advantage when constructing very large programs that would require
  a lot of compile time.
\end{description}
This last point is very important. By allowing the creation of
multiple output files, we avoid the need for monolithic programs.
Thus we support the creation of very large programs by groups of
people.

A further reduction in compilation time is achieved by first
writing each output file to a temporary location, then comparing the
temporary file with the old version of the file. If there is no
difference, the temporary file can be deleted. If the files differ,
the old version is deleted and the temporary file renamed. This
approach works well in combination with \verb|make| (or similar tools),
since \verb|make| will avoid recompiling untouched output files.

\subsection{Nuweb and HTML}

In addition to producing {\LaTeX} source, nuweb can be used to
generate HyperText Markup Language (HTML), the markup language used by
the World Wide Web.  HTML provides hypertext links.  When an HTML
document is viewed online, a user can navigate within the document by
activating the links.  The tools which generate HTML automatically
produce hypertext links from a nuweb source.

(Note that hyperlinks can be included in \LaTeX\ using the
\verb|hyperref| package. This is now the preferred way of doing
this and the HTML processing is not up to date.)

\section{Writing Nuweb}

The bulk of a nuweb file will be ordinary \LaTeX\@@. In fact, any
{\LaTeX} file can serve as input to nuweb and will be simply copied
through, unchanged, to the documentation file---unless a nuweb command
is discovered. All nuweb commands begin with an ``at-sign''
(\verb|@@|).  Therefore, a file without at-signs will be copied
unchanged.  Nuweb commands are used to specify {\em output files,}
define {\em fragments,} and delimit {\em scraps}. These are the basic
features of interest to the nuweb tool---all else is simply text to be
copied to the documentation file.

\subsection{The Major Commands}

Files and fragments are defined with the following commands:
\begin{description}
\item[{\tt @@o} {\em file-name flags scrap\/}] Output a file. The file
  name is terminated by whitespace.
\item[{\tt @@d} {\em fragment-name scrap\/}] Define a fragment. The
  fragment name is terminated by a return or the beginning of a scrap.
\item[{\tt @@q} {\em fragment-name scrap\/}] Define a fragment. The
  fragment name is terminated by a return or the beginning of a scrap.
  This a quoted fragment.
\end{description}
A specific file may be specified several times, with each definition
being written out, one after the other, in the order they appear.
The definitions of fragments may be similarly specified piecemeal.

A fragment name may have embedded parameters. The parameters are
denoted by the sequence \texttt{@@'value@@'} where \texttt{value} is
an uninterpreted string of characters (although the sequence
\texttt{@@@@} denotes a single \texttt{@@} character). When a fragment
name is used inside a scrap the parameters may be replaced by an
argument which may be a different literal string, a fragment use, an
embedded fragment or by a parameter use.

The difference between a quoted fragment (\texttt{@@q}) and an
ordinary one (\texttt{@@d}) is that inside a quoted fragment fragments
are not expanded on output. Rather, they are formatted as uses of
fragments so that the output file can itself be \texttt{nuweb}
source. This allows you to create files containing fragments which can
undergo further processing before the fragments are expanded, while
also describing and documenting them in one place.

You can have both quoted and unquoted fragments with the same
name. They are written out in order as usual, with those introduced by
\texttt{@@q} being quoted and those with \texttt{@@d} expanded as
normal.

In quoted fragments, the \texttt{@@f} filename is quoted as well, so that
when it is expanded it refers to the finally produced file, not
any of the intermediate ones.

\subsubsection{Scraps}

Scraps have specific begin markers and end markers to allow precise
control over the contents and layout. Note that any amount of
whitespace (including carriage returns) may appear between a name and
the beginning of a scrap. Scraps may also appear in the running text
where they are formatted (almost) identically to their use in definitions,
but don't appear in any code output.
\begin{description}
\item[\tt @@\{{\em anything\/}@@\}] where the scrap body includes every
  character in {\em anything\/}---all the blanks, all the tabs, all the
  carriage returns.  This scrap will be typeset in verbatim mode. Using
  the \texttt{-l} option will cause the program to typeset the scrap with
  the help of \LaTeX's \texttt{listings} package.
\item[\tt @@[{\em anything\/}@@]] where the scrap body includes every
  character in {\em anything\/}---all the blanks, all the tabs, all the
  carriage returns.  This scrap will be typeset in paragraph mode, allowing
  sections of \TeX\ documents to be scraps, but still  be prettyprinted
  in the document.
\item[\tt @@({\em anything\/}@@)] where the scrap body includes every
  character in {\em anything\/}---all the blanks, all the tabs, all the
  carriage returns.  This scrap will be typeset in math mode.  This allows
  this scrap to contain a formula which will be typeset nicely.
\end{description}
Inside a scrap, we may invoke a fragment.
\begin{description}
\item[\tt @@<{\em fragment-name\/}@@>]
  This is a fragment use. It causes the fragment
  {\em fragment-name\/} to be expanded inline as the code is written out
  to a file. It is an error to specify recursive fragment invocations.
\item[\tt @@<{\em fragment-name\/}@@( {\em a1} @@, {\em a2} @@) @@>] This
  is the old form of parameterising a fragment. It causes the fragment
  {\em fragment-name\/} to be expanded inline with the arguments {\em a1},
    {\em a2}, etc. Up to 9 arguments may be given.
\item[\tt @@1, @@2, ..., @@9] In a fragment causes the n'th fragment
      argument to be substituted into the scrap.  If the argument
      is not passed, a null string is substituted.
      Arguments can be passed in two ways, either embedded in the
      fragment
      name or as the old form given above.

      An embedded argument may specified in four ways.
      \begin{description}
      \item[\tt @@'string@@']
      The string will be copied literally into the called fragment.
      It will not be interpreted (except for \texttt{@@@@} converted
            to \texttt{@@}).
      \item[\tt @@<{\em fragment-name\/}@@>]
      The fragment will be expanded in the usual fashion and the results
      passed to the called fragment.
      \item[\tt @@\{text@@\}]
      The text will be expanded as normal and the results passed to
      the called fragment. This behaves like an anonymous fragment which has
      the same arguments as the calling fragment. Its principle use is
      to combine text and arguments into one argument.
      \item[\tt @@1, @@2, ..., @@9]
      The argument of the calling fragment will be passed to the called
      fragment and expanded in there.
      \end{description}

      If an argument is used but there is no corresponding parameter
      in the fragment name, the null string is substituted. But what
      happens if there is a parameter in the full name of a fragment,
      but a particular application of the fragment is abbreviated
      (using the \verb|. . .| notation) and the argument is missed? In
      that case the argument is replaced by the string given in the
      definition of the fragment.

      In the old form the parameter may contain any text and will be
      expanded as a normal scrap. The two forms of parameter passing
      don't play nicely together. If a scrap passes both embedded and
      old form arguments the old form arguments are ignored.
\item[\tt @@x{\em label}@@x] Marks a place inside a scrap and
associates it to the label (which can be any text not containing
a @@). Expands to the reference number of the scrap followed by a
numeric value. Outside scraps it expands to the same value. It is
used so that text outside scraps can refer to particular places
within scraps.
\item[\tt @@f] Inside a scrap this is replaced by the name of the
current output file.
\item[\tt @@t] Inside a scrap this is replaced by the title of the
fragment as it is at the point it is used, with all parameters
replaced by actual arguments.
\item[\tt @@\#] At the beginning of a line in a scrap this will
suppress the normal indentation for that line. Use this, for
example, when you have a \verb|#ifdef| inside a nested scrap.
Writing \verb|@@##ifdef| will cause it to be lined up on the left
rather than indented with the rest of its code.
\item[\tt @@s] Inside a scrap supresses indentation for the following
fragment expansion.
\end{description}
Note that fragment names may be abbreviated, either during invocation or
definition. For example, it would be very tedious to have to
type, repeatedly, the fragment name
\begin{quote}
\verb|@@d Check for terminating at-sequence and return name if found|
\end{quote}
Therefore, we provide a mechanism (stolen from Knuth) of indicating
abbreviated names.
\begin{quote}
\verb|@@d Check for terminating...|
\end{quote}
Basically, the programmer need only type enough characters to
identify the fragment name uniquely, followed by three periods. An abbreviation
may even occur before the full version; nuweb simply preserves the
longest version of a fragment name. Note also that blanks and tabs are
insignificant within a fragment name; each string of them is replaced by a
single blank.

Sometimes, for instance during program testing, it is convenient to comment
out a few lines of code. In C or Fortran placing \verb|/* ... */| around the relevant
code is not a robust solution, as the code itself may contain
comments. Nuweb provides the command
\begin{quote}
\verb|@@%|
\end{quote}only to be used inside scraps. It behaves exactly the same
as \verb|%| in the normal {\LaTeX} text body.

When scraps are written to a program file or a documentation file, tabs are
expanded into spaces by default. Currently, I assume tab stops are set
every eight characters. Furthermore, when a fragment is expanded in a scrap,
the body of the fragment is indented to match the indentation of the
fragment invocation. Therefore, care must be taken with languages
({\em e.g.,} Fortran) that are sensitive to indentation.
These default behaviors may be changed for each output file (see
below).

\subsubsection{Flags}

When defining an output file, the programmer has the option of using
flags to control output of a particular file. The flags are intended
to make life a little easier for programmers using certain languages.
They introduce little language dependences; however, they do so only
for a particular file. Thus it is still easy to mix languages within a
single document. There are four ``per-file'' flags:
\begin{description}
\item[\tt -d] Forces the creation of \verb|#line| directives in the
  output file. These are useful with C (and sometimes C++ and Fortran) on
  many Unix systems since they cause the compiler's error messages to
  refer to the web file rather than to the output file. Similarly, they
  allow source debugging in terms of the web file.
\item[\tt -i] Suppresses the indentation of fragments. That is, when a
  fragment is expanded within a scrap, it will {\em not\/} be indented to
  match the indentation of the fragment invocation. This flag would seem
  most useful for Fortran programmers.
\item[\tt -t] Suppresses expansion of tabs in the output file. This
  feature seems important when generating \verb|make| files.
\item[\tt -c{\it x}] Puts comments in generated code documenting the
fragment that generated that code. The {\it x} selects the comment style
for the language in use. So far the only valid values are \verb|c| to get
\verb|C| comment style, \verb|+| for \verb|C++| and \verb|p| for
\verb|Perl|. (\verb|Perl| commenting can be used for several languages
including \verb|sh| and, mostly, \verb|tcl|.)
If the global \verb|-x| cross-reference flag is
set the comment includes the page reference for the first scrap that
generated the code.
\end{description}


\subsection{The Minor Commands\label{minorcommands}}

We have some very low-level utility commands that may appear anywhere
in the web file.
\begin{description}
\item[\tt @@@@] Causes a single ``at sign'' to be copied into the output.
\item[\tt @@\_] Causes the text between it and the next {\tt @@\_}
      to be made bold (for keywords, etc.)
\item[\tt @@i {\em file-name\/}] Includes a file. Includes may be
  nested, though there is currently a limit of 10~levels. The file name
  should be complete (no extension will be appended) and should be
  terminated by a carriage return. Normally the current directory is
  searched for the file to be included, but this can be varied using
  the \verb|-I| flag on the command line. Each such flag adds one
  directory tothe search path and they are searched in the order
  given.
\item[{\tt @@r}$x$] Changes the escape character `@@' to `$x$'.
  This must appear before any scrap definitions.
\item[\tt @@v] Always replaced by the string established by
the \texttt{-V} flag, or a default string if the flag isn't
given. This is intended to mark versions of the generated
files.
\end{description}

In the text of the document, that is outside scraps, you may include
scrap-like material.

\begin{description}
\item[\tt @@\{\textit{Anything}@@\}]
The included material, the \textit{Anything},
is typeset as if it appeared inside a scrap. This is useful for
referring to fragments in the text and for
describing the literate programming process itself.
\item[\tt @@<\textit{Fragment name}@@>]
The fragment named is expanded in place in the text. 
The expansion is presented verbatim, it is not interpretted for
typesetting, so any special environment must be set up before and
after this is used.
\end{description}

Finally, there are three commands used to create indices to the
fragment
names, file definitions, and user-specified identifiers.
\begin{description}
\item[\tt @@f] Create an index of file names.
\item[\tt @@m] Create an index of fragment names.
\item[\tt @@u] Create an index of user-specified identifiers.
\end{description}
I usually put these in their own section
in the \LaTeX\ document; for example, see Chapter~\ref{indices}.

Identifiers must be explicitly specified for inclusion in the
\verb|@@u| index. By convention, each identifier is marked at the
point of its definition; all references to each identifier (inside
scraps) will be discovered automatically. To ``mark'' an identifier
for inclusion in the index, we must mention it at the end of a scrap.
For example,
\begin{quote}
\begin{verbatim}
@@d a scrap @@{
Let's pretend we're declaring the variables FOO and BAR
inside this scrap.
@@| FOO BAR @@}
\end{verbatim}
\end{quote}
I've used alphabetic identifiers in this example, but any string of
characters (not including whitespace or \verb|@@| characters) will do.
Therefore, it's possible to add index entries for things like
\verb|<<=| if desired. An identifier may be declared in more than one
scrap.

In the generated index, each identifier appears with a list of all the
scraps using and defining it, where the defining scraps are
distinguished by underlining. Note that the identifier doesn't
actually have to appear in the defining scrap; it just has to be in
the list of definitions at the end of a scrap.

\section{Sectioning commands}
For larger documents the indexes and usage lists get rather
unwieldy and problems arise in naming things so that different
things in different parts of the document don't get confused. We
have a sectioning command which keeps the fragment names and user
identifiers separate. Thus, you can give a fragment in one section
the same name as a fragment in another and the two won't be confused
or connected in any way. Nor will user identifiers
defined in one section be referenced in another. Except for the
fact that scraps in successive sections can go into the same
output file, this is the same as if the sections came from
separate input files.

However, occasionally you may really want fragments from one section
to be used in another. More often, you will want to identify a
user identifier in one section with the same identifier in
another (as, for example, a header file defined in one section is
included in code in another). Extra commands allow a fragment
defined in one section to be accessible from all other sections.
Similarly, you can have scraps which define user identifiers and
export them so that they can be used in other sections.

\begin{description}
\item[{\tt @@s}] Start a new section.
\item[{\tt @@S}] Close the current section and don't start another.
\item[{\tt @@d+} fragment-name scrap] Define a fragment which is
accessible in all sections, a global fragment.
\item[{\tt @@D+}] Likewise
\item[{\tt @@q+}] Likewise
\item[{\tt @@Q+}] Likewise
\item[{\tt @@m+}] Create an index of all such fragments.
\item[{\tt @@u+}] Create an index of globally accessible
user identifiers.
\end{description}

There are two kinds of section, the base section which is where
normally everything goes, and local sections which are introduced with
the {\tt @@s} command. A local section comprises everything from the
command which starts it to the one which ends it. A {\tt @@s} command
will start a new local section. A {\tt @@S} command closes the current
local section, but doesn't open another, so what follows goes into the
base section. Note that fragments defined in the base section aren't
global; they are accessible only in the base section, but they are
accessible regardless of any local sections between their definition
and their use.

Within a scrap:
\begin{description}
\item[\tt @@<+{\em fragment-name\/}@@>]
Expand the globally accessible fragment with that name, rather than
any local fragment.
\item[{\tt @@+}] Like \verb"@@|" except that the identifiers
defined are exported to the global realm and are not directly
referenced in any scrap in any section (not even the one where
they are defined).
\item[{\tt @@-}] Like \verb"@@|" except that the identifiers
are imported to the local realm. The cross-references show where
the global variables are defined and defines the same names as
locally accesible. Uses of the names within the section will
point to this scrap.
\end{description}

Note that the \verb"+" signs above are part of the commands. They
are not part of the fragment names. If you want a fragment whose name
begins with a plus sign, leave a space between the command and the
name.

\section{Running Nuweb}

Nuweb is invoked using the following command:
\begin{quote}
{\tt nuweb} {\em flags file-name}\ldots
\end{quote}
One or more files may be processed at a time. If a file name has no
extension, \verb|.w| will be appended.  {\LaTeX} suitable for
translation into HTML by {\LaTeX}2HTML will be produced from
files whose name ends with \verb|.hw|, otherwise, ordinary {\LaTeX} will be
produced.  While a file name may specify a file in another directory,
the resulting documentation file will always be created in the current
directory. For example,
\begin{quote}
{\tt nuweb /foo/bar/quux}
\end{quote}
will take as input the file \verb|/foo/bar/quux.w| and will create the
file \verb|quux.tex| in the current directory.

By default, nuweb performs both tangling and weaving at the same time.
Normally, this is not a bottleneck in the compilation process;
however, it's possible to achieve slightly faster throughput by
avoiding one or another of the default functions using command-line
flags. There are currently three possible flags:
\begin{description}
\item[\tt -t] Suppress generation of the documentation file.
\item[\tt -o] Suppress generation of the output files.
\item[\tt -c] Avoid testing output files for change before updating them.
\end{description}
Thus, the command
\begin{quote}
\verb|nuweb -to /foo/bar/quux|
\end{quote}
would simply scan the input and produce no output at all.

There are several additional command-line flags:
\begin{description}
\item[\tt -v] For ``verbose'', causes nuweb to write information about
  its progress to \verb|stderr|.
\item[\tt -n] Forces scraps to be numbered sequentially from~1
  (instead of using page numbers). This form is perhaps more desirable
  for small webs.
\item[\tt -s] Doesn't print list of scraps making up each file
  following each scrap.
\item[\tt -d] Print ``dangling'' identifiers -- user identifiers which
  are never referenced, in indices, etc.
\item[\tt -p {\it path}] Prepend \textit{path} to the filenames for
all the output files.
\item[\tt -l] \label{sec:pretty-print} Use the \texttt{listings}
package for formatting scraps. Use this if you want to have a
pretty-printer for your scraps. In order to e.g. have pretty Perl
scraps, include the following \LaTeX\ commands in your document:
\lstset{language=[LaTeX]TeX}

\begin{lstlisting}{language={[LaTeX]TeX}}
\usepackage{listings}
...
\lstset{extendedchars=true,keepspaces=true,language=perl}
\end{lstlisting}

See the \texttt{listings} documentation for a list of formatting
options. Be sure to include a \texttt{\char92
usepackage\{listings\}}
in your document.

\item[\tt -V \it string] Provide \textit{string} as the
replacement for the @@v operation.
\end{description}

\section{Generating HTML}

Nikos Drakos' {\LaTeX}2HTML Version 0.5.3~\cite{drakos:94} can be used
to translate {\LaTeX} with embedded HTML scraps into HTML\@@.  Be sure
to include the document-style option \verb|html| so that {\LaTeX} will
understand the hypertext commands.  When translating into HTML, do not
allow a document to be split by specifying ``\verb|-split 0|''.
You need not generate navigation links, so also specify
``\verb|-no_navigation|''.

While preparing a web, you may want to view the program's scraps without
taking the time to run {\LaTeX}2HTML\@@.  Simply rename the generated
{\LaTeX} source so that its file name ends with \verb|.html|, and view
that file.  The documentations section will be jumbled, but the
scraps will be clear.

(Note that the HTML generation is not currently maintained. If the
only reason you want HTML is ti get hyperlinks, use the {\LaTeX}
\verb|hyperref| package and produce your document as PDF via
\verb|pdflatex|.)

\section{Restrictions}

Because nuweb is intended to be a simple tool, I've established a few
restrictions. Over time, some of these may be eliminated; others seem
fundamental.
\begin{itemize}
\item The handling of errors is not completely ideal. In some cases, I
  simply warn of a problem and continue; in other cases I halt
  immediately. This behavior should be regularized.
\item I warn about references to fragments that haven't been defined, but
  don't halt. The name of the fragment is included in the output file
  surrounded by \verb|<>| signs.
  This seems most convenient for development, but may change
  in the future.
\item File names and index entries should not contain any \verb|@@|
  signs.
\item Fragment names may be (almost) any well-formed \TeX\ string.
  It makes sense to change fonts or use math mode; however, care should
  be taken to ensure matching braces, brackets, and dollar signs.
  When producing HTML, fragments are displayed in a preformatted element
  (PRE), so fragments may contain one or more A, B, I, U, or P elements
  or data characters.
\item Anything is allowed in the body of a scrap; however, very
  long scraps (horizontally or vertically) may not typeset well.
\item Temporary files (created for comparison to the eventual
  output files) are placed in the current directory. Since they may be
  renamed to an output file name, all the output files should be on the
  same file system as the current directory. Alternatively, you can
  use the \verb|-p| flag to specify where the files go.
\item Because page numbers cannot be determined until the document has
  been typeset, we have to rerun nuweb after \LaTeX\ to obtain a clean
  version of the document (very similar to the way we sometimes have
  to rerun \LaTeX\ to obtain an up-to-date table of contents after
  significant edits).  Nuweb will warn (in most cases) when this needs
  to be done; in the remaining cases, \LaTeX\ will warn that labels
  may have changed.
\end{itemize}
Very long scraps may be allowed to break across a page if declared
with \verb|@@O| or \verb|@@D| (instead of \verb|@@o| and \verb|@@d|).
This doesn't work very well as a default, since far too many short
scraps will be broken across pages; however, as a user-controlled
option, it seems very useful.  No distinction is made between the
upper case and lower case forms of these commands when generating
HTML\@@.

\section{Acknowledgements}

Several people have contributed their times, ideas, and debugging
skills. In particular, I'd like to acknowledge the contributions of
Osman Buyukisik, Manuel Carriba, Adrian Clarke, Tim Harvey, Michael
Lewis, Walter Ravenek, Rob Shillingsburg, Kayvan Sylvan, Dominique
de~Waleffe, and Scott Warren.  Of course, most of these people would
never have heard or nuweb (or many other tools) without the efforts of
George Greenwade.

Since maintenance has been taken over by Marc Mengel, Simon Wright and
Keith Harwood online contributions have been made by:
\begin{itemize}
\item Walter Brown \verb|<wb@@fnal.gov>|
\item Nicky van Foreest \verb|<n.d.vanforeest@@math.utwente.nl>|
\item Javier Goizueta \verb|<jgoizueta@@jazzfree.com>|
\item Alan Karp \verb|<karp@@hp.com>|
\end{itemize}

\ifshowcode
\chapter{The Overall Structure}

Processing a web requires three major steps:
\begin{enumerate}
  \item Read the source, accumulating file names, fragment names, scraps,
    and lists of cross-references.
  \item Reread the source, copying out to the documentation file, with
    protection and cross-reference information for all the scraps.
  \item Traverse the list of files names. For each file name:
  \begin{enumerate}
    \item Dump all the defining scraps into a temporary file.
    \item If the file already exists and is unchanged, delete the
      temporary file; otherwise, rename the temporary file.
  \end{enumerate}
\end{enumerate}


\section{Files}

I have divided the program into several files for quicker
recompilation during development.
@o global.h -cc
@{@<Include files@>
@<Type declarations@>
@<Limits@>
@<Global variable declarations@>
@<Function prototypes@>
@<Operating System Dependencies@>@}

We'll need at least five of the standard system include files.
@d Include files
@{
/* #include <fcntl.h> */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <signal.h>
#include <locale.h>
@| FILE stderr exit fprintf fputs fopen fclose getc putc strlen
toupper isupper islower isgraph isspace remove malloc size_t
setlocale getenv @}


\newpage
\noindent
I like to use \verb|TRUE| and \verb|FALSE| in my code.
I'd use an \verb|enum| here, except that some systems seem to provide
definitions of \verb|TRUE| and \verb|FALSE| by default.  The following
code seems to work on all the local systems.
@d Type dec...
@{#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif
@| FALSE TRUE @}

Here we define the maximum length for names (of fragments etc).

@d Limits @{@%
#ifndef MAX_NAME_LEN
#define MAX_NAME_LEN 1024
#endif
@| MAX_NAME_LEN @}


\subsection{The Main Files}

The code is divided into four main files (introduced here) and five
support files (introduced in the next section).
The file \verb|main.c| will contain the driver for the whole program
(see Section~\ref{main-routine}).
@o main.c -cc
@{#include "global.h"
@}

The first pass over the source file is contained in \verb|pass1.c|.
It handles collection of all the file names, fragments names, and scraps
(see Section~\ref{pass-one}).
@o pass1.c -cc
@{#include "global.h"
@}

The \verb|.tex| file is created during a second pass over the source
file. The file \verb|latex.c| contains the code controlling the
construction of the \verb|.tex| file
(see Section~\ref{latex-file}).
@o latex.c -cc
@{#include "global.h"
static int scraps = 1;
int extra_scraps;
@}

The file \verb|html.c| contains the code controlling the
construction of the \verb|.tex| file appropriate for use with {\LaTeX}2HTML
(see Section~\ref{html-file}).
@o html.c
@{#include "global.h"
static int scraps = 1;
int extra_scraps;
@}

The code controlling the creation of the output files is in \verb|output.c|
(see Section~\ref{output-files}).
@o output.c -cc
@{#include "global.h"
@}

\newpage
\subsection{Support Files}

The support files contain a variety of support routines used to define
and manipulate the major data abstractions.
The file \verb|input.c| holds all the routines used for referring to
source files (see Section~\ref{source-files}).
@o input.c -cc
@{#include "global.h"
@}

Creation and lookup of scraps is handled by routines in \verb|scraps.c|
(see Section~\ref{scraps}).
@o scraps.c -cc
@{#include "global.h"
@}


The handling of file names and fragment names is detailed in \verb|names.c|
(see Section~\ref{names}).
@o names.c -cc
@{#include "global.h"
@}

Memory allocation and deallocation is handled by routines in \verb|arena.c|
(see Section~\ref{memory-management}).
@o arena.c -cc
@{#include "global.h"
@}

Finally, for best portability, I seem to need a file containing
(useless!) definitions of all the global variables.
@o global.c -cc
@{#include "global.h"
@<Operating System Dependencies@>
@<Global variable definitions@>
@}

\section{The Main Routine} \label{main-routine}

The main routine is quite simple in structure.
It wades through the optional command-line arguments,
then handles any files listed on the command line.
@o main.c -cc
@{
#include <stdlib.h>
int main(argc, argv)
     int argc;
     char **argv;
{
  int arg = 1;
  @<Interpret command-line arguments@>
  @<Set locale information@>
  initialise_delimit_scrap_array();
  @<Process the remaining arguments (file names)@>
  exit(0);
}
@| main @}

We only have two major operating system dependencies; the separators for
file names, and how to set environment variables.
For now we assume the latter can be accomplished
via \verb|putenv()| in \verb|stdlib.h|.
@d Operating System Dependencies @{
#if defined(VMS)
#define PATH_SEP(c) (c==']'||c==':')
#define PATH_SEP_CHAR ""
#define DEFAULT_PATH ""
#elif defined(MSDOS)
#define PATH_SEP(c) (c=='\\')
#define PATH_SEP_CHAR "\\"
#define DEFAULT_PATH "."
#else
#define PATH_SEP(c) (c=='/')
#define PATH_SEP_CHAR "/"
#define DEFAULT_PATH "."
#endif
@}
\subsection{Command-Line Arguments}

There are numerous possible command-line arguments:
\begin{description}
\item[\tt -t] Suppresses generation of the {\tt .tex} file.
\item[\tt -o] Suppresses generation of the output files.
\item[\tt -d] list dangling identifier references in indexes.
\item[\tt -c] Forces output files to overwrite old files of the same
  name without comparing for equality first.
\item[\tt -v] The verbose flag. Forces output of progress reports.
\item[\tt -n] Forces sequential numbering of scraps (instead of page
  numbers).
\item[\tt -s] Doesn't print list of scraps making up file at end of
  each scrap.
\item[\tt -x] Include cross-reference numbers in scrap comments.
\item[\tt -p \it path] Prepend \textit{path} to the filenames for
all the output files.
\item[\tt -h \it options] Provide options for the hyperref
package.
\item[\tt -r] Turn on hyperlinks. You must include the |usepackage|
options in the text.
\end{description}

There are two ways to get hyper-links into your documentation. With
one, the \texttt{-r} flag simply arranges for fragment
cross-references to be hyperlinks. You have to provide all the rest of
the \texttt{hyperref} material yourself. The \texttt{-h} flag does
more work, but requires you provide the \texttt{hyperref} options on
the command line. You would use the first if you know you will use the
same tools all the time. You would use the second if you have to
distribute the nuweb file and use the build system to provide the
\texttt{hyperref} options.

The \texttt{-h}\ option is used as follows. If you want
hyperlinks in your document give a string to this option which is
a valid option for the \texttt{hyperref} package. For example,
\verb|"dvips,colorlinks=true"| sets it to use the
\texttt{dvips} driver and mark the links in colour. For more
information about these options, see the \texttt{hyperref}\
documentation.

Then in your document you put the command \verb|\NWuseHyperlinks|
immadiately after your \verb|usepackage| commands. If you do both
of these you will get hyperlinks. If you miss out either then
nothing interesting happens.

\noindent
Global flags are declared for each of the arguments.
@d Global variable dec...
@{extern int tex_flag;      /* if FALSE, don't emit the documentation file */
extern int html_flag;     /* if TRUE, emit HTML instead of LaTeX scraps. */
extern int output_flag;   /* if FALSE, don't emit the output files */
extern int compare_flag;  /* if FALSE, overwrite without comparison */
extern int verbose_flag;  /* if TRUE, write progress information */
extern int number_flag;   /* if TRUE, use a sequential numbering scheme */
extern int scrap_flag;    /* if FALSE, don't print list of scraps */
extern int dangling_flag;    /* if FALSE, don't print dangling identifiers */
extern int xref_flag; /* If TRUE, print cross-references in scrap comments */
extern int prepend_flag;  /* If TRUE, prepend a path to the output file names */
extern char * dirpath;    /* The prepended directory path */
extern char * path_sep;   /* How to join path to filename */
extern int listings_flag;   /* if TRUE, use listings package for scrap formatting */
extern int version_info_flag; /* If TRUE, set up version string */
extern char *  version_string; /* What to print for @@v */
extern int hyperref_flag; /* Are we preparing for hyperref
                             package. */
extern int hyperopt_flag; /* Are we preparing for hyperref options */
extern char * hyperoptions; /* The options to pass to the
                               hyperref package */
extern int includepath_flag; /* Do we have an include path? */
extern struct incl{char * name; struct incl * next;} * include_list;
                       /* The list of include paths */
@| tex_flag html_flag output_flag compare_flag verbose_flag number_flag
scrap_flag dangling_flag xref_flag version_info_flag
version_string hyperref_flag hyperopt_flag hyperoptions includepath_flag
incl @}

The flags are all initialized for correct default behavior.

@d Global variable def...
@{int tex_flag = TRUE;
int html_flag = FALSE;
int output_flag = TRUE;
int compare_flag = TRUE;
int verbose_flag = FALSE;
int number_flag = FALSE;
int scrap_flag = TRUE;
int dangling_flag = FALSE;
int xref_flag = FALSE;
int prepend_flag = FALSE;
char * dirpath = DEFAULT_PATH; /* Default directory path */
char * path_sep = PATH_SEP_CHAR;
int listings_flag = FALSE;
int version_info_flag = FALSE;
char default_version_string[] = "no version";
char *  version_string = default_version_string;
int hyperref_flag = FALSE;
int hyperopt_flag = FALSE;
char * hyperoptions = "";
int includepath_flag = FALSE; /* Do we have an include path? */
struct incl * include_list = NULL;
                       /* The list of include paths */
@}

A global variable \verb|nw_char| will be used for the nuweb
meta-character, which by default will be @@.
@d Global variable dec...
@{extern int nw_char;
@| nw_char @}
@d Global variable def...
@{int nw_char='@@';
@| nw_char @}


We save the invocation name of the command in a global variable
\verb|command_name| for use in error messages.
@d Global variable dec...
@{extern char *command_name;
@| command_name @}

@d Global variable def...
@{char *command_name = NULL;
@}

The invocation name is conventionally passed in \verb|argv[0]|.
@d Interpret com...
@{command_name = argv[0];
@}

We need to examine the remaining entries in \verb|argv|, looking for
command-line arguments.
@d Interpret com...
@{while (arg < argc) {
  char *s = argv[arg];
  if (*s++ == '-') {
    @<Interpret the argument string \verb|s|@>
    arg++;
    @<Perhaps get the prepend path@>
    @<Perhaps get the version info string@>
    @<Perhaps get the hyperref options@>
    @<Perhaps add an include path@>
  }
  else break;
}@}

Several flags can be stacked behind a single minus sign; therefore,
we've got to loop through the string, handling them all.
If this flag requires an argument we skip to getting its argument
straight away. This allows arguments to butt up to their flags
and also avoids ambiguity about which value goes with which flag.

@d Interpret the...
@{{
  char c = *s++;
  while (c) {
    switch (c) {
      case 'c': compare_flag = FALSE;
                break;
      case 'd': dangling_flag = TRUE;
                break;
      case 'h': hyperopt_flag = TRUE;
                goto HasValue;
      case 'I': includepath_flag = TRUE;
                goto HasValue;
      case 'l': listings_flag = TRUE;
                break;
      case 'n': number_flag = TRUE;
                break;
      case 'o': output_flag = FALSE;
                break;
      case 'p': prepend_flag = TRUE;
                goto HasValue;
      case 'r': hyperref_flag = TRUE;
                break;
      case 's': scrap_flag = FALSE;
                break;
      case 't': tex_flag = FALSE;
                break;
      case 'v': verbose_flag = TRUE;
                break;
      case 'V': version_info_flag = TRUE;
                goto HasValue;
      case 'x': xref_flag = TRUE;
                break;
      default:  fprintf(stderr, "%s: unexpected argument ignored.  ",
                        command_name);
                fprintf(stderr, "Usage is: %s [-cdnostvx] "
                      "[-I path] [-V version] "
                      "[-h options] [-p path] file...\n",
                        command_name);
                break;
    }
    c = *s++;
  }
@#HasValue:;
}@}


@d Perhaps get the prepend path
@{if (prepend_flag)
{
  if (*s == '\0')
    s = argv[arg++];
  dirpath = s;
  prepend_flag = FALSE;
}
@}

@d Perhaps add an include path
@{if (includepath_flag)
{
   struct incl * le
      = (struct incl *)arena_getmem(sizeof(struct incl));
   struct incl ** p = &include_list;

   if (*s == '\0')
     s = argv[arg++];
   le->name = save_string(s);
   le->next = NULL;
   while (*p != NULL)
      p = &((*p)->next);
   *p = le;
   includepath_flag = FALSE;
}
@}

@d Perhaps get the version info string
@{if (version_info_flag)
{
   if (*s == '\0')
     s = argv[arg++];
   version_string = s;
   version_info_flag = FALSE;
}
@}

@d Perhaps get the hyperref options
@{if (hyperopt_flag)
{
  if (*s == '\0')
    s = argv[arg++];
  hyperoptions = s;
  hyperopt_flag = FALSE;
  hyperref_flag = TRUE;
}
@}

In order to be able to process files in foreign languages we
set the locale information. \texttt{isgraph()} and friends need
this (see Section~\ref{names}).
Try to read \texttt{LC\_CTYPE} from the environment. Use \texttt{LC\_ALL}
if that fails. Don't set the locale if reading \texttt{LC\_ALL} fails, too.
Print a warning if setting the program's locale fails.
@d Set locale information @{
{
  /* try to get locale information */
  char *s=getenv("LC_CTYPE");
  if (s==NULL) s=getenv("LC_ALL");

  /* set it */
  if (s!=NULL)
    if(setlocale(LC_CTYPE, s)==NULL)
      fprintf(stderr, "Setting locale failed\n");
}
@}

\subsection{File Names}

We expect at least one file name. While a missing file name might be
ignored without causing any problems, we take the opportunity to report
the usage convention.
@d Process the remaining...
@{{
  if (arg >= argc) {
    fprintf(stderr, "%s: expected a file name.  ", command_name);
    fprintf(stderr, "Usage is: %s [-cnotv] [-p path] file-name...\n", command_name);
    exit(-1);
  }
  do {
    @<Handle the file name in \verb|argv[arg]|@>
    arg++;
  } while (arg < argc);
}@}

\newpage
\noindent
The code to handle a particular file name is rather more tedious than
the actual processing of the file. A file name may be an arbitrarily
complicated path name, with an optional extension. If no extension is
present, we add \verb|.w| as a default. The extended path name will be
kept in a local variable \verb|source_name|. The resulting documentation
file will be written in the current directory; its name will be kept
in the variable \verb|tex_name|.
@d Handle the file...
@{{
  char source_name[FILENAME_MAX];
  char tex_name[FILENAME_MAX];
  char aux_name[FILENAME_MAX];
  @<Build \verb|source_name| and \verb|tex_name|@>
  @<Process a file@>
}@}


I bump the pointer \verb|p| through all the characters in \verb|argv[arg]|,
copying all the characters into \verb|source_name| (via the pointer
\verb|q|).

At each slash, I update \verb|trim| to point just past the
slash in \verb|source_name|. The effect is that \verb|trim| will point
at the file name without any leading directory specifications.

The pointer \verb|dot| is made to point at the file name extension, if
present. If there is no extension, we add \verb|.w| to the source name.
In any case, we create the \verb|tex_name| from \verb|trim|, taking
care to get the correct extension.  The \verb|html_flag| is set in
this scrap.
@d Build \verb|sou...
@{{
  char *p = argv[arg];
  char *q = source_name;
  char *trim = q;
  char *dot = NULL;
  char c = *p++;
  while (c) {
    *q++ = c;
    if (PATH_SEP(c)) {
      trim = q;
      dot = NULL;
    }
    else if (c == '.')
      dot = q - 1;
    c = *p++;
  }
  @<Add the source path to the include path list@>
  *q = '\0';
  if (dot) {
    *dot = '\0'; /* produce HTML when the file extension is ".hw" */
    html_flag = dot[1] == 'h' && dot[2] == 'w' && dot[3] == '\0';
    sprintf(tex_name, "%s%s%s.tex", dirpath, path_sep, trim);
    sprintf(aux_name, "%s%s%s.aux", dirpath, path_sep, trim);
    *dot = '.';
  }
  else {
    sprintf(tex_name, "%s%s%s.tex", dirpath, path_sep, trim);
    sprintf(aux_name, "%s%s%s.aux", dirpath, path_sep, trim);
    *q++ = '.';
    *q++ = 'w';
    *q = '\0';
  }
}@}

If the source file has a directory part we add that directory to the
end of the search path so that the path of last resort is the same as
the source path, not, as one person put it, something irrelevant like
the directory nuweb was invoked from.

@d Add the source path to the include path list
@{if (trim != source_name) {
   struct incl * le
      = (struct incl *)arena_getmem(sizeof(struct incl));
   struct incl ** p = &include_list;
   char sv = *trim;

   *trim = '\0';
   le->name = save_string(source_name);
   le->next = NULL;
   while (*p != NULL)
      p = &((*p)->next);
   *p = le;
   *trim = sv;
}
@}

Now that we're finally ready to process a file, it's not really too
complex.  We bundle most of the work into four routines \verb|pass1|
(see Section~\ref{pass-one}), \verb|write_tex| (see
Section~\ref{latex-file}), \verb|write_html| (see
Section~\ref{html-file}), and \verb|write_files| (see
Section~\ref{output-files}). After we're finished with a
particular file, we must remember to release its storage (see
Section~\ref{memory-management}).  The sequential numbering of scraps
is forced when generating HTML.
@d Process a file
@{{
  pass1(source_name);
  current_sector = 1;
  prev_sector = 1;
  if (tex_flag) {
    if (html_flag) {
      int saved_number_flag = number_flag;
      number_flag = TRUE;
      collect_numbers(aux_name);
      write_html(source_name, tex_name, 0/*Dummy */);
      number_flag = saved_number_flag;
    }
    else {
      collect_numbers(aux_name);
      write_tex(source_name, tex_name);
    }
  }
  if (output_flag)
    write_files(file_names);
  arena_free();
}@}


\newpage
\section{Pass One} \label{pass-one}

During the first pass, we scan the file, recording the definitions of
each fragment and file and accumulating all the scraps.

@d Function pro...
@{extern void pass1();
@}


The routine \verb|pass1| takes a single argument, the name of the
source file. It opens the file, then initializes the scrap structures
(see Section~\ref{scraps}) and the roots of the file-name tree, the
fragment-name tree, and the tree of user-specified index entries (see
Section~\ref{names}). After completing all the
necessary preparation, we make a pass over the file, filling in all
our data structures. Next, we seach all the scraps for references to
the user-specified index entries. Finally, we must reverse all the
cross-reference lists accumulated while scanning the scraps.
@o pass1.c -cc
@{void pass1(file_name)
     char *file_name;
{
  if (verbose_flag)
    fprintf(stderr, "reading %s\n", file_name);
  source_open(file_name);
  init_scraps();
  macro_names = NULL;
  file_names = NULL;
  user_names = NULL;
  @<Scan the source file, looking for at-sequences@>
  if (tex_flag)
    search();
  @<Reverse cross-reference lists@>
}
@| pass1 @}

The only thing we look for in the first pass are the command
sequences. All ordinary text is skipped entirely.
@d Scan the source file, look...
@{{
  int c = source_get();
  while (c != EOF) {
    if (c == nw_char)
      @<Scan at-sequence@>
    c = source_get();
  }
}@}

Only four of the at-sequences are interesting during the first pass.
We skip past others immediately; warning if unexpected sequences are
discovered.
@d Scan at-sequence
@{{
  char quoted = 0;

  c = source_get();
  switch (c) {
    case 'r':
          c = source_get();
          nw_char = c;
          update_delimit_scrap();
          break;
    case 'O':
    case 'o': @<Build output file definition@>
              break;
    case 'Q':
    case 'q': quoted = 1;
    case 'D':
    case 'd': @<Build fragment definition@>
              break;
    case 's':
              @<Step to next sector@>
              break;
    case 'S':
              @<Close the current sector@>
              break;
    case '<':
    case '(':
    case '[':
    case '{': @<Skip over an in-text scrap@>
              break;
    case 'c': @<Collect a block comment@>
              break;
    case 'x':
    case 'v':
    case 'u':
    case 'm':
    case 'f': /* ignore during this pass */
              break;
    default:  if (c==nw_char) /* ignore during this pass */
                break;
              fprintf(stderr,
                      "%s: unexpected %c sequence ignored (%s, line %d)\n",
                      command_name, nw_char, source_name, source_line);
              break;
  }
}@}

@d Step to next sector
@{
prev_sector += 1;
current_sector = prev_sector;
c = source_get();
@}

@d Close the current sector
@{current_sector = 1;
c = source_get();
@}

@d Global variable declar...
@{unsigned char current_sector;
unsigned char prev_sector;
@| current_sector prev_sector @}

@d Global variable def...
@{unsigned char current_sector = 1;
unsigned char prev_sector = 1;
@}

\subsection{Accumulating Definitions}

There are three steps required to handle a definition:
\begin{enumerate}
  \item Build an entry for the name so we can look it up later.
  \item Collect the scrap and save it in the table of scraps.
  \item Attach the scrap to the name.
\end{enumerate}
We go through the same steps for both file names and fragment names.
@d Build output file definition
@{{
  Name *name = collect_file_name(); /* returns a pointer to the name entry */
  int scrap = collect_scrap();      /* returns an index to the scrap */
  @<Add \verb|scrap| to...@>
}@}


@d Build fragment definition
@{{
  Name *name = collect_macro_name();
  int scrap = collect_scrap();
  @<Add \verb|scrap| to...@>
}@}


Since a file or fragment may be defined by many scraps, we maintain them
in a simple linked list. The list is actually built in reverse order,
with each new definition being added to the head of the list.
@d Add \verb|scrap| to \verb|name|'s definition list
@{{
  Scrap_Node *def = (Scrap_Node *) arena_getmem(sizeof(Scrap_Node));
  def->scrap = scrap;
  def->quoted = quoted;
  def->next = name->defs;
  name->defs = def;
}@}

@d Skip over an in-text scrap
@{
{
   int c;
   int depth = 1;
   while ((c = source_get()) != EOF) {
      if (c == nw_char)
         @<Skip over at-sign or go to skipped@>
   }
   fprintf(stderr, "%s: unexpected EOF in text at (%s, %d)\n",
                    command_name, source_name, source_line);
   exit(-1);

skipped:  ;
}
@}

@d Skip over at-sign or go to skipped
@{
{
   c = source_get();
   switch (c) {
     case '{': case '[': case '(': case '<':
        depth += 1;
        break;
     case '}': case ']': case ')': case '>':
        if (--depth == 0)
           goto skipped;
     case 'x': case '|': case ',': 
     case '%': case '1': case '2':
     case '3': case '4': case '5': case '6':
     case '7': case '8': case '9': case '_':
     case 'f': case '#': case '+': case '-':
     case 'v': case '*': case 'c': case '\'':
     case 's':
        break;
     default:
        if (c != nw_char) {
	   fprintf(stderr, "%s: unexpected %c%c in text at (%s, %d)\n",
	                   command_name, nw_char, c, source_name, source_line);
	   exit(-1);
	}
        break;
   }
}
@}
\subsection{Block Comments}

@d Collect a block comment
@{{
   char * p = blockBuff;
   char * e = blockBuff + (sizeof(blockBuff)/sizeof(blockBuff[0])) - 1;

   @<Skip whitespace@>
   while (p < e)
   {
      @<Add one char to the block buffer@>
   }
   if (p == e)
   {
      @<Skip to the next nw-char@>
   }
   *p = '\000';
}
@}

@d Skip whitespace
@{while (source_peek == ' '
       || source_peek == '\t'
       || source_peek == '\n')
   (void)source_get();
@}

@d Add one char to the block buffer
@{int c = source_get();

if (c == nw_char)
{
   @<Add an at character to the block or break@>
}
else if (c == EOF)
{
   source_ungetc(&c);
   break;
}
else
{
   @<Add any other character to the block@>
}
@}

@d Add an at character to the block or break
@{int cc = source_peek;

if (cc == 'c')
{
   do
      c = source_get();
   while (c <= ' ');

   break;
}
else if (cc == 'd'
         || cc == 'D'
         || cc == 'q'
         || cc == 'Q'
         || cc == 'o'
         || cc == 'O'
         || cc == EOF)
{
   source_ungetc(&c);
   break;
}
else
{
   *p++ = c;
   *p++ = source_get();
}
@}

@d Add any other character to the block
@{
   @<Perhaps skip white-space@>
   *p++ = c;
@}

@d Perhaps skip white-space
@{if (c == ' ')
{
   while (source_peek == ' ')
      c = source_get();
}
if (c == '\n')
{
   if (source_peek == '\n')
   {
      do
         c = source_get();
      while (source_peek == '\n');
   }
   else
      c = ' ';
}
@}

@d Skip to the next nw-char
@{int c;

while ((c = source_get()), c != nw_char && c != EOF)/* Skip */
source_ungetc(&c);@}

@d Global variable declar...
@{char blockBuff[6400];
@| blockBuff @}

We don't show block comments inside scraps in the \TeX\ file,
but we do show where they go.

@d Show presence of a block comment
@{{
  fputs(delimit_scrap[scrap_type][1],file);
  fprintf(file, "\\hbox{\\sffamily\\slshape (Comment)}");
  fputs(delimit_scrap[scrap_type][0], file);
}
@}

The block comment is presently in the block buffer. Here we
copy it into the scrap whence we shall copy it into the output
file.

@d Include block comment in a scrap
@{{
   char * p = blockBuff;

   push(nw_char, &writer);
   do
   {
      push(c, &writer);
      c = *p++;
   } while (c != '\0');
}@}

@d Copy block comment from scrap
@{{
   int bgn = indent + global_indent;
   int posn = bgn + strlen(comment_begin[comment_flag]);
   int i;

   @<Perhaps put a delayed indent@>
   c = pop(&reader);
   fputs(comment_begin[comment_flag], file);
   while (c != '\0')
   {
      @<Move a word to the file@>
      @<If we break the line at this word@>
      {
         putc('\n', file);
         for (i = 0; i < bgn ; i++)
            putc(' ', file);
         c = pop(&reader);
         if (c != '\0')
         {
            posn = bgn + strlen(comment_mid[comment_flag]);
            fputs(comment_mid[comment_flag], file);
         }
      }
   }
   fputs(comment_end[comment_flag], file);
}
@}

@d Move a word to the file
@{do
{
   putc(c, file);
   posn += 1;
   c = pop(&reader);
} while (c > ' ');
@}

@d If we break the line at this word
@{if (c == '\n' || (c == ' ' && posn > 60))@}

@d Skip over a block comment
@{if (last == nw_char && c == 'c')
   while ((c = pop(reader.m)) != '\0')
      /* Skip */;
@}

@d Begin or end a block comment
@{if (inBlock)
{
   @<End block@>
}
else
{
   @<Start block@>
}@}


\subsection{Fixing the Cross References}

Since the definition and reference lists for each name are accumulated
in reverse order, we take the time at the end of \verb|pass1| to
reverse them all so they'll be simpler to print out prettily.
The code for \verb|reverse_lists| appears in Section~\ref{names}.
@d Reverse cross-reference lists
@{{
  reverse_lists(file_names);
  reverse_lists(macro_names);
  reverse_lists(user_names);
}@}

\subsection{Dealing with fragment parameters}

Fragment parameters were added on later in nuweb's development.
There still is not, for example, an index of fragment parameters.
We need a data type to keep track of fragment parameters.

@o global.h -cc
@{typedef int *Parameters;
@| Parameters @}


When we are copying a scrap to the output, we check for an embedded
parameter. If we find it we copy it. Otherwise it's an old-style
parameter and we can then pull
the $n$th string from the \verb|Parameters| list when we
see an \verb|@@1| \verb|@@2|, etc.

@D Handle macro parameter substitution @{
case '1': case '2': case '3':
case '4': case '5': case '6':
case '7': case '8': case '9':
  {
    Arglist * args;
    Name * name;

    lookup(c - '1', inArgs, inParams, &name, &args);

    if (name == (Name *)1) {
      Embed_Node * q = (Embed_Node *)args;
      indent = write_scraps(file, spelling, q->defs,
                            global_indent + indent,
                            indent_chars, debug_flag,
                            tab_flag, indent_flag,
                            0,
                            q->args, inParams,
                            local_parameters, "");
    }
    else if (name != NULL) {
       int i, narg;
       char * p = name->spelling;
       Arglist *q = args;

       @<Perhaps comment...@>
       indent = write_scraps(file, spelling, name->defs,
                             global_indent + indent,
                             indent_chars, debug_flag,
                             tab_flag, indent_flag,
                             comment_flag, args, name->arg,
                             local_parameters, p);
    }
    else if (args != NULL) {
       if (delayed_indent) {
         @<Put out the indent@>
       }
       fputs((char *)args, file);
    }
    else if ( parameters && parameters[c - '1'] ) {
      Scrap_Node param_defs;
      param_defs.scrap = parameters[c - '1'];
      param_defs.next = 0;
      write_scraps(file, spelling, &param_defs,
                   global_indent + indent,
                   indent_chars, debug_flag,
                   tab_flag, indent_flag,
                   comment_flag, NULL, NULL, 0, "");
    } else if (delayed_indent) {
      @<Put out the indent@>
    }
  }
@}
Now onto actually parsing fragment parameters from a call.
We start off checking for fragment parameters, an \verb|@@(| sequence
followed by parameters separated by \verb|@@,| sequences, and
terminated by a \verb|@@)| sequence.

We collect separate scraps for each parameter, and write the
scrap numbers down in the text. For example, if the file has:
\begin{verbatim}
   @@<foo @@( param1 @@, param2 @@)@@>
\end{verbatim}
we actually make new scraps, say 10 and 11, for param1 and param2,
and write in the collected scrap:
\begin{verbatim}
   @@<foo @@(10@@,11@@)@@>
\end{verbatim}

@d Save macro parameters
@{{
  int param_scrap;
  char param_buf[10];

  push(nw_char, &writer);
  push('(', &writer);
  do {
     param_scrap = collect_scrap();
     sprintf(param_buf, "%d", param_scrap);
     pushs(param_buf, &writer);
     push(nw_char, &writer);
     push(scrap_ended_with, &writer);
     add_to_use(name, current_scrap);
  } while( scrap_ended_with == ',' );
  do
    c = source_get();
  while( ' ' == c );
  if (c == nw_char) {
    c = source_get();
  }
  if (c != '>') {
    /* ZZZ print error */;
  }
}@}

If we get inside, we have at least one parameter, which will be at
the beginning of the parms buffer, and we prime the pump with the
first character.

@d Check for macro parameters
@{
  if (c == '(') {
    Parameters res = arena_getmem(10 * sizeof(int));
    int *p2 = res;
    int count = 0;
    int scrapnum;

    while( c && c != ')' ) {
      scrapnum = 0;
      c = pop(manager);
      while( '0' <= c && c <= '9' ) {
        scrapnum = scrapnum  * 10 + c - '0';
        c = pop(manager);
      }
      if ( c == nw_char ) {
        c = pop(manager);
      }
      *p2++ = scrapnum;
    }
    while (count < 10) {
      *p2++ = 0;
      count++;
    }
    while( c && c != nw_char ) {
        c = pop(manager);
    }
    if ( c == nw_char ) {
      c = pop(manager);
    }
    *parameters = res;
  }
@}

These are used in \verb|write_tex| and \verb|write_html| to output the
argument list for a fragment.

@d Format macro parameters
@{
   char sep;

   sep = '(';
   do {
     fputc(sep,file);

     fputs("{\\footnotesize ", file);
     write_single_scrap_ref(file, scraps + 1);
     fprintf(file, "\\label{scrap%d}\n", scraps + 1);
     fputs(" }", file);

     source_last = '{';
     copy_scrap(file, TRUE, NULL);

     ++scraps;

     sep = ',';
   } while ( source_last != ')' && source_last != EOF );
   fputs(" ) ",file);
   do
     c = source_get();
   while(c != nw_char && c != EOF);
   if (c == nw_char) {
     c = source_get();
   }
@}

@d Format HTML macro parameters
@{
   char sep;

   sep = '(';
   fputs("\\begin{rawhtml}", file);
   do {

     fputc(sep,file);

     fprintf(file, "%d <A NAME=\"#nuweb%d\"></A>", scraps, scraps);

     source_last = '{';
     copy_scrap(file, TRUE);

     ++scraps;
     sep = ',';

   } while ( source_last != ')' && source_last != EOF );
   fputs(" ) ",file);
   do
     c = source_get();
   while(c != nw_char && c != EOF);
   if (c == nw_char) {
     c = source_get();
   }
   fputs("\\end{rawhtml}", file);
@}


\section{Writing the Latex File} \label{latex-file}

The second pass (invoked via a call to \verb|write_tex|) copies most of
the text from the source file straight into a \verb|.tex| file.
Definitions are formatted slightly and cross-reference information is
printed out.

Note that all the formatting is handled in this section.
If you don't like the format of definitions or indices or whatever,
it'll be in this section somewhere. Similarly, if someone wanted to
modify nuweb to work with a different typesetting system, this would
be the place to look.

@d Function...
@{extern void write_tex();
@}

We need a few local function declarations before we get into the body
of \verb|write_tex|.

@o latex.c -cc
@{static void copy_scrap();             /* formats the body of a scrap */
static void print_scrap_numbers();      /* formats a list of scrap numbers */
static void format_entry();             /* formats an index entry */
static void format_file_entry();        /* formats a file index entry */
static void format_user_entry();
static void write_arg();
static void write_literal();
static void write_ArglistElement();
@}


The routine \verb|write_tex| takes two file names as parameters: the
name of the web source file and the name of the \verb|.tex| output file.
@o latex.c -cc
@{void write_tex(file_name, tex_name, sector)
     char *file_name;
     char *tex_name;
     unsigned char sector;
{
  FILE *tex_file = fopen(tex_name, "w");
  if (tex_file) {
    if (verbose_flag)
      fprintf(stderr, "writing %s\n", tex_name);
    source_open(file_name);
    @<Write LaTeX limbo definitions@>
    @<Copy \verb|source_file| into \verb|tex_file|@>
    fclose(tex_file);
  }
  else
    fprintf(stderr, "%s: can't open %s\n", command_name, tex_name);
}
@| write_tex @}


Now that the \verb|\NW...| macros are used, it seems convenient
to write default definitions for those macros so that source files
need not define anything new. If a user wants to change any of
the macros (to use hyperref or to write in some language other than
english) he or she can redefine the commands.

@d Write LaTeX limbo definitions
@{if (hyperref_flag) {
   fputs("\\newcommand{\\NWtarget}[2]{\\hypertarget{#1}{#2}}\n", tex_file);
   fputs("\\newcommand{\\NWlink}[2]{\\hyperlink{#1}{#2}}\n", tex_file);
} else {
   fputs("\\newcommand{\\NWtarget}[2]{#2}\n", tex_file);
   fputs("\\newcommand{\\NWlink}[2]{#2}\n", tex_file);
}
fputs("\\newcommand{\\NWtxtMacroDefBy}{Fragment defined by}\n", tex_file);
fputs("\\newcommand{\\NWtxtMacroRefIn}{Fragment referenced in}\n", tex_file);
fputs("\\newcommand{\\NWtxtMacroNoRef}{Fragment never referenced}\n", tex_file);
fputs("\\newcommand{\\NWtxtDefBy}{Defined by}\n", tex_file);
fputs("\\newcommand{\\NWtxtRefIn}{Referenced in}\n", tex_file);
fputs("\\newcommand{\\NWtxtNoRef}{Not referenced}\n", tex_file);
fputs("\\newcommand{\\NWtxtFileDefBy}{File defined by}\n", tex_file);
fputs("\\newcommand{\\NWtxtIdentsUsed}{Uses:}\n", tex_file);
fputs("\\newcommand{\\NWtxtIdentsNotUsed}{Never used}\n", tex_file);
fputs("\\newcommand{\\NWtxtIdentsDefed}{Defines:}\n", tex_file);
fputs("\\newcommand{\\NWsep}{${\\diamond}$}\n", tex_file);
fputs("\\newcommand{\\NWnotglobal}{(not defined globally)}\n", tex_file);
fputs("\\newcommand{\\NWuseHyperlinks}{", tex_file);
if (hyperoptions[0] != '\0')
{
   @<Write the hyperlink usage macro@>
}
fputs("}\n", tex_file);
@}

@d Write the hyperlink usage macro
@{fprintf(tex_file, "\\usepackage[%s]{hyperref}", hyperoptions);@}

We make our second (and final) pass through the source web, this time
copying characters straight into the \verb|.tex| file. However, we keep
an eye peeled for \verb|@@|~characters, which signal a command sequence.

@d Copy \verb|source_file| into \verb|tex_file|
@{{
  int inBlock = FALSE;
  int c = source_get();
  while (c != EOF) {
    if (c == nw_char)
      {
      @<Interpret at-sequence@>
      }
    else {
      putc(c, tex_file);
      c = source_get();
    }
  }
}@}

@d Interpret at-sequence
@{{
  int big_definition = FALSE;
  c = source_get();
  switch (c) {
    case 'r':
          c = source_get();
          nw_char = c;
          update_delimit_scrap();
          break;
    case 'O': big_definition = TRUE;
    case 'o': @<Write output file definition@>
              break;
    case 'Q':
    case 'D': big_definition = TRUE;
    case 'q':
    case 'd': @<Write macro definition@>
              break;
    case 's':
              @<Step to next sector@>
              break;
    case 'S':
              @<Close the current sector@>
              break;
    case '{':
    case '[':
    case '(': @<Write in-text scrap@>
              break;
    case '<': @<Expand macro into @'tex_file@'@>
              break;
    case 'x': @<Copy label from source into@(tex_file@)@>
              c = source_get();
              break;
    case 'c': @<Begin or end a block comment@>
              c = source_get();
              break;
    case 'f': @<Write index of file names@>
              break;
    case 'm': @<Write index of macro names@>
              break;
    case 'u': @<Write index of user-specified names@>
              break;
    case 'v': @<Copy version info into tex file@>
              break;
    default:
          if (c==nw_char)
            putc(c, tex_file);
          c = source_get();
              break;
  }
}@}

@d Copy version info into tex file
@{fputs(version_string, tex_file);
c = source_get();
@}

@d Expand macro into @'file@'
@{{
   Parameters local_parameters = 0;
   int changed;
   char indent_chars[MAX_INDENT];
   Arglist *a;
   Name *name;
   Arglist * args;
   char * * inParams;
   a = collect_scrap_name(0);
   name = a->name;
   args = instance(a->args, NULL, NULL, &changed);
   inParams = name->arg;
   name->mark = TRUE;
   write_scraps(@1, tex_name, name->defs, 0, indent_chars, 0, 0, 1, 0,
         args, name->arg, local_parameters, tex_name);
   name->mark = FALSE;
   c = source_get();
}
@}

\subsection{Formatting Definitions}

We go through a fair amount of effort to format a file definition.
I've derived most of the \LaTeX\ commands experimentally; it's quite
likely that an expert could do a better job. The \LaTeX\ for
the previous fragment definition should look like this (perhaps modulo
the scrap references):
{\small
\begin{verbatim}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap70}\raggedright\small
$\langle$Interpret at-sequence {\footnotesize 18}$\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@@{@@\\
\mbox{}\verb@@  int big_definition = FALSE;@@\\
\mbox{}\verb@@  c = source_get();@@\\
\mbox{}\verb@@  switch (c) {@@\\
\mbox{}\verb@@    case 'O': big_definition = TRUE;@@\\
\mbox{}\verb@@    case 'o': @@$\langle$Write output file definition {\footnotesize 19a}$\rangle$\verb@@@@\\
\end{verbatim}
\vdots
\begin{verbatim}
\mbox{}\verb@@    case '@@{\tt @@}\verb@@': putc(c, tex_file);@@\\
\mbox{}\verb@@    default:  c = source_get();@@\\
\mbox{}\verb@@              break;@@\\
\mbox{}\verb@@  }@@\\
\mbox{}\verb@@}@@$\diamond$
\end{list}
\vspace{-1ex}
\footnotesize\addtolength{\baselineskip}{-1ex}
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item Fragment referenced in scrap 17b.
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\end{verbatim}}

\noindent
The {\em flushleft\/} environment is used to avoid \LaTeX\ warnings
about underful lines. The {\em minipage\/} environment is used to
avoid page breaks in the middle of scraps. The {\em verb\/} command
allows arbitrary characters to be printed (however, note the special
handling of the \verb|@@| case in the switch statement).

Fragment and file definitions are formatted nearly identically.
I've factored the common parts out into separate scraps.

@d Write output file definition
@{{
  Name *name = collect_file_name();
  @<Begin the scrap environment@>
  fputs("\\NWtarget{nuweb", tex_file);
  write_single_scrap_ref(tex_file, scraps);
  fputs("}{} ", tex_file);
  fprintf(tex_file, "\\verb%c\"%s\"%c\\nobreak\\ {\\footnotesize {", nw_char, name->spelling, nw_char);
  write_single_scrap_ref(tex_file, scraps);
  fputs("}}$\\equiv$\n", tex_file);
  @<Fill in the middle of the scrap environment@>
  @<Begin the cross-reference environment@>
  if ( scrap_flag ) {
    @<Write file defs@>
  }
  format_defs_refs(tex_file, scraps);
  format_uses_refs(tex_file, scraps++);
  @<Finish the cross-reference environment@>
  @<Finish the scrap environment@>
}@}


I don't format a fragment name at all specially, figuring the programmer
might want to use italics or bold face in the midst of the name.

@d Write macro definition
@{{
  Name *name = collect_macro_name();

  @<Begin the scrap environment@>
  fputs("\\NWtarget{nuweb", tex_file);
  write_single_scrap_ref(tex_file, scraps);
  fputs("}{} $\\langle\\,${\\itshape ", tex_file);
  @<Write the macro's name@>
  fputs("}\\nobreak\\ {\\footnotesize {", tex_file);
  write_single_scrap_ref(tex_file, scraps);
  fputs("}}$\\,\\rangle\\equiv$\n", tex_file);
  @<Fill in the middle of the scrap environment@>
  @<Begin the cross-reference environment@>
  @<Write macro defs@>
  @<Write macro refs@>
  format_defs_refs(tex_file, scraps);
  format_uses_refs(tex_file, scraps++);
  @<Finish the cross-reference environment@>
  @<Finish the scrap environment@>
}@}

@d Write the macro's name
@{{
  char * p = name->spelling;
  int i = 0;

  while (*p != '\000') {
    if (*p == ARG_CHR) {
      write_arg(tex_file, name->arg[i++]);
      p++;
    }
    else
       fputc(*p++, tex_file);
  }
}@}

@o latex.c -cc
@{static void write_arg(FILE * tex_file, char * p)
{
   fputs("\\hbox{\\slshape\\sffamily ", tex_file);
   while (*p)
   {
      switch (*p)
      {
      case '$':
      case '_':
      case '^':
      case '#':
         fputc('\\', tex_file);
         break;
      default:
         break;
      }
      fputc(*p, tex_file);
      p++;
   }

   fputs("\\/}", tex_file);
}
@| write_arg @}

@d Begin the scrap environment
@{{
  if (big_definition)
  {
    if (inBlock)
    {
       @<End block@>
    }
    fputs("\\begin{flushleft} \\small", tex_file);
  }
  else
  {
    if (inBlock)
    {
       @<Switch block@>
    }
    else
    {
       @<Start block@>
    }
  }
  fprintf(tex_file, "\\label{scrap%d}\\raggedright\\small\n", scraps);
}@}

@d Start block
@{fputs("\\begin{flushleft} \\small\n\\begin{minipage}{\\linewidth}", tex_file);
inBlock = TRUE;@}

@d Switch block
@{fputs("\\par\\vspace{\\baselineskip}\n",  tex_file);@}

@d End block
@{fputs("\\end{minipage}\\vspace{4ex}\n",  tex_file);
fputs("\\end{flushleft}\n", tex_file);
inBlock = FALSE;@}

The interesting things here are the $\diamond$ inserted at the end of
each scrap and the various spacing commands. The diamond helps to
clearly indicate the end of a scrap. The spacing commands were derived
empirically; they may be adjusted to taste.

@d Fill in the middle of the scrap environment
@{{
  fputs("\\vspace{-1ex}\n\\begin{list}{}{} \\item\n", tex_file);
  extra_scraps = 0;
  copy_scrap(tex_file, TRUE, name);
  fputs("{\\NWsep}\n\\end{list}\n", tex_file);
}@}

\newpage
\noindent
We've got one last spacing command, controlling the amount of white
space after a scrap.

Note also the whitespace eater. I use it to remove any blank lines
that appear after a scrap in the source file. This way, text following
a scrap will not be indented. Again, this is a matter of personal taste.

@d Finish the scrap environment
@{{
  scraps += extra_scraps;
  if (big_definition)
    fputs("\\vspace{4ex}\n\\end{flushleft}\n", tex_file);
  else
  {
     @<End block@>
  }
  do
    c = source_get();
  while (isspace(c));
}@}

@d Global variable dec...
@{extern int extra_scraps;
@}

@d Write in-text scrap
@{copy_scrap(tex_file, FALSE, NULL);
c = source_get();
@}

\subsubsection{Formatting Cross References}

@d Begin the cross-reference environment
@{{
  fputs("\\vspace{-1.5ex}\n", tex_file);
  fputs("\\footnotesize\n", tex_file);
  fputs("\\begin{list}{}{\\setlength{\\itemsep}{-\\parsep}",
    tex_file);
  fputs("\\setlength{\\itemindent}{-\\leftmargin}}\n", tex_file);}
@}

There may (unusually) be nothing to output in the cross-reference
section, so output an empty list item anyway to avoid having an empty
list.

@d Finish the cross-reference environment
@{{
  fputs("\n\\item{}", tex_file);
  fputs("\n\\end{list}\n", tex_file);
}@}

@d Write file defs
@{{
  if (name->defs) {
    if (name->defs->next) {
      fputs("\\item \\NWtxtFileDefBy\\ ", tex_file);
      print_scrap_numbers(tex_file, name->defs);
    }
  } else {
    fprintf(stderr,
            "would have crashed in 'Write file defs' for '%s'\n",
             name->spelling);
  }
}@}

@d Write macro defs
@{{
  if (name->defs->next) {
    fputs("\\item \\NWtxtMacroDefBy\\ ", tex_file);
    print_scrap_numbers(tex_file, name->defs);
  }
}@}

@d Write macro refs
@{{
  if (name->uses) {
    if (name->uses->next) {
      fputs("\\item \\NWtxtMacroRefIn\\ ", tex_file);
      print_scrap_numbers(tex_file, name->uses);
    }
    else {
      fputs("\\item \\NWtxtMacroRefIn\\ ", tex_file);
      fputs("\\NWlink{nuweb", tex_file);
      write_single_scrap_ref(tex_file, name->uses->scrap);
      fputs("}{", tex_file);
      write_single_scrap_ref(tex_file, name->uses->scrap);
      fputs("}", tex_file);
      fputs(".\n", tex_file);
    }
  }
  else {
    fputs("\\item {\\NWtxtMacroNoRef}.\n", tex_file);
    fprintf(stderr, "%s: <%s> never referenced.\n",
            command_name, name->spelling);
  }
}@}

@o latex.c -cc
@{static void print_scrap_numbers(tex_file, scraps)
     FILE *tex_file;
     Scrap_Node *scraps;
{
  int page;
  fputs("\\NWlink{nuweb", tex_file);
  write_scrap_ref(tex_file, scraps->scrap, -1, &page);
  fputs("}{", tex_file);
  write_scrap_ref(tex_file, scraps->scrap, TRUE, &page);
  fputs("}", tex_file);
  scraps = scraps->next;
  while (scraps) {
    fputs("\\NWlink{nuweb", tex_file);
    write_scrap_ref(tex_file, scraps->scrap, -1, &page);
    fputs("}{", tex_file);
    write_scrap_ref(tex_file, scraps->scrap, FALSE, &page);
    scraps = scraps->next;
    fputs("}", tex_file);
  }
  fputs(".\n", tex_file);
}
@| print_scrap_numbers @}

\subsubsection{Formatting a Scrap}

We add a \verb|\mbox{}| at the beginning of each line to avoid
problems with older versions of \TeX.
This is the only place we really care whether a scrap is
delimited with \verb|@@{...@@}|, \verb|@@[...@@]|, or \verb|@@(...@@)|,
and we base our output sequences on that.

We have an array \texttt{delimit\_scrap} where we store our strings
that perform the formatting for one line of a scrap. Upon
initialisation we copy our strings from the source
\texttt{orig\_delimit\_scrap} to it to have the strings writeable.  We
might change the strings later when we encounter the command to change
the `nuweb character'.

@o latex.c
@{static char *orig_delimit_scrap[3][5] = {
  /* {} mode: begin, end, insert nw_char, prefix, suffix */
  { "\\verb@@", "@@", "@@{\\tt @@}\\verb@@", "\\mbox{}", "\\\\" },
  /* [] mode: begin, end, insert nw_char, prefix, suffix */
  { "", "", "@@", "", "" },
  /* () mode: begin, end, insert nw_char, prefix, suffix */
  { "$", "$", "@@", "", "" },
};

static char *delimit_scrap[3][5];
@}

The function \texttt{initialise\_delimit\_scrap\_array} does the
copying. If we want to have the listings package \index{listings package}
do the formatting we have to replace only two of those strings: the
\texttt{verb} command has to be replaced by the package's \texttt{lstinline}
command.

@o latex.c
@{void initialise_delimit_scrap_array() {
  int i,j;
  for(i = 0; i < 3; i++) {
    for(j = 0; j < 5; j++) {
      if((delimit_scrap[i][j] = strdup(orig_delimit_scrap[i][j])) == NULL) {
        fprintf(stderr, "Not enough memory for string allocation\n");
        exit(EXIT_FAILURE);
      }
    }
  }

  /* replace verb by lstinline */
  if (listings_flag) {
    free(delimit_scrap[0][0]);
    if((delimit_scrap[0][0]=strdup("\\lstinline@@")) == NULL) {
      fprintf(stderr, "Not enough memory for string allocation\n");
      exit(EXIT_FAILURE);
    }
    free(delimit_scrap[0][2]);
    if((delimit_scrap[0][2]=strdup("@@{\\tt @@}\\lstinline@@")) == NULL) {
      fprintf(stderr, "Not enough memory for string allocation\n");
      exit(EXIT_FAILURE);
    }
  }
}
@}

@d Function prototypes
@{void initialise_delimit_scrap_array(void);
@}

@o latex.c
@{int scrap_type = 0;
@| scrap_type @}

@o latex.c -cc
@{static void write_literal(FILE * tex_file, char * p, int mode)
{
   fprintf(tex_file, "", p);
   fputs(delimit_scrap[mode][0], tex_file);
   while (*p!= '\000') {
     if (*p == nw_char)
       fputs(delimit_scrap[mode][2], tex_file);
     else
       fputc(*p, tex_file);
     p++;
   }
   fputs(delimit_scrap[mode][1], tex_file);
}
@| write_literal @}

@o latex.c -cc
@{static void copy_scrap(file, prefix, name)
     FILE *file;
     int prefix;
     Name * name;
{
  int indent = 0;
  int c;
  char ** params = name->arg;
  if (source_last == '{') scrap_type = 0;
  if (source_last == '[') scrap_type = 1;
  if (source_last == '(') scrap_type = 2;
  c = source_get();
  if (prefix) fputs(delimit_scrap[scrap_type][3], file);
  fputs(delimit_scrap[scrap_type][0], file);
  while (1) {
    switch (c) {
      case '\n': fputs(delimit_scrap[scrap_type][1], file);
                 if (prefix) fputs(delimit_scrap[scrap_type][4], file);
                 fputs("\n", file);
                 if (prefix) fputs(delimit_scrap[scrap_type][3], file);
                 fputs(delimit_scrap[scrap_type][0], file);
                 indent = 0;
                 break;
      case '\t': @<Expand tab into spaces@>
                 break;
      default:
         if (c==nw_char)
           {
             @<Check at-sequence for end-of-scrap@>
             break;
           }
         putc(c, file);
                 indent++;
                 break;
    }
    c = source_get();
  }
}
@| copy_scrap scrap_type @}

When we encounter the command to change the `nuweb character' we call
this function. It updates the scrap formatting directives accordingly.

@o latex.c
@{void update_delimit_scrap()
{
  static int been_here_before = 0;

  /* {}-mode begin */
  if (listings_flag) {
    delimit_scrap[0][0][10] = nw_char;
  } else {
    delimit_scrap[0][0][5] = nw_char;
  }
  /* {}-mode end */
  delimit_scrap[0][1][0] = nw_char;
  /* {}-mode insert nw_char */

  delimit_scrap[0][2][0] = nw_char;
  delimit_scrap[0][2][6] = nw_char;

  if (listings_flag) {
    delimit_scrap[0][2][18] = nw_char;
  } else {
    delimit_scrap[0][2][13] = nw_char;
  }

  /* []-mode insert nw_char */
  delimit_scrap[1][2][0] = nw_char;

  /* ()-mode insert nw_char */
  delimit_scrap[2][2][0] = nw_char;
}
@| update_delimit_scrap @}

@d Function prototypes
@{void update_delimit_scrap();
@}

@d Expand tab into spaces
@{{
  int delta = 8 - (indent % 8);
  indent += delta;
  while (delta > 0) {
    putc(' ', file);
    delta--;
  }
}@}

@d Check at-sequence...
@{{
  c = source_get();
  switch (c) {
    case 'c': @<Show presence of a block comment@>
              break;
    case 'x': @<Copy label from source into@(file@)@>
              break;
    case 'v': @<Copy version info into file@>
    case 's':
              break;
    case '+':
    case '-':
    case '*':
    case '|': @<Skip over index entries@>
    case ',':
    case ')':
    case ']':
    case '}': fputs(delimit_scrap[scrap_type][1], file);
              return;
    case '<': @<Format macro name@>
              break;
    case '%': @<Skip commented-out code@>
              break;
    case '_': @<Bold Keyword@>
              break;
    case 't': @<Italic "@'fragment title@'"@>
              break;
    case 'f': @<Italic "@'file name@'"@>
              break;
    case '1': case '2': case '3':
    case '4': case '5': case '6':
    case '7': case '8': case '9':
              if (name == NULL
                  || name->arg[c - '1'] == NULL) {
                fputs(delimit_scrap[scrap_type][2], file);
                fputc(c,   file);
              }
              else {
                fputs(delimit_scrap[scrap_type][1], file);
                write_arg(file, name->arg[c - '1']);
                fputs(delimit_scrap[scrap_type][0], file);
              }
              break;
    default:
          if (c==nw_char)
            {
              fputs(delimit_scrap[scrap_type][2], file);
              break;
            }
          /* ignore these since pass1 will have warned about them */
              break;
  }
}@}

@d Copy version info into file
@{fputs(version_string, file);
@}

@d Copy label from source into
@{{
   @<Get label from@(source_get()@)@>
   write_label(label_name, @1);
}@}


There's no need to check for errors here, since we will have already
pointed out any during the first pass.
@d Skip over index entries
@{{
  do {
    do
      c = source_get();
    while (c != nw_char);
    c = source_get();
  } while (c != '}' && c != ']' && c != ')' );
}@}

@d Skip commented-out code...
@{{
        do
                c = source_get();
        while (c != '\n');
}@}

This scrap helps deal with bold keywords:

@d Bold Keyword
@{{
  fputs(delimit_scrap[scrap_type][1],file);
  fprintf(file, "\\hbox{\\sffamily\\bfseries ");
  c = source_get();
  do {
      fputc(c, file);
      c = source_get();
  } while (c != nw_char);
  c = source_get();
  fprintf(file, "}");
  fputs(delimit_scrap[scrap_type][0], file);
}@}

@d Italic "@'whatever@'"
@{{
  fputs(delimit_scrap[scrap_type][1],file);
  fprintf(file, "\\hbox{\\sffamily\\slshape @1}");
  fputs(delimit_scrap[scrap_type][0], file);
}@}

@d Format macro name
@{{
  Arglist *args = collect_scrap_name(-1);
  Name *name = args->name;
  char * p = name->spelling;
  Arglist *q = args->args;
  int narg = 0;

  fputs(delimit_scrap[scrap_type][1],file);
  if (prefix)
    fputs("\\hbox{", file);
  fputs("$\\langle\\,${\\itshape ", file);
  while (*p != '\000') {
    if (*p == ARG_CHR) {
      if (q == NULL) {
         write_literal(file, name->arg[narg], scrap_type);
      }
      else {
        write_ArglistElement(file, q, params);
        q = q->next;
      }
      p++;
      narg++;
    }
    else
       fputc(*p++, file);
  }
  fputs("}\\nobreak\\ ", file);
  if (scrap_name_has_parameters) {
    @<Format macro parameters@>
  }
  fprintf(file, "{\\footnotesize ");
  if (name->defs)
    @<Write abbreviated definition list@>
  else {
    putc('?', file);
    fprintf(stderr, "%s: never defined <%s>\n",
            command_name, name->spelling);
  }
  fputs("}$\\,\\rangle$", file);
  if (prefix)
     fputs("}", file);
  fputs(delimit_scrap[scrap_type][0], file);
}@}


@d Write abbreviated definition list
@{{
  Scrap_Node *p = name->defs;
  fputs("\\NWlink{nuweb", file);
  write_single_scrap_ref(file, p->scrap);
  fputs("}{", file);
  write_single_scrap_ref(file, p->scrap);
  fputs("}", file);
  p = p->next;
  if (p)
    fputs(", \\ldots\\ ", file);
}@}

@o latex.c -cc
@{static void
write_ArglistElement(FILE * file, Arglist * args, char ** params)
{
  Name *name = args->name;
  Arglist *q = args->args;

  if (name == NULL) {
    char * p = (char*)q;

    if (p[0] == ARG_CHR) {
       write_arg(file, params[p[1] - '1']);
    } else {
       write_literal(file, (char *)q, 0);
    }
  } else if (name == (Name *)1) {
    Scrap_Node * qq = (Scrap_Node *)q;
    qq->quoted = TRUE;
    fputs(delimit_scrap[scrap_type][0], file);
    write_scraps(file, "", qq,
                 -1, "", 0, 0, 0, 0,
                 NULL, params, 0, "");
    fputs(delimit_scrap[scrap_type][1], file);
    extra_scraps++;
    qq->quoted = FALSE;
  } else {
    char * p = name->spelling;
    fputs("$\\langle\\,${\\itshape ", file);
      while (*p != '\000') {
      if (*p == ARG_CHR) {
        write_ArglistElement(file, q, params);
        q = q->next;
        p++;
      }
      else
         fputc(*p++, file);
    }
    fputs("}\\nobreak\\ ", file);
    if (scrap_name_has_parameters) {
      int c;

      @<Format macro parameters@>
    }
    fprintf(file, "{\\footnotesize ");
    if (name->defs)
      @<Write abbreviated definition list@>
    else {
      putc('?', file);
      fprintf(stderr, "%s: never defined <%s>\n",
              command_name, name->spelling);
    }
    fputs("}$\\,\\rangle$", file);
  }
}
@| write_ArglistElement @}

\subsection{Generating the Indices}

@d Write index of file names
@{{
  if (file_names) {
    fputs("\n{\\small\\begin{list}{}{\\setlength{\\itemsep}{-\\parsep}",
          tex_file);
    fputs("\\setlength{\\itemindent}{-\\leftmargin}}\n", tex_file);
    format_file_entry(file_names, tex_file);
    fputs("\\end{list}}", tex_file);
  }
  c = source_get();
}@}

@o latex.c -cc
@{static void format_file_entry(name, tex_file)
     Name *name;
     FILE *tex_file;
{
  while (name) {
    format_file_entry(name->llink, tex_file);
    @<Format a file index entry@>
    name = name->rlink;
  }
}
@| format_file_entry @}

@d Format a file index entry
@{fputs("\\item ", tex_file);
fprintf(tex_file, "\\verb%c\"%s\"%c ", nw_char, name->spelling, nw_char);
@<Write file's defining scrap numbers@>
putc('\n', tex_file);@}

@d Write file's defining scrap numbers
@{{
  Scrap_Node *p = name->defs;
  fputs("{\\footnotesize {\\NWtxtDefBy}", tex_file);
  if (p->next) {
    /* fputs("s ", tex_file); */
      putc(' ', tex_file);
    print_scrap_numbers(tex_file, p);
  }
  else {
    putc(' ', tex_file);
    fputs("\\NWlink{nuweb", tex_file);
    write_single_scrap_ref(tex_file, p->scrap);
    fputs("}{", tex_file);
    write_single_scrap_ref(tex_file, p->scrap);
    fputs("}", tex_file);
    putc('.', tex_file);
  }
  putc('}', tex_file);
}@}

@d Write index of macro names
@{{
  unsigned char sector = current_sector;
  int c = source_get();
  if (c == '+')
     sector = 0;
  else
     source_ungetc(&c);
  if (has_sector(macro_names, sector)) {
    fputs("\n{\\small\\begin{list}{}{\\setlength{\\itemsep}{-\\parsep}",
          tex_file);
    fputs("\\setlength{\\itemindent}{-\\leftmargin}}\n", tex_file);
    format_entry(macro_names, tex_file, sector);
    fputs("\\end{list}}", tex_file);
  } else {
    fputs("None.\n", tex_file);
  }
}
c = source_get();
@}

@o latex.c -cc
@{static int load_entry(Name * name, Name ** nms, int n)
{
   while (name) {
      n = load_entry(name->llink, nms, n);
      nms[n++] = name;
      name = name->rlink;
   }
   return n;
}
@| load_entry @}

@o latex.c -cc
@{static void format_entry(name, tex_file, sector)
     Name *name;
     FILE *tex_file;
     unsigned char sector;
{
  Name ** nms = malloc(num_scraps()*sizeof(Name *));
  int n = load_entry(name, nms, 0);
  int i;

  @<Sort @'nms@' of size @'n@' for @<Rob's ordering@>@>
  for (i = 0; i < n; i++)
  {
     Name * name = nms[i];

     @<Format an index entry@>
  }
}
@| format_entry @}

@d Rob's...
@{robs_strcmp(ki->spelling, kj->spelling) < 0@}

@d Sort @'key@' of size @'n@' for @'ordering@'
@{int j;
for (j = 1; j < @2; j++)
{
   int i = j - 1;
   Name * kj = @1[j];

   do
   {
      Name * ki = @1[i];

      if (@3)
         break;
      @1[i + 1] = ki;
      i -= 1;
   } while (i >= 0);
   @1[i + 1] = kj;
}
@}

@d Format an index entry
@{if (name->sector == sector){
  fputs("\\item ", tex_file);
  fputs("$\\langle\\,$", tex_file);
  @<Write the macro's name@>
  fputs("\\nobreak\\ {\\footnotesize ", tex_file);
  @<Write defining scrap numbers@>
  fputs("}$\\,\\rangle$ ", tex_file);
  @<Write referencing scrap numbers@>
  putc('\n', tex_file);
}@}

@d Write defining scrap numbers
@{{
  Scrap_Node *p = name->defs;
  if (p) {
    int page;
    fputs("\\NWlink{nuweb", tex_file);
    write_scrap_ref(tex_file, p->scrap, -1, &page);
    fputs("}{", tex_file);
    write_scrap_ref(tex_file, p->scrap, TRUE, &page);
    fputs("}", tex_file);
    p = p->next;
    while (p) {
      fputs("\\NWlink{nuweb", tex_file);
      write_scrap_ref(tex_file, p->scrap, -1, &page);
      fputs("}{", tex_file);
      write_scrap_ref(tex_file, p->scrap, FALSE, &page);
      fputs("}", tex_file);
      p = p->next;
    }
  }
  else
    putc('?', tex_file);
}@}

@d Write referencing scrap numbers
@{{
  Scrap_Node *p = name->uses;
  fputs("{\\footnotesize ", tex_file);
  if (p) {
    fputs("{\\NWtxtRefIn}", tex_file);
    if (p->next) {
      /* fputs("s ", tex_file); */
      putc(' ', tex_file);
      print_scrap_numbers(tex_file, p);
    }
    else {
      putc(' ', tex_file);
      fputs("\\NWlink{nuweb", tex_file);
      write_single_scrap_ref(tex_file, p->scrap);
      fputs("}{", tex_file);
      write_single_scrap_ref(tex_file, p->scrap);
      fputs("}", tex_file);
      putc('.', tex_file);
    }
  }
  else
    fputs("{\\NWtxtNoRef}.", tex_file);
  putc('}', tex_file);
}@}

@o latex.c -cc
@{int has_sector(name, sector)
Name * name;
unsigned char sector;
{
  while(name) {
    if (name->sector == sector)
       return TRUE;
    if (has_sector(name->llink, sector))
       return TRUE;
     name = name->rlink;
   }
   return FALSE;
}
@| has_sector @}

@d Write index of user-specified names
@{{
    unsigned char sector = current_sector;
    c = source_get();
    if (c == '+') {
       sector = 0;
       c = source_get();
    }
    if (has_sector(user_names, sector)) {
      fputs("\n{\\small\\begin{list}{}{\\setlength{\\itemsep}{-\\parsep}",
            tex_file);
      fputs("\\setlength{\\itemindent}{-\\leftmargin}}\n", tex_file);
      format_user_entry(user_names, tex_file, sector);
      fputs("\\end{list}}", tex_file);
    }
}@}


@o latex.c -cc
@{static void format_user_entry(name, tex_file, sector)
     Name *name;
     FILE *tex_file;
     unsigned char sector;
{
  while (name) {
    format_user_entry(name->llink, tex_file, sector);
    @<Format a user index entry@>
    name = name->rlink;
  }
}
@| format_user_entry @}


@D Format a user index entry
@{if (name->sector == sector){
  Scrap_Node *uses = name->uses;
  if ( uses || dangling_flag ) {
    int page;
    Scrap_Node *defs = name->defs;
    fprintf(tex_file, "\\item \\verb%c%s%c: ", nw_char,name->spelling,nw_char);
    if (!uses) {
        fputs("(\\underline{", tex_file);
        fputs("\\NWlink{nuweb", tex_file);
        write_single_scrap_ref(tex_file, defs->scrap);
        fputs("}{", tex_file);
        write_single_scrap_ref(tex_file, defs->scrap);
        fputs("})}", tex_file);
        page = -2;
        defs = defs->next;
    }
    else
      if (!defs || uses->scrap < defs->scrap) {
      fputs("\\NWlink{nuweb", tex_file);
      write_scrap_ref(tex_file, uses->scrap, -1, &page);
      fputs("}{", tex_file);
      write_scrap_ref(tex_file, uses->scrap, TRUE, &page);
      fputs("}", tex_file);
      uses = uses->next;
    }
    else {
      if (defs->scrap == uses->scrap)
        uses = uses->next;
      fputs("\\underline{", tex_file);

      fputs("\\NWlink{nuweb", tex_file);
      write_single_scrap_ref(tex_file, defs->scrap);
      fputs("}{", tex_file);
      write_single_scrap_ref(tex_file, defs->scrap);
      fputs("}}", tex_file);
      page = -2;
      defs = defs->next;
    }
    while (uses || defs) {
      if (uses && (!defs || uses->scrap < defs->scrap)) {
        fputs("\\NWlink{nuweb", tex_file);
        write_scrap_ref(tex_file, uses->scrap, -1, &page);
        fputs("}{", tex_file);
        write_scrap_ref(tex_file, uses->scrap, FALSE, &page);
        fputs("}", tex_file);
        uses = uses->next;
      }
      else {
        if (uses && defs->scrap == uses->scrap)
          uses = uses->next;
        fputs(", \\underline{", tex_file);

        fputs("\\NWlink{nuweb", tex_file);
        write_single_scrap_ref(tex_file, defs->scrap);
        fputs("}{", tex_file);
        write_single_scrap_ref(tex_file, defs->scrap);
        fputs("}", tex_file);

        putc('}', tex_file);
        page = -2;
        defs = defs->next;
      }
    }
    fputs(".\n", tex_file);
  }
}@}

\section{Writing the LaTeX File with HTML Scraps} \label{html-file}

The HTML generated is patterned closely upon the {\LaTeX} generated in
the previous section.\footnote{\relax While writing this section, I
tried to follow Preston's style as displayed in
Section~\ref{latex-file}---J. D. R.}  When a file name ends in
\verb|.hw|, the second pass (invoked via a call to \verb|write_html|)
copies most of the text from the source file straight into a
\verb|.tex| file.  Definitions are formatted slightly and
cross-reference information is printed out.

@d Function...
@{extern void write_html();
@}

We need a few local function declarations before we get into the body
of \verb|write_html|.

@o html.c
@{static void copy_scrap();               /* formats the body of a scrap */
static void display_scrap_ref();        /* formats a scrap reference */
static void display_scrap_numbers();    /* formats a list of scrap numbers */
static void print_scrap_numbers();      /* pluralizes scrap formats list */
static void format_entry();             /* formats an index entry */
static void format_file_entry();        /* formats a file index entry */
static void format_user_entry();
@}


The routine \verb|write_html| takes two file names as parameters: the
name of the web source file and the name of the \verb|.tex| output file.
@o html.c
@{void write_html(file_name, html_name)
     char *file_name;
     char *html_name;
{
  FILE *html_file = fopen(html_name, "w");
  FILE *tex_file = html_file;
  @<Write LaTeX limbo definitions@>
  if (html_file) {
    if (verbose_flag)
      fprintf(stderr, "writing %s\n", html_name);
    source_open(file_name);
    @<Copy \verb|source_file| into \verb|html_file|@>
    fclose(html_file);
  }
  else
    fprintf(stderr, "%s: can't open %s\n", command_name, html_name);
}
@| write_html @}


We make our second (and final) pass through the source web, this time
copying characters straight into the \verb|.tex| file. However, we keep
an eye peeled for \verb|@@|~characters, which signal a command sequence.

@d Copy \verb|source_file| into \verb|html_file|
@{{
  int c = source_get();
  while (c != EOF) {
    if (c == nw_char)
      @<Interpret HTML at-sequence@>
    else {
      putc(c, html_file);
      c = source_get();
    }
  }
}@}

@d Interpret HTML at-sequence
@{{
  c = source_get();
  switch (c) {
    case 'r':
          c = source_get();
          nw_char = c;
          update_delimit_scrap();
          break;
    case 'O':
    case 'o': @<Write HTML output file definition@>
              break;
    case 'Q':
    case 'q':
    case 'D':
    case 'd': @<Write HTML macro definition@>
              break;
    case 'f': @<Write HTML index of file names@>
              break;
    case 'm': @<Write HTML index of macro names@>
              break;
    case 'u': @<Write HTML index of user-specified names@>
              break;
    default:
          if (c==nw_char)
            putc(c, html_file);
          c = source_get();
              break;
  }
}@}


\subsection{Formatting Definitions}

We go through only a little amount of effort to format a definition.
The HTML for the previous fragment definition should look like this
(perhaps modulo the scrap references):

\begin{verbatim}
<pre>
<a name="nuweb68">&lt;Interpret HTML at-sequence 68&gt;</a> =
{
  c = source_get();
  switch (c) {
    case 'O':
    case 'o': &lt;Write HTML output file definition <a href="#nuweb69">69</a>&gt;
              break;
    case 'D':
    case 'd': &lt;Write HTML macro definition <a href="#nuweb71">71</a>&gt;
              break;
    case 'f': &lt;Write HTML index of file names <a href="#nuweb86">86</a>&gt;
              break;
    case 'm': &lt;Write HTML index of macro names <a href="#nuweb87">87</a>&gt;
              break;
    case 'u': &lt;Write HTML index of user-specified names <a href="#nuweb93">93</a>&gt;
              break;
    default:
         if (c==nw_char)
           putc(c, html_file);
         c = source_get();
              break;
  }
}&lt;&gt;</pre>
Fragment referenced in scrap <a href="#nuweb67">67</a>.
<br>
\end{verbatim}

Fragment and file definitions are formatted nearly identically.
I've factored the common parts out into separate scraps.

@d Write HTML output file definition
@{{
  Name *name = collect_file_name();
  @<Begin HTML scrap environment@>
  @<Write HTML output file declaration@>
  scraps++;
  @<Fill in the middle of HTML scrap environment@>
  @<Write HTML file defs@>
  @<Finish HTML scrap environment@>
}@}

@d Write HTML output file declaration
@{  fputs("<a name=\"nuweb", html_file);
  write_single_scrap_ref(html_file, scraps);
  fprintf(html_file, "\"><code>\"%s\"</code> ", name->spelling);
  write_single_scrap_ref(html_file, scraps);
  fputs("</a> =\n", html_file);
@}

@d Write HTML macro definition
@{{
  Name *name = collect_macro_name();
  @<Begin HTML scrap environment@>
  @<Write HTML macro declaration@>
  scraps++;
  @<Fill in the middle of HTML scrap environment@>
  @<Write HTML macro defs@>
  @<Write HTML macro refs@>
  @<Finish HTML scrap environment@>
}@}

I don't format a fragment name at all specially, figuring the programmer
might want to use italics or bold face in the midst of the name.  Note
that in this implementation, programmers may only use directives in
fragment names that are recognized in preformatted text elements (PRE).

Modification 2001--02--15.: I'm interpreting the fragment name
as regular LaTex, so that any formatting can be used in it. To use
HTML formatting, the \verb|rawhtml| environment should be used.

@d Write HTML macro declaration
@{  fputs("<a name=\"nuweb", html_file);
  write_single_scrap_ref(html_file, scraps);
  fputs("\">&lt;\\end{rawhtml}", html_file);
  fputs(name->spelling, html_file);
  fputs("\\begin{rawhtml} ", html_file);
  write_single_scrap_ref(html_file, scraps);
  fputs("&gt;</a> =\n", html_file);
@}

@d Begin HTML scrap environment
@{{
  fputs("\\begin{rawhtml}\n", html_file);
  fputs("<pre>\n", html_file);
}@}

The end of a scrap is marked with the characters \verb|<>|.
@d Fill in the middle of HTML scrap environment
@{{
  copy_scrap(html_file, TRUE);
  fputs("&lt;&gt;</pre>\n", html_file);
}@}

The only task remaining is to get rid of the current at command and
end the paragraph.

@d Finish HTML scrap environment
@{{
  fputs("\\end{rawhtml}\n", html_file);
  c = source_get(); /* Get rid of current at command. */
}@}


\subsubsection{Formatting Cross References}

@d Write HTML file defs
@{{
  if (name->defs->next) {
    fputs("\\end{rawhtml}\\NWtxtFileDefBy\\begin{rawhtml} ", html_file);
    print_scrap_numbers(html_file, name->defs);
    fputs("<br>\n", html_file);
  }
}@}

@d Write HTML macro defs
@{{
  if (name->defs->next) {
    fputs("\\end{rawhtml}\\NWtxtMacroDefBy\\begin{rawhtml} ", html_file);
    print_scrap_numbers(html_file, name->defs);
    fputs("<br>\n", html_file);
  }
}@}

@d Write HTML macro refs
@{{
  if (name->uses) {
    fputs("\\end{rawhtml}\\NWtxtMacroRefIn\\begin{rawhtml} ", html_file);
    print_scrap_numbers(html_file, name->uses);
  }
  else {
    fputs("\\end{rawhtml}{\\NWtxtMacroNoRef}.\\begin{rawhtml}", html_file);
    fprintf(stderr, "%s: <%s> never referenced.\n",
            command_name, name->spelling);
  }
  fputs("<br>\n", html_file);
}@}

@o html.c
@{static void display_scrap_ref(html_file, num)
     FILE *html_file;
     int num;
{
  fputs("<a href=\"#nuweb", html_file);
  write_single_scrap_ref(html_file, num);
  fputs("\">", html_file);
  write_single_scrap_ref(html_file, num);
  fputs("</a>", html_file);
}
@| display_scrap_ref @}

@o html.c
@{static void display_scrap_numbers(html_file, scraps)
     FILE *html_file;
     Scrap_Node *scraps;
{
  display_scrap_ref(html_file, scraps->scrap);
  scraps = scraps->next;
  while (scraps) {
    fputs(", ", html_file);
    display_scrap_ref(html_file, scraps->scrap);
    scraps = scraps->next;
  }
}
@| display_scrap_numbers @}

@o html.c
@{static void print_scrap_numbers(html_file, scraps)
     FILE *html_file;
     Scrap_Node *scraps;
{
  display_scrap_numbers(html_file, scraps);
  fputs(".\n", html_file);
}
@| print_scrap_numbers @}


\subsubsection{Formatting a Scrap}

We must translate HTML special keywords into entities in scraps.

@o html.c
@{static void copy_scrap(file, prefix)
     FILE *file;
{
  int indent = 0;
  int c = source_get();
  while (1) {
    switch (c) {
      case '<' : fputs("&lt;", file);
                 indent++;
                 break;
      case '>' : fputs("&gt;", file);
                 indent++;
                 break;
      case '&' : fputs("&amp;", file);
                 indent++;
                 break;
      case '\n': fputc(c, file);
                 indent = 0;
                 break;
      case '\t': @<Expand tab into spaces@>
                 break;
      default:
         if (c==nw_char)
           {
             @<Check HTML at-sequence for end-of-scrap@>
             break;
           }
         putc(c, file);
                 indent++;
                 break;
    }
    c = source_get();
  }
}
@| copy_scrap @}

@d Check HTML at-sequence...
@{{
  c = source_get();
  switch (c) {
    case '+':
    case '-':
    case '*':
    case '|': @<Skip over index entries@>
    case ',':
    case '}':
    case ']':
    case ')': return;
    case '_': @<Write HTML bold tag or end@>
              break;
    case '1': case '2': case '3':
    case '4': case '5': case '6':
    case '7': case '8': case '9':
              fputc(nw_char, file);
              fputc(c,   file);
              break;
    case '<': @<Format HTML macro name@>
              break;
    case '%': @<Skip commented-out code@>
              break;
    default:
         if (c==nw_char)
           {
             fputc(c, file);
             break;
           }
          /* ignore these since pass1 will have warned about them */
              break;
  }
}@}

There's no need to check for errors here, since we will have already
pointed out any during the first pass.

@d Format HTML macro name
@{{
  Arglist * args = collect_scrap_name(-1);
  Name *name = args->name;
  fputs("&lt;\\end{rawhtml}", file);
  fputs(name->spelling, file);
  if (scrap_name_has_parameters) {
    @<Format HTML macro parameters@>
  }
  fputs("\\begin{rawhtml} ", file);
  if (name->defs)
    @<Write HTML abbreviated definition list@>
  else {
    putc('?', file);
    fprintf(stderr, "%s: never defined <%s>\n",
            command_name, name->spelling);
  }
  fputs("&gt;", file);
}@}


@d Write HTML abbreviated definition list
@{{
  Scrap_Node *p = name->defs;
  display_scrap_ref(file, p->scrap);
  if (p->next)
    fputs(", ... ", file);
}@}


\subsection{Generating the Indices}

@d Write HTML index of file names
@{{
  if (file_names) {
    fputs("\\begin{rawhtml}\n", html_file);
    fputs("<dl compact>\n", html_file);
    format_entry(file_names, html_file, TRUE);
    fputs("</dl>\n", html_file);
    fputs("\\end{rawhtml}\n", html_file);
  }
  c = source_get();
}@}


@d Write HTML index of macro names
@{{
  if (macro_names) {
    fputs("\\begin{rawhtml}\n", html_file);
    fputs("<dl compact>\n", html_file);
    format_entry(macro_names, html_file, FALSE);
    fputs("</dl>\n", html_file);
    fputs("\\end{rawhtml}\n", html_file);
  }
  c = source_get();
}@}


@d Write HTML bold tag or end
@{{
     static int toggle;
     toggle = ~toggle;
     if( toggle ) {
        fputs( "<b>", file );
     } else {
        fputs( "</b>", file );
     }
}@}

@o html.c
@{static void format_entry(name, html_file, file_flag)
     Name *name;
     FILE *html_file;
     int file_flag;
{
  while (name) {
    format_entry(name->llink, html_file, file_flag);
    @<Format an HTML index entry@>
    name = name->rlink;
  }
}
@| format_entry @}

@d Format an HTML index entry
@{{
  fputs("<dt> ", html_file);
  if (file_flag) {
    fprintf(html_file, "<code>\"%s\"</code>\n<dd> ", name->spelling);
    @<Write HTML file's defining scrap numbers@>
  }
  else {
    fputs("&lt;\\end{rawhtml}", html_file);
    fputs(name->spelling, html_file);
    fputs("\\begin{rawhtml} ", html_file);
    @<Write HTML defining scrap numbers@>
    fputs("&gt;\n<dd> ", html_file);
    @<Write HTML referencing scrap numbers@>
  }
  putc('\n', html_file);
}@}


@d Write HTML file's defining scrap numbers
@{{
  fputs("\\end{rawhtml}\\NWtxtDefBy\\begin{rawhtml} ", html_file);
  print_scrap_numbers(html_file, name->defs);
}@}

@d Write HTML defining scrap numbers
@{{
  if (name->defs)
    display_scrap_numbers(html_file, name->defs);
  else
    putc('?', html_file);
}@}

@d Write HTML referencing scrap numbers
@{{
  Scrap_Node *p = name->uses;
  if (p) {
    fputs("\\end{rawhtml}\\NWtxtRefIn\\begin{rawhtml} ", html_file);
    print_scrap_numbers(html_file, p);
  }
  else
    fputs("\\end{rawhtml}{\\NWtxtNoRef}.\\begin{rawhtml}", html_file);
}@}


@d Write HTML index of user-specified names
@{{
  if (user_names) {
    fputs("\\begin{rawhtml}\n", html_file);
    fputs("<dl compact>\n", html_file);
    format_user_entry(user_names, html_file, 0/* Dummy */);
    fputs("</dl>\n", html_file);
    fputs("\\end{rawhtml}\n", html_file);
  }
  c = source_get();
}@}


@o html.c
@{static void format_user_entry(name, html_file, sector)
     Name *name;
     FILE *html_file;
{
  while (name) {
    format_user_entry(name->llink, html_file, sector);
    @<Format a user HTML index entry@>
    name = name->rlink;
  }
}
@| format_user_entry @}


@d Format a user HTML index entry
@{{
  Scrap_Node *uses = name->uses;
  if (uses) {
    Scrap_Node *defs = name->defs;
    fprintf(html_file, "<dt><code>%s</code>:\n<dd> ", name->spelling);
    if (uses->scrap < defs->scrap) {
      display_scrap_ref(html_file, uses->scrap);
      uses = uses->next;
    }
    else {
      if (defs->scrap == uses->scrap)
        uses = uses->next;
      fputs("<strong>", html_file);
      display_scrap_ref(html_file, defs->scrap);
      fputs("</strong>", html_file);
      defs = defs->next;
    }
    while (uses || defs) {
      fputs(", ", html_file);
      if (uses && (!defs || uses->scrap < defs->scrap)) {
        display_scrap_ref(html_file, uses->scrap);
        uses = uses->next;
      }
      else {
        if (uses && defs->scrap == uses->scrap)
          uses = uses->next;
        fputs("<strong>", html_file);
        display_scrap_ref(html_file, defs->scrap);
        fputs("</strong>", html_file);
        defs = defs->next;
      }
    }
    fputs(".\n", html_file);
  }
}@}

\section{Writing the Output Files} \label{output-files}

@d Function pro...
@{extern void write_files();
@}

@o output.c -cc
@{void write_files(files)
     Name *files;
{
  while (files) {
    write_files(files->llink);
    @<Write out \verb|files->spelling|@>
    files = files->rlink;
  }
}
@| write_files @}

\verb|MAX_INDENT| defines the maximum number of leading whitespace
 characters. This is only a problem when outputting very long lines,
 possibly by multiple definitions of the same fragment (as in a list
 of elements which is added to every time a new element is defined).

@d Type dec...
@{
#define MAX_INDENT 500
@| MAX_INDENT @}

@d Write out \verb|files->spelling|
@{{
  static char temp_name[FILENAME_MAX];
  static char real_name[FILENAME_MAX];
  static int temp_name_count = 0;
  char indent_chars[MAX_INDENT];
  int temp_file_fd;
  FILE *temp_file;

  @< Find a free temporary file @>

  sprintf(real_name, "%s%s%s", dirpath, path_sep, files->spelling);
  if (verbose_flag)
    fprintf(stderr, "writing %s [%s]\n", files->spelling, temp_name);
  write_scraps(temp_file, files->spelling, files->defs, 0, indent_chars,
               files->debug_flag, files->tab_flag, files->indent_flag,
               files->comment_flag, NULL, NULL, 0, files->spelling);
  fclose(temp_file);

  @< Move the temporary file to the target, if required @>
}@}

@d Find a free temporary file @{@%
for( temp_name_count = 0; temp_name_count < 10000; temp_name_count++) {
  sprintf(temp_name,"%s%snw%06d", dirpath, path_sep, temp_name_count);
#ifdef O_EXCL
  if (-1 != (temp_file_fd = open(temp_name, O_CREAT|O_WRONLY|O_EXCL))) {
     temp_file = fdopen(temp_file_fd, "w");
     break;
  }
#else
  if (0 != (temp_file = fopen(temp_name, "a"))) {
     if ( 0L == ftell(temp_file)) {
        break;
     } else {
        fclose(temp_file);
        temp_file = 0;
     }
  }
#endif
}
if (!temp_file) {
  fprintf(stderr, "%s: can't create %s for a temporary file\n",
          command_name, temp_name);
  exit(-1);
}
@}

Note the call to \verb|remove| before \verb|rename| -- the ANSI/ISO C
standard does {\em not} guarantee that renaming a file to an existing
filename will overwrite the file.

@d Move the temporary file to the target, if required @{@%
if (compare_flag)
  @<Compare the temp file and the old file@>
else {
  remove(real_name);
  @< Rename the temporary file to the target @>
}
@}

Again, we use a call to \verb|remove| before \verb|rename|.
@d Compare the temp file...
@{{
  FILE *old_file = fopen(real_name, "r");
  if (old_file) {
    int x, y;
    temp_file = fopen(temp_name, "r");
    do {
      x = getc(old_file);
      y = getc(temp_file);
    } while (x == y && x != EOF);
    fclose(old_file);
    fclose(temp_file);
    if (x == y)
      remove(temp_name);
    else {
      remove(real_name);
      @< Rename the temporary file to the target @>
    }
  }
  else
    @< Rename the temporary file to the target @>
}@}

@d Rename the temporary file to the target @{@%
if (0 != rename(temp_name, real_name)) {
  fprintf(stderr, "%s: can't rename output file to %s\n",
          command_name, real_name);
}
@|@}



\chapter{The Support Routines}

\section{Source Files} \label{source-files}

\subsection{Global Declarations}

We need two routines to handle reading the source files.
@d Function pro...
@{extern void source_open(); /* pass in the name of the source file */
extern int source_get();   /* no args; returns the next char or EOF */
extern int source_last;   /* what last source_get() returned. */
extern int source_peek;   /* The next character to get */
@}


There are also two global variables maintained for use in error
messages and such.
@d Global variable dec...
@{extern char *source_name;  /* name of the current file */
extern int source_line;    /* current line in the source file */
@| source_name source_line @}

@d Global variable def...
@{char *source_name = NULL;
int source_line = 0;
@}

\subsection{Local Declarations}


@o input.c -cc
@{static FILE *source_file;  /* the current input file */
static int double_at;
static int include_depth;
@| source_file double_at include_depth @}


@o input.c -cc
@{static struct {
  FILE *file;
  char *name;
  int line;
} stack[10];
@| stack @}


\subsection{Reading a File}

The routine \verb|source_get| returns the next character from the
current source file. It notices newlines and keeps the line counter
\verb|source_line| up to date. It also catches \verb|EOF| and watches
for \verb|@@|~characters. All other characters are immediately returned.
We define \verb|source_last| to let us tell which type of scrap we
are defining.
@o input.c -cc
@{
int source_peek;
int source_last;
int source_get()
{
  int c;
  source_last = c = source_peek;
  switch (c) {
    case EOF:  @<Handle \verb|EOF|@>
               return c;
    case '\n': source_line++;
    default:
           if (c==nw_char)
             {
               @<Handle an ``at'' character@>
               return c;
             }
           source_peek = getc(source_file);
               return c;
  }
}
@| source_peek source_get source_last @}

\verb|source_ungetc| pushes a read character back to the \verb|source_file|.
@o input.c -cc
@{void source_ungetc(int *c)
{
  ungetc(source_peek, source_file);
  if(*c == '\n')
    source_line--;
  source_peek=*c;
}
@|source_ungetc @}

This whole \verb|@@|~character handling mess is pretty annoying.
I want to recognize \verb|@@i| so I can handle include files correctly.
At the same time, it makes sense to recognize illegal \verb|@@|~sequences
and complain; this avoids ever having to check anywhere else.
Unfortunately, I need to avoid tripping over the \verb|@@@@|~sequence;
hence this whole unsatisfactory \verb|double_at| business.
@d Handle an ``at''...
@{{
  c = getc(source_file);
  if (double_at) {
    source_peek = c;
    double_at = FALSE;
    c = nw_char;
  }
  else
    switch (c) {
      case 'i': @<Open an include file@>
                break;
      case '#': case 'f': case 'm': case 'u': case 'v':
      case 'd': case 'o': case 'D': case 'O': case 's':
      case 'q': case 'Q': case 'S': case 't':
      case '+':
      case '-':
      case '*':
      case '\'':
      case '{': case '}': case '<': case '>': case '|':
      case '(': case ')': case '[': case ']':
      case '%': case '_':
      case ':': case ',': case 'x': case 'c':
      case '1': case '2': case '3': case '4': case '5':
      case '6': case '7': case '8': case '9':
      case 'r':
                source_peek = c;
                c = nw_char;
                break;
      default:
            if (c==nw_char)
              {
                source_peek = c;
                double_at = TRUE;
                break;
              }
             fprintf(stderr, "%s: bad %c sequence %c[%d] (%s, line %d)\n",
                     command_name, nw_char, c, c, source_name, source_line);
             exit(-1);
    }
}@}

@d Open an include file
@{{
  char name[FILENAME_MAX];
  char fullname[FILENAME_MAX];
  struct incl * p = include_list;

  if (include_depth >= 10) {
    fprintf(stderr, "%s: include nesting too deep (%s, %d)\n",
            command_name, source_name, source_line);
    exit(-1);
  }
  @<Collect include-file name@>
  stack[include_depth].file = source_file;
  fullname[0] = '\0';
  for (;;) {
     strcat(fullname, name);
     source_file = fopen(fullname, "r");
     if (source_file || !p)
        break;
     strcpy(fullname, p->name);
     strcat(fullname, "/");
     p = p->next;
  }
  if (!source_file) {
    fprintf(stderr, "%s: can't open include file %s\n",
            command_name, name);
    source_file = stack[include_depth].file;
  }
  else
  {
     stack[include_depth].name = source_name;
     stack[include_depth].line = source_line + 1;
     include_depth++;
     source_line = 1;
     source_name = save_string(fullname);
  }
  source_peek = getc(source_file);
  c = source_get();
}@}

@d Collect include-file name
@{{
    char *p = name;
    do
      c = getc(source_file);
    while (c == ' ' || c == '\t');
    while (isgraph(c)) {
      *p++ = c;
      c = getc(source_file);
    }
    *p = '\0';
    if (c != '\n') {
      fprintf(stderr, "%s: unexpected characters after file name (%s, %d)\n",
              command_name, source_name, source_line);
      exit(-1);
    }
}@}

If an \verb|EOF| is discovered, the current file must be closed and
input from the next stacked file must be resumed. If no more files are
on the stack, the \verb|EOF| is returned.
@d Handle \verb|EOF|
@{{
  fclose(source_file);
  if (include_depth) {
    include_depth--;
    source_file = stack[include_depth].file;
    source_line = stack[include_depth].line;
    source_name = stack[include_depth].name;
    source_peek = getc(source_file);
    c = source_get();
  }
}@}


\subsection{Opening a File}

The routine \verb|source_open| takes a file name and tries to open the
file. If unsuccessful, it complains and halts. Otherwise, it sets
\verb|source_name|, \verb|source_line|, and \verb|double_at|.
@o input.c -cc
@{void source_open(name)
     char *name;
{
  source_file = fopen(name, "r");
  if (!source_file) {
    fprintf(stderr, "%s: couldn't open %s\n", command_name, name);
    exit(-1);
  }
  nw_char = '@@';
  source_name = name;
  source_line = 1;
  source_peek = getc(source_file);
  double_at = FALSE;
  include_depth = 0;
}
@| source_open @}




\section{Scraps} \label{scraps}


@o scraps.c -cc
@{#define SLAB_SIZE 1024

typedef struct slab {
  struct slab *next;
  char chars[SLAB_SIZE];
} Slab;
@| Slab SLAB_SIZE @}

@o scraps.c -cc
@{typedef struct {
  char *file_name;
  Slab *slab;
  struct uses *uses;
  struct uses *defs;
  int file_line;
  int page;
  char letter;
  unsigned char sector;
} ScrapEntry;
@| ScrapEntry @}

@o scraps.c -cc
@{static ScrapEntry *SCRAP[256];

#define scrap_array(i) SCRAP[(i) >> 8][(i) & 255]

static int scraps;
int num_scraps()
{
   return scraps;
};
@<Forward declarations for scraps.c@>
@| num_scraps scraps scrap_array SCRAP @}


@d Function pro...
@{extern void init_scraps();
extern int collect_scrap();
extern int write_scraps();
extern void write_scrap_ref();
extern void write_single_scrap_ref();
extern int num_scraps();
@}


@o scraps.c -cc
@{void init_scraps()
{
  scraps = 1;
  SCRAP[0] = (ScrapEntry *) arena_getmem(256 * sizeof(ScrapEntry));
}
@| init_scraps @}

@o scraps.c -cc
@{void write_scrap_ref(file, num, first, page)
     FILE *file;
     int num;
     int first;
     int *page;
{
  if (scrap_array(num).page >= 0) {
    if (first!=0)
      fprintf(file, "%d", scrap_array(num).page);
    else if (scrap_array(num).page != *page)
      fprintf(file, ", %d", scrap_array(num).page);
    if (scrap_array(num).letter > 0)
      fputc(scrap_array(num).letter, file);
  }
  else {
    if (first!=0)
      putc('?', file);
    else
      fputs(", ?", file);
    @<Warn (only once) about needing to rerun after Latex@>
  }
  if (first>=0)
  *page = scrap_array(num).page;
}
@| write_scrap_ref @}

@o scraps.c -cc
@{void write_single_scrap_ref(file, num)
     FILE *file;
     int num;
{
  int page;
  write_scrap_ref(file, num, TRUE, &page);
}
@| write_single_scrap_ref @}


@d Warn (only once) about needing to...
@{{
  if (!already_warned) {
    fprintf(stderr, "%s: you'll need to rerun nuweb after running latex\n",
            command_name);
    already_warned = TRUE;
  }
}@}

@d Global variable dec...
@{extern int already_warned;
@| already_warned @}

@d Global variable def...
@{int already_warned = 0;
@}

@o scraps.c -cc
@{typedef struct {
  Slab *scrap;
  Slab *prev;
  int index;
} Manager;
@| Manager @}



@o scraps.c -cc
@{static void push(c, manager)
     char c;
     Manager *manager;
{
  Slab *scrap = manager->scrap;
  int index = manager->index;
  scrap->chars[index++] = c;
  if (index == SLAB_SIZE) {
    Slab *new = (Slab *) arena_getmem(sizeof(Slab));
    scrap->next = new;
    manager->scrap = new;
    index = 0;
  }
  manager->index = index;
}
@| push @}

@o scraps.c -cc
@{static void pushs(s, manager)
     char *s;
     Manager *manager;
{
  while (*s)
    push(*s++, manager);
}
@| pushs @}

@o scraps.c -cc
@{int collect_scrap()
{
  int current_scrap, lblseq = 0;
  int depth = 1;
  Manager writer;
  @<Create new scrap...@>
  @<Accumulate scrap and return \verb|scraps++|@>
}
@| collect_scrap @}

@d Create new scrap, managed by \verb|writer|
@{{
  Slab *scrap = (Slab *) arena_getmem(sizeof(Slab));
  if ((scraps & 255) == 0)
    SCRAP[scraps >> 8] = (ScrapEntry *) arena_getmem(256 * sizeof(ScrapEntry));
  scrap_array(scraps).slab = scrap;
  scrap_array(scraps).file_name = save_string(source_name);
  scrap_array(scraps).file_line = source_line;
  scrap_array(scraps).page = -1;
  scrap_array(scraps).letter = 0;
  scrap_array(scraps).uses = NULL;
  scrap_array(scraps).defs = NULL;
  scrap_array(scraps).sector = current_sector;
  writer.scrap = scrap;
  writer.index = 0;
  current_scrap = scraps++;
}@}


@d Accumulate scrap...
@{{
  int c = source_get();
  while (1) {
    switch (c) {
      case EOF: fprintf(stderr, "%s: unexpect EOF in (%s, %d)\n",
                        command_name, scrap_array(current_scrap).file_name,
                        scrap_array(current_scrap).file_line);
                exit(-1);
      default:
        if (c==nw_char)
          {
            @<Handle at-sign during scrap accumulation@>
                break;
          }
        push(c, &writer);
                c = source_get();
                break;
    }
  }
}@}

@d Handle at-sign during scrap accumulation
@{{
  c = source_get();
  switch (c) {
    case '(':
    case '[':
    case '{': depth++;
              break;
    case '+':
    case '-':
    case '*':
    case '|': @<Collect user-specified index entries@>
              /* Fall through */
    case ')':
    case ']':
    case '}': if (--depth > 0)
                break;
	      /* else fall through */
    case ',':
              push('\0', &writer);
              scrap_ended_with = c;
              return current_scrap;
    case '<': @<Handle macro invocation in scrap@>
              break;
    case '%': @<Skip commented-out code@>
              /* emit line break to the output file to keep #line in sync. */
              push('\n', &writer);
              c = source_get();
              break;
    case 'x': @<Get label while collecting scrap@>
              break;
    case 'c': @<Include block comment in a scrap@>
              break;
    case '1': case '2': case '3':
    case '4': case '5': case '6':
    case '7': case '8': case '9':
    case 'f': case '#': case 'v':
    case 't': case 's':
              push(nw_char, &writer);
              break;
    case '_': c = source_get();
              break;
    default :
          if (c==nw_char)
            {
              push(nw_char, &writer);
              push(nw_char, &writer);
              c = source_get();
              break;
            }
          fprintf(stderr, "%s: unexpected %c%c in scrap (%s, %d)\n",
                      command_name, nw_char, c, source_name, source_line);
              exit(-1);
  }
}@}

@d Get label while collecting scrap
@{{
   @<Get label from@(source_get()@)@>
   @<Save label to label store@>
   push(nw_char, &writer);
   push('x', &writer);
   pushs(label_name, &writer);
   push(nw_char, &writer);
}@}


@d Collect user-specified index entries
@{{
  do {
    int type = c;
    do {
      char new_name[MAX_NAME_LEN];
      char *p = new_name;
      unsigned int sector = 0;
      do
        c = source_get();
      while (isspace(c));
      if (c != nw_char) {
        Name *name;
        do {
          *p++ = c;
          c = source_get();
        } while (c != nw_char && !isspace(c));
        *p = '\0';
        switch (type) {
        case '*':
           sector = current_sector;
           @<Add user identifier use@>
           break;
        case '-':
           @<Add user identifier use@>
           /* Fall through */
        case '|':
           sector = current_sector;
           /* Fall through */
        case '+':
           @<Add user identifier definition@>
           break;
        }
      }
    } while (c != nw_char);
    c = source_get();
  }while (c == '|' || c == '*' || c == '-' || c == '+');
  if (c != '}' && c != ']' && c != ')') {
    fprintf(stderr, "%s: unexpected %c%c in index entry (%s, %d)\n",
            command_name, nw_char, c, source_name, source_line);
    exit(-1);
  }
}@}

@d Add user identifier use
@{name = name_add(&user_names, new_name, sector);
if (!name->uses || name->uses->scrap != current_scrap) {
  Scrap_Node *use = (Scrap_Node *) arena_getmem(sizeof(Scrap_Node));
  use->scrap = current_scrap;
  use->next = name->uses;
  name->uses = use;
  add_uses(&(scrap_array(current_scrap).uses), name);
}@}

@d Add user identifier definition
@{name = name_add(&user_names, new_name, sector);
if (!name->defs || name->defs->scrap != current_scrap) {
  Scrap_Node *def = (Scrap_Node *) arena_getmem(sizeof(Scrap_Node));
  def->scrap = current_scrap;
  def->next = name->defs;
  name->defs = def;
  add_uses(&(scrap_array(current_scrap).defs), name);
}@}

@d Handle macro invocation in scrap
@{{
  Arglist * args = collect_scrap_name(current_scrap);
  Name *name = args->name;
  @<Save macro name@>
  add_to_use(name, current_scrap);
  if (scrap_name_has_parameters) {
    @<Save macro parameters @>
  }
  push(nw_char, &writer);
  push('>', &writer);
  c = source_get();
}@}


@d Save macro name
@{{
  char buff[24];

  push(nw_char, &writer);
  push('<', &writer);
  push(name->sector, &writer);
  sprintf(buff, "%p", args);
  pushs(buff, &writer);
}@}

@o scraps.c -cc
@{void
add_to_use(Name * name, int current_scrap)
{
  if (!name->uses || name->uses->scrap != current_scrap) {
    Scrap_Node *use = (Scrap_Node *) arena_getmem(sizeof(Scrap_Node));
    use->scrap = current_scrap;
    use->next = name->uses;
    name->uses = use;
  }
}
@| add_to_use @}

@d Function...
@{extern void add_to_use(Name * name, int current_scrap);
@}
@o scraps.c -cc
@{static char pop(manager)
     Manager *manager;
{
  Slab *scrap = manager->scrap;
  int index = manager->index;
  char c = scrap->chars[index++];
  if (index == SLAB_SIZE) {
    manager->prev = scrap;
    manager->scrap = scrap->next;
    index = 0;
  }
  manager->index = index;
  return c;
}
@| pop @}

@o scraps.c -cc
@{static void backup(n, manager)
     int n;
     Manager *manager;
{
  Slab *scrap = manager->scrap;
  int index = manager->index;
  if (n > index
      && manager->prev != NULL)
  {
     manager->scrap = manager->prev;
     manager->prev = NULL;
     index += SLAB_SIZE;
  }
  manager->index = (n <= index ? index - n : 0);
}
@| backup @}

@o scraps.c -cc
@{void
lookup(int n, Arglist * par, char * arg[9], Name **name, Arglist ** args)
{
  int i;
  Arglist * p = par;

  for (i = 0; i < n && p != NULL; i++)
    p = p->next;
  if (p == NULL) {
    char * a = arg[n];

    *name = NULL;
    *args = (Arglist *)a;
  }
  else {
    *name = p->name;
    *args = p->args;
  }
}
@| lookup @}

@o scraps.c -cc
@{Arglist * instance(Arglist * a, Arglist * par, char * arg[9], int * ch)
{
   if (a != NULL) {
      int changed = 0;
      Arglist *args, *next;
      Name* name;
      @<Set up name, args and next@>
      if (changed){
        @<Build a new arglist@>
        *ch = 1;
      }
   }

   return a;
}
@| instance @}

@d Function prototypes
@{Arglist * instance();
@}

@d Set up name, args and next
@{next = instance(a->next, par, arg, &changed);
name = a->name;
if (name == (Name *)1) {
   Embed_Node * q = (Embed_Node *)arena_getmem(sizeof(Embed_Node));
   q->defs = (Scrap_Node *)a->args;
   q->args = par;
   args = (Arglist *)q;
   changed = 1;
} else if (name != NULL)
  args = instance(a->args, par, arg, &changed);
else {
  char * p = (char *)a->args;
   if (p[0] == ARG_CHR) {
      lookup(p[1] - '1', par, arg, &name, &args);
      changed = 1;
   }
   else {
      args = a->args;
   }
}@}

@d Build a new arglist
@{a = (Arglist *)arena_getmem(sizeof(Arglist));
a->name = name;
a->args = args;
a->next = next;@}

@o scraps.c -cc
@{static Arglist *pop_scrap_name(manager, parameters)
     Manager *manager;
     Parameters *parameters;
{
  char name[MAX_NAME_LEN];
  char *p = name;
  int sector = pop(manager);
  int c = pop(manager);
  Arglist * args;

  while (c != nw_char) {
    *p++ = c;
    c = pop(manager);
  }
  *p = '\000';
  if (sscanf(name, "%p", &args) != 1)
  {
    fprintf(stderr,  "%s: found an internal problem (2)\n", command_name);
    exit(-1);
  }
  @<Check for end of scrap name@>
  return args;
}
@| pop_scrap_name @}


@d Check for end of scrap name
@{{
  Name *pn;
  c = pop(manager);
  @<Check for macro parameters@>
}@}

@o scraps.c -cc
@{int write_scraps(file, spelling, defs, global_indent, indent_chars,
                   debug_flag, tab_flag, indent_flag,
                   comment_flag, inArgs, inParams, parameters, title)
     FILE *file;
     char * spelling;
     Scrap_Node *defs;
     int global_indent;
     char *indent_chars;
     char debug_flag;
     char tab_flag;
     char indent_flag;
     unsigned char comment_flag;
     Arglist * inArgs;
     char * inParams[9];
     Parameters parameters;
     char * title;
{
  /* This is in file @f */
  int indent = 0;
  int newline = 1;
  int iter = 0;
  while (defs) {
    @<Copy \verb|defs->scrap| to \verb|file|@>
    defs = defs->next;
  }
  return indent + global_indent;
}
@| write_scraps @}

@d Forward declarations for scraps.c
@{int delayed_indent = 0;
@| delayed_indent @}

@d Copy \verb|defs->scrap...
@{{
  char c;
  Manager reader;
  Parameters local_parameters = 0;
  int line_number = scrap_array(defs->scrap).file_line;
  reader.scrap = scrap_array(defs->scrap).slab;
  reader.index = 0;
  @<Insert debugging information if required@>
  if (delayed_indent)
  {
    @<Insert appropriate indentation@>
  }
  c = pop(&reader);
  while (c) {
    switch (c) {
      case '\n':
         if (global_indent >= 0) {
           putc(c, file);
           line_number++;
           newline = 1;
           delayed_indent = 0;
           @<Insert appropriate indentation@>
           break;
         } else {
           /* Don't show newlines in embedded fragmants */
           fputs(". . .", file);
           return;
         }
      case '\t': @<Handle tab...@>
                 delayed_indent = 0;
                 break;
      default:
         if (c==nw_char)
           {
             @<Check for macro invocation in scrap@>
             break;
           }
         putc(c, file);
         if (global_indent >= 0) {
           @<Add more indentation @'' '@'@>
         }
         indent++;
         if (c > ' ') newline = 0;
         delayed_indent = 0;
         break;
    }
    c = pop(&reader);
  }
}@}

We need to make sure that we don't overflow \verb|indent_chars[]|.
@d Add more indentation @'char@'
@{{
  if (global_indent + indent >= MAX_INDENT) {
    fprintf(stderr,
           "Error! maximum indentation exceeded in \"%s\".\n",
            spelling);
    exit(1);
  }
  indent_chars[global_indent + indent] = @1;
}@}


@d Insert debugging information if required
@{if (debug_flag) {
  fprintf(file, "\n#line %d \"%s\"\n",
          line_number, scrap_array(defs->scrap).file_name);
  @<Insert appropr...@>
}@}


@d Insert approp...
@{{
  char c1 = pop(&reader);
  char c2 = pop(&reader);

  if (indent_flag && !(@<Indent suppressed@>)) {
    @<Put out the indent@>
  }
  indent = 0;
  backup(2, &reader);
}@}

@d Put out the indent
@{if (tab_flag)
    for (indent=0; indent<global_indent; indent++)
      putc(' ', file);
  else
    for (indent=0; indent<global_indent; indent++)
      putc(indent_chars[indent], file);
@}

Indent will be suppressed if the next character is a newline or
if the next two characters are \verb|@@#|. If the next two characters
are \verb|@@<|, we suppress the indent for now but mark that it
may be needed when the next fragment is started.

@d Indent suppressed
@{c1 == '\n'
|| c1 == nw_char && (c2 == '#' || (delayed_indent |= (c2 == '<')))@}

@d Handle tab characters on output
@{{
  if (tab_flag)
    @<Expand tab...@>
  else {
    putc('\t', file);
    if (global_indent >= 0) {
      @<Add more indentation @''\t'@'@>
    }
    indent++;
  }
}@}


@d Check for macro invocation...
@{{
  int oldin = indent;
  char oldcf = comment_flag;
  c = pop(&reader);
  switch (c) {
    case 't': @<Copy fragment title into file@>
              break;
    case 'c': @<Copy block comment from scrap@>
              break;
    case 'f': @<Copy file name into file@>
              break;
    case 'x': @<Copy label from scrap into file@>
    case '_': break;
    case 'v': @<Copy version info into file@>
              break;
    case 's': indent = -global_indent;
              comment_flag = 0;
              break;
    case '<': @<Copy macro into \verb|file|@>
              @<Insert debugging information if required@>
              indent = oldin;
              comment_flag = oldcf;
              break;
    @<Handle macro parameter substitution@>
              indent = oldin;
              break;
    default:
          if(c==nw_char)
            {
              putc(c, file);
              if (global_indent >= 0) {
                 @<Add more indentation @'' '@'@>
              }
              indent++;
              break;
            }
          /* ignore, since we should already have a warning */
              break;
  }
}@}

@d Copy label from scrap into file
@{{
   @<Get label from@(pop(&reader)@)@>
   write_label(label_name, file);
}@}

@d Copy file name into file
@{if (defs->quoted)
   fprintf(file, "%cf", nw_char);
else
   fputs(spelling, file);
@}

@d Copy macro into...
@{{
  Arglist *a = pop_scrap_name(&reader, &local_parameters);
  Name *name = a->name;
  int changed;
  Arglist * args = instance(a->args, inArgs, inParams, &changed);
  int i, narg;
  char * p = name->spelling;
  char * * inParams = name->arg;
  Arglist *q = args;

  if (name->mark) {
    fprintf(stderr, "%s: recursive macro discovered involving <%s>\n",
            command_name, name->spelling);
    exit(-1);
  }
  if (name->defs && !defs->quoted) {
    @<Perhaps comment this macro@>
    name->mark = TRUE;
    indent = write_scraps(file, spelling, name->defs, global_indent + indent,
                          indent_chars, debug_flag, tab_flag, indent_flag,
                          comment_flag, args, name->arg,
                          local_parameters, name->spelling);
    indent -= global_indent;
    name->mark = FALSE;
  }
  else
  {
    if (delayed_indent)
    {
      for (i = indent + global_indent; --i >= 0; )
         putc(' ', file);
    }

    fprintf(file, "%c<",  nw_char);
    if (name->sector == 0)
       fputc('+', file);
    @<Comment this macro use@>
    fprintf(file, "%c>",  nw_char);
    if (!defs->quoted && !tex_flag)
      fprintf(stderr, "%s: macro never defined <%s>\n",
            command_name, name->spelling);
  }
}@}

@d Perhaps comment this macro
@{if (comment_flag && newline) {
   @<Perhaps put a delayed indent@>
   fputs(comment_begin[comment_flag], file);
   @<Comment this macro use@>
   if (xref_flag) {
      putc(' ', file);
      write_single_scrap_ref(file, name->defs->scrap);
   }
   if (comment_end)
      fputs(comment_end[comment_flag], file);
   putc('\n', file);
   if (!delayed_indent)
      for (i = indent + global_indent; --i >= 0; )
         putc(' ', file);
}
@}

@d Perhaps put a delayed indent
@{if (delayed_indent)
   for (i = indent + global_indent; --i >= 0; )
      putc(' ', file);
@}

@d Copy fragment title into file
@{{
   char * p = title;
   Arglist *q = inArgs;
   int narg;

   @<Comment this macro use@>
   if (xref_flag) {
      putc(' ', file);
      write_single_scrap_ref(file, defs->scrap);
   }
}@}

@d Comment this macro use
@{narg = 0;
while (*p != '\000') {
  if (*p == ARG_CHR) {
    if (q == NULL) {
       if (defs->quoted)
          fprintf(file, "%c'%s%c'", nw_char, inParams[narg], nw_char);
       else
          fprintf(file, "'%s'", inParams[narg]);
    }
    else {
      comment_ArglistElement(file, q, defs->quoted);
      q = q->next;
    }
    p++;
    narg++;
  }
  else
     fputc(*p++, file);
}@}

@d Forward declarations for scraps.c
@{static void
comment_ArglistElement(FILE * file, Arglist * args, int quote)
{
  Name *name = args->name;
  Arglist *q = args->args;

  if (name == NULL) {
    if (quote)
       fprintf(file, "%c'%s%c'", nw_char, (char *)q, nw_char);
    else
       fprintf(file, "'%s'", (char *)q);
  } else if (name == (Name *)1) {
     @<Include an embedded scrap in comment@>
  } else {
     @<Include a fragment use in comment@>
  }
}
@| comment_ArglistElement @}

@d Include an embedded scrap in comment
@{Embed_Node * e = (Embed_Node *)q;
fputc('{', file);
write_scraps(file, "", e->defs, -1, "", 0, 0, 0, 0, e->args, 0, 1, "");
fputc('}', file);@}

@d Include a fragment use in comment
@{char * p = name->spelling;
if (quote)
   fputc(nw_char, file);
fputc('<', file);
if (quote && name->sector == 0)
   fputc('+', file);
while (*p != '\000') {
  if (*p == ARG_CHR) {
    comment_ArglistElement(file, q, quote);
    q = q->next;
    p++;
  }
  else
     fputc(*p++, file);
}
if (quote)
   fputc(nw_char, file);
fputc('>', file);@}

\subsection{Collecting Page Numbers}

@d Function...
@{extern void collect_numbers();
@}

@o scraps.c -cc
@{void collect_numbers(aux_name)
     char *aux_name;
{
  if (number_flag) {
    int i;
    for (i=1; i<scraps; i++)
      scrap_array(i).page = i;
  }
  else {
    FILE *aux_file = fopen(aux_name, "r");
    already_warned = FALSE;
    if (aux_file) {
      char aux_line[500];
      while (fgets(aux_line, 500, aux_file)) {
        @< Read line in \verb|.aux| file @>
      }
      fclose(aux_file);
      @<Add letters to scraps with duplicate page numbers@>
    }
  }
}
@| collect_numbers @}

The \textit{memoir} document class creates references in the
\verb|.aux| file with nested braces, so after each open brace we have
to wait for the matching closing brace.

@d Read line in \verb|.aux| file @{@%
int scrap_number;
int page_number;
int i;
int dummy_idx;
int bracket_depth = 1;
if (1 == sscanf(aux_line,
                "\\newlabel{scrap%d}{{%n",
                &scrap_number,
                &dummy_idx)) {
  for (i = dummy_idx; i < strlen(aux_line) && bracket_depth > 0; i++) {
    if (aux_line[i] == '{') bracket_depth++;
    else if (aux_line[i] == '}') bracket_depth--;
  }
  if (i > dummy_idx
      && i < strlen(aux_line)
      && 1 == sscanf(aux_line+i, "{%d}" ,&page_number)) {
    if (scrap_number < scraps)
      scrap_array(scrap_number).page = page_number;
    else
      @<Warn...@>
  }
}
@|@}


@d Add letters to scraps with...
@{{
   int i = 0;

   @<Step @'i@' to the next valid scrap@>
   @<For all remaining scraps@> {
      int j = i;
      @<Step @'j@' to the next valid scrap@>
      @<Perhaps add letters to the page numbers@>
      i = j;
   }
}
@}

@d Step @'i@' to the next valid scrap
@{do
   @1++;
while (@1 < scraps && scrap_array(@1).page == -1);
@}

@d For all remaining scraps
@{while (i < scraps)@}

@d Perhaps add letters to the page numbers
@{if (scrap_array(i).page == scrap_array(j).page) {
   if (scrap_array(i).letter == 0)
      scrap_array(i).letter = 'a';
   scrap_array(j).letter = scrap_array(i).letter + 1;
}
@}

\section{Names} \label{names}

@d Type de...
@{typedef struct scrap_node {
  struct scrap_node *next;
  int scrap;
  char quoted;
} Scrap_Node;
@| Scrap_Node @}


@d Type de...
@{typedef struct name {
  char *spelling;
  struct name *llink;
  struct name *rlink;
  Scrap_Node *defs;
  Scrap_Node *uses;
  char * arg[9];
  int mark;
  char tab_flag;
  char indent_flag;
  char debug_flag;
  unsigned char comment_flag;
  unsigned char sector;
} Name;
@| Name @}

@d Global variable dec...
@{extern Name *file_names;
extern Name *macro_names;
extern Name *user_names;
extern int scrap_name_has_parameters;
extern int scrap_ended_with;
@| file_names macro_names user_names @}

@d Global variable def...
@{Name *file_names = NULL;
Name *macro_names = NULL;
Name *user_names = NULL;
int scrap_name_has_parameters;
int scrap_ended_with;
@}

@d Function pro...
@{extern Name *collect_file_name();
extern Name *collect_macro_name();
extern Arglist *collect_scrap_name();
extern Name *name_add();
extern Name *prefix_add();
extern char *save_string();
extern void reverse_lists();
@}

@o names.c -cc
@{enum { LESS, GREATER, EQUAL, PREFIX, EXTENSION };

static int compare(x, y)
     char *x;
     char *y;
{
  int len, result;
  int xl = strlen(x);
  int yl = strlen(y);
  int xp = x[xl - 1] == ' ';
  int yp = y[yl - 1] == ' ';
  if (xp) xl--;
  if (yp) yl--;
  len = xl < yl ? xl : yl;
  result = strncmp(x, y, len);
  if (result < 0) return GREATER;
  else if (result > 0) return LESS;
  else if (xl < yl) {
    if (xp) return EXTENSION;
    else return LESS;
  }
  else if (xl > yl) {
    if (yp) return PREFIX;
    else return GREATER;
  }
  else return EQUAL;
}
@| compare LESS GREATER EQUAL PREFIX EXTENSION @}


@o names.c -cc
@{char *save_string(s)
     char *s;
{
  char *new = (char *) arena_getmem((strlen(s) + 1) * sizeof(char));
  strcpy(new, s);
  return new;
}
@| save_string @}

@o names.c -cc
@{static int ambiguous_prefix();

static char * found_name = NULL;

Name *prefix_add(rt, spelling, sector)
     Name **rt;
     char *spelling;
     unsigned char sector;
{
  Name *node = *rt;
  int cmp;

  while (node) {
    switch ((cmp = compare(node->spelling, spelling))) {
    case GREATER:   rt = &node->rlink;
                    break;
    case LESS:      rt = &node->llink;
                    break;
    case EQUAL:
                    found_name = node->spelling;
    case EXTENSION: if (node->sector > sector) {
                       rt = &node->rlink;
                       break;
                    }
                    else if (node->sector < sector) {
                       rt = &node->llink;
                       break;
                    }
                    if (cmp == EXTENSION)
                       node->spelling = save_string(spelling);
                    return node;
    case PREFIX:    @<Check for ambiguous prefix@>
                    return node;
    }
    node = *rt;
  }
  @<Create new name entry@>
}
@| prefix_add @}

Since a very short prefix might match more than one fragment name, I need
to check for other matches to avoid mistakes. Basically, I simply
continue the search down {\em both\/} branches of the tree.

@d Check for ambiguous prefix
@{{
  if (ambiguous_prefix(node->llink, spelling, sector) ||
      ambiguous_prefix(node->rlink, spelling, sector))
    fprintf(stderr,
            "%s: ambiguous prefix %c<%s...%c> (%s, line %d)\n",
            command_name, nw_char, spelling, nw_char, source_name, source_line);
}@}

@o names.c -cc
@{static int ambiguous_prefix(node, spelling, sector)
     Name *node;
     char *spelling;
     unsigned char sector;
{
  while (node) {
    switch (compare(node->spelling, spelling)) {
    case GREATER:   node = node->rlink;
                    break;
    case LESS:      node = node->llink;
                    break;
    case EXTENSION:
    case PREFIX:
    case EQUAL:     if (node->sector > sector) {
                       node = node->rlink;
                       break;
                    }
                    else if (node->sector < sector) {
                       node = node->llink;
                       break;
                    }
                    return TRUE;
    }
  }
  return FALSE;
}
@}

Rob Shillingsburg suggested that I organize the index of
user-specified identifiers more traditionally; that is, not relying on
strict {\small ASCII} comparisons via \verb|strcmp|. Ideally, we'd like
to see the index ordered like this:
\begin{quote}
\begin{flushleft}
aardvark \\
Adam \\
atom \\
Atomic \\
atoms
\end{flushleft}
\end{quote}
The function \verb|robs_strcmp| implements the desired predicate.
It returns -2 for alphabetically less-than, -1 for less-than but only
differing in case, zero for equal, 1 for greater-than but only in case
and 2 for alphabetically greater-than.

@o names.c -cc
@{int robs_strcmp(x, y)
     char *x;
     char *y;
{
   int cmp = 0;

   for (; *x && *y; x++, y++)
   {
      @<Skip invisibles on @'x@'@>
      @<Skip invisibles on @'y@'@>
      if (*x == *y)
         continue;
      if (islower(*x) && toupper(*x) == *y)
      {
         if (!cmp) cmp = 1;
         continue;
      }
      if (islower(*y) && *x == toupper(*y))
      {
         if (!cmp) cmp = -1;
         continue;
      }
      return 2*(toupper(*x) - toupper(*y));
   }
   if (*x)
      return 2;
   if (*y)
      return -2;
   return cmp;
}
@| robs_strcmp @}

Certain character sequences are invisible when printed. We don't want
them to be considered for the alphabetical ordering.

@d Skip invisibles on @'p@'
@{if (*@1 == '|')
   @1++;
@}

@o names.c -cc
@{Name *name_add(rt, spelling, sector)
     Name **rt;
     char *spelling;
     unsigned char sector;
{
  Name *node = *rt;
  while (node) {
    int result = robs_strcmp(node->spelling, spelling);
    if (result > 0)
      rt = &node->llink;
    else if (result < 0)
      rt = &node->rlink;
    else
    {
       found_name = node->spelling;
       if (node->sector > sector)
         rt = &node->llink;
       else if (node->sector < sector)
         rt = &node->rlink;
       else
         return node;
    }
    node = *rt;
  }
  @<Create new name entry@>
}
@| name_add @}


@d Create new name...
@{{
  node = (Name *) arena_getmem(sizeof(Name));
  if (found_name && robs_strcmp(found_name, spelling) == 0)
     node->spelling = found_name;
  else
     node->spelling = save_string(spelling);
  node->mark = FALSE;
  node->llink = NULL;
  node->rlink = NULL;
  node->uses = NULL;
  node->defs = NULL;
  node->arg[0] =
  node->arg[1] =
  node->arg[2] =
  node->arg[3] =
  node->arg[4] =
  node->arg[5] =
  node->arg[6] =
  node->arg[7] =
  node->arg[8] = NULL;
  node->tab_flag = TRUE;
  node->indent_flag = TRUE;
  node->debug_flag = FALSE;
  node->comment_flag = 0;
  node->sector = sector;
  *rt = node;
  return node;
}@}


Name terminated by whitespace.  Also check for ``per-file'' flags. Keep
skipping white space until we reach scrap.
@o names.c -cc
@{Name *collect_file_name()
{
  Name *new_name;
  char name[MAX_NAME_LEN];
  char *p = name;
  int start_line = source_line;
  int c = source_get(), c2;
  while (isspace(c))
    c = source_get();
  while (isgraph(c)) {
    *p++ = c;
    c = source_get();
  }
  if (p == name) {
    fprintf(stderr, "%s: expected file name (%s, %d)\n",
            command_name, source_name, start_line);
    exit(-1);
  }
  *p = '\0';
  /* File names are always global. */
  new_name = name_add(&file_names, name, 0);
  @<Handle optional per-file flags@>
  c2 = source_get();
  if (c != nw_char || (c2 != '{' && c2 != '(' && c2 != '[')) {
    fprintf(stderr, "%s: expected %c{, %c[, or %c( after file name (%s, %d)\n",
            command_name, nw_char, nw_char, nw_char, source_name, start_line);
    exit(-1);
  }
  return new_name;
}
@| collect_file_name @}

@d Handle optional per-file flags
@{{
  while (1) {
    while (isspace(c))
      c = source_get();
    if (c == '-') {
      c = source_get();
      do {
        switch (c) {
          case 't': new_name->tab_flag = FALSE;
                    break;
          case 'd': new_name->debug_flag = TRUE;
                    break;
          case 'i': new_name->indent_flag = FALSE;
                    break;
          case 'c': @<Get comment delimiters@>
                    break;
          default : fprintf(stderr, "%s: unexpected per-file flag (%s, %d)\n",
                            command_name, source_name, source_line);
                    break;
        }
        c = source_get();
      } while (!isspace(c));
    }
    else break;
  }
}@}

So far we only deal with C comments.
@d Get comment delimiters
@{c = source_get();
if (c == 'c')
   new_name->comment_flag = 1;
else if (c == '+')
   new_name->comment_flag = 2;
else if (c == 'p')
   new_name->comment_flag = 3;
else
   fprintf(stderr, "%s: Unrecognised comment flag (%s, %d)\n",
           command_name, source_name, source_line);
@}


@d Forward declarations for scraps.c
@{char * comment_begin[4] = { "", "/* ", "// ", "# "};
char * comment_mid[4] = { "", " * ", "// ", "# "};
char * comment_end[4] = { "", " */", "", ""};
@| comment_begin comment_end comment_mid @}

Name terminated by \verb+\n+ or \verb+@@{+; but keep skipping until \verb+@@{+
@o names.c -cc
@{Name *collect_macro_name()
{
  char name[MAX_NAME_LEN];
  char args[1000];
  char * arg[9];
  char * argp = args;
  int argc = 0;
  char *p = name;
  int start_line = source_line;
  int c = source_get(), c2;
  unsigned char sector = current_sector;

  if (c == '+') {
    sector = 0;
    c = source_get();
  }
  while (isspace(c))
    c = source_get();
  while (c != EOF) {
    Name * node;
    switch (c) {
      case '\t':
      case ' ':  *p++ = ' ';
                 do
                   c = source_get();
                 while (c == ' ' || c == '\t');
                 break;
      case '\n': @<Skip until scrap begins, then return name@>
      default:
         if (c==nw_char)
           {
             @<Check for terminating at-sequence and return name@>
             break;
           }
         *p++ = c;
                 c = source_get();
                 break;
    }
  }
  fprintf(stderr, "%s: expected fragment name (%s, %d)\n",
          command_name, source_name, start_line);
  exit(-1);
  return NULL;  /* unreachable return to avoid warnings on some compilers */
}
@| collect_macro_name @}


@d Check for termina...
@{{
  c = source_get();
  switch (c) {
    case '(':
    case '[':
    case '{': @<Cleanup and install name@>
             return install_args(node, argc, arg);
    case '\'': @<Enter the next argument@>
               break;
    default:
          if (c==nw_char)
            {
              *p++ = c;
              break;
            }
          fprintf(stderr,
                      "%s: unexpected %c%c in fragment definition name (%s, %d)\n",
                      command_name, nw_char, c, source_name, start_line);
              exit(-1);
  }
}@}

@d Enter the next argument
@{arg[argc] = argp;
while ((c = source_get()) != EOF) {
   if (c==nw_char) {
      c2 = source_get();
      if (c2=='\'') {
        @<Make this argument@>
        c = source_get();
        break;
      }
      else
        *argp++ = c2;
   }
   else
     *argp++ = c;
}
*p++ = ARG_CHR;
@}

@d Type dec...
@{#define ARG_CHR '\001'
@| ARG_CHR@}

@d Make this argument
@{if (argc < 9) {
  *argp++ = '\000';
  argc += 1;
}
@}

@d Cleanup and install name
@{{
  if (p > name && p[-1] == ' ')
    p--;
  if (p - name > 3 && p[-1] == '.' && p[-2] == '.' && p[-3] == '.') {
    p[-3] = ' ';
    p -= 2;
  }
  if (p == name || name[0] == ' ') {
    fprintf(stderr, "%s: empty name (%s, %d)\n",
            command_name, source_name, source_line);
    exit(-1);
  }
  *p = '\0';
  node = prefix_add(&macro_names, name, sector);
}@}

@d Skip until scrap...
@{{
  do
    c = source_get();
  while (isspace(c));
  c2 = source_get();
  if (c != nw_char || (c2 != '{' && c2 != '(' && c2 != '[')) {
    fprintf(stderr, "%s: expected %c{ after fragment name (%s, %d)\n",
            command_name, nw_char, source_name, start_line);
    exit(-1);
  }
  @<Cleanup and install name@>
  return install_args(node, argc, arg);
}@}

@d Function prototypes
@{extern Name *install_args();
@}

@o names.c -cc
@{Name *install_args(Name * name, int argc, char *arg[9])
{
  int i;

  for (i = 0; i < argc; i++) {
    if (name->arg[i] == NULL)
      name->arg[i] = save_string(arg[i]);
  }
  return name;
}
@}

@d Type declarations
@{typedef struct arglist
{Name * name;
struct arglist * args;
struct arglist * next;
} Arglist;
@| Arglist @}

@o names.c -cc
@{Arglist * buildArglist(Name * name, Arglist * a)
{
  Arglist * args = (Arglist *)arena_getmem(sizeof(Arglist));

  args->args = a;
  args->next = NULL;
  args->name = name;
  return args;
}
@| buildArglist @}

Terminated by \verb+@@>+
@o names.c -cc
@{Arglist * collect_scrap_name(int current_scrap)
{
  char name[MAX_NAME_LEN];
  char *p = name;
  int c = source_get();
  unsigned char sector = current_sector;
  Arglist * head = NULL;
  Arglist ** tail = &head;

  if (c == '+')
  {
    sector = 0;
    c = source_get();
  }
  while (c == ' ' || c == '\t')
    c = source_get();
  while (c != EOF) {
    switch (c) {
      case '\t':
      case ' ':  *p++ = ' ';
                 do
                   c = source_get();
                 while (c == ' ' || c == '\t');
                 break;
      default:
         if (c==nw_char)
           {
             @<Look for end of scrap name and return@>
             break;
           }
         if (!isgraph(c)) {
                   fprintf(stderr,
                           "%s: unexpected character in fragment name (%s, %d)\n",
                           command_name, source_name, source_line);
                   exit(-1);
                 }
                 *p++ = c;
                 c = source_get();
                 break;
    }
  }
  fprintf(stderr, "%s: unexpected end of file (%s, %d)\n",
          command_name, source_name, source_line);
  exit(-1);
  return NULL;  /* unreachable return to avoid warnings on some compilers */
}
@| collect_scrap_name @}

@d Look for end of scrap name...
@{{
  Name * node;

  c = source_get();
  switch (c) {

    case '\'': {
          @< Add plain string argument@>
        }
        *p++ = ARG_CHR;
        c = source_get();
        break;
    case '1': case '2': case '3':
    case '4': case '5': case '6':
    case '7': case '8': case '9': {
          @<Add a propagated argument@>
        }
        *p++ = ARG_CHR;
        c = source_get();
        break;
    case '{': {
        @<Add an inline scrap argument@>
        }
        *p++ = ARG_CHR;
        c = source_get();
        break;
    case '<':
        @<Add macro call argument@>
        *p++ = ARG_CHR;
        c = source_get();
        break;
    case '(':
        scrap_name_has_parameters = 1;
        @<Cleanup and install name@>
        return buildArglist(node, head);
    case '>':
        scrap_name_has_parameters = 0;
        @<Cleanup and install name@>
        return buildArglist(node, head);

    default:
       if (c==nw_char)
         {
           *p++ = c;
              c = source_get();
              break;
         }
       fprintf(stderr,
                      "%s: unexpected %c%c in fragment invocation name (%s, %d)\n",
                      command_name, nw_char, c, source_name, source_line);
              exit(-1);
  }
}@}

A plain string argument has no name and a string as a value.

@d Add plain string argument
@{char buff[MAX_NAME_LEN];
char * s = buff;
int c, c2;

while ((c = source_get()) != EOF) {
  if (c==nw_char) {
    c2 = source_get();
    if (c2=='\'')
      break;
    *s++ = c2;
  }
  else
    *s++ = c;
}
*s = '\000';
@<Add buff to current arg list@>@}

A parameter argument propagated into an interior fragment has no name
and and a string of \verb|ARG_CHAR| followed by a digit as value.

@d Add a propagated argument
@{char buff[3];
buff[0] = ARG_CHR;
buff[1] = c;
buff[2] = '\000';
@<Add buff to current arg list@>@}

@d Add an inline scrap argument
@{int s = collect_scrap();
Scrap_Node * d = (Scrap_Node *)arena_getmem(sizeof(Scrap_Node));
d->scrap = s;
d->quoted = 0;
d->next = NULL;
*tail = buildArglist((Name *)1, (Arglist *)d);
tail = &(*tail)->next;@}

@d Type declarations
@{typedef struct embed {
   Scrap_Node * defs;
   Arglist * args;
} Embed_Node;
@| Embed_Node@}

@d Add macro call argument
@{*tail = collect_scrap_name(current_scrap);
if (current_scrap >= 0)
  add_to_use((*tail)->name, current_scrap);
tail = &(*tail)->next;
@}

@d Add buff...
@{*tail = buildArglist(NULL, (Arglist *)save_string(buff));
tail = &(*tail)->next;
@}

@o names.c -cc
@{static Scrap_Node *reverse(); /* a forward declaration */

void reverse_lists(names)
     Name *names;
{
  while (names) {
    reverse_lists(names->llink);
    names->defs = reverse(names->defs);
    names->uses = reverse(names->uses);
    names = names->rlink;
  }
}
@| reverse_lists @}

Just for fun, here's a non-recursive version of the traditional list
reversal code. Note that it reverses the list in place; that is, it
does no new allocations.
@o names.c -cc
@{static Scrap_Node *reverse(a)
     Scrap_Node *a;
{
  if (a) {
    Scrap_Node *b = a->next;
    a->next = NULL;
    while (b) {
      Scrap_Node *c = b->next;
      b->next = a;
      a = b;
      b = c;
    }
  }
  return a;
}
@| reverse @}


\section{Searching for Index Entries} \label{search}

Given the array of scraps and a set of index entries, we need to
search all the scraps for occurrences of each entry. The obvious
approach to this problem would be quite expensive for large documents;
however, there is an interesting  paper describing an efficient
solution~\cite{aho:75}.


@o scraps.c -cc
@{typedef struct name_node {
  struct name_node *next;
  Name *name;
} Name_Node;
@| Name_Node @}

@o scraps.c -cc
@{typedef struct goto_node {
  Name_Node *output;            /* list of words ending in this state */
  struct move_node *moves;      /* list of possible moves */
  struct goto_node *fail;       /* and where to go when no move fits */
  struct goto_node *next;       /* next goto node with same depth */
} Goto_Node;
@| Goto_Node @}

@o scraps.c -cc
@{typedef struct move_node {
  struct move_node *next;
  Goto_Node *state;
  char c;
} Move_Node;
@| Move_Node @}

@o scraps.c -cc
@{static Goto_Node *root[128];
static int max_depth;
static Goto_Node **depths;
@| root max_depth depths @}


@o scraps.c -cc
@{static Goto_Node *goto_lookup(c, g)
     char c;
     Goto_Node *g;
{
  Move_Node *m = g->moves;
  while (m && m->c != c)
    m = m->next;
  if (m)
    return m->state;
  else
    return NULL;
}
@| goto_lookup @}

\subsection{Retrieving scrap uses}

@o scraps.c -cc
@{typedef struct ArgMgr_s
{
   char * pv;
   char * bgn;
   Arglist * arg;
   struct ArgMgr_s * old;
} ArgMgr;
@| ArgMgr @}

@o scraps.c -cc
@{typedef struct ArgManager_s
{
   Manager * m;
   ArgMgr * a;
} ArgManager;
@| ArgManager @}

@o scraps.c -cc
@{static void
pushArglist(ArgManager * mgr, Arglist * a)
{
   ArgMgr * b = malloc(sizeof(ArgMgr));

   if (b == NULL)
   {
      fprintf(stderr, "Can't allocate space for an argument manager\n");
      exit(EXIT_FAILURE);
   }
   b->pv = b->bgn = NULL;
   b->arg = a;
   b->old = mgr->a;
   mgr->a = b;
}
@| pushArglist @}

@o scraps.c -cc
@{static char argpop(ArgManager * mgr)
{
   while (mgr->a != NULL)
   {
      ArgMgr * a = mgr->a;

      @<Perhaps |return| a character from the current arg@>
      @<Perhaps start a new arg@>
      @<Otherwise pop the current arg@>
   }

   return (pop(mgr->m));
}
@| argpop @}

We separate individual arguments using spaces.

@d Perhaps |return| a character from the current arg
@{if (a->pv != NULL)
{
   char c = *a->pv++;

   if (c != '\0')
      return c;
   a->pv = NULL;
   return ' ';
}
@}

I'm pretty sure that only the first case is ever used. I don't think
the others can occur in this context, which makes the whole
|ArgManager| thing doubtful.

@d Perhaps start a new arg
@{if (a->arg) {
   Arglist * b = a->arg;

   a->arg = b->next;
   if (b->name == NULL) {
      a->bgn = a->pv = (char *)b->args;
   } else if (b->name == (Name *)1) {
      a->bgn = a->pv = "{Embedded Scrap}";
   } else {
      pushArglist(mgr, b->args);
   }@}

@d Otherwise pop the current arg
@{} else {
   mgr->a = a->old;
   free(a);
}@}

@o scraps.c -cc
@{static char
prev_char(ArgManager * mgr, int n)
{
   char c = '\0';
   ArgMgr * a = mgr->a;
   Manager * m = mgr->m;

   if (a != NULL) {
      @<Get the nth previous character from an argument@>
   } else {
      @<Get the nth previous character from a scrap@>
   }

   return c;
}
@| prev_char @}

@d Get the nth previous character from an argument
@{if (a->pv && a->pv - n >= a->bgn)
   c = *a->pv;
else if (a->bgn) {
   int j = strlen(a->bgn) + 1;

   if (n >= j)
      c = a->bgn[j - n];
   else
      c = ' ';
}
@}

@d Get the nth previous character from a scrap
@{int k = m->index - n - 2;

if (k >= 0)
   c = m->scrap->chars[k];
else if (m->prev)
   c = m->prev->chars[SLAB_SIZE - k];
@}

\subsection{Building the Automata}

@d Function pro...
@{extern void search();
@}

@o scraps.c -cc
@{static void build_gotos();
static int reject_match();

void search()
{
  int i;
  for (i=0; i<128; i++)
    root[i] = NULL;
  max_depth = 10;
  depths = (Goto_Node **) arena_getmem(max_depth * sizeof(Goto_Node *));
  for (i=0; i<max_depth; i++)
    depths[i] = NULL;
  build_gotos(user_names);
  @<Build failure functions@>
  @<Search scraps@>
}
@| search @}



@o scraps.c -cc
@{static void build_gotos(tree)
     Name *tree;
{
  while (tree) {
    @<Extend goto graph with \verb|tree->spelling|@>
    build_gotos(tree->rlink);
    tree = tree->llink;
  }
}
@| build_gotos @}

@d Extend goto...
@{{
  int depth = 2;
  char *p = tree->spelling;
  char c = *p++;
  Goto_Node *q = root[c];
  Name_Node * last;
  if (!q) {
    q = (Goto_Node *) arena_getmem(sizeof(Goto_Node));
    root[c] = q;
    q->moves = NULL;
    q->fail = NULL;
    q->moves = NULL;
    q->output = NULL;
    q->next = depths[1];
    depths[1] = q;
  }
  while (c = *p++) {
    Goto_Node *new = goto_lookup(c, q);
    if (!new) {
      Move_Node *new_move = (Move_Node *) arena_getmem(sizeof(Move_Node));
      new = (Goto_Node *) arena_getmem(sizeof(Goto_Node));
      new->moves = NULL;
      new->fail = NULL;
      new->moves = NULL;
      new->output = NULL;
      new_move->state = new;
      new_move->c = c;
      new_move->next = q->moves;
      q->moves = new_move;
      if (depth == max_depth) {
        int i;
        Goto_Node **new_depths =
            (Goto_Node **) arena_getmem(2*depth*sizeof(Goto_Node *));
        max_depth = 2 * depth;
        for (i=0; i<depth; i++)
          new_depths[i] = depths[i];
        depths = new_depths;
        for (i=depth; i<max_depth; i++)
          depths[i] = NULL;
      }
      new->next = depths[depth];
      depths[depth] = new;
    }
    q = new;
    depth++;
  }
  last = q->output;
  q->output = (Name_Node *) arena_getmem(sizeof(Name_Node));
  q->output->next = last;
  q->output->name = tree;
}@}


@d Build failure functions
@{{
  int depth;
  for (depth=1; depth<max_depth; depth++) {
    Goto_Node *r = depths[depth];
    while (r) {
      Move_Node *m = r->moves;
      while (m) {
        char a = m->c;
        Goto_Node *s = m->state;
        Goto_Node *state = r->fail;
        while (state && !goto_lookup(a, state))
          state = state->fail;
        if (state)
          s->fail = goto_lookup(a, state);
        else
          s->fail = root[a];
        if (s->fail) {
          Name_Node *p = s->fail->output;
          while (p) {
            Name_Node *q = (Name_Node *) arena_getmem(sizeof(Name_Node));
            q->name = p->name;
            q->next = s->output;
            s->output = q;
            p = p->next;
          }
        }
        m = m->next;
      }
      r = r->next;
    }
  }
}@}


\subsection{Searching the Scraps}

@d Search scraps
@{{
  for (i=1; i<scraps; i++) {
    char c, last = '\0';
    Manager rd;
    ArgManager reader;
    Goto_Node *state = NULL;
    rd.prev = NULL;
    rd.scrap = scrap_array(i).slab;
    rd.index = 0;
    reader.m = &rd;
    reader.a = NULL;
    c = argpop(&reader);
    while (c) {
      while (state && !goto_lookup(c, state))
        state = state->fail;
      if (state)
        state = goto_lookup(c, state);
      else
        state = root[c];
      @<Skip over at at@>
      @<Skip over a scrap use@>
      @<Skip over a block comment@>
      last = c;
      c = argpop(&reader);
      if (state && state->output) {
        Name_Node *p = state->output;
        do {
          Name *name = p->name;
          if (!reject_match(name, c, &reader) &&
              scrap_array(i).sector == name->sector &&
              (!name->uses || name->uses->scrap != i)) {
            Scrap_Node *new_use =
                (Scrap_Node *) arena_getmem(sizeof(Scrap_Node));
            new_use->scrap = i;
            new_use->next = name->uses;
            name->uses = new_use;
            if (!scrap_is_in(name->defs, i))
              add_uses(&(scrap_array(i).uses), name);
          }
          p = p->next;
        } while (p);
      }
    }
  }
}@}

@d Skip over at at
@{if (last == nw_char && c == nw_char)
{
   last = '\0';
   c = argpop(&reader);
}
@}

@d Skip over a scrap use
@{if (last == nw_char && c == '<')
{
   char buf[MAX_NAME_LEN];
   char * p = buf;
   Arglist * args;

   c = argpop(&reader);
   while ((c = argpop(&reader)) != nw_char)
      *p++ = c;
   c = argpop(&reader);
   *p = '\0';
   if (sscanf(buf, "%p", &args) != 1) {
      fprintf(stderr,  "%s: found an internal problem (3)\n", command_name);
      exit(-1);
   }
   pushArglist(&reader, args);
}@}

@d Forward declarations for scraps.c
@{
static void add_uses();
static int scrap_is_in();
@}

@o scraps.c -cc
@{
static int scrap_is_in(Scrap_Node * list, int i)
{
  while (list != NULL) {
    if (list->scrap == i)
      return TRUE;
    list = list->next;
  }
  return FALSE;
}
@| scrap_is_in@}

@o scraps.c -cc
@{
static void add_uses(Uses * * root, Name *name)
{
   int cmp;
   Uses *p, **q = root;

   while ((p = *q, p != NULL)
          && (cmp = robs_strcmp(p->defn->spelling, name->spelling)) < 0)
      q = &(p->next);
   if (p == NULL || cmp > 0)
   {
      Uses *new = arena_getmem(sizeof(Uses));
      new->next = p;
      new->defn = name;
      *q = new;
   }
}
@| add_uses @}

@d Type dec...
@{typedef struct uses {
  struct uses *next;
  Name *defn;
} Uses;
@| Uses @}

@o scraps.c -cc
@{
void
format_uses_refs(FILE * tex_file, int scrap)
{
  Uses * p = scrap_array(scrap).uses;
  if (p != NULL)
    @<Write uses references@>
}
@| format_uses_refs @}

@d Write uses ...
@{{
  char join = ' ';
  fputs("\\item \\NWtxtIdentsUsed\\nobreak\\", tex_file);
  do {
    @<Write one use reference@>
    join = ',';
    p = p->next;
  }while (p != NULL);
  fputs(".", tex_file);
}@}

@d Write one use reference
@{Name * name = p->defn;
Scrap_Node *defs = name->defs;
int first = TRUE, page = -1;
fprintf(tex_file,
        "%c \\verb%c%s%c\\nobreak\\ ",
        join, nw_char, name->spelling, nw_char);
if (defs)
{
  do {
    @<Write one referenced scrap@>
    first = FALSE;
    defs = defs->next;
  }while (defs!= NULL);
}
else
{
  fputs("\\NWnotglobal", tex_file);
}
@}

@d Write one referenced scrap
@{fputs("\\NWlink{nuweb", tex_file);
write_scrap_ref(tex_file, defs->scrap, -1, &page);
fputs("}{", tex_file);
write_scrap_ref(tex_file, defs->scrap, first, &page);
fputs("}", tex_file);@}

@o scraps.c -cc
@{
void
format_defs_refs(FILE * tex_file, int scrap)
{
  Uses * p = scrap_array(scrap).defs;
  if (p != NULL)
    @<Write defs references@>
}
@| format_defs_refs @}

@d Write defs ...
@{{
  char join = ' ';
  fputs("\\item \\NWtxtIdentsDefed\\nobreak\\", tex_file);
  do {
    @<Write one def reference@>
    join = ',';
    p = p->next;
  }while (p != NULL);
  fputs(".", tex_file);
}@}

@d Write one def reference
@{Name * name = p->defn;
Scrap_Node *defs = name->uses;
int first = TRUE, page = -1;
fprintf(tex_file,
        "%c \\verb%c%s%c\\nobreak\\ ",
        join, nw_char, name->spelling, nw_char);
if (defs == NULL
    || (defs->scrap == scrap && defs->next == NULL)) {
  fputs("\\NWtxtIdentsNotUsed", tex_file);
}
else {
  do {
    if (defs->scrap != scrap) {
       @<Write one referenced scrap@>
       first = FALSE;
    }
    defs = defs->next;
  }while (defs!= NULL);
}
@}

\subsubsection{Rejecting Matches}

A problem with simple substring matching is that the string ``he''
would match longer strings like ``she'' and ``her.'' Norman Ramsey
suggested examining the characters occurring immediately before and
after a match and rejecting the match if it appears to be part of a
longer token. Of course, the concept of {\sl token\/} is
language-dependent, so we may be occasionally mistaken.
For the present, we'll consider the mechanism an experiment.

@o scraps.c -cc
@{#define sym_char(c) (isalnum(c) || (c) == '_')

static int op_char(c)
     char c;
{
  switch (c) {
    case '!':           case '#': case '%': case '$': case '^':
    case '&': case '*': case '-': case '+': case '=': case '/':
    case '|': case '~': case '<': case '>':
      return TRUE;
    default:
      return c==nw_char ? TRUE : FALSE;
  }
}
@| sym_char op_char @}

@o scraps.c -cc
@{static int reject_match(name, post, reader)
     Name *name;
     char post;
     ArgManager *reader;
{
  int len = strlen(name->spelling);
  char first = name->spelling[0];
  char last = name->spelling[len - 1];
  char prev = prev_char(reader, len);
  if (sym_char(last) && sym_char(post)) return TRUE;
  if (sym_char(first) && sym_char(prev)) return TRUE;
  if (op_char(last) && op_char(post)) return TRUE;
  if (op_char(first) && op_char(prev)) return TRUE;
  return FALSE; /* Here is @xother@x */
}
@| reject_match @}


\section{Labels}

Refer to @xlabel@x.
And another one @xother@x.

@d Get label from
@{char  label_name[MAX_NAME_LEN];
char * p = label_name;
while (c = @1, c != nw_char) /* Here is @xlabel@x */
   *p++ = c;
*p = '\0';
c = @1;
@}

@o scraps.c -cc
@{void
write_label(char label_name[], FILE * file)
@<Search for label(@<Write the label to file@>,@<Complain about missing label@>)@>
@| write_label@}

@d Function prototypes
@{void write_label(char label_name[], FILE * file);
@}

@d Write the label to file
@{write_single_scrap_ref(file, lbl->scrap);
fprintf(file, "-%02d", lbl->seq);@}

@d Complain about missing label
@{fprintf(stderr, "Can't find label %s.\n", label_name);@}

@d Save label to label store
@{if (label_name[0])
@<Search for label(@<Complain about duplicate labels@>,@<Create a new label entry@>)@>
else
{
   @<Complain about empty label@>
}@}

@d Create a new label en...
@{lbl = (label_node *)arena_getmem(sizeof(label_node) + (p - label_name));
lbl->left = lbl->right = NULL;
strcpy(lbl->name, label_name);
lbl->scrap = current_scrap;
lbl->seq = ++lblseq;
*plbl = lbl;@}

@d Complain about duplicate labels
@{fprintf(stderr, "Duplicate label %s.\n", label_name);@}

@d Complain about empty label
@{fprintf(stderr, "Empty label.\n");@}

@d Search for label(@'Found@',@'Notfound@')
@{{
   label_node * * plbl = &label_tab;
   for (;;)
   {
      label_node * lbl = *plbl;

      if (lbl)
      {
         int cmp = label_name[0] - lbl->name[0];

         if (cmp == 0)
	    cmp = strcmp(label_name + 1, lbl->name + 1);
	 if (cmp < 0)
	    plbl = &lbl->left;
	 else if (cmp > 0)
	    plbl = &lbl->right;
	 else
	 {
	    @1
	    break;
	 }
      }
      else
      {
          @2
	  break;
      }
   }
}
@}

@o global.c -cc
@{label_node * label_tab = NULL;
@| label_tab@}

@d Type declarations
@{typedef struct l_node
{
   struct l_node * left, * right;
   int scrap, seq;
   char name[1];
} label_node;
@| label_node@}

@d Global variable declarations
@{extern label_node * label_tab;
@}


\section{Memory Management} \label{memory-management}

I manage memory using a simple scheme inspired by Hanson's idea of
{\em arenas\/}~\cite{hanson:90}.
Basically, I allocate all the storage required when processing a
source file (primarily for names and scraps) using calls to
\verb|arena_getmem(n)|, where \verb|n| specifies the number of bytes to
be allocated. When the storage is no longer required, the entire arena
is freed with a single call to  \verb|arena_free()|. Both operations
are quite fast.
@d Function p...
@{extern void *arena_getmem();
extern void arena_free();
@}


@o arena.c -cc
@{typedef struct chunk {
  struct chunk *next;
  char *limit;
  char *avail;
} Chunk;
@| Chunk @}


We define an empty chunk called \verb|first|. The variable \verb|arena| points
at the current chunk of memory; it's initially pointed at \verb|first|.
As soon as some storage is required, a ``real'' chunk of memory will
be allocated and attached to \verb|first->next|; storage will be
allocated from the new chunk (and later chunks if necessary).
@o arena.c -cc
@{static Chunk first = { NULL, NULL, NULL };
static Chunk *arena = &first;
@| first arena @}


\subsection{Allocating Memory}

The routine \verb|arena_getmem(n)| returns a pointer to (at least)
\verb|n| bytes of memory. Note that \verb|n| is rounded up to ensure
that returned pointers are always aligned.  We align to the nearest
8-byte segment, since that'll satisfy the more common 2-byte and
4-byte alignment restrictions too.

@o arena.c -cc
@{void *arena_getmem(n)
     size_t n;
{
  char *q;
  char *p = arena->avail;
  n = (n + 7) & ~7;             /* ensuring alignment to 8 bytes */
  q = p + n;
  if (q <= arena->limit) {
    arena->avail = q;
    return p;
  }
  @<Find a new chunk of memory@>
}
@| arena_getmem @}


If the current chunk doesn't have adequate space (at least \verb|n|
bytes) we examine the rest of the list of chunks (starting at
\verb|arena->next|) looking for a chunk with adequate space. If \verb|n|
is very large, we may not find it right away or we may not find a
suitable chunk at all.
@d Find a new chunk...
@{{
  Chunk *ap = arena;
  Chunk *np = ap->next;
  while (np) {
    char *v = sizeof(Chunk) + (char *) np;
    if (v + n <= np->limit) {
      np->avail = v + n;
      arena = np;
      return v;
    }
    ap = np;
    np = ap->next;
  }
  @<Allocate a new chunk of memory@>
}@}


If there isn't a suitable chunk of memory on the free list, then we
need to allocate a new one.
@d Allocate a new ch...
@{{
  size_t m = n + 10000;
  np = (Chunk *) malloc(m);
  np->limit = m + (char *) np;
  np->avail = n + sizeof(Chunk) + (char *) np;
  np->next = NULL;
  ap->next = np;
  arena = np;
  return sizeof(Chunk) + (char *) np;
}@}


\subsection{Freeing Memory}

To free all the memory in the arena, we need only point \verb|arena|
back to the first empty chunk.
@o arena.c -cc
@{void arena_free()
{
  arena = &first;
}
@| arena_free @}

\chapter{Man page}

Here is the UNIX man page for nuweb:

@O nuweb.1 @{.TH NUWEB 1 "local 3/22/95"
.SH NAME
Nuweb, a literate programming tool
.SH SYNOPSIS
.B nuweb
.br
\fBnuweb\fP [options] [file] ...
.SH DESCRIPTION
.I Nuweb
is a literate programming tool like Knuth's
.I WEB,
only simpler.
A
.I nuweb
file contains program source code interleaved with documentation.
When
.I nuweb
is given a
.I nuweb
file, it writes the program file(s),
and also
produces,
.I LaTeX
source for typeset documentation.
.SH COMMAND LINE OPTIONS
.br
\fB-t\fP Suppresses generation of the {\tt .tex} file.
.br
\fB-o\fP Suppresses generation of the output files.
.br
\fB-d\fP List dangling identifier references in indexes.
.br
\fB-c\fP Forces output files to overwrite old files of the same
  name without comparing for equality first.
.br
\fB-v\fP The verbose flag. Forces output of progress reports.
.br
\fB-n\fP Forces sequential numbering of scraps (instead of page
  numbers).
.br
\fB-s\fP Doesn't print list of scraps making up file at end of
  each scrap.
\fB-p path\fP Prepend path to the filenames for all the output files.
\fB-V string\fP Provide the string for replacement of the @@v
operation. This is intended as a means for including version
information in generated output.
\fB-x\fP Include cross-references in comments in output files.
\fB-h options\fP Turn on hyperlinks using the hyperref package of
LaTeX and provide the options to the package.
\fB-r\fP Turn on hyperlinks using the hyperref package of
LaTeX, with the package options being in the text.
\fB-I path\fP Provide a directory to search for included files. This
may appear several times.

.SH FORMAT OF NUWEB FILES
A
.I nuweb
file contains mostly ordinary
.I LaTeX.
The file is read and copied to output (.tex file) unless a
.I nuweb
command is encountered. All
.I nuweb
commands start with an ``at-sign'' (@@).
Files and fragments are defined with the following commands:
.PP
@@o \fIfile-name flags  scrap\fP  where scrap is smaller than one page.
.br
@@O \fIfile-name flags  scrap\fP  where scrap is bigger than one page.
.br
@@d \fIfragment-name scrap\fP. Where scrap is smallar than one page.
.br
@@D \fIfragment-name scrap\fP. Where scrap is bigger than one page.
.PP
@@q \fIfragment-name scrap\fP. Where scrap is smallar than one page.
The scrap is not expanded in the output, allowing you to construct
output files which can, perhaps after further processing, be input to
.I nuweb.
.br
@@Q \fIfragment-name scrap\fP. Where scrap is bigger than one page.
Likewise.
.PP
Scraps have specific begin and end
markers;
which begin and end marker you use determines how the scrap will be
typeset in the .tex file:
.br
\fB@@{\fP...\fB@@}\fP for verbatim "terminal style" formatting or,
with the -l flag, LaTeX listing package.
.br
\fB@@[\fP...\fB@@]\fP for LaTeX paragraph mode formatting, and
.br
\fB@@(\fP...\fB@@)\fP for LaTeX math mode formmating.
.br
Any amount of whitespace
(including carriage returns) may appear between a name and the
begining of a scrap.
.PP
Several code/file scraps may have the same name;
.I nuweb
concatenates their definitions to produce a single scrap.
Code scrap definitions are like macro definitions;
.I nuweb
extracts a program by expanding one scrap.
The definition of that scrap contains references to other scraps, which are
themselves expanded, and so on.
\fINuweb\fP's output is readable; it preserves the indentation of expanded
scraps with respect to the scraps in which they appear.
.PP
.SH PER FILE OPTIONS
When defining an output file, the programmer has the option of using flags
to control the output.
.PP
\fB-d\fR option,
.I Nuweb
will emit line number indications at scrap boundaries.
.br
\fB-i\fR option,
.I Nuweb
supresses the indentation of fragments (useful for \fBFortran\fR).
.br
\fB-t\fP option makes \fInuweb\fP
copy tabs untouched from input to output.
.br
\fB-c\fIx\fP Include comments in the output file.
\fIx\fP may be \fBc\fP for C-style comments, \fB+\fP for C++ and
\fBp\fP for perl and similar.
.PP
.SH MINOR COMMANDS
.br
@@@@    Causes a single ``at-sign'' to be copied into the output.
.br
@@\_    Causes the text between it and the next {\tt @@\_} to be made bold
        (for keywords, etc.) in the formatted document
.br
@@%     Comments out a line so that it doesn't appear in the output.
.br
@@i     \fBfilename\fR causes the file named to be included.
.br
@@f     Creates an index of output files.
.br
@@m     Creates an index of fragments.
.br
@@u     Creates an index of user-specified identifiers.
.PP
To mark an identifier for inclusion in the index, it must be mentioned
at the end of the scrap it was defined in. The line starts
with @@| and ends with the \fBend of scrap\fP mark \fB@@}\fP.
.PP
.SH ERROR MESSAGES
.PP
.SH BUGS
.PP
.SH AUTHOR
Preston Briggs.
Internet address \fBpreston@@cs.rice.edu\fP.
.SH MAINTAINER
Simon Wright
Internet address \fBsimon@@pushface.org\fP
.br
Keith Harwood
Internet address \fBKeith.Harwood@@vitalmis.com\fP
@}

\chapter{Indices} \label{indices}

Three sets of indices can be created automatically: an index of file
names, an index of fragment names, and an index of user-specified
identifiers. An index entry includes the name of the entry, where it
was defined, and where it was referenced.

\section{Files}

@f

\section{Fragments}

@m

\section{Identifiers}

Knuth prints his index of identifiers in a two-column format.
I could force this automatically by emitting the \verb|\twocolumn|
command; but this has the side effect of forcing a new page.
Therefore, it seems better to leave it this up to the user.

@u

\fi

\bibliographystyle{amsplain}
\bibliography{litprog,master,misc}

\end{document}

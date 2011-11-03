#!/bin/sh
#
# $RCSfile: t0005a.sh,v $-- Test test/00/t0005a.sh
#
#
# Test of Commenting macroes as argument uses
#
work=${TMPDIR:-/tmp}/$$
PAGER=cat
export PAGER
umask 022
here=`pwd`
if test $? -ne 0 ; then exit 2; fi
SHELL=/bin/sh
export SHELL

bin="$here/${1-.}"

pass()
{
	set +x
	cd $here
	rm -rf $work
	exit 0
}
fail()
{
	set +x
	echo "FAILED test of Commenting macroes as argument uses" 1>&2
	cd $here
	rm -rf $work
	exit 1
}
no_result()
{
	set +x
	echo "NO RESULT for test of Commenting macroes as argument uses" 1>&2
	cd $here
	rm -rf $work
	exit 2
}
trap \"no_result\" 1 2 3 15

mkdir $work
if test $? -ne 0 ; then no_result; fi
cd $work
if test $? -ne 0 ; then no_result; fi

#
# test Commenting macroes as argument uses
#

cat > test.w <<"EOF"
\documentclass{article}
\begin{document}
@o test.c -cc
@{Call the macro
   @<Fragment with @<A macro argument@> as parameter@>
   @<Second frag with @<A macro argument@> as parameter@>
   @<Third frag with @<A macro argument@> as parameter@>
@}

@d Fragment with @'Begin macro@'...
@{@1<<<Here 'tis.
That argument was at the beginning of the fragment@}

@d Second frag with @'Begin line@'...
@{Here is the beginning of the second macro
@1<<<That is the argument
And this is the end of the second frag@}

@d Third frag with @'Embedded@'...
@{Here is the argument>>>@1<<<That was it.@}

@d A macro argument
@{Hello folks@}
\end{document}
EOF

cat > test.expected.tex <<"EOF"
\newcommand{\NWtarget}[2]{#2}
\newcommand{\NWlink}[2]{#2}
\newcommand{\NWtxtMacroDefBy}{Fragment defined by}
\newcommand{\NWtxtMacroRefIn}{Fragment referenced in}
\newcommand{\NWtxtMacroNoRef}{Fragment never referenced}
\newcommand{\NWtxtDefBy}{Defined by}
\newcommand{\NWtxtRefIn}{Referenced in}
\newcommand{\NWtxtNoRef}{Not referenced}
\newcommand{\NWtxtFileDefBy}{File defined by}
\newcommand{\NWtxtIdentsUsed}{Uses:}
\newcommand{\NWtxtIdentsNotUsed}{Never used}
\newcommand{\NWtxtIdentsDefed}{Defines:}
\newcommand{\NWsep}{${\diamond}$}
\newcommand{\NWnotglobal}{(not defined globally)}
\newcommand{\NWuseHyperlinks}{}
\documentclass{article}
\begin{document}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap1}\raggedright\small
\NWtarget{nuweb?}{} \verb@"test.c"@\nobreak\ {\footnotesize {?}}$\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Call the macro@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Fragment with $\langle\,${\itshape A macro argument}\nobreak\ {\footnotesize \NWlink{nuweb?}{?}}$\,\rangle$ as parameter}\nobreak\ {\footnotesize \NWlink{nuweb?}{?}}$\,\rangle$}\verb@@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Second frag with $\langle\,${\itshape A macro argument}\nobreak\ {\footnotesize \NWlink{nuweb?}{?}}$\,\rangle$ as parameter}\nobreak\ {\footnotesize \NWlink{nuweb?}{?}}$\,\rangle$}\verb@@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Third frag with $\langle\,${\itshape A macro argument}\nobreak\ {\footnotesize \NWlink{nuweb?}{?}}$\,\rangle$ as parameter}\nobreak\ {\footnotesize \NWlink{nuweb?}{?}}$\,\rangle$}\verb@@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap2}\raggedright\small
\NWtarget{nuweb?}{} $\langle\,${\itshape Fragment with \hbox{\slshape\sffamily Begin macro\/} as parameter}\nobreak\ {\footnotesize {?}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@@\hbox{\slshape\sffamily Begin macro\/}\verb@<<<Here 'tis.@\\
\mbox{}\verb@That argument was at the beginning of the fragment@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb?}{?}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap3}\raggedright\small
\NWtarget{nuweb?}{} $\langle\,${\itshape Second frag with \hbox{\slshape\sffamily Begin line\/} as parameter}\nobreak\ {\footnotesize {?}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Here is the beginning of the second macro@\\
\mbox{}\verb@@\hbox{\slshape\sffamily Begin line\/}\verb@<<<That is the argument@\\
\mbox{}\verb@And this is the end of the second frag@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb?}{?}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap4}\raggedright\small
\NWtarget{nuweb?}{} $\langle\,${\itshape Third frag with \hbox{\slshape\sffamily Embedded\/} as parameter}\nobreak\ {\footnotesize {?}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Here is the argument>>>@\hbox{\slshape\sffamily Embedded\/}\verb@<<<That was it.@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb?}{?}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap5}\raggedright\small
\NWtarget{nuweb?}{} $\langle\,${\itshape A macro argument}\nobreak\ {\footnotesize {?}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Hello folks@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb?}{?}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\end{document}
EOF

cat > test.expected.c <<"EOF"
Call the macro
   /* Fragment with <A macro argument> as parameter */
   /* A macro argument */
   Hello folks<<<Here 'tis.
   That argument was at the beginning of the fragment
   /* Second frag with <A macro argument> as parameter */
   Here is the beginning of the second macro
   /* A macro argument */
   Hello folks<<<That is the argument
   And this is the end of the second frag
   /* Third frag with <A macro argument> as parameter */
   Here is the argument>>>Hello folks<<<That was it.
EOF

# [Add other files here.  Avoid any extra processing such as
# decompression until after demo has run.  If demo fails this script
# can save time by not decompressing. ]

$bin/nuweb test.w
if test $? -ne 0 ; then fail; fi

diff -a --context test.expected.tex test.tex
if test $? -ne 0 ; then fail; fi

diff -a --context test.expected.c test.c
if test $? -ne 0 ; then fail; fi

# [Add other sub-tests that might be failed here.  If they need files
# created above to be decompressed, decompress them here ; this saves
# time if demo fails or the text-based sub-test fails.]

#
# Only definite negatives are possible.
# The functionality exercised by this test appears to work,
# no other guarantees are made.
#
pass

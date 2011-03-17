#!/bin/sh
#
# $RCSfile: t0004a.sh,v $-- Test test/00/t0004a.sh
#
#
# Test of indent before parameter
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
	echo "FAILED test of indent before parameter" 1>&2
	cd $here
	rm -rf $work
	exit 1
}
no_result()
{
	set +x
	echo "NO RESULT for test of indent before parameter" 1>&2
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
# test indent before parameter
#

cat > test.w <<"EOF"
\documentclass{article}
\begin{document}
@o test.c
@{Start
   @<Here is the first call@>
End
@}

@d Here is the first call
@{@<Use @'xxx@' as parameter@>
@<Use @'ZZZ@' as parameter@>
@}

@d Use @'yyy@' as...
@{@1 is here.
@}
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
\mbox{}\verb@Start@\\
\mbox{}\verb@   @\hbox{$\langle\,${\it Here is the first call}\nobreak\ {\footnotesize \NWlink{nuweb?}{?}}$\,\rangle$}\verb@@\\
\mbox{}\verb@End@\\
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
\NWtarget{nuweb?}{} $\langle\,${\it Here is the first call}\nobreak\ {\footnotesize {?}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@@\hbox{$\langle\,${\it Use \verb@xxx@ as parameter}\nobreak\ {\footnotesize \NWlink{nuweb?}{?}}$\,\rangle$}\verb@@\\
\mbox{}\verb@@\hbox{$\langle\,${\it Use \verb@ZZZ@ as parameter}\nobreak\ {\footnotesize \NWlink{nuweb?}{?}}$\,\rangle$}\verb@@\\
\mbox{}\verb@@{\NWsep}
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
\NWtarget{nuweb?}{} $\langle\,${\it Use \hbox{\slshape\sffamily yyy\/} as parameter}\nobreak\ {\footnotesize {?}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@@\hbox{\slshape\sffamily yyy\/}\verb@ is here.@\\
\mbox{}\verb@@{\NWsep}
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
Start
   xxx is here.
   
   ZZZ is here.
   
   
End
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

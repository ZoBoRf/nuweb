#!/bin/sh
#
# $RCSfile: t0009a.sh,v $-- Test test/00/t0009a.sh
#
#
# Test of user specified use of identifiers
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
	echo "FAILED test of user specified use of identifiers" 1>&2
	cd $here
	rm -rf $work
	exit 1
}
no_result()
{
	set +x
	echo "NO RESULT for test of user specified use of identifiers" 1>&2
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
# test user specified use of identifiers
#

cat > test.w <<"EOF"
\documentclass{article}
\begin{document}
Define a thing.
@o test.c -cc
@{This defines ident.
@<Use the thing defined@>
@| ident @}

Now use it without it actually appearing in the text.

@d Use the thing defined
@{Pretend that we use it here.
@* ident @}
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
Define a thing.
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap1}\raggedright\small
\NWtarget{nuweb1a}{} \verb@"test.c"@\nobreak\ {\footnotesize {1a}}$\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@This defines ident.@\\
\mbox{}\verb@@\hbox{$\langle\,${\itshape Use the thing defined}\nobreak\ {\footnotesize \NWlink{nuweb1b}{1b}}$\,\rangle$}\verb@@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtIdentsDefed\nobreak\  \verb@ident@\nobreak\ \NWlink{nuweb1b}{1b}.
\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
Now use it without it actually appearing in the text.

\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap2}\raggedright\small
\NWtarget{nuweb1b}{} $\langle\,${\itshape Use the thing defined}\nobreak\ {\footnotesize {1b}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Pretend that we use it here.@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb1a}{1a}.
\item \NWtxtIdentsUsed\nobreak\  \verb@ident@\nobreak\ \NWlink{nuweb1a}{1a}.
\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\end{document}
EOF

$bin/nuweb test.w
if test $? -ne 0 ; then fail; fi

latex test
latex test

$bin/nuweb test.w
if test $? -ne 0 ; then fail; fi

diff -a --context test.expected.tex test.tex
if test $? -ne 0 ; then fail; fi

#
# Only definite negatives are possible.
# The functionality exercised by this test appears to work,
# no other guarantees are made.
#
pass

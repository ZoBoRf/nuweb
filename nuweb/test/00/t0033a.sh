#!/bin/sh
#
# $RCSfile: t0033a.sh,v $-- Test test/00/t0032a.sh
#
#
# Test of Cross-reference environment
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
	echo "FAILED test of Cross-reference environment" 1>&2
	cd $here
	rm -rf $work
	exit 1
}
no_result()
{
	set +x
	echo "NO RESULT for test of Cross-reference environment" 1>&2
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
# test Cross-reference environment
#

cat > test.w <<"EOF"
\documentclass{article}
\begin{document}
@o test.c -cc
@{Begin
Define abc cba
@<Outer @'abc@' and @'def@' retuO@>
@<Outer @'cba@' and @'fed@' retuO@>
End
@| abc cba @}

@d Outer @'Arg1@' and @'Arg2@' retuO
@{Start
Define def fed
Use abc cba
@<Inner @{x@1y@2z@} rennI@>
Finish
@| def fed@}

@d Inner @'Stuff@' rennI
@{XX>>@1<<YY@}

@o test.c -cc
@{More stuff
@}

@d Outer...
@{Added stuff to force fragment defined
cross-reference entry.
@}

@m

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
\NWtarget{nuweb1a}{} \verb@"test.c"@\nobreak\ {\footnotesize {1a}}$\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Begin@\\
\mbox{}\verb@Define abc cba@\\
\mbox{}\verb@@\hbox{$\langle\,${\it Outer \verb@abc@ and \verb@def@ retuO}\nobreak\ {\footnotesize \NWlink{nuweb1b}{1b}, \ldots\ }$\,\rangle$}\verb@@\\
\mbox{}\verb@@\hbox{$\langle\,${\it Outer \verb@cba@ and \verb@fed@ retuO}\nobreak\ {\footnotesize \NWlink{nuweb1b}{1b}, \ldots\ }$\,\rangle$}\verb@@\\
\mbox{}\verb@End@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtFileDefBy\ \NWlink{nuweb1a}{1a}\NWlink{nuweb1d}{d}.
\item \NWtxtIdentsDefed\nobreak\  \verb@abc@\nobreak\ \NWlink{nuweb1b}{1b}, \verb@cba@\nobreak\ \NWlink{nuweb1b}{1b}.\item \NWtxtIdentsUsed\nobreak\  \verb@def@\nobreak\ \NWlink{nuweb1b}{1b}, \verb@fed@\nobreak\ \NWlink{nuweb1b}{1b}.
\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap2}\raggedright\small
\NWtarget{nuweb1b}{} $\langle\,${\it Outer \hbox{\slshape\sffamily Arg1\/} and \hbox{\slshape\sffamily Arg2\/} retuO}\nobreak\ {\footnotesize {1b}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Start@\\
\mbox{}\verb@Define def fed@\\
\mbox{}\verb@Use abc cba@\\
\mbox{}\verb@@\hbox{$\langle\,${\it Inner \verb@xArg1yArg2z@ rennI}\nobreak\ {\footnotesize \NWlink{nuweb1c}{1c}}$\,\rangle$}\verb@@\\
\mbox{}\verb@Finish@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroDefBy\ \NWlink{nuweb1b}{1b}\NWlink{nuweb1e}{e}.
\item \NWtxtMacroRefIn\ \NWlink{nuweb1a}{1a}.
\item \NWtxtIdentsDefed\nobreak\  \verb@def@\nobreak\ \NWlink{nuweb1a}{1a}, \verb@fed@\nobreak\ \NWlink{nuweb1a}{1a}.\item \NWtxtIdentsUsed\nobreak\  \verb@abc@\nobreak\ \NWlink{nuweb1a}{1a}, \verb@cba@\nobreak\ \NWlink{nuweb1a}{1a}.
\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap4}\raggedright\small
\NWtarget{nuweb1c}{} $\langle\,${\it Inner \hbox{\slshape\sffamily Stuff\/} rennI}\nobreak\ {\footnotesize {1c}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@XX>>@\hbox{\slshape\sffamily Stuff\/}\verb@<<YY@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb1b}{1b}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap5}\raggedright\small
\NWtarget{nuweb1d}{} \verb@"test.c"@\nobreak\ {\footnotesize {1d}}$\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@More stuff@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtFileDefBy\ \NWlink{nuweb1a}{1a}\NWlink{nuweb1d}{d}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap6}\raggedright\small
\NWtarget{nuweb1e}{} $\langle\,${\it Outer \hbox{\slshape\sffamily Arg1\/} and \hbox{\slshape\sffamily Arg2\/} retuO}\nobreak\ {\footnotesize {1e}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Added stuff to force fragment defined@\\
\mbox{}\verb@cross-reference entry.@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroDefBy\ \NWlink{nuweb1b}{1b}\NWlink{nuweb1e}{e}.
\item \NWtxtMacroRefIn\ \NWlink{nuweb1a}{1a}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}

{\small\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item $\langle\,$Inner \hbox{\slshape\sffamily Stuff\/} rennI\nobreak\ {\footnotesize \NWlink{nuweb1c}{1c}}$\,\rangle$ {\footnotesize {\NWtxtRefIn} \NWlink{nuweb1b}{1b}.}
\item $\langle\,$Outer \hbox{\slshape\sffamily Arg1\/} and \hbox{\slshape\sffamily Arg2\/} retuO\nobreak\ {\footnotesize \NWlink{nuweb1b}{1b}\NWlink{nuweb1e}{e}}$\,\rangle$ {\footnotesize {\NWtxtRefIn} \NWlink{nuweb1a}{1a}.}
\end{list}}

\end{document}
EOF

cat > test.expected.c <<"EOF"
Begin
Define abc cba
/* Outer 'abc' and 'def' retuO 1b */
Start
Define def fed
Use abc cba
/* Inner {xabcydefz} rennI 1c */
XX>>xabcydefz<<YY
Finish
Added stuff to force fragment defined
cross-reference entry.

/* Outer 'cba' and 'fed' retuO 1b */
Start
Define def fed
Use abc cba
/* Inner {xcbayfedz} rennI 1c */
XX>>xcbayfedz<<YY
Finish
Added stuff to force fragment defined
cross-reference entry.

End
More stuff
EOF

$bin/nuweb -x test.w
if test $? -ne 0 ; then fail; fi

latex test

$bin/nuweb -x test.w
if test $? -ne 0 ; then fail; fi

diff -a --context test.expected.tex test.tex
if test $? -ne 0 ; then fail; fi

diff -a --context test.expected.c test.c
if test $? -ne 0 ; then fail; fi

#
# Only definite negatives are possible.
# The functionality exercised by this test appears to work,
# no other guarantees are made.
#
pass

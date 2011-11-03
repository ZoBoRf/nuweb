#!/bin/sh
#
# $RCSfile: t0035a.sh,v $-- Test test/00/t0018a.sh
#
#
# Test of hyperlinks using -r
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
	echo "FAILED test of hyperlinks using -r" 1>&2
	cd $here
        rm -rf $work
        exit 1
}
no_result()
{
	set +x
	echo "NO RESULT for test of hyperlinks using -r" 1>&2
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
# test hyperlinks using -r
#

cat > test.w <<"EOF"
\documentclass{article}
\usepackage[pdftex,colorlinks=true]{hyperref}
\begin{document}
@o test.c -cc
@{@<Use a fragment@>
@}
@d Use...
@{Here is a fragment.
   Make sure it is referenced properly.@}
\end{document}
EOF

cat > test.expected.tex <<"EOF"
\newcommand{\NWtarget}[2]{\hypertarget{#1}{#2}}
\newcommand{\NWlink}[2]{\hyperlink{#1}{#2}}
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
\usepackage[pdftex,colorlinks=true]{hyperref}
\begin{document}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap1}\raggedright\small
\NWtarget{nuweb1a}{} \verb@"test.c"@\nobreak\ {\footnotesize {1a}}$\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@@\hbox{$\langle\,${\itshape Use a fragment}\nobreak\ {\footnotesize \NWlink{nuweb1b}{1b}}$\,\rangle$}\verb@@\\
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
\NWtarget{nuweb1b}{} $\langle\,${\itshape Use a fragment}\nobreak\ {\footnotesize {1b}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Here is a fragment.@\\
\mbox{}\verb@   Make sure it is referenced properly.@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb1a}{1a}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\end{document}
EOF


# [Add other files here.  Avoid any extra processing such as
# decompression until after nuweb has run.  If nuweb fails this script
# can save time by not decompressing. ]

$bin/nuweb -r test.w
if test $? -ne 0 ; then fail; fi

pdflatex test
if test $? -ne 0 ; then fail; fi

$bin/nuweb -r test.w
if test $? -ne 0 ; then fail; fi

pdflatex test
if test $? -ne 0 ; then fail; fi

diff -a --context test.expected.tex test.tex
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

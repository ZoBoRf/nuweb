#!/bin/sh
#
# $RCSfile: t0034a.sh,v $-- Test test/00/t0034a.sh
#
#
# Test of Listing package
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
	echo "FAILED test of Listing package" 1>&2
	cd $here
	rm -rf $work
	exit 1
}
no_result()
{
	set +x
	echo "NO RESULT for test of Listing package" 1>&2
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
# test Listing package
#

cat > test.w <<"EOF"
\documentclass{article}
\usepackage{listings}
\begin{document}

\lstset{extendedchars=true,keepspaces=true,language=C}

@o test.c -cc
@{int
main(int argc, char ** argv)
{
   @<Body of main@>
}
@}

@d Body...
@{int in;
unsigned char out[20];

while (scanf("%x", &in) == 1)
{
   @<Do one item@>
}
return 0;@}

@d Do...
@{int n = mangle(in, out);

for (int i = 0; i < n; i++)
   printf("%02x", out[i]);
printf("\n");@}

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
\usepackage{listings}
\begin{document}

\lstset{extendedchars=true,keepspaces=true,language=C}

\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap1}\raggedright\small
\NWtarget{nuweb?}{} \verb@"test.c"@\nobreak\ {\footnotesize {?}}$\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\lstinline@int@\\
\mbox{}\lstinline@main(int argc, char ** argv)@\\
\mbox{}\lstinline@{@\\
\mbox{}\lstinline@   @\hbox{$\langle\,${\itshape Body of main}\nobreak\ {\footnotesize \NWlink{nuweb?}{?}}$\,\rangle$}\lstinline@@\\
\mbox{}\lstinline@}@\\
\mbox{}\lstinline@@{\NWsep}
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
\NWtarget{nuweb?}{} $\langle\,${\itshape Body of main}\nobreak\ {\footnotesize {?}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\lstinline@int in;@\\
\mbox{}\lstinline@unsigned char out[20];@\\
\mbox{}\lstinline@@\\
\mbox{}\lstinline@while (scanf("%x", &in) == 1)@\\
\mbox{}\lstinline@{@\\
\mbox{}\lstinline@   @\hbox{$\langle\,${\itshape Do one item}\nobreak\ {\footnotesize \NWlink{nuweb?}{?}}$\,\rangle$}\lstinline@@\\
\mbox{}\lstinline@}@\\
\mbox{}\lstinline@return 0;@{\NWsep}
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
\NWtarget{nuweb?}{} $\langle\,${\itshape Do one item}\nobreak\ {\footnotesize {?}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\lstinline@int n = mangle(in, out);@\\
\mbox{}\lstinline@@\\
\mbox{}\lstinline@for (int i = 0; i < n; i++)@\\
\mbox{}\lstinline@   printf("%02x", out[i]);@\\
\mbox{}\lstinline@printf("\n");@{\NWsep}
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

# [Add other files here.  Avoid any extra processing such as
# decompression until after demo has run.  If demo fails this script
# can save time by not decompressing. ]

$bin/nuweb -l test.w
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

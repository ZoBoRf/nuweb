#!/bin/sh
#
# $RCSfile: t0016a.sh,v $-- Test test/00/t0016a.sh
#
#
# Test no pagebreak before scraps
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
	echo "FAILED test no pagebreak before scraps" 1>&2
	cd $here
	rm -rf $work
	exit 1
}
no_result()
{
	set +x
	echo "NO RESULT for test no pagebreak before scraps" 1>&2
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
# test ???
#

cat > test.w <<"EOF"
\documentclass{article}
\begin{document}
This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

@c Here comes a block comment just before a scrap and we don't
want this separated from it. (Thinks:
This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:
This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:)

@d Here is a scrap.
@{This is the contents of the scrap.

More stuff, not related to songs without ends.

"This is a song that will get on your nerves,
   Get on your nerves,
   Get on your nerves,"

Ad infinitum.
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
This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:

\begin{flushleft} \small
\begin{minipage}{\linewidth} Here comes a block comment just before a scrap and we don't
want this separated from it. (Thinks:
This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:
This is a song without and end. It goes on and on my friend. Some
people started singing it, not knowing what it was, and they'll
go on forever just because:)

\par\vspace{\baselineskip}
\label{scrap1}\raggedright\small
\NWtarget{nuweb?}{} $\langle\,${\itshape Here is a scrap.}\nobreak\ {\footnotesize {?}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@This is the contents of the scrap.@\\
\mbox{}\verb@@\\
\mbox{}\verb@More stuff, not related to songs without ends.@\\
\mbox{}\verb@@\\
\mbox{}\verb@"This is a song that will get on your nerves,@\\
\mbox{}\verb@   Get on your nerves,@\\
\mbox{}\verb@   Get on your nerves,"@\\
\mbox{}\verb@@\\
\mbox{}\verb@Ad infinitum.@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item {\NWtxtMacroNoRef}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\end{document}
EOF

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

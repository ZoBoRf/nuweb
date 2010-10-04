#!/bin/sh
#
# $RCSfile: t0015a.sh,v $-- Test test/00/t0015a.sh
#
#
# Test of ???
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
	echo "FAILED test of ???" 1>&2
	cd $here
	rm -rf $work
	exit 1
}
no_result()
{
	set +x
	echo "NO RESULT for test of ???" 1>&2
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
@d Sort @'key@' of size @'n@' for @'ordering@'
@{for (int j = 1; j < @2; j++)
{
   int i = j - 1;
   int kj = @1[j];

   do
   {
      int ki = @1[i];

      if (@3)
         break;
      @1[i + 1] = ki;
      i -= 1;
   } while (i >= 0);
   @1[i + 1] = kj;
}
@}

Test in-text @{@<Sort @'key@'...@>@} usage.
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
\NWtarget{nuweb?}{} $\langle\,${\it Sort \hbox{\slshape\sffamily key\/} of size \hbox{\slshape\sffamily n\/} for \hbox{\slshape\sffamily ordering\/}}\nobreak\ {\footnotesize {?}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@for (int j = 1; j < @\hbox{\slshape\sffamily n\/}\verb@; j++)@\\
\mbox{}\verb@{@\\
\mbox{}\verb@   int i = j - 1;@\\
\mbox{}\verb@   int kj = @\hbox{\slshape\sffamily key\/}\verb@[j];@\\
\mbox{}\verb@@\\
\mbox{}\verb@   do@\\
\mbox{}\verb@   {@\\
\mbox{}\verb@      int ki = @\hbox{\slshape\sffamily key\/}\verb@[i];@\\
\mbox{}\verb@@\\
\mbox{}\verb@      if (@\hbox{\slshape\sffamily ordering\/}\verb@)@\\
\mbox{}\verb@         break;@\\
\mbox{}\verb@      @\hbox{\slshape\sffamily key\/}\verb@[i + 1] = ki;@\\
\mbox{}\verb@      i -= 1;@\\
\mbox{}\verb@   } while (i >= 0);@\\
\mbox{}\verb@   @\hbox{\slshape\sffamily key\/}\verb@[i + 1] = kj;@\\
\mbox{}\verb@}@\\
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
Test in-text \verb@@$\langle\,${\it Sort \verb@key@ of size \verb@n@ for \verb@ordering@}\nobreak\ {\footnotesize \NWlink{nuweb?}{?}}$\,\rangle$\verb@@ usage.
\end{document}
EOF

# [Add other files here.  Avoid any extra processing such as
# decompression until after demo has run.  If demo fails this script
# can save time by not decompressing. ]

$bin/nuweb test.w
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

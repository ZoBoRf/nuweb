#!/bin/sh
#
# $RCSfile: t0025a.sh,v $-- Test test/00/t0024a.sh
#
#
# Test of Local and global sectors
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
	echo "FAILED test of Local and global sectors" 1>&2
	cd $here
	rm -rf $work
	exit 1
}
no_result()
{
	set +x
	echo "NO RESULT for test of Local and global sectors" 1>&2
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
# test Local and global sectors
#

cat > test.w <<"EOF"
\documentclass{article}
\begin{document}
@o test.actual.c
@{ First use in global
@<Frag 1@>
@}
@d Frag 1
@{Base sector line one.
@}
@s
@d Frag 1
@{First sector line one.
@}
@o test.actual.c
@{Use first local
@<Frag 1@>
@<+ Frag 2@>
@}
@m
@s
@o test.actual.c
@{Use second local
@<Frag 1@>
@}
@d Frag 1
@{Second sector line one.
@}
@m
@S
@d Frag 1
@{Base sector line two.
@}
@s
@d Frag 1
@{Third sector line one.
@}
@o test.actual.c
@{Use second local
@<Frag 1@>
@}
@m
@S
@d Frag 1
@{Base sector line three.
@}
@o test.actual.c
@{ Last use in global
@<Frag 1@>
@}
@d+ Frag 2
@{Here is frag 2
@}
@m
@m+
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
\NWtarget{nuweb1a}{} \verb@"test.actual.c"@\nobreak\ {\footnotesize {1a}}$\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@ First use in global@\\
\mbox{}\verb@@\hbox{$\langle\,${\itshape Frag 1}\nobreak\ {\footnotesize \NWlink{nuweb1b}{1b}, \ldots\ }$\,\rangle$}\verb@@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtFileDefBy\ \NWlink{nuweb1a}{1a}\NWlink{nuweb1d}{d}\NWlink{nuweb1e}{e}\NWlink{nuweb2c}{, 2c}\NWlink{nuweb2e}{e}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap2}\raggedright\small
\NWtarget{nuweb1b}{} $\langle\,${\itshape Frag 1}\nobreak\ {\footnotesize {1b}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Base sector line one.@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroDefBy\ \NWlink{nuweb1b}{1b}\NWlink{nuweb2a}{, 2a}\NWlink{nuweb2d}{d}.
\item \NWtxtMacroRefIn\ \NWlink{nuweb1a}{1a}\NWlink{nuweb2e}{, 2e}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}

\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap3}\raggedright\small
\NWtarget{nuweb1c}{} $\langle\,${\itshape Frag 1}\nobreak\ {\footnotesize {1c}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@First sector line one.@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb1d}{1d}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap4}\raggedright\small
\NWtarget{nuweb1d}{} \verb@"test.actual.c"@\nobreak\ {\footnotesize {1d}}$\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Use first local@\\
\mbox{}\verb@@\hbox{$\langle\,${\itshape Frag 1}\nobreak\ {\footnotesize \NWlink{nuweb1c}{1c}}$\,\rangle$}\verb@@\\
\mbox{}\verb@@\hbox{$\langle\,${\itshape Frag 2}\nobreak\ {\footnotesize \NWlink{nuweb2f}{2f}}$\,\rangle$}\verb@@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtFileDefBy\ \NWlink{nuweb1a}{1a}\NWlink{nuweb1d}{d}\NWlink{nuweb1e}{e}\NWlink{nuweb2c}{, 2c}\NWlink{nuweb2e}{e}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}

{\small\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item $\langle\,$Frag 1\nobreak\ {\footnotesize \NWlink{nuweb1c}{1c}}$\,\rangle$ {\footnotesize {\NWtxtRefIn} \NWlink{nuweb1d}{1d}.}
\end{list}}

\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap5}\raggedright\small
\NWtarget{nuweb1e}{} \verb@"test.actual.c"@\nobreak\ {\footnotesize {1e}}$\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Use second local@\\
\mbox{}\verb@@\hbox{$\langle\,${\itshape Frag 1}\nobreak\ {\footnotesize \NWlink{nuweb1f}{1f}}$\,\rangle$}\verb@@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtFileDefBy\ \NWlink{nuweb1a}{1a}\NWlink{nuweb1d}{d}\NWlink{nuweb1e}{e}\NWlink{nuweb2c}{, 2c}\NWlink{nuweb2e}{e}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap6}\raggedright\small
\NWtarget{nuweb1f}{} $\langle\,${\itshape Frag 1}\nobreak\ {\footnotesize {1f}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Second sector line one.@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb1e}{1e}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}

{\small\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item $\langle\,$Frag 1\nobreak\ {\footnotesize \NWlink{nuweb1f}{1f}}$\,\rangle$ {\footnotesize {\NWtxtRefIn} \NWlink{nuweb1e}{1e}.}
\end{list}}

\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap7}\raggedright\small
\NWtarget{nuweb2a}{} $\langle\,${\itshape Frag 1}\nobreak\ {\footnotesize {2a}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Base sector line two.@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroDefBy\ \NWlink{nuweb1b}{1b}\NWlink{nuweb2a}{, 2a}\NWlink{nuweb2d}{d}.
\item \NWtxtMacroRefIn\ \NWlink{nuweb1a}{1a}\NWlink{nuweb2e}{, 2e}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}

\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap8}\raggedright\small
\NWtarget{nuweb2b}{} $\langle\,${\itshape Frag 1}\nobreak\ {\footnotesize {2b}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Third sector line one.@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb2c}{2c}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap9}\raggedright\small
\NWtarget{nuweb2c}{} \verb@"test.actual.c"@\nobreak\ {\footnotesize {2c}}$\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Use second local@\\
\mbox{}\verb@@\hbox{$\langle\,${\itshape Frag 1}\nobreak\ {\footnotesize \NWlink{nuweb2b}{2b}}$\,\rangle$}\verb@@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtFileDefBy\ \NWlink{nuweb1a}{1a}\NWlink{nuweb1d}{d}\NWlink{nuweb1e}{e}\NWlink{nuweb2c}{, 2c}\NWlink{nuweb2e}{e}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}

{\small\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item $\langle\,$Frag 1\nobreak\ {\footnotesize \NWlink{nuweb2b}{2b}}$\,\rangle$ {\footnotesize {\NWtxtRefIn} \NWlink{nuweb2c}{2c}.}
\end{list}}

\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap10}\raggedright\small
\NWtarget{nuweb2d}{} $\langle\,${\itshape Frag 1}\nobreak\ {\footnotesize {2d}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Base sector line three.@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroDefBy\ \NWlink{nuweb1b}{1b}\NWlink{nuweb2a}{, 2a}\NWlink{nuweb2d}{d}.
\item \NWtxtMacroRefIn\ \NWlink{nuweb1a}{1a}\NWlink{nuweb2e}{, 2e}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap11}\raggedright\small
\NWtarget{nuweb2e}{} \verb@"test.actual.c"@\nobreak\ {\footnotesize {2e}}$\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@ Last use in global@\\
\mbox{}\verb@@\hbox{$\langle\,${\itshape Frag 1}\nobreak\ {\footnotesize \NWlink{nuweb1b}{1b}, \ldots\ }$\,\rangle$}\verb@@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtFileDefBy\ \NWlink{nuweb1a}{1a}\NWlink{nuweb1d}{d}\NWlink{nuweb1e}{e}\NWlink{nuweb2c}{, 2c}\NWlink{nuweb2e}{e}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap12}\raggedright\small
\NWtarget{nuweb2f}{} $\langle\,${\itshape Frag 2}\nobreak\ {\footnotesize {2f}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Here is frag 2@\\
\mbox{}\verb@@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb1d}{1d}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}

{\small\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item $\langle\,$Frag 1\nobreak\ {\footnotesize \NWlink{nuweb1b}{1b}\NWlink{nuweb2a}{, 2a}\NWlink{nuweb2d}{d}}$\,\rangle$ {\footnotesize {\NWtxtRefIn} \NWlink{nuweb1a}{1a}\NWlink{nuweb2e}{, 2e}.
}
\end{list}}

{\small\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item $\langle\,$Frag 2\nobreak\ {\footnotesize \NWlink{nuweb2f}{2f}}$\,\rangle$ {\footnotesize {\NWtxtRefIn} \NWlink{nuweb1d}{1d}.}
\end{list}}
\end{document}
EOF

cat > test.expected.c <<"EOF"
 First use in global
Base sector line one.
Base sector line two.
Base sector line three.

Use first local
First sector line one.

Here is frag 2

Use second local
Second sector line one.

Use second local
Third sector line one.

 Last use in global
Base sector line one.
Base sector line two.
Base sector line three.

EOF

# [Add other files here.  Avoid any extra processing such as
# decompression until after demo has run.  If demo fails this script
# can save time by not decompressing. ]

$bin/nuweb test.w
if test $? -ne 0 ; then fail; fi

latex test
if test $? -ne 0 ; then fail; fi

$bin/nuweb test.w
if test $? -ne 0 ; then fail; fi

latex test
if test $? -ne 0 ; then fail; fi

diff -a --context test.expected.tex test.tex
if test $? -ne 0 ; then fail; fi

diff -a --context test.expected.c test.actual.c
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

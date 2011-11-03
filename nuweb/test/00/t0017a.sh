#!/bin/sh
#
# $RCSfile: t0017a.sh,v $-- Test test/00/t0017a.sh
#
#
# Test of quoted scraps
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
	echo "FAILED test of quoted scraps" 1>&2
	cd $here
        rm -rf $work
	exit 1
}
no_result()
{
	set +x
	echo "NO RESULT for test of quoted scraps" 1>&2
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
# test quoted scraps
#

cat > test.w <<"EOF"
\documentclass{article}
\begin{document}
@o test.c -cc
@{Test of quoted fragments.
   @<Insert first fragment@>
   @<Insert second fragment@>
   @<Insert third fragment@>
   @<Insert parameter @'whatsit@'...@>
End of test.
@}

@d Insert first fragment
@{This fragment is not quoted.
   @<Insert unquoted fragment@>
   @<Insert quoted fragment@>
   @<Insert parameter @'1@'...@>
   @<Insert param...@>
End of first fragment.@}

@q Insert second fragment
@{This fragment is quoted.
   @<Insert unquoted fragment@>
   @<Insert quoted fragment@>
   @<Insert parameter @'2@'...@>
   @<Insert param...@>
End of second fragment.@}

@d Insert third fragment
@{This fragment is not quoted.
   @<Insert unquoted fragment@>
   @<Insert quoted fragment@>
   @<Insert parameter @'3@'...@>
   @<Insert param...@>
End of third fragment.@}

@d Insert unquoted fragment
@{This fragment in file @f is not quoted@}

@q Insert quoted fragment
@{This fragment in file @f is quoted@}

@d Insert parameter @'thing@' fragment
@{Here >>@1<< is the parameter@}

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
\mbox{}\verb@Test of quoted fragments.@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Insert first fragment}\nobreak\ {\footnotesize \NWlink{nuweb1b}{1b}}$\,\rangle$}\verb@@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Insert second fragment}\nobreak\ {\footnotesize \NWlink{nuweb1c}{1c}}$\,\rangle$}\verb@@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Insert third fragment}\nobreak\ {\footnotesize \NWlink{nuweb1d}{1d}}$\,\rangle$}\verb@@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Insert parameter \verb@whatsit@ fragment}\nobreak\ {\footnotesize \NWlink{nuweb2b}{2b}}$\,\rangle$}\verb@@\\
\mbox{}\verb@End of test.@\\
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
\NWtarget{nuweb1b}{} $\langle\,${\itshape Insert first fragment}\nobreak\ {\footnotesize {1b}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@This fragment is not quoted.@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Insert unquoted fragment}\nobreak\ {\footnotesize \NWlink{nuweb1e}{1e}}$\,\rangle$}\verb@@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Insert quoted fragment}\nobreak\ {\footnotesize \NWlink{nuweb2a}{2a}}$\,\rangle$}\verb@@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Insert parameter \verb@1@ fragment}\nobreak\ {\footnotesize \NWlink{nuweb2b}{2b}}$\,\rangle$}\verb@@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Insert parameter \verb@thing@ fragment}\nobreak\ {\footnotesize \NWlink{nuweb2b}{2b}}$\,\rangle$}\verb@@\\
\mbox{}\verb@End of first fragment.@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb1a}{1a}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap3}\raggedright\small
\NWtarget{nuweb1c}{} $\langle\,${\itshape Insert second fragment}\nobreak\ {\footnotesize {1c}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@This fragment is quoted.@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Insert unquoted fragment}\nobreak\ {\footnotesize \NWlink{nuweb1e}{1e}}$\,\rangle$}\verb@@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Insert quoted fragment}\nobreak\ {\footnotesize \NWlink{nuweb2a}{2a}}$\,\rangle$}\verb@@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Insert parameter \verb@2@ fragment}\nobreak\ {\footnotesize \NWlink{nuweb2b}{2b}}$\,\rangle$}\verb@@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Insert parameter \verb@thing@ fragment}\nobreak\ {\footnotesize \NWlink{nuweb2b}{2b}}$\,\rangle$}\verb@@\\
\mbox{}\verb@End of second fragment.@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb1a}{1a}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap4}\raggedright\small
\NWtarget{nuweb1d}{} $\langle\,${\itshape Insert third fragment}\nobreak\ {\footnotesize {1d}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@This fragment is not quoted.@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Insert unquoted fragment}\nobreak\ {\footnotesize \NWlink{nuweb1e}{1e}}$\,\rangle$}\verb@@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Insert quoted fragment}\nobreak\ {\footnotesize \NWlink{nuweb2a}{2a}}$\,\rangle$}\verb@@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Insert parameter \verb@3@ fragment}\nobreak\ {\footnotesize \NWlink{nuweb2b}{2b}}$\,\rangle$}\verb@@\\
\mbox{}\verb@   @\hbox{$\langle\,${\itshape Insert parameter \verb@thing@ fragment}\nobreak\ {\footnotesize \NWlink{nuweb2b}{2b}}$\,\rangle$}\verb@@\\
\mbox{}\verb@End of third fragment.@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb1a}{1a}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap5}\raggedright\small
\NWtarget{nuweb1e}{} $\langle\,${\itshape Insert unquoted fragment}\nobreak\ {\footnotesize {1e}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@This fragment in file @\hbox{\sffamily\slshape file name}\verb@ is not quoted@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb1b}{1b}\NWlink{nuweb1c}{c}\NWlink{nuweb1d}{d}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap6}\raggedright\small
\NWtarget{nuweb2a}{} $\langle\,${\itshape Insert quoted fragment}\nobreak\ {\footnotesize {2a}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@This fragment in file @\hbox{\sffamily\slshape file name}\verb@ is quoted@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb1b}{1b}\NWlink{nuweb1c}{c}\NWlink{nuweb1d}{d}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\begin{flushleft} \small
\begin{minipage}{\linewidth}\label{scrap7}\raggedright\small
\NWtarget{nuweb2b}{} $\langle\,${\itshape Insert parameter \hbox{\slshape\sffamily thing\/} fragment}\nobreak\ {\footnotesize {2b}}$\,\rangle\equiv$
\vspace{-1ex}
\begin{list}{}{} \item
\mbox{}\verb@Here >>@\hbox{\slshape\sffamily thing\/}\verb@<< is the parameter@{\NWsep}
\end{list}
\vspace{-1.5ex}
\footnotesize
\begin{list}{}{\setlength{\itemsep}{-\parsep}\setlength{\itemindent}{-\leftmargin}}
\item \NWtxtMacroRefIn\ \NWlink{nuweb1a}{1a}\NWlink{nuweb1b}{b}\NWlink{nuweb1c}{c}\NWlink{nuweb1d}{d}.

\item{}
\end{list}
\end{minipage}\vspace{4ex}
\end{flushleft}
\end{document}
EOF

cat > test.expected.c <<"EOF"
Test of quoted fragments.
   /* Insert first fragment */
   This fragment is not quoted.
      /* Insert unquoted fragment */
      This fragment in file test.c is not quoted
      /* Insert quoted fragment */
      This fragment in file @f is quoted
      /* Insert parameter '1' fragment */
      Here >>1<< is the parameter
      /* Insert parameter 'thing' fragment */
      Here >>thing<< is the parameter
   End of first fragment.
   /* Insert second fragment */
   This fragment is quoted.
      @<Insert unquoted fragment@>
      @<Insert quoted fragment@>
      @<Insert parameter @'2@' fragment@>
      @<Insert parameter @'thing@' fragment@>
   End of second fragment.
   /* Insert third fragment */
   This fragment is not quoted.
      /* Insert unquoted fragment */
      This fragment in file test.c is not quoted
      /* Insert quoted fragment */
      This fragment in file @f is quoted
      /* Insert parameter '3' fragment */
      Here >>3<< is the parameter
      /* Insert parameter 'thing' fragment */
      Here >>thing<< is the parameter
   End of third fragment.
   /* Insert parameter 'whatsit' fragment */
   Here >>whatsit<< is the parameter
End of test.
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

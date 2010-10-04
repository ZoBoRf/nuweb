#!/bin/sh
#
# $RCSfile: t0006a.sh,v $-- Test test/00/t0006a.sh
#
#
# Test of cross-reference flag
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
	echo "FAILED test of cross-reference flag" 1>&2
	cd $here
	rm -rf $work
	exit 1
}
no_result()
{
	set +x
	echo "NO RESULT for test of cross-reference flag" 1>&2
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
# test cross-reference flag
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

cat > test.expected.c <<"EOF"
Call the macro
   /* Fragment with <A macro argument> as parameter 1b */
   /* A macro argument 1e */
   Hello folks<<<Here 'tis.
   That argument was at the beginning of the fragment
   /* Second frag with <A macro argument> as parameter 1c */
   Here is the beginning of the second macro
   /* A macro argument 1e */
   Hello folks<<<That is the argument
   And this is the end of the second frag
   /* Third frag with <A macro argument> as parameter 1d */
   Here is the argument>>>Hello folks<<<That was it.
EOF

# [Add other files here.  Avoid any extra processing such as
# decompression until after demo has run.  If demo fails this script
# can save time by not decompressing. ]

$bin/nuweb -x test.w
if test $? -ne 0 ; then fail; fi

latex test

$bin/nuweb -x test.w
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

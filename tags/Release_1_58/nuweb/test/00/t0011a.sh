#!/bin/sh
#
# $RCSfile: t0011a.sh,v $-- Test test/00/t0011a.sh
#
#
# Test that unimpemented fragments are indented
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
	echo "FAILED test that unimpemented fragments are indented" 1>&2
	cd $here
	rm -rf $work
	exit 1
}
no_result()
{
	set +x
	echo "NO RESULT for test that unimpemented fragments are indented" 1>&2
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
@o test.c
@{Begin
   @<Implemented fragment@>
End
@}

@d Impl...
@{@<Unimplemented fragment A@>
@<Unimplemented fragment B@>
@<Unimplemented fragment C@>@}

\end{document}
EOF

cat > test.expected.c <<"EOF"
Begin
   @<Unimplemented fragment A@>
   @<Unimplemented fragment B@>
   @<Unimplemented fragment C@>
End
EOF

# [Add other files here.  Avoid any extra processing such as
# decompression until after demo has run.  If demo fails this script
# can save time by not decompressing. ]

$bin/nuweb test.w
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

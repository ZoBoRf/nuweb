#!/bin/sh
#
# $RCSfile: t0019a.sh,v $-- Test test/00/t0019a.sh
#
#
# Test of C++ comments
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
	echo "FAILED test of C++ comments" 1>&2
	cd $here
	rm -rf $work
	exit 1
}
no_result()
{
	set +x
	echo "NO RESULT for test of C++ comments" 1>&2
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
# test C++ comments
#

cat > test.w <<"EOF"
\documentclass{article}
\begin{document}
This tests C++ style comments.
@o test.cpp -c+
@{@<File header@>
@<More stuff@>
@<A little more stuff@>
@}

@d File header
@{// The comments here are explicit.
// @f
@}

@c
Here we have a lot of stuff that is going to go into a block
comment which we make long enough to spread over several lines.
Here we have a lot of stuff that is going to go into a block
comment which we make long enough to spread over several lines.
Here we have a lot of stuff that is going to go into a block
comment which we make long enough to spread over several lines.
Here we have a lot of stuff that is going to go into a block
comment which we make long enough to spread over several lines.
Here we have a lot of stuff that is going to go into a block
comment which we make long enough to spread over several lines.
Here we have a lot of stuff that is going to go into a block
comment which we make long enough to spread over several lines.
@d More stuff
@{@c
This is the body of more stuff.
@}

@d A little more stuff
@{Another check on a single-line comment.
   And another check on block comments.
   @<More stuff@>
That is the end of a little more stuff.
@}
\end{document}
EOF

cat > test.expected.cpp <<"EOF"
// File header
// The comments here are explicit.
// test.cpp

// More stuff
// Here we have a lot of stuff that is going to go into a block
// comment which we make long enough to spread over several lines.
// Here we have a lot of stuff that is going to go into a block
// comment which we make long enough to spread over several lines.
// Here we have a lot of stuff that is going to go into a block
// comment which we make long enough to spread over several lines.
// Here we have a lot of stuff that is going to go into a block
// comment which we make long enough to spread over several lines.
// Here we have a lot of stuff that is going to go into a block
// comment which we make long enough to spread over several lines.
// Here we have a lot of stuff that is going to go into a block
// comment which we make long enough to spread over several lines.

This is the body of more stuff.

// A little more stuff
Another check on a single-line comment.
   And another check on block comments.
   // More stuff
   // Here we have a lot of stuff that is going to go into a block
   // comment which we make long enough to spread over several
   // lines. Here we have a lot of stuff that is going to go into
   // a block comment which we make long enough to spread over
   // several lines. Here we have a lot of stuff that is going
   // to go into a block comment which we make long enough to
   // spread over several lines. Here we have a lot of stuff that
   // is going to go into a block comment which we make long enough
   // to spread over several lines. Here we have a lot of stuff
   // that is going to go into a block comment which we make long
   // enough to spread over several lines. Here we have a lot
   // of stuff that is going to go into a block comment which
   // we make long enough to spread over several lines. 
   This is the body of more stuff.
   
That is the end of a little more stuff.

EOF

# [Add other files here.  Avoid any extra processing such as
# decompression until after demo has run.  If demo fails this script
# can save time by not decompressing. ]

$bin/nuweb test.w
if test $? -ne 0 ; then fail; fi

diff -a --context test.expected.cpp test.cpp
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

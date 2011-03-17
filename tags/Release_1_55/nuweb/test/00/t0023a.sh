#!/bin/sh
#
# $RCSfile: t0023a.sh,v $-- Test test/00/t0023a.sh
#
#
# Test Perl comments
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
	echo "FAILED test Perl comments" 1>&2
	cd $here
	rm -rf $work
	exit 1
}
no_result()
{
	set +x
	echo "NO RESULT for test Perl comments" 1>&2
	cd $here
	rm -rf $work
	exit 2
}
trap \"no_result\" 1 2 3 15

mkdir $work
if test $? -ne 0 ; then no_result; fi
cd $work
if test $? -ne 0 ; then no_result; fi


cat > test.w <<"EOF"
\documentclass{article}
\begin{document}
@c
Here is a block comment that takes many lines.
Here is a block comment that takes many lines.
Here is a block comment that takes many lines.
Here is a block comment that takes many lines.
@o test -cp
@{@<First stuff@>
Now a block comment.
@c
@<Second stuff@>
End
@}

@d First...
@{This is the body of first stuff.
@}

@d Second...
@{Yes, it's the second stuff.
@}
\end{document}
EOF

cat > test.expected <<"EOF"
# First stuff
This is the body of first stuff.

Now a block comment.
# Here is a block comment that takes many lines. Here is a block
# comment that takes many lines. Here is a block comment that
# takes many lines. Here is a block comment that takes many lines.

# Second stuff
Yes, it's the second stuff.

End
EOF

# [Add other files here.  Avoid any extra processing such as
# decompression until after demo has run.  If demo fails this script
# can save time by not decompressing. ]

$bin/nuweb test.w
if test $? -ne 0 ; then fail; fi

diff -a --context test.expected test
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

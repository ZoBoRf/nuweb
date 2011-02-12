#!/bin/sh
#
# $RCSfile: t0026a.sh,v $-- Test test/00/t0026a.sh
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
@{@<Frag 3@>
@}
@q Frag 3
@{Use first local
@<Frag 1@>
@<+ Frag 2@>
@}
@m
@S
@d Frag 1
@{Base sector line two.
@}
@d+ Frag 2
@{Here is frag 2
@}
@m
@m+
\end{document}
EOF

cat > test.expected.c <<"EOF"
 First use in global
Base sector line one.
Base sector line two.

Use first local
@<Frag 1@>
@<+Frag 2@>

EOF

# [Add other files here.  Avoid any extra processing such as
# decompression until after demo has run.  If demo fails this script
# can save time by not decompressing. ]

$bin/nuweb test.w
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

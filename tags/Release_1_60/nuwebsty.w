% nuwebsty.w -- styles for use with nuweb
% (c) 2001 Javier Goizueta

\documentclass{report}

%\usepackage{html}

\title{Nuweb Redefinitions}
\date{}
\author{Javier Goizueta}

\begin{document}

I've changed \verb|nuweb| to use macros instead of
some fixed strings. The modified \verb|nuweb| inserts
default values of those macros at the beginning of
the produced \LaTeX\ file.
The macros I've introduced and their default values are as follows.
\begin{itemize}
\item
\verb|\NWtarget| has two arguments just like \verb|hyperref|'s
\verb|\hypertarget| and by default simply places the second argument
in the output. It's used as a placeholder to introduce hyperlinks.
\item
\verb|\NWlink| has two arguments just like \verb|hyperref|'s
\verb|\hyperlink| and by default simply places the second argument in
the output. It's used as a placeholder to introduce hyper links.
\item
\verb|\NWtxtMacroDefBy| its default value is the string ``Macro defined by''
and it's used to replace that string in other languages.
\item
\verb|\NWtxtMacroRefIn| its default value is the string ``Macro referenced in''
and it's used to replace that string in other languages.
\item
\verb|\NWtxtMacroNoRef| its default value is the string ``Macro never referenced''
and it's used to replace that string in other languages.
\item
\verb|\NWtxtDefBy| its default value is the string ``Defined by''
and it's used to replace that string in other languages.
\item
\verb|\NWtxtRefIn| its default value is the string ``Referenced in''
and it's used to replace that string in other languages.
\item
\verb|\NWtxtNoRef| its default value is the string ``Not referenced''
and it's used to replace that string in other languages.
\item
\verb|\NWtxtFileDefBy| its default value is the string ``File defined by''
and it's used to replace that string in other languages.
\item
\verb|\NWsep| is used as an end marker for scraps; its default value is
\verb|$\Diamond $|.
\end{itemize}

These macros can be redefined in the \LaTeX\ file to adapt
the output to the taste of the user. I define here two files
to redefine the macros to include hyper-links from the
\verb|hyper-ref| package in the documentation (which works for
example in pdf output) in english and spanish.
These files can be included with \verb|\usepackage| in the
documentation part.

Here's the english hyper-ref version:

@o nwhren.sty
@{% nwhren.sty -- nuweb macros for hyperref in english
@<Hyper-ref macros@>
@}

@d Hyper-ref macros
@{@%
\renewcommand{\NWtarget}[2]{\hypertarget{#1}{#2}}
\renewcommand{\NWlink}[2]{\hyperlink{#1}{#2}}
@}

For the spanish version I'm using the spanish \emph{fragmento} ---whose meaning
is close to ``scrap''--- for the term ``macro''.
I like this but many spanish people involved with computer science use \emph{macro}
itself in spanish.

@o nwhres.sty
@{% nwhres.sty -- nuweb macros for hyperref in spanish
@<Hyper-ref macros@>
\renewcommand{\NWtxtMacroDefBy}{Fragmento definido en} % Macro defined by
\renewcommand{\NWtxtMacroRefIn}{Fragmento usado en}    % Macro referenced in
\renewcommand{\NWtxtMacroNoRef}{Fragmento no usado}    % Macro never referenced
\renewcommand{\NWtxtDefBy}{Definido en}                % Defined by
\renewcommand{\NWtxtRefIn}{Usado en}                   % Referenced in
\renewcommand{\NWtxtNoRef}{No usado}                   % Not referenced
\renewcommand{\NWtxtFileDefBy}{Archivo definido en}    % File defined by
@}

\end{document}

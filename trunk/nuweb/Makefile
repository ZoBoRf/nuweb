CC = cc

CFLAGS = -g

TARGET = nuweb
VERSION = 1.0b1

OBJS = main.o pass1.o latex.o html.o output.o input.o scraps.o names.o \
	arena.o global.o

SRCS = main.c pass1.c latex.c html.c output.c input.c scraps.c names.c \
	arena.c global.c

HDRS = global.h

DIST = Makefile README *.bib *.sty nuweb.w nuwebsty.w \
		$(TARGET)doc.tex $(SRCS) $(HDRS)
 

.SUFFIXES: .dvi .tex .w .hw

.w.tex:
	nuweb $*.w

.hw.tex:
	nuweb $*.hw

.tex.dvi:
	latex ./$*.tex

.w.dvi:
	nuweb $*.w
	latex ./$*.tex

all:
	$(MAKE) $(TARGET).tex
	$(MAKE) $(TARGET)

shar:	$(TARGET)doc.tex
	shar $(DIST) > $(TARGET)$(VERSION).sh

tar:	$(TARGET)doc.tex
	tar -cf $(TARGET)$(VERSION).tar $(DIST)

distribution: all shar tar nuwebhtml nuwebdoc 

nuwebdoc: nuwebdoc.tex
	-latex nuwebdoc
	-bibtex nuwebdoc
	-latex nuwebdoc
	dvips nuwebdoc
	latex2html -split 0 nuwebdoc.tex

nuwebhtml: nuweb
	sed -e 's/%\\usepackage{html}/\\usepackage{html}/' < nuweb.w > nuwebhtml.hw
	nuweb nuwebhtml.hw
	-latex nuwebhtml.tex
	-bibtex nuwebhtml
	-nuweb nuwebhtml.hw
	-latex nuwebhtml.tex
	latex2html -split 0 nuwebhtml.tex
	
$(TARGET)doc.tex:	$(TARGET).tex
	sed -e '/^\\ifshowcode$$/,/^\\fi$$/d' $(TARGET).tex > $@

check: nuweb
	@declare -i n=0; \
        declare -i f=0; \
	for i in test/*/*.sh ; do \
	echo "Testing $$i"; \
	sh $$i; \
	if test $$? -ne 0; \
	then echo "         $$i failed" ; \
	f+=1; \
	fi; \
	n+=1; \
	done; \
        echo "$$n done"; \
        echo "$$f failed"

clean:
	-rm -f *.o *.tex *.log *.dvi *~ *.blg *.lint

veryclean:
	-rm -f *.o *.c *.h *.tex *.log *.dvi *~ *.blg *.lint

view:	$(TARGET).dvi
	xdvi $(TARGET).dvi

print:	$(TARGET).dvi
	lpr -d $(TARGET).dvi

lint:	
	lint $(SRCS) > nuweb.lint

$(OBJS): global.h

$(TARGET): $(OBJS)
	$(CC) -o $(TARGET) $(OBJS)

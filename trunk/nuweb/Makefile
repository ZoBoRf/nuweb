CC = cc

CFLAGS = -g

TARGET = nuweb
VERSION = 1.58

OBJS = main.o pass1.o latex.o html.o output.o input.o scraps.o names.o \
	arena.o global.o

SRCS = main.c pass1.c latex.c html.c output.c input.c scraps.c names.c \
	arena.c global.c

HDRS = global.h

BIBS = litprog.bib master.bib misc.bib

STYS = bibnames.sty html.sty

DIST = Makefile README nuweb.w nuwebsty.w test htdocs nuweb.el \
	$(TARGET)doc.tex $(SRCS) $(HDRS) $(BIBS) $(STYS)

%.tex: %.w
	nuweb -r $<

%: %.tex
	latex2html -split 0 $<

%.hw: %.w
	cp $< $@

%.dvi: %.tex
	latex $<

%.pdf: %.tex
	pdflatex $<

all:
	$(MAKE) $(TARGET).tex
	$(MAKE) $(TARGET)

tar: $(TARGET)doc.tex
	mkdir $(TARGET)-$(VERSION)
	cp -R $(DIST) $(TARGET)-$(VERSION)
	tar -zcf $(TARGET)-$(VERSION).tar.gz $(TARGET)-$(VERSION)
	rm -rf $(TARGET)-$(VERSION)

distribution: all tar nuweb.pdf nuwebdoc.pdf

$(TARGET)doc.tex: $(TARGET).tex
	sed -e '/^\\ifshowcode$$/,/^\\fi$$/d' $< > $@

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

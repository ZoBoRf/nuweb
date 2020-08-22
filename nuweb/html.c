#include "global.h"
static int scraps = 1;
int extra_scraps;
static void copy_scrap();               /* formats the body of a scrap */
static void display_scrap_ref();        /* formats a scrap reference */
static void display_scrap_numbers();    /* formats a list of scrap numbers */
static void print_scrap_numbers();      /* pluralizes scrap formats list */
static void format_entry();             /* formats an index entry */
static void format_file_entry();        /* formats a file index entry */
static void format_user_entry();
void write_html(file_name, html_name)
     char *file_name;
     char *html_name;
{
  FILE *html_file = fopen(html_name, "w");
  FILE *tex_file = html_file;
  if (hyperref_flag) {
     fputs("\\newcommand{\\NWtarget}[2]{\\hypertarget{#1}{#2}}\n", tex_file);
     fputs("\\newcommand{\\NWlink}[2]{\\hyperlink{#1}{#2}}\n", tex_file);
  } else {
     fputs("\\newcommand{\\NWtarget}[2]{#2}\n", tex_file);
     fputs("\\newcommand{\\NWlink}[2]{#2}\n", tex_file);
  }
  fputs("\\newcommand{\\NWtxtMacroDefBy}{Fragment defined by}\n", tex_file);
  fputs("\\newcommand{\\NWtxtMacroRefIn}{Fragment referenced in}\n", tex_file);
  fputs("\\newcommand{\\NWtxtMacroNoRef}{Fragment never referenced}\n", tex_file);
  fputs("\\newcommand{\\NWtxtDefBy}{Defined by}\n", tex_file);
  fputs("\\newcommand{\\NWtxtRefIn}{Referenced in}\n", tex_file);
  fputs("\\newcommand{\\NWtxtNoRef}{Not referenced}\n", tex_file);
  fputs("\\newcommand{\\NWtxtFileDefBy}{File defined by}\n", tex_file);
  fputs("\\newcommand{\\NWtxtIdentsUsed}{Uses:}\n", tex_file);
  fputs("\\newcommand{\\NWtxtIdentsNotUsed}{Never used}\n", tex_file);
  fputs("\\newcommand{\\NWtxtIdentsDefed}{Defines:}\n", tex_file);
  fputs("\\newcommand{\\NWsep}{${\\diamond}$}\n", tex_file);
  fputs("\\newcommand{\\NWnotglobal}{(not defined globally)}\n", tex_file);
  fputs("\\newcommand{\\NWuseHyperlinks}{", tex_file);
  if (hyperoptions[0] != '\0')
  {
     fprintf(tex_file, "\\usepackage[%s]{hyperref}", hyperoptions);
  }
  fputs("}\n", tex_file);
  
  if (html_file) {
    if (verbose_flag)
      fprintf(stderr, "writing %s\n", html_name);
    source_open(file_name);
    {
      int c = source_get();
      while (c != EOF) {
        if (c == nw_char)
          {
            c = source_get();
            switch (c) {
              case 'r':
                    c = source_get();
                    nw_char = c;
                    update_delimit_scrap();
                    break;
              case 'O':
              case 'o': {
                          Name *name = collect_file_name();
                          {
                            fputs("\\begin{rawhtml}\n", html_file);
                            fputs("<pre>\n", html_file);
                          }
                            fputs("<a name=\"nuweb", html_file);
                            write_single_scrap_ref(html_file, scraps);
                            fprintf(html_file, "\"><code>\"%s\"</code> ", name->spelling);
                            write_single_scrap_ref(html_file, scraps);
                            fputs("</a> =\n", html_file);
                          
                          scraps++;
                          {
                            copy_scrap(html_file, TRUE);
                            fputs("&lt;&gt;</pre>\n", html_file);
                          }
                          {
                            if (name->defs->next) {
                              fputs("\\end{rawhtml}\\NWtxtFileDefBy\\begin{rawhtml} ", html_file);
                              print_scrap_numbers(html_file, name->defs);
                              fputs("<br>\n", html_file);
                            }
                          }
                          {
                            fputs("\\end{rawhtml}\n", html_file);
                            c = source_get(); /* Get rid of current at command. */
                          }
                        }
                        break;
              case 'Q':
              case 'q':
              case 'D':
              case 'd': {
                          Name *name = collect_macro_name();
                          {
                            fputs("\\begin{rawhtml}\n", html_file);
                            fputs("<pre>\n", html_file);
                          }
                            fputs("<a name=\"nuweb", html_file);
                            write_single_scrap_ref(html_file, scraps);
                            fputs("\">&lt;\\end{rawhtml}", html_file);
                            fputs(name->spelling, html_file);
                            fputs("\\begin{rawhtml} ", html_file);
                            write_single_scrap_ref(html_file, scraps);
                            fputs("&gt;</a> =\n", html_file);
                          
                          scraps++;
                          {
                            copy_scrap(html_file, TRUE);
                            fputs("&lt;&gt;</pre>\n", html_file);
                          }
                          {
                            if (name->defs->next) {
                              fputs("\\end{rawhtml}\\NWtxtMacroDefBy\\begin{rawhtml} ", html_file);
                              print_scrap_numbers(html_file, name->defs);
                              fputs("<br>\n", html_file);
                            }
                          }
                          {
                            if (name->uses) {
                              fputs("\\end{rawhtml}\\NWtxtMacroRefIn\\begin{rawhtml} ", html_file);
                              print_scrap_numbers(html_file, name->uses);
                            }
                            else {
                              fputs("\\end{rawhtml}{\\NWtxtMacroNoRef}.\\begin{rawhtml}", html_file);
                              fprintf(stderr, "%s: <%s> never referenced.\n",
                                      command_name, name->spelling);
                            }
                            fputs("<br>\n", html_file);
                          }
                          {
                            fputs("\\end{rawhtml}\n", html_file);
                            c = source_get(); /* Get rid of current at command. */
                          }
                        }
                        break;
              case 'f': {
                          if (file_names) {
                            fputs("\\begin{rawhtml}\n", html_file);
                            fputs("<dl compact>\n", html_file);
                            format_entry(file_names, html_file, TRUE);
                            fputs("</dl>\n", html_file);
                            fputs("\\end{rawhtml}\n", html_file);
                          }
                          c = source_get();
                        }
                        break;
              case 'm': {
                          if (macro_names) {
                            fputs("\\begin{rawhtml}\n", html_file);
                            fputs("<dl compact>\n", html_file);
                            format_entry(macro_names, html_file, FALSE);
                            fputs("</dl>\n", html_file);
                            fputs("\\end{rawhtml}\n", html_file);
                          }
                          c = source_get();
                        }
                        break;
              case 'u': {
                          if (user_names) {
                            fputs("\\begin{rawhtml}\n", html_file);
                            fputs("<dl compact>\n", html_file);
                            format_user_entry(user_names, html_file, 0/* Dummy */);
                            fputs("</dl>\n", html_file);
                            fputs("\\end{rawhtml}\n", html_file);
                          }
                          c = source_get();
                        }
                        break;
              default:
                    if (c==nw_char)
                      putc(c, html_file);
                    c = source_get();
                        break;
            }
          }
        else {
          putc(c, html_file);
          c = source_get();
        }
      }
    }
    fclose(html_file);
  }
  else
    fprintf(stderr, "%s: can't open %s\n", command_name, html_name);
}
static void display_scrap_ref(html_file, num)
     FILE *html_file;
     int num;
{
  fputs("<a href=\"#nuweb", html_file);
  write_single_scrap_ref(html_file, num);
  fputs("\">", html_file);
  write_single_scrap_ref(html_file, num);
  fputs("</a>", html_file);
}
static void display_scrap_numbers(html_file, scraps)
     FILE *html_file;
     Scrap_Node *scraps;
{
  display_scrap_ref(html_file, scraps->scrap);
  scraps = scraps->next;
  while (scraps) {
    fputs(", ", html_file);
    display_scrap_ref(html_file, scraps->scrap);
    scraps = scraps->next;
  }
}
static void print_scrap_numbers(html_file, scraps)
     FILE *html_file;
     Scrap_Node *scraps;
{
  display_scrap_numbers(html_file, scraps);
  fputs(".\n", html_file);
}
static void copy_scrap(file, prefix)
     FILE *file;
     int prefix;
{
  int indent = 0;
  int c = source_get();
  while (1) {
    switch (c) {
      case '<' : fputs("&lt;", file);
                 indent++;
                 break;
      case '>' : fputs("&gt;", file);
                 indent++;
                 break;
      case '&' : fputs("&amp;", file);
                 indent++;
                 break;
      case '\n': fputc(c, file);
                 indent = 0;
                 break;
      case '\t': {
                   int delta = 8 - (indent % 8);
                   indent += delta;
                   while (delta > 0) {
                     putc(' ', file);
                     delta--;
                   }
                 }
                 break;
      default:
         if (c==nw_char)
           {
             {
               c = source_get();
               switch (c) {
                 case '+':
                 case '-':
                 case '*':
                 case '|': {
                             do {
                               do
                                 c = source_get();
                               while (c != nw_char);
                               c = source_get();
                             } while (c != '}' && c != ']' && c != ')' );
                           }
                 case ',':
                 case '}':
                 case ']':
                 case ')': return;
                 case '_': {
                                static int toggle;
                                toggle = ~toggle;
                                if( toggle ) {
                                   fputs( "<b>", file );
                                } else {
                                   fputs( "</b>", file );
                                }
                           }
                           break;
                 case '1': case '2': case '3':
                 case '4': case '5': case '6':
                 case '7': case '8': case '9':
                           fputc(nw_char, file);
                           fputc(c,   file);
                           break;
                 case '<': {
                             Arglist * args = collect_scrap_name(-1);
                             Name *name = args->name;
                             fputs("&lt;\\end{rawhtml}", file);
                             fputs(name->spelling, file);
                             if (scrap_name_has_parameters) {
                               
                                  char sep;

                                  sep = '(';
                                  fputs("\\begin{rawhtml}", file);
                                  do {

                                    fputc(sep,file);

                                    fprintf(file, "%d <A NAME=\"#nuweb%d\"></A>", scraps, scraps);

                                    source_last = '{';
                                    copy_scrap(file, TRUE);

                                    ++scraps;
                                    sep = ',';

                                  } while ( source_last != ')' && source_last != EOF );
                                  fputs(" ) ",file);
                                  do
                                    c = source_get();
                                  while(c != nw_char && c != EOF);
                                  if (c == nw_char) {
                                    c = source_get();
                                  }
                                  fputs("\\end{rawhtml}", file);
                               
                             }
                             fputs("\\begin{rawhtml} ", file);
                             if (name->defs)
                               {
                                 Scrap_Node *p = name->defs;
                                 display_scrap_ref(file, p->scrap);
                                 if (p->next)
                                   fputs(", ... ", file);
                               }
                             else {
                               putc('?', file);
                               fprintf(stderr, "%s: never defined <%s>\n",
                                       command_name, name->spelling);
                             }
                             fputs("&gt;", file);
                           }
                           break;
                 case '%': {
                                   do
                                           c = source_get();
                                   while (c != '\n');
                           }
                           break;
                 default:
                      if (c==nw_char)
                        {
                          fputc(c, file);
                          break;
                        }
                       /* ignore these since pass1 will have warned about them */
                           break;
               }
             }
             break;
           }
         putc(c, file);
                 indent++;
                 break;
    }
    c = source_get();
  }
}
static void format_entry(name, html_file, file_flag)
     Name *name;
     FILE *html_file;
     int file_flag;
{
  while (name) {
    format_entry(name->llink, html_file, file_flag);
    {
      fputs("<dt> ", html_file);
      if (file_flag) {
        fprintf(html_file, "<code>\"%s\"</code>\n<dd> ", name->spelling);
        {
          fputs("\\end{rawhtml}\\NWtxtDefBy\\begin{rawhtml} ", html_file);
          print_scrap_numbers(html_file, name->defs);
        }
      }
      else {
        fputs("&lt;\\end{rawhtml}", html_file);
        fputs(name->spelling, html_file);
        fputs("\\begin{rawhtml} ", html_file);
        {
          if (name->defs)
            display_scrap_numbers(html_file, name->defs);
          else
            putc('?', html_file);
        }
        fputs("&gt;\n<dd> ", html_file);
        {
          Scrap_Node *p = name->uses;
          if (p) {
            fputs("\\end{rawhtml}\\NWtxtRefIn\\begin{rawhtml} ", html_file);
            print_scrap_numbers(html_file, p);
          }
          else
            fputs("\\end{rawhtml}{\\NWtxtNoRef}.\\begin{rawhtml}", html_file);
        }
      }
      putc('\n', html_file);
    }
    name = name->rlink;
  }
}
static void format_user_entry(name, html_file, sector)
     Name *name;
     FILE *html_file;
     int sector;
{
  while (name) {
    format_user_entry(name->llink, html_file, sector);
    {
      Scrap_Node *uses = name->uses;
      if (uses) {
        Scrap_Node *defs = name->defs;
        fprintf(html_file, "<dt><code>%s</code>:\n<dd> ", name->spelling);
        if (uses->scrap < defs->scrap) {
          display_scrap_ref(html_file, uses->scrap);
          uses = uses->next;
        }
        else {
          if (defs->scrap == uses->scrap)
            uses = uses->next;
          fputs("<strong>", html_file);
          display_scrap_ref(html_file, defs->scrap);
          fputs("</strong>", html_file);
          defs = defs->next;
        }
        while (uses || defs) {
          fputs(", ", html_file);
          if (uses && (!defs || uses->scrap < defs->scrap)) {
            display_scrap_ref(html_file, uses->scrap);
            uses = uses->next;
          }
          else {
            if (uses && defs->scrap == uses->scrap)
              uses = uses->next;
            fputs("<strong>", html_file);
            display_scrap_ref(html_file, defs->scrap);
            fputs("</strong>", html_file);
            defs = defs->next;
          }
        }
        fputs(".\n", html_file);
      }
    }
    name = name->rlink;
  }
}

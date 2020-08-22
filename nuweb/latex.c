#include "global.h"
static int scraps = 1;
int extra_scraps;
static void copy_scrap();             /* formats the body of a scrap */
static void print_scrap_numbers();      /* formats a list of scrap numbers */
static void format_entry();             /* formats an index entry */
static void format_file_entry();        /* formats a file index entry */
static void format_user_entry();
static void write_arg();
static void write_literal();
static void write_ArglistElement();
void write_tex(file_name, tex_name, sector)
     char *file_name;
     char *tex_name;
     unsigned char sector;
{
  FILE *tex_file = fopen(tex_name, "w");
  if (tex_file) {
    if (verbose_flag)
      fprintf(stderr, "writing %s\n", tex_name);
    source_open(file_name);
    /* Write LaTeX limbo definitions */
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
       /* Write the hyperlink usage macro */
       fprintf(tex_file, "\\usepackage[%s]{hyperref}", hyperoptions);
    }
    fputs("}\n", tex_file);
    
    /* Copy \verb|source_file| into \verb|tex_file| */
    {
      int inBlock = FALSE;
      int c = source_get();
      while (c != EOF) {
        if (c == nw_char)
          {
          /* Interpret at-sequence */
          {
            int big_definition = FALSE;
            c = source_get();
            switch (c) {
              case 'r':
                    c = source_get();
                    nw_char = c;
                    update_delimit_scrap();
                    break;
              case 'O': big_definition = TRUE;
              case 'o': {
                          Name *name = collect_file_name();
                          int first;
                          /* Begin the scrap environment */
                          {
                            if (big_definition)
                            {
                              if (inBlock)
                              {
                                 /* End block */
                                 fputs("\\end{minipage}\\vspace{4ex}\n",  tex_file);
                                 fputs("\\end{flushleft}\n", tex_file);
                                 inBlock = FALSE;
                              }
                              fputs("\\begin{flushleft} \\small", tex_file);
                            }
                            else
                            {
                              if (inBlock)
                              {
                                 /* Switch block */
                                 fputs("\\par\\vspace{\\baselineskip}\n",  tex_file);
                              }
                              else
                              {
                                 /* Start block */
                                 fputs("\\begin{flushleft} \\small\n\\begin{minipage}{\\linewidth}", tex_file);
                                 inBlock = TRUE;
                              }
                            }
                            fprintf(tex_file, "\\label{scrap%d}\\raggedright\\small\n", scraps);
                          }
                          fputs("\\NWtarget{nuweb", tex_file);
                          first = is_first_scrap(name, scraps);
                          write_single_scrap_ref(tex_file, scraps);
                          fputs("}{} ", tex_file);
                          fprintf(tex_file, "\\verb%c\"%s\"%c\\nobreak\\ {\\footnotesize {", nw_char, name->spelling, nw_char);
                          write_single_scrap_ref(tex_file, scraps);
                          if (first)
                            fputs("}}$\\,\\equiv$\n", tex_file);
                          else
                            fputs("}}$\\,\\mathrel+\\equiv$\n", tex_file);
                          /* Fill in the middle of the scrap environment */
                          {
                            fputs("\\vspace{-1ex}\n\\begin{list}{}{} \\item\n", tex_file);
                            extra_scraps = 0;
                            copy_scrap(tex_file, TRUE, name);
                            fputs("{\\NWsep}\n\\end{list}\n", tex_file);
                          }
                          /* Begin the cross-reference environment */
                          {
                            fputs("\\vspace{-1.5ex}\n", tex_file);
                            fputs("\\footnotesize\n", tex_file);
                            fputs("\\begin{list}{}{\\setlength{\\itemsep}{-\\parsep}",
                              tex_file);
                            fputs("\\setlength{\\itemindent}{-\\leftmargin}}\n", tex_file);}
                          
                          if ( scrap_flag ) {
                            /* Write file defs */
                            {
                              if (name->defs) {
                                if (name->defs->next) {
                                  fputs("\\item \\NWtxtFileDefBy\\ ", tex_file);
                                  print_scrap_numbers(tex_file, name->defs);
                                }
                              } else {
                                fprintf(stderr,
                                        "would have crashed in 'Write file defs' for '%s'\n",
                                         name->spelling);
                              }
                            }
                          }
                          format_defs_refs(tex_file, scraps);
                          format_uses_refs(tex_file, scraps++);
                          /* Finish the cross-reference environment */
                          {
                            fputs("\n\\item{}", tex_file);
                            fputs("\n\\end{list}\n", tex_file);
                          }
                          /* Finish the scrap environment */
                          {
                            scraps += extra_scraps;
                            if (big_definition)
                              fputs("\\vspace{4ex}\n\\end{flushleft}\n", tex_file);
                            else
                            {
                               /* End block */
                               fputs("\\end{minipage}\\vspace{4ex}\n",  tex_file);
                               fputs("\\end{flushleft}\n", tex_file);
                               inBlock = FALSE;
                            }
                            do
                              c = source_get();
                            while (isspace(c));
                          }
                        }
                        break;
              case 'Q':
              case 'D': big_definition = TRUE;
              case 'q':
              case 'd': {
                          Name *name = collect_macro_name();
                          int first;

                          /* Begin the scrap environment */
                          {
                            if (big_definition)
                            {
                              if (inBlock)
                              {
                                 /* End block */
                                 fputs("\\end{minipage}\\vspace{4ex}\n",  tex_file);
                                 fputs("\\end{flushleft}\n", tex_file);
                                 inBlock = FALSE;
                              }
                              fputs("\\begin{flushleft} \\small", tex_file);
                            }
                            else
                            {
                              if (inBlock)
                              {
                                 /* Switch block */
                                 fputs("\\par\\vspace{\\baselineskip}\n",  tex_file);
                              }
                              else
                              {
                                 /* Start block */
                                 fputs("\\begin{flushleft} \\small\n\\begin{minipage}{\\linewidth}", tex_file);
                                 inBlock = TRUE;
                              }
                            }
                            fprintf(tex_file, "\\label{scrap%d}\\raggedright\\small\n", scraps);
                          }
                          fputs("\\NWtarget{nuweb", tex_file);
                          first = is_first_scrap(name, scraps);
                          write_single_scrap_ref(tex_file, scraps);
                          fputs("}{} $\\langle\\,${\\itshape ", tex_file);
                          /* Write the macro's name */
                          {
                            char * p = name->spelling;
                            int i = 0;

                            while (*p != '\000') {
                              if (*p == ARG_CHR) {
                                write_arg(tex_file, name->arg[i++]);
                                p++;
                              }
                              else
                                 fputc(*p++, tex_file);
                            }
                          }
                          fputs("}\\nobreak\\ {\\footnotesize {", tex_file);
                          write_single_scrap_ref(tex_file, scraps);
                          if (first)
                            fputs("}}$\\,\\rangle\\equiv$\n", tex_file);
                          else
                            fputs("}}$\\,\\rangle\\,\\mathrel+\\equiv$\n", tex_file);
                          /* Fill in the middle of the scrap environment */
                          {
                            fputs("\\vspace{-1ex}\n\\begin{list}{}{} \\item\n", tex_file);
                            extra_scraps = 0;
                            copy_scrap(tex_file, TRUE, name);
                            fputs("{\\NWsep}\n\\end{list}\n", tex_file);
                          }
                          /* Begin the cross-reference environment */
                          {
                            fputs("\\vspace{-1.5ex}\n", tex_file);
                            fputs("\\footnotesize\n", tex_file);
                            fputs("\\begin{list}{}{\\setlength{\\itemsep}{-\\parsep}",
                              tex_file);
                            fputs("\\setlength{\\itemindent}{-\\leftmargin}}\n", tex_file);}
                          
                          /* Write macro defs */
                          {
                            if (name->defs->next) {
                              fputs("\\item \\NWtxtMacroDefBy\\ ", tex_file);
                              print_scrap_numbers(tex_file, name->defs);
                            }
                          }
                          /* Write macro refs */
                          {
                            if (name->uses) {
                              if (name->uses->next) {
                                fputs("\\item \\NWtxtMacroRefIn\\ ", tex_file);
                                print_scrap_numbers(tex_file, name->uses);
                              }
                              else {
                                fputs("\\item \\NWtxtMacroRefIn\\ ", tex_file);
                                fputs("\\NWlink{nuweb", tex_file);
                                write_single_scrap_ref(tex_file, name->uses->scrap);
                                fputs("}{", tex_file);
                                write_single_scrap_ref(tex_file, name->uses->scrap);
                                fputs("}", tex_file);
                                fputs(".\n", tex_file);
                              }
                            }
                            else {
                              fputs("\\item {\\NWtxtMacroNoRef}.\n", tex_file);
                              fprintf(stderr, "%s: <%s> never referenced.\n",
                                      command_name, name->spelling);
                            }
                          }
                          format_defs_refs(tex_file, scraps);
                          format_uses_refs(tex_file, scraps++);
                          /* Finish the cross-reference environment */
                          {
                            fputs("\n\\item{}", tex_file);
                            fputs("\n\\end{list}\n", tex_file);
                          }
                          /* Finish the scrap environment */
                          {
                            scraps += extra_scraps;
                            if (big_definition)
                              fputs("\\vspace{4ex}\n\\end{flushleft}\n", tex_file);
                            else
                            {
                               /* End block */
                               fputs("\\end{minipage}\\vspace{4ex}\n",  tex_file);
                               fputs("\\end{flushleft}\n", tex_file);
                               inBlock = FALSE;
                            }
                            do
                              c = source_get();
                            while (isspace(c));
                          }
                        }
                        break;
              case 's':
                        /* Step to next sector */
                        
                        prev_sector += 1;
                        current_sector = prev_sector;
                        c = source_get();
                        
                        break;
              case 'S':
                        /* Close the current sector */
                        current_sector = 1;
                        c = source_get();
                        
                        break;
              case '{':
              case '[':
              case '(': copy_scrap(tex_file, FALSE, NULL);
                        c = source_get();
                        
                        break;
              case '<': {
                           Parameters local_parameters = 0;
                           int changed;
                           char indent_chars[MAX_INDENT];
                           Arglist *a;
                           Name *name;
                           Arglist * args;
                           char * * inParams;
                           a = collect_scrap_name(0);
                           name = a->name;
                           args = instance(a->args, NULL, NULL, &changed);
                           inParams = name->arg;
                           name->mark = TRUE;
                           write_scraps(tex_file, tex_name, name->defs, 0, indent_chars, 0, 0, 1, 0,
                                 args, name->arg, local_parameters, tex_name);
                           name->mark = FALSE;
                           c = source_get();
                        }
                        
                        break;
              case 'x': {
                           /* Get label from */
                           char  label_name[MAX_NAME_LEN];
                           char * p = label_name;
                           while (c = source_get(), c != nw_char) /* Here is 148c-01 */
                              *p++ = c;
                           *p = '\0';
                           c = source_get();
                           
                           write_label(label_name, tex_file);
                        }
                        c = source_get();
                        break;
              case 'c': if (inBlock)
                        {
                           /* End block */
                           fputs("\\end{minipage}\\vspace{4ex}\n",  tex_file);
                           fputs("\\end{flushleft}\n", tex_file);
                           inBlock = FALSE;
                        }
                        else
                        {
                           /* Start block */
                           fputs("\\begin{flushleft} \\small\n\\begin{minipage}{\\linewidth}", tex_file);
                           inBlock = TRUE;
                        }
                        c = source_get();
                        break;
              case 'f': {
                          if (file_names) {
                            fputs("\n{\\small\\begin{list}{}{\\setlength{\\itemsep}{-\\parsep}",
                                  tex_file);
                            fputs("\\setlength{\\itemindent}{-\\leftmargin}}\n", tex_file);
                            format_file_entry(file_names, tex_file);
                            fputs("\\end{list}}", tex_file);
                          }
                          c = source_get();
                        }
                        break;
              case 'm': {
                          unsigned char sector = current_sector;
                          int c = source_get();
                          if (c == '+')
                             sector = 0;
                          else
                             source_ungetc(&c);
                          if (has_sector(macro_names, sector)) {
                            fputs("\n{\\small\\begin{list}{}{\\setlength{\\itemsep}{-\\parsep}",
                                  tex_file);
                            fputs("\\setlength{\\itemindent}{-\\leftmargin}}\n", tex_file);
                            format_entry(macro_names, tex_file, sector);
                            fputs("\\end{list}}", tex_file);
                          } else {
                            fputs("None.\n", tex_file);
                          }
                        }
                        c = source_get();
                        
                        break;
              case 'u': {
                            unsigned char sector = current_sector;
                            c = source_get();
                            if (c == '+') {
                               sector = 0;
                               c = source_get();
                            }
                            if (has_sector(user_names, sector)) {
                              fputs("\n{\\small\\begin{list}{}{\\setlength{\\itemsep}{-\\parsep}",
                                    tex_file);
                              fputs("\\setlength{\\itemindent}{-\\leftmargin}}\n", tex_file);
                              format_user_entry(user_names, tex_file, sector);
                              fputs("\\end{list}}", tex_file);
                            }
                        }
                        break;
              case 'v': fputs(version_string, tex_file);
                        c = source_get();
                        
                        break;
              default:
                    if (c==nw_char)
                      putc(c, tex_file);
                    c = source_get();
                        break;
            }
          }
          }
        else {
          putc(c, tex_file);
          c = source_get();
        }
      }
    }
    fclose(tex_file);
  }
  else
    fprintf(stderr, "%s: can't open %s\n", command_name, tex_name);
}
static void write_arg(FILE * tex_file, char * p)
{
   fputs("\\hbox{\\slshape\\sffamily ", tex_file);
   while (*p)
   {
      switch (*p)
      {
      case '$':
      case '_':
      case '^':
      case '#':
         fputc('\\', tex_file);
         break;
      default:
         break;
      }
      fputc(*p, tex_file);
      p++;
   }

   fputs("\\/}", tex_file);
}
static void print_scrap_numbers(tex_file, scraps)
     FILE *tex_file;
     Scrap_Node *scraps;
{
  int page;
  fputs("\\NWlink{nuweb", tex_file);
  write_scrap_ref(tex_file, scraps->scrap, -1, &page);
  fputs("}{", tex_file);
  write_scrap_ref(tex_file, scraps->scrap, TRUE, &page);
  fputs("}", tex_file);
  scraps = scraps->next;
  while (scraps) {
    fputs("\\NWlink{nuweb", tex_file);
    write_scrap_ref(tex_file, scraps->scrap, -1, &page);
    fputs("}{", tex_file);
    write_scrap_ref(tex_file, scraps->scrap, FALSE, &page);
    scraps = scraps->next;
    fputs("}", tex_file);
  }
  fputs(".\n", tex_file);
}
static char *orig_delimit_scrap[3][5] = {
  /* {} mode: begin, end, insert nw_char, prefix, suffix */
  { "\\verb@", "@", "@{\\tt @}\\verb@", "\\mbox{}", "\\\\" },
  /* [] mode: begin, end, insert nw_char, prefix, suffix */
  { "", "", "@", "", "" },
  /* () mode: begin, end, insert nw_char, prefix, suffix */
  { "$", "$", "@", "", "" },
};

static char *delimit_scrap[3][5];
void initialise_delimit_scrap_array() {
  int i,j;
  for(i = 0; i < 3; i++) {
    for(j = 0; j < 5; j++) {
      if((delimit_scrap[i][j] = strdup(orig_delimit_scrap[i][j])) == NULL) {
        fprintf(stderr, "Not enough memory for string allocation\n");
        exit(EXIT_FAILURE);
      }
    }
  }

  /* replace verb by lstinline */
  if (listings_flag) {
    free(delimit_scrap[0][0]);
    if((delimit_scrap[0][0]=strdup("\\lstinline@")) == NULL) {
      fprintf(stderr, "Not enough memory for string allocation\n");
      exit(EXIT_FAILURE);
    }
    free(delimit_scrap[0][2]);
    if((delimit_scrap[0][2]=strdup("@{\\tt @}\\lstinline@")) == NULL) {
      fprintf(stderr, "Not enough memory for string allocation\n");
      exit(EXIT_FAILURE);
    }
  }
}
int scrap_type = 0;
static void write_literal(FILE * tex_file, char * p, int mode)
{
   fprintf(tex_file, "", p);
   fputs(delimit_scrap[mode][0], tex_file);
   while (*p!= '\000') {
     if (*p == nw_char)
       fputs(delimit_scrap[mode][2], tex_file);
     else
       fputc(*p, tex_file);
     p++;
   }
   fputs(delimit_scrap[mode][1], tex_file);
}
static void copy_scrap(file, prefix, name)
     FILE *file;
     int prefix;
     Name * name;
{
  int indent = 0;
  int c;
  char ** params = name->arg;
  if (source_last == '{') scrap_type = 0;
  if (source_last == '[') scrap_type = 1;
  if (source_last == '(') scrap_type = 2;
  c = source_get();
  if (prefix) fputs(delimit_scrap[scrap_type][3], file);
  fputs(delimit_scrap[scrap_type][0], file);
  while (1) {
    switch (c) {
      case '\n': fputs(delimit_scrap[scrap_type][1], file);
                 if (prefix) fputs(delimit_scrap[scrap_type][4], file);
                 fputs("\n", file);
                 if (prefix) fputs(delimit_scrap[scrap_type][3], file);
                 fputs(delimit_scrap[scrap_type][0], file);
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
             /* Check at-sequence for end-of-scrap */
             {
               c = source_get();
               switch (c) {
                 case 'c': {
                             fputs(delimit_scrap[scrap_type][1],file);
                             fprintf(file, "\\hbox{\\sffamily\\slshape (Comment)}");
                             fputs(delimit_scrap[scrap_type][0], file);
                           }
                           
                           break;
                 case 'x': {
                              /* Get label from */
                              char  label_name[MAX_NAME_LEN];
                              char * p = label_name;
                              while (c = source_get(), c != nw_char) /* Here is 148c-01 */
                                 *p++ = c;
                              *p = '\0';
                              c = source_get();
                              
                              write_label(label_name, file);
                           }
                           break;
                 case 'v': fputs(version_string, file);
                           
                 case 's':
                           break;
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
                 case ')':
                 case ']':
                 case '}': fputs(delimit_scrap[scrap_type][1], file);
                           return;
                 case '<': {
                             Arglist *args = collect_scrap_name(-1);
                             Name *name = args->name;
                             char * p = name->spelling;
                             Arglist *q = args->args;
                             int narg = 0;

                             fputs(delimit_scrap[scrap_type][1],file);
                             if (prefix)
                               fputs("\\hbox{", file);
                             fputs("$\\langle\\,${\\itshape ", file);
                             while (*p != '\000') {
                               if (*p == ARG_CHR) {
                                 if (q == NULL) {
                                    write_literal(file, name->arg[narg], scrap_type);
                                 }
                                 else {
                                   write_ArglistElement(file, q, params);
                                   q = q->next;
                                 }
                                 p++;
                                 narg++;
                               }
                               else
                                  fputc(*p++, file);
                             }
                             fputs("}\\nobreak\\ ", file);
                             if (scrap_name_has_parameters) {
                               /* Format macro parameters */
                               
                                  char sep;

                                  sep = '(';
                                  do {
                                    fputc(sep,file);

                                    fputs("{\\footnotesize ", file);
                                    write_single_scrap_ref(file, scraps + 1);
                                    fprintf(file, "\\label{scrap%d}\n", scraps + 1);
                                    fputs(" }", file);

                                    source_last = '{';
                                    copy_scrap(file, TRUE, NULL);

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
                               
                             }
                             fprintf(file, "{\\footnotesize ");
                             if (name->defs)
                               /* Write abbreviated definition list */
                               {
                                 Scrap_Node *p = name->defs;
                                 fputs("\\NWlink{nuweb", file);
                                 write_single_scrap_ref(file, p->scrap);
                                 fputs("}{", file);
                                 write_single_scrap_ref(file, p->scrap);
                                 fputs("}", file);
                                 p = p->next;
                                 if (p)
                                   fputs(", \\ldots\\ ", file);
                               }
                             else {
                               putc('?', file);
                               fprintf(stderr, "%s: never defined <%s>\n",
                                       command_name, name->spelling);
                             }
                             fputs("}$\\,\\rangle$", file);
                             if (prefix)
                                fputs("}", file);
                             fputs(delimit_scrap[scrap_type][0], file);
                           }
                           break;
                 case '%': {
                                   do
                                           c = source_get();
                                   while (c != '\n');
                           }
                           break;
                 case '_': {
                             fputs(delimit_scrap[scrap_type][1],file);
                             fprintf(file, "\\hbox{\\sffamily\\bfseries ");
                             c = source_get();
                             do {
                                 fputc(c, file);
                                 c = source_get();
                             } while (c != nw_char);
                             c = source_get();
                             fprintf(file, "}");
                             fputs(delimit_scrap[scrap_type][0], file);
                           }
                           break;
                 case 't': {
                             fputs(delimit_scrap[scrap_type][1],file);
                             fprintf(file, "\\hbox{\\sffamily\\slshape fragment title}");
                             fputs(delimit_scrap[scrap_type][0], file);
                           }
                           break;
                 case 'f': {
                             fputs(delimit_scrap[scrap_type][1],file);
                             fprintf(file, "\\hbox{\\sffamily\\slshape file name}");
                             fputs(delimit_scrap[scrap_type][0], file);
                           }
                           break;
                 case '1': case '2': case '3':
                 case '4': case '5': case '6':
                 case '7': case '8': case '9':
                           if (name == NULL
                               || name->arg[c - '1'] == NULL) {
                             fputs(delimit_scrap[scrap_type][2], file);
                             fputc(c,   file);
                           }
                           else {
                             fputs(delimit_scrap[scrap_type][1], file);
                             write_arg(file, name->arg[c - '1']);
                             fputs(delimit_scrap[scrap_type][0], file);
                           }
                           break;
                 default:
                       if (c==nw_char)
                         {
                           fputs(delimit_scrap[scrap_type][2], file);
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
void update_delimit_scrap()
{
  static int been_here_before = 0;

  /* {}-mode begin */
  if (listings_flag) {
    delimit_scrap[0][0][10] = nw_char;
  } else {
    delimit_scrap[0][0][5] = nw_char;
  }
  /* {}-mode end */
  delimit_scrap[0][1][0] = nw_char;
  /* {}-mode insert nw_char */

  delimit_scrap[0][2][0] = nw_char;
  delimit_scrap[0][2][6] = nw_char;

  if (listings_flag) {
    delimit_scrap[0][2][18] = nw_char;
  } else {
    delimit_scrap[0][2][13] = nw_char;
  }

  /* []-mode insert nw_char */
  delimit_scrap[1][2][0] = nw_char;

  /* ()-mode insert nw_char */
  delimit_scrap[2][2][0] = nw_char;
}
static void
write_ArglistElement(FILE * file, Arglist * args, char ** params)
{
  Name *name = args->name;
  Arglist *q = args->args;

  if (name == NULL) {
    char * p = (char*)q;

    if (p[0] == ARG_CHR) {
       write_arg(file, params[p[1] - '1']);
    } else {
       write_literal(file, (char *)q, 0);
    }
  } else if (name == (Name *)1) {
    Scrap_Node * qq = (Scrap_Node *)q;
    qq->quoted = TRUE;
    fputs(delimit_scrap[scrap_type][0], file);
    write_scraps(file, "", qq,
                 -1, "", 0, 0, 0, 0,
                 NULL, params, 0, "");
    fputs(delimit_scrap[scrap_type][1], file);
    extra_scraps++;
    qq->quoted = FALSE;
  } else {
    char * p = name->spelling;
    fputs("$\\langle\\,${\\itshape ", file);
      while (*p != '\000') {
      if (*p == ARG_CHR) {
        write_ArglistElement(file, q, params);
        q = q->next;
        p++;
      }
      else
         fputc(*p++, file);
    }
    fputs("}\\nobreak\\ ", file);
    if (scrap_name_has_parameters) {
      int c;

      /* Format macro parameters */
      
         char sep;

         sep = '(';
         do {
           fputc(sep,file);

           fputs("{\\footnotesize ", file);
           write_single_scrap_ref(file, scraps + 1);
           fprintf(file, "\\label{scrap%d}\n", scraps + 1);
           fputs(" }", file);

           source_last = '{';
           copy_scrap(file, TRUE, NULL);

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
      
    }
    fprintf(file, "{\\footnotesize ");
    if (name->defs)
      /* Write abbreviated definition list */
      {
        Scrap_Node *p = name->defs;
        fputs("\\NWlink{nuweb", file);
        write_single_scrap_ref(file, p->scrap);
        fputs("}{", file);
        write_single_scrap_ref(file, p->scrap);
        fputs("}", file);
        p = p->next;
        if (p)
          fputs(", \\ldots\\ ", file);
      }
    else {
      putc('?', file);
      fprintf(stderr, "%s: never defined <%s>\n",
              command_name, name->spelling);
    }
    fputs("}$\\,\\rangle$", file);
  }
}
static void format_file_entry(name, tex_file)
     Name *name;
     FILE *tex_file;
{
  while (name) {
    format_file_entry(name->llink, tex_file);
    /* Format a file index entry */
    fputs("\\item ", tex_file);
    fprintf(tex_file, "\\verb%c\"%s\"%c ", nw_char, name->spelling, nw_char);
    /* Write file's defining scrap numbers */
    {
      Scrap_Node *p = name->defs;
      fputs("{\\footnotesize {\\NWtxtDefBy}", tex_file);
      if (p->next) {
        /* fputs("s ", tex_file); */
          putc(' ', tex_file);
        print_scrap_numbers(tex_file, p);
      }
      else {
        putc(' ', tex_file);
        fputs("\\NWlink{nuweb", tex_file);
        write_single_scrap_ref(tex_file, p->scrap);
        fputs("}{", tex_file);
        write_single_scrap_ref(tex_file, p->scrap);
        fputs("}", tex_file);
        putc('.', tex_file);
      }
      putc('}', tex_file);
    }
    putc('\n', tex_file);
    name = name->rlink;
  }
}
static int load_entry(Name * name, Name ** nms, int n)
{
   while (name) {
      n = load_entry(name->llink, nms, n);
      nms[n++] = name;
      name = name->rlink;
   }
   return n;
}
static void format_entry(name, tex_file, sector)
     Name *name;
     FILE *tex_file;
     unsigned char sector;
{
  Name ** nms = malloc(num_scraps()*sizeof(Name *));
  int n = load_entry(name, nms, 0);
  int i;

  /* Sort 'nms' of size 'n' for <Rob's ordering> */
  int j;
  for (j = 1; j < n; j++)
  {
     int i = j - 1;
     Name * kj = nms[j];

     do
     {
        Name * ki = nms[i];

        if (robs_strcmp(ki->spelling, kj->spelling) < 0)
           break;
        nms[i + 1] = ki;
        i -= 1;
     } while (i >= 0);
     nms[i + 1] = kj;
  }
  
  for (i = 0; i < n; i++)
  {
     Name * name = nms[i];

     /* Format an index entry */
     if (name->sector == sector){
       fputs("\\item ", tex_file);
       fputs("$\\langle\\,$", tex_file);
       /* Write the macro's name */
       {
         char * p = name->spelling;
         int i = 0;

         while (*p != '\000') {
           if (*p == ARG_CHR) {
             write_arg(tex_file, name->arg[i++]);
             p++;
           }
           else
              fputc(*p++, tex_file);
         }
       }
       fputs("\\nobreak\\ {\\footnotesize ", tex_file);
       /* Write defining scrap numbers */
       {
         Scrap_Node *p = name->defs;
         if (p) {
           int page;
           fputs("\\NWlink{nuweb", tex_file);
           write_scrap_ref(tex_file, p->scrap, -1, &page);
           fputs("}{", tex_file);
           write_scrap_ref(tex_file, p->scrap, TRUE, &page);
           fputs("}", tex_file);
           p = p->next;
           while (p) {
             fputs("\\NWlink{nuweb", tex_file);
             write_scrap_ref(tex_file, p->scrap, -1, &page);
             fputs("}{", tex_file);
             write_scrap_ref(tex_file, p->scrap, FALSE, &page);
             fputs("}", tex_file);
             p = p->next;
           }
         }
         else
           putc('?', tex_file);
       }
       fputs("}$\\,\\rangle$ ", tex_file);
       /* Write referencing scrap numbers */
       {
         Scrap_Node *p = name->uses;
         fputs("{\\footnotesize ", tex_file);
         if (p) {
           fputs("{\\NWtxtRefIn}", tex_file);
           if (p->next) {
             /* fputs("s ", tex_file); */
             putc(' ', tex_file);
             print_scrap_numbers(tex_file, p);
           }
           else {
             putc(' ', tex_file);
             fputs("\\NWlink{nuweb", tex_file);
             write_single_scrap_ref(tex_file, p->scrap);
             fputs("}{", tex_file);
             write_single_scrap_ref(tex_file, p->scrap);
             fputs("}", tex_file);
             putc('.', tex_file);
           }
         }
         else
           fputs("{\\NWtxtNoRef}.", tex_file);
         putc('}', tex_file);
       }
       putc('\n', tex_file);
     }
  }
}
int has_sector(Name * name, unsigned char sector)
{
  while(name) {
    if (name->sector == sector)
       return TRUE;
    if (has_sector(name->llink, sector))
       return TRUE;
     name = name->rlink;
   }
   return FALSE;
}
static void format_user_entry(name, tex_file, sector)
     Name *name;
     FILE *tex_file;
     unsigned char sector;
{
  while (name) {
    format_user_entry(name->llink, tex_file, sector);
    /* Format a user index entry */
    if (name->sector == sector){
      Scrap_Node *uses = name->uses;
      if ( uses || dangling_flag ) {
        int page;
        Scrap_Node *defs = name->defs;
        fprintf(tex_file, "\\item \\verb%c%s%c: ", nw_char,name->spelling,nw_char);
        if (!uses) {
            fputs("(\\underline{", tex_file);
            fputs("\\NWlink{nuweb", tex_file);
            write_single_scrap_ref(tex_file, defs->scrap);
            fputs("}{", tex_file);
            write_single_scrap_ref(tex_file, defs->scrap);
            fputs("})}", tex_file);
            page = -2;
            defs = defs->next;
        }
        else
          if (!defs || uses->scrap < defs->scrap) {
          fputs("\\NWlink{nuweb", tex_file);
          write_scrap_ref(tex_file, uses->scrap, -1, &page);
          fputs("}{", tex_file);
          write_scrap_ref(tex_file, uses->scrap, TRUE, &page);
          fputs("}", tex_file);
          uses = uses->next;
        }
        else {
          if (defs->scrap == uses->scrap)
            uses = uses->next;
          fputs("\\underline{", tex_file);

          fputs("\\NWlink{nuweb", tex_file);
          write_single_scrap_ref(tex_file, defs->scrap);
          fputs("}{", tex_file);
          write_single_scrap_ref(tex_file, defs->scrap);
          fputs("}}", tex_file);
          page = -2;
          defs = defs->next;
        }
        while (uses || defs) {
          if (uses && (!defs || uses->scrap < defs->scrap)) {
            fputs("\\NWlink{nuweb", tex_file);
            write_scrap_ref(tex_file, uses->scrap, -1, &page);
            fputs("}{", tex_file);
            write_scrap_ref(tex_file, uses->scrap, FALSE, &page);
            fputs("}", tex_file);
            uses = uses->next;
          }
          else {
            if (uses && defs->scrap == uses->scrap)
              uses = uses->next;
            fputs(", \\underline{", tex_file);

            fputs("\\NWlink{nuweb", tex_file);
            write_single_scrap_ref(tex_file, defs->scrap);
            fputs("}{", tex_file);
            write_single_scrap_ref(tex_file, defs->scrap);
            fputs("}", tex_file);

            putc('}', tex_file);
            page = -2;
            defs = defs->next;
          }
        }
        fputs(".\n", tex_file);
      }
    }
    name = name->rlink;
  }
}

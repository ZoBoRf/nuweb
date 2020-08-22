#include "global.h"
void pass1(file_name)
     char *file_name;
{
  if (verbose_flag)
    fprintf(stderr, "reading %s\n", file_name);
  source_open(file_name);
  init_scraps();
  macro_names = NULL;
  file_names = NULL;
  user_names = NULL;
  /* Scan the source file, looking for at-sequences */
  {
    int c = source_get();
    while (c != EOF) {
      if (c == nw_char)
        /* Scan at-sequence */
        {
          char quoted = 0;

          c = source_get();
          switch (c) {
            case 'r':
                  c = source_get();
                  nw_char = c;
                  update_delimit_scrap();
                  break;
            case 'O':
            case 'o': {
                        Name *name = collect_file_name(); /* returns a pointer to the name entry */
                        int scrap = collect_scrap();      /* returns an index to the scrap */
                        /* Add \verb|scrap| to \verb|name|'s definition list */
                        {
                          Scrap_Node *def = (Scrap_Node *) arena_getmem(sizeof(Scrap_Node));
                          def->scrap = scrap;
                          def->quoted = quoted;
                          def->next = name->defs;
                          name->defs = def;
                        }
                      }
                      break;
            case 'Q':
            case 'q': quoted = 1;
            case 'D':
            case 'd': {
                        Name *name = collect_macro_name();
                        int scrap = collect_scrap();
                        /* Add \verb|scrap| to \verb|name|'s definition list */
                        {
                          Scrap_Node *def = (Scrap_Node *) arena_getmem(sizeof(Scrap_Node));
                          def->scrap = scrap;
                          def->quoted = quoted;
                          def->next = name->defs;
                          name->defs = def;
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
            case '<':
            case '(':
            case '[':
            case '{': 
                      {
                         int c;
                         int depth = 1;
                         while ((c = source_get()) != EOF) {
                            if (c == nw_char)
                               /* Skip over at-sign or go to skipped */
                               
                               {
                                  c = source_get();
                                  switch (c) {
                                    case '{': case '[': case '(': case '<':
                                       depth += 1;
                                       break;
                                    case '}': case ']': case ')': case '>':
                                       if (--depth == 0)
                                          goto skipped;
                                    case 'x': case '|': case ',':
                                    case '%': case '1': case '2':
                                    case '3': case '4': case '5': case '6':
                                    case '7': case '8': case '9': case '_':
                                    case 'f': case '#': case '+': case '-':
                                    case 'v': case '*': case 'c': case '\'':
                                    case 's':
                                       break;
                                    default:
                                       if (c != nw_char) {
                                          fprintf(stderr, "%s: unexpected %c%c in text at (%s, %d)\n",
                                                          command_name, nw_char, c, source_name, source_line);
                                          exit(-1);
                                       }
                                       break;
                                  }
                               }
                               
                         }
                         fprintf(stderr, "%s: unexpected EOF in text at (%s, %d)\n",
                                          command_name, source_name, source_line);
                         exit(-1);

                      skipped:  ;
                      }
                      
                      break;
            case 'c': {
                         char * p = blockBuff;
                         char * e = blockBuff + (sizeof(blockBuff)/sizeof(blockBuff[0])) - 1;

                         /* Skip whitespace */
                         while (source_peek == ' '
                                || source_peek == '\t'
                                || source_peek == '\n')
                            (void)source_get();
                         
                         while (p < e)
                         {
                            /* Add one char to the block buffer */
                            int c = source_get();

                            if (c == nw_char)
                            {
                               /* Add an at character to the block or break */
                               int cc = source_peek;

                               if (cc == 'c')
                               {
                                  do
                                     c = source_get();
                                  while (c <= ' ');

                                  break;
                               }
                               else if (cc == 'd'
                                        || cc == 'D'
                                        || cc == 'q'
                                        || cc == 'Q'
                                        || cc == 'o'
                                        || cc == 'O'
                                        || cc == EOF)
                               {
                                  source_ungetc(&c);
                                  break;
                               }
                               else
                               {
                                  *p++ = c;
                                  *p++ = source_get();
                               }
                               
                            }
                            else if (c == EOF)
                            {
                               source_ungetc(&c);
                               break;
                            }
                            else
                            {
                               /* Add any other character to the block */
                               
                                  /* Perhaps skip white-space */
                                  if (c == ' ')
                                  {
                                     while (source_peek == ' ')
                                        c = source_get();
                                  }
                                  if (c == '\n')
                                  {
                                     if (source_peek == '\n')
                                     {
                                        do
                                           c = source_get();
                                        while (source_peek == '\n');
                                     }
                                     else
                                        c = ' ';
                                  }
                                  
                                  *p++ = c;
                               
                            }
                            
                         }
                         if (p == e)
                         {
                            /* Skip to the next nw-char */
                            int c;

                            while ((c = source_get()), c != nw_char && c != EOF)/* Skip */
                            source_ungetc(&c);
                         }
                         *p = '\000';
                      }
                      
                      break;
            case 'x':
            case 'v':
            case 'u':
            case 'm':
            case 'f': /* ignore during this pass */
                      break;
            default:  if (c==nw_char) /* ignore during this pass */
                        break;
                      fprintf(stderr,
                              "%s: unexpected %c sequence ignored (%s, line %d)\n",
                              command_name, nw_char, source_name, source_line);
                      break;
          }
        }
      c = source_get();
    }
  }
  if (tex_flag)
    search();
  /* Reverse cross-reference lists */
  {
    reverse_lists(file_names);
    reverse_lists(macro_names);
    reverse_lists(user_names);
  }
}

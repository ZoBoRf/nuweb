#include "global.h"
static FILE *source_file;  /* the current input file */
static int double_at;
static int include_depth;
static struct {
  FILE *file;
  char *name;
  int line;
} stack[10];

int source_peek;
int source_last;
int source_get()
{
  int c;
  source_last = c = source_peek;
  switch (c) {
    case EOF:  {
                 fclose(source_file);
                 if (include_depth) {
                   include_depth--;
                   source_file = stack[include_depth].file;
                   source_line = stack[include_depth].line;
                   source_name = stack[include_depth].name;
                   source_peek = getc(source_file);
                   c = source_get();
                 }
               }
               return c;
    case '\n': source_line++;
    default:
           if (c==nw_char)
             {
               /* Handle an ``at'' character */
               {
                 c = getc(source_file);
                 if (double_at) {
                   source_peek = c;
                   double_at = FALSE;
                   c = nw_char;
                 }
                 else
                   switch (c) {
                     case 'i': {
                                 char name[FILENAME_MAX];
                                 char fullname[FILENAME_MAX];
                                 struct incl * p = include_list;

                                 if (include_depth >= 10) {
                                   fprintf(stderr, "%s: include nesting too deep (%s, %d)\n",
                                           command_name, source_name, source_line);
                                   exit(-1);
                                 }
                                 /* Collect include-file name */
                                 {
                                     char *p = name;
                                     do
                                       c = getc(source_file);
                                     while (c == ' ' || c == '\t');
                                     while (isgraph(c)) {
                                       *p++ = c;
                                       c = getc(source_file);
                                     }
                                     *p = '\0';
                                     if (c != '\n') {
                                       fprintf(stderr, "%s: unexpected characters after file name (%s, %d)\n",
                                               command_name, source_name, source_line);
                                       exit(-1);
                                     }
                                 }
                                 stack[include_depth].file = source_file;
                                 fullname[0] = '\0';
                                 for (;;) {
                                    strcat(fullname, name);
                                    source_file = fopen(fullname, "r");
                                    if (source_file || !p)
                                       break;
                                    strcpy(fullname, p->name);
                                    strcat(fullname, "/");
                                    p = p->next;
                                 }
                                 if (!source_file) {
                                   fprintf(stderr, "%s: can't open include file %s\n",
                                           command_name, name);
                                   source_file = stack[include_depth].file;
                                 }
                                 else
                                 {
                                    stack[include_depth].name = source_name;
                                    stack[include_depth].line = source_line + 1;
                                    include_depth++;
                                    source_line = 1;
                                    source_name = save_string(fullname);
                                 }
                                 source_peek = getc(source_file);
                                 c = source_get();
                               }
                               break;
                     case '#': case 'f': case 'm': case 'u': case 'v':
                     case 'd': case 'o': case 'D': case 'O': case 's':
                     case 'q': case 'Q': case 'S': case 't':
                     case '+':
                     case '-':
                     case '*':
                     case '\'':
                     case '{': case '}': case '<': case '>': case '|':
                     case '(': case ')': case '[': case ']':
                     case '%': case '_':
                     case ':': case ',': case 'x': case 'c':
                     case '1': case '2': case '3': case '4': case '5':
                     case '6': case '7': case '8': case '9':
                     case 'r':
                               source_peek = c;
                               c = nw_char;
                               break;
                     default:
                           if (c==nw_char)
                             {
                               source_peek = c;
                               double_at = TRUE;
                               break;
                             }
                            fprintf(stderr, "%s: bad %c sequence %c[%d] (%s, line %d)\n",
                                    command_name, nw_char, c, c, source_name, source_line);
                            exit(-1);
                   }
               }
               return c;
             }
           source_peek = getc(source_file);
               return c;
  }
}
void source_ungetc(int *c)
{
  ungetc(source_peek, source_file);
  if(*c == '\n')
    source_line--;
  source_peek=*c;
}
void source_open(name)
     char *name;
{
  source_file = fopen(name, "r");
  if (!source_file) {
    fprintf(stderr, "%s: couldn't open %s\n", command_name, name);
    exit(-1);
  }
  nw_char = '@';
  source_name = name;
  source_line = 1;
  source_peek = getc(source_file);
  double_at = FALSE;
  include_depth = 0;
}

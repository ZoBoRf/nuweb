#include "global.h"
enum { LESS, GREATER, EQUAL, PREFIX, EXTENSION };

static int compare(x, y)
     char *x;
     char *y;
{
  int len, result;
  int xl = strlen(x);
  int yl = strlen(y);
  int xp = x[xl - 1] == ' ';
  int yp = y[yl - 1] == ' ';
  if (xp) xl--;
  if (yp) yl--;
  len = xl < yl ? xl : yl;
  result = strncmp(x, y, len);
  if (result < 0) return GREATER;
  else if (result > 0) return LESS;
  else if (xl < yl) {
    if (xp) return EXTENSION;
    else return LESS;
  }
  else if (xl > yl) {
    if (yp) return PREFIX;
    else return GREATER;
  }
  else return EQUAL;
}
char *save_string(s)
     char *s;
{
  char *new = (char *) arena_getmem((strlen(s) + 1) * sizeof(char));
  strcpy(new, s);
  return new;
}
static int ambiguous_prefix();

static char * found_name = NULL;

Name *prefix_add(rt, spelling, sector)
     Name **rt;
     char *spelling;
     unsigned char sector;
{
  Name *node = *rt;
  int cmp;

  while (node) {
    switch ((cmp = compare(node->spelling, spelling))) {
    case GREATER:   rt = &node->rlink;
                    break;
    case LESS:      rt = &node->llink;
                    break;
    case EQUAL:
                    found_name = node->spelling;
    case EXTENSION: if (node->sector > sector) {
                       rt = &node->rlink;
                       break;
                    }
                    else if (node->sector < sector) {
                       rt = &node->llink;
                       break;
                    }
                    if (cmp == EXTENSION)
                       node->spelling = save_string(spelling);
                    return node;
    case PREFIX:    {
                      if (ambiguous_prefix(node->llink, spelling, sector) ||
                          ambiguous_prefix(node->rlink, spelling, sector))
                        fprintf(stderr,
                                "%s: ambiguous prefix %c<%s...%c> (%s, line %d)\n",
                                command_name, nw_char, spelling, nw_char, source_name, source_line);
                    }
                    return node;
    }
    node = *rt;
  }
  /* Create new name entry */
  {
    node = (Name *) arena_getmem(sizeof(Name));
    if (found_name && robs_strcmp(found_name, spelling) == 0)
       node->spelling = found_name;
    else
       node->spelling = save_string(spelling);
    node->mark = FALSE;
    node->llink = NULL;
    node->rlink = NULL;
    node->uses = NULL;
    node->defs = NULL;
    node->arg[0] =
    node->arg[1] =
    node->arg[2] =
    node->arg[3] =
    node->arg[4] =
    node->arg[5] =
    node->arg[6] =
    node->arg[7] =
    node->arg[8] = NULL;
    node->tab_flag = TRUE;
    node->indent_flag = TRUE;
    node->debug_flag = FALSE;
    node->comment_flag = 0;
    node->sector = sector;
    *rt = node;
    return node;
  }
}
static int ambiguous_prefix(node, spelling, sector)
     Name *node;
     char *spelling;
     unsigned char sector;
{
  while (node) {
    switch (compare(node->spelling, spelling)) {
    case GREATER:   node = node->rlink;
                    break;
    case LESS:      node = node->llink;
                    break;
    case EXTENSION:
    case PREFIX:
    case EQUAL:     if (node->sector > sector) {
                       node = node->rlink;
                       break;
                    }
                    else if (node->sector < sector) {
                       node = node->llink;
                       break;
                    }
                    return TRUE;
    }
  }
  return FALSE;
}
int robs_strcmp(char* x, char* y)
{
   int cmp = 0;

   for (; *x && *y; x++, y++)
   {
      /* Skip invisibles on 'x' */
      if (*x == '|')
         x++;
      
      /* Skip invisibles on 'y' */
      if (*y == '|')
         y++;
      
      if (*x == *y)
         continue;
      if (islower(*x) && toupper(*x) == *y)
      {
         if (!cmp) cmp = 1;
         continue;
      }
      if (islower(*y) && *x == toupper(*y))
      {
         if (!cmp) cmp = -1;
         continue;
      }
      return 2*(toupper(*x) - toupper(*y));
   }
   if (*x)
      return 2;
   if (*y)
      return -2;
   return cmp;
}
Name *name_add(rt, spelling, sector)
     Name **rt;
     char *spelling;
     unsigned char sector;
{
  Name *node = *rt;
  while (node) {
    int result = robs_strcmp(node->spelling, spelling);
    if (result > 0)
      rt = &node->llink;
    else if (result < 0)
      rt = &node->rlink;
    else
    {
       found_name = node->spelling;
       if (node->sector > sector)
         rt = &node->llink;
       else if (node->sector < sector)
         rt = &node->rlink;
       else
         return node;
    }
    node = *rt;
  }
  /* Create new name entry */
  {
    node = (Name *) arena_getmem(sizeof(Name));
    if (found_name && robs_strcmp(found_name, spelling) == 0)
       node->spelling = found_name;
    else
       node->spelling = save_string(spelling);
    node->mark = FALSE;
    node->llink = NULL;
    node->rlink = NULL;
    node->uses = NULL;
    node->defs = NULL;
    node->arg[0] =
    node->arg[1] =
    node->arg[2] =
    node->arg[3] =
    node->arg[4] =
    node->arg[5] =
    node->arg[6] =
    node->arg[7] =
    node->arg[8] = NULL;
    node->tab_flag = TRUE;
    node->indent_flag = TRUE;
    node->debug_flag = FALSE;
    node->comment_flag = 0;
    node->sector = sector;
    *rt = node;
    return node;
  }
}
Name *collect_file_name()
{
  Name *new_name;
  char name[MAX_NAME_LEN];
  char *p = name;
  int start_line = source_line;
  int c = source_get(), c2;
  while (isspace(c))
    c = source_get();
  while (isgraph(c)) {
    *p++ = c;
    c = source_get();
  }
  if (p == name) {
    fprintf(stderr, "%s: expected file name (%s, %d)\n",
            command_name, source_name, start_line);
    exit(-1);
  }
  *p = '\0';
  /* File names are always global. */
  new_name = name_add(&file_names, name, 0);
  /* Handle optional per-file flags */
  {
    while (1) {
      while (isspace(c))
        c = source_get();
      if (c == '-') {
        c = source_get();
        do {
          switch (c) {
            case 't': new_name->tab_flag = FALSE;
                      break;
            case 'd': new_name->debug_flag = TRUE;
                      break;
            case 'i': new_name->indent_flag = FALSE;
                      break;
            case 'c': c = source_get();
                      if (c == 'c')
                         new_name->comment_flag = 1;
                      else if (c == '+')
                         new_name->comment_flag = 2;
                      else if (c == 'p')
                         new_name->comment_flag = 3;
                      else
                         fprintf(stderr, "%s: Unrecognised comment flag (%s, %d)\n",
                                 command_name, source_name, source_line);
                      
                      break;
            default : fprintf(stderr, "%s: unexpected per-file flag (%s, %d)\n",
                              command_name, source_name, source_line);
                      break;
          }
          c = source_get();
        } while (!isspace(c));
      }
      else break;
    }
  }
  c2 = source_get();
  if (c != nw_char || (c2 != '{' && c2 != '(' && c2 != '[')) {
    fprintf(stderr, "%s: expected %c{, %c[, or %c( after file name (%s, %d)\n",
            command_name, nw_char, nw_char, nw_char, source_name, start_line);
    exit(-1);
  }
  return new_name;
}
Name *collect_macro_name()
{
  char name[MAX_NAME_LEN];
  char args[1000];
  char * arg[9];
  char * argp = args;
  int argc = 0;
  char *p = name;
  int start_line = source_line;
  int c = source_get(), c2;
  unsigned char sector = current_sector;

  if (c == '+') {
    sector = 0;
    c = source_get();
  }
  while (isspace(c))
    c = source_get();
  while (c != EOF) {
    Name * node;
    switch (c) {
      case '\t':
      case ' ':  *p++ = ' ';
                 do
                   c = source_get();
                 while (c == ' ' || c == '\t');
                 break;
      case '\n': {
                   do
                     c = source_get();
                   while (isspace(c));
                   c2 = source_get();
                   if (c != nw_char || (c2 != '{' && c2 != '(' && c2 != '[')) {
                     fprintf(stderr, "%s: expected %c{ after fragment name (%s, %d)\n",
                             command_name, nw_char, source_name, start_line);
                     exit(-1);
                   }
                   /* Cleanup and install name */
                   {
                     if (p > name && p[-1] == ' ')
                       p--;
                     if (p - name > 3 && p[-1] == '.' && p[-2] == '.' && p[-3] == '.') {
                       p[-3] = ' ';
                       p -= 2;
                     }
                     if (p == name || name[0] == ' ') {
                       fprintf(stderr, "%s: empty name (%s, %d)\n",
                               command_name, source_name, source_line);
                       exit(-1);
                     }
                     *p = '\0';
                     node = prefix_add(&macro_names, name, sector);
                   }
                   return install_args(node, argc, arg);
                 }
      default:
         if (c==nw_char)
           {
             /* Check for terminating at-sequence and return name */
             {
               c = source_get();
               switch (c) {
                 case '(':
                 case '[':
                 case '{': {
                             if (p > name && p[-1] == ' ')
                               p--;
                             if (p - name > 3 && p[-1] == '.' && p[-2] == '.' && p[-3] == '.') {
                               p[-3] = ' ';
                               p -= 2;
                             }
                             if (p == name || name[0] == ' ') {
                               fprintf(stderr, "%s: empty name (%s, %d)\n",
                                       command_name, source_name, source_line);
                               exit(-1);
                             }
                             *p = '\0';
                             node = prefix_add(&macro_names, name, sector);
                           }
                          return install_args(node, argc, arg);
                 case '\'': arg[argc] = argp;
                            while ((c = source_get()) != EOF) {
                               if (c==nw_char) {
                                  c2 = source_get();
                                  if (c2=='\'') {
                                    /* Make this argument */
                                    if (argc < 9) {
                                      *argp++ = '\000';
                                      argc += 1;
                                    }
                                    
                                    c = source_get();
                                    break;
                                  }
                                  else
                                    *argp++ = c2;
                               }
                               else
                                 *argp++ = c;
                            }
                            *p++ = ARG_CHR;
                            
                            break;
                 default:
                       if (c==nw_char)
                         {
                           *p++ = c;
                           break;
                         }
                       fprintf(stderr,
                                   "%s: unexpected %c%c in fragment definition name (%s, %d)\n",
                                   command_name, nw_char, c, source_name, start_line);
                           exit(-1);
               }
             }
             break;
           }
         *p++ = c;
                 c = source_get();
                 break;
    }
  }
  fprintf(stderr, "%s: expected fragment name (%s, %d)\n",
          command_name, source_name, start_line);
  exit(-1);
  return NULL;  /* unreachable return to avoid warnings on some compilers */
}
Name *install_args(Name * name, int argc, char *arg[9])
{
  int i;

  for (i = 0; i < argc; i++) {
    if (name->arg[i] == NULL)
      name->arg[i] = save_string(arg[i]);
  }
  return name;
}
Arglist * buildArglist(Name * name, Arglist * a)
{
  Arglist * args = (Arglist *)arena_getmem(sizeof(Arglist));

  args->args = a;
  args->next = NULL;
  args->name = name;
  return args;
}
Arglist * collect_scrap_name(int current_scrap)
{
  char name[MAX_NAME_LEN];
  char *p = name;
  int c = source_get();
  unsigned char sector = current_sector;
  Arglist * head = NULL;
  Arglist ** tail = &head;

  if (c == '+')
  {
    sector = 0;
    c = source_get();
  }
  while (c == ' ' || c == '\t')
    c = source_get();
  while (c != EOF) {
    switch (c) {
      case '\t':
      case ' ':  *p++ = ' ';
                 do
                   c = source_get();
                 while (c == ' ' || c == '\t');
                 break;
      default:
         if (c==nw_char)
           {
             /* Look for end of scrap name and return */
             {
               Name * node;

               c = source_get();
               switch (c) {

                 case '\'': {
                       /* Add plain string argument */
                       char buff[MAX_NAME_LEN];
                       char * s = buff;
                       int c, c2;

                       while ((c = source_get()) != EOF) {
                         if (c==nw_char) {
                           c2 = source_get();
                           if (c2=='\'')
                             break;
                           *s++ = c2;
                         }
                         else
                           *s++ = c;
                       }
                       *s = '\000';
                       /* Add buff to current arg list */
                       *tail = buildArglist(NULL, (Arglist *)save_string(buff));
                       tail = &(*tail)->next;
                       
                     }
                     *p++ = ARG_CHR;
                     c = source_get();
                     break;
                 case '1': case '2': case '3':
                 case '4': case '5': case '6':
                 case '7': case '8': case '9': {
                       /* Add a propagated argument */
                       char buff[3];
                       buff[0] = ARG_CHR;
                       buff[1] = c;
                       buff[2] = '\000';
                       /* Add buff to current arg list */
                       *tail = buildArglist(NULL, (Arglist *)save_string(buff));
                       tail = &(*tail)->next;
                       
                     }
                     *p++ = ARG_CHR;
                     c = source_get();
                     break;
                 case '{': {
                     /* Add an inline scrap argument */
                     int s = collect_scrap();
                     Scrap_Node * d = (Scrap_Node *)arena_getmem(sizeof(Scrap_Node));
                     d->scrap = s;
                     d->quoted = 0;
                     d->next = NULL;
                     *tail = buildArglist((Name *)1, (Arglist *)d);
                     tail = &(*tail)->next;
                     }
                     *p++ = ARG_CHR;
                     c = source_get();
                     break;
                 case '<':
                     /* Add macro call argument */
                     *tail = collect_scrap_name(current_scrap);
                     if (current_scrap >= 0)
                       add_to_use((*tail)->name, current_scrap);
                     tail = &(*tail)->next;
                     
                     *p++ = ARG_CHR;
                     c = source_get();
                     break;
                 case '(':
                     scrap_name_has_parameters = 1;
                     /* Cleanup and install name */
                     {
                       if (p > name && p[-1] == ' ')
                         p--;
                       if (p - name > 3 && p[-1] == '.' && p[-2] == '.' && p[-3] == '.') {
                         p[-3] = ' ';
                         p -= 2;
                       }
                       if (p == name || name[0] == ' ') {
                         fprintf(stderr, "%s: empty name (%s, %d)\n",
                                 command_name, source_name, source_line);
                         exit(-1);
                       }
                       *p = '\0';
                       node = prefix_add(&macro_names, name, sector);
                     }
                     return buildArglist(node, head);
                 case '>':
                     scrap_name_has_parameters = 0;
                     /* Cleanup and install name */
                     {
                       if (p > name && p[-1] == ' ')
                         p--;
                       if (p - name > 3 && p[-1] == '.' && p[-2] == '.' && p[-3] == '.') {
                         p[-3] = ' ';
                         p -= 2;
                       }
                       if (p == name || name[0] == ' ') {
                         fprintf(stderr, "%s: empty name (%s, %d)\n",
                                 command_name, source_name, source_line);
                         exit(-1);
                       }
                       *p = '\0';
                       node = prefix_add(&macro_names, name, sector);
                     }
                     return buildArglist(node, head);

                 default:
                    if (c==nw_char)
                      {
                        *p++ = c;
                           c = source_get();
                           break;
                      }
                    fprintf(stderr,
                                   "%s: unexpected %c%c in fragment invocation name (%s, %d)\n",
                                   command_name, nw_char, c, source_name, source_line);
                           exit(-1);
               }
             }
             break;
           }
         if (!isgraph(c)) {
                   fprintf(stderr,
                           "%s: unexpected character in fragment name (%s, %d)\n",
                           command_name, source_name, source_line);
                   exit(-1);
                 }
                 *p++ = c;
                 c = source_get();
                 break;
    }
  }
  fprintf(stderr, "%s: unexpected end of file (%s, %d)\n",
          command_name, source_name, source_line);
  exit(-1);
  return NULL;  /* unreachable return to avoid warnings on some compilers */
}
static Scrap_Node *reverse(); /* a forward declaration */

void reverse_lists(names)
     Name *names;
{
  while (names) {
    reverse_lists(names->llink);
    names->defs = reverse(names->defs);
    names->uses = reverse(names->uses);
    names = names->rlink;
  }
}
static Scrap_Node *reverse(a)
     Scrap_Node *a;
{
  if (a) {
    Scrap_Node *b = a->next;
    a->next = NULL;
    while (b) {
      Scrap_Node *c = b->next;
      b->next = a;
      a = b;
      b = c;
    }
  }
  return a;
}

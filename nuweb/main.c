#include "global.h"

#include <stdlib.h>
int main(argc, argv)
     int argc;
     char **argv;
{
  int arg = 1;
  /* Interpret command-line arguments */
  command_name = argv[0];
  while (arg < argc) {
    char *s = argv[arg];
    if (*s++ == '-') {
      /* Interpret the argument string \verb|s| */
      {
        char c = *s++;
        while (c) {
          switch (c) {
            case 'c': compare_flag = FALSE;
                      break;
            case 'd': dangling_flag = TRUE;
                      break;
            case 'h': hyperopt_flag = TRUE;
                      goto HasValue;
            case 'I': includepath_flag = TRUE;
                      goto HasValue;
            case 'l': listings_flag = TRUE;
                      break;
            case 'n': number_flag = TRUE;
                      break;
            case 'o': output_flag = FALSE;
                      break;
            case 'p': prepend_flag = TRUE;
                      goto HasValue;
            case 'r': hyperref_flag = TRUE;
                      break;
            case 's': scrap_flag = FALSE;
                      break;
            case 't': tex_flag = FALSE;
                      break;
            case 'v': verbose_flag = TRUE;
                      break;
            case 'V': version_info_flag = TRUE;
                      goto HasValue;
            case 'x': xref_flag = TRUE;
                      break;
            default:  fprintf(stderr, "%s: unexpected argument ignored.  ",
                              command_name);
                      fprintf(stderr, "Usage is: %s [-cdnostvx] "
                            "[-I path] [-V version] "
                            "[-h options] [-p path] file...\n",
                              command_name);
                      break;
          }
          c = *s++;
        }
HasValue:;
      }
      arg++;
      /* Perhaps get the prepend path */
      if (prepend_flag)
      {
        if (*s == '\0')
          s = argv[arg++];
        dirpath = s;
        prepend_flag = FALSE;
      }
      
      /* Perhaps get the version info string */
      if (version_info_flag)
      {
         if (*s == '\0')
           s = argv[arg++];
         version_string = s;
         version_info_flag = FALSE;
      }
      
      /* Perhaps get the hyperref options */
      if (hyperopt_flag)
      {
        if (*s == '\0')
          s = argv[arg++];
        hyperoptions = s;
        hyperopt_flag = FALSE;
        hyperref_flag = TRUE;
      }
      
      /* Perhaps add an include path */
      if (includepath_flag)
      {
         struct incl * le
            = (struct incl *)arena_getmem(sizeof(struct incl));
         struct incl ** p = &include_list;

         if (*s == '\0')
           s = argv[arg++];
         le->name = save_string(s);
         le->next = NULL;
         while (*p != NULL)
            p = &((*p)->next);
         *p = le;
         includepath_flag = FALSE;
      }
      
    }
    else break;
  }
  /* Set locale information */
  
  {
    /* try to get locale information */
    char *s=getenv("LC_CTYPE");
    if (s==NULL) s=getenv("LC_ALL");

    /* set it */
    if (s!=NULL)
      if(setlocale(LC_CTYPE, s)==NULL)
        fprintf(stderr, "Setting locale failed\n");
  }
  
  initialise_delimit_scrap_array();
  /* Process the remaining arguments (file names) */
  {
    if (arg >= argc) {
      fprintf(stderr, "%s: expected a file name.  ", command_name);
      fprintf(stderr, "Usage is: %s [-cnotv] [-p path] file-name...\n", command_name);
      exit(-1);
    }
    do {
      /* Handle the file name in \verb|argv[arg]| */
      {
        char source_name[FILENAME_MAX];
        char tex_name[FILENAME_MAX];
        char aux_name[FILENAME_MAX];
        /* Build \verb|source_name| and \verb|tex_name| */
        {
          char *p = argv[arg];
          char *q = source_name;
          char *trim = q;
          char *dot = NULL;
          char c = *p++;
          while (c) {
            *q++ = c;
            if (PATH_SEP(c)) {
              trim = q;
              dot = NULL;
            }
            else if (c == '.')
              dot = q - 1;
            c = *p++;
          }
          /* Add the source path to the include path list */
          if (trim != source_name) {
             struct incl * le
                = (struct incl *)arena_getmem(sizeof(struct incl));
             struct incl ** p = &include_list;
             char sv = *trim;

             *trim = '\0';
             le->name = save_string(source_name);
             le->next = NULL;
             while (*p != NULL)
                p = &((*p)->next);
             *p = le;
             *trim = sv;
          }
          
          *q = '\0';
          if (dot) {
            *dot = '\0'; /* produce HTML when the file extension is ".hw" */
            html_flag = dot[1] == 'h' && dot[2] == 'w' && dot[3] == '\0';
            sprintf(tex_name, "%s%s%s.tex", dirpath, path_sep, trim);
            sprintf(aux_name, "%s%s%s.aux", dirpath, path_sep, trim);
            *dot = '.';
          }
          else {
            sprintf(tex_name, "%s%s%s.tex", dirpath, path_sep, trim);
            sprintf(aux_name, "%s%s%s.aux", dirpath, path_sep, trim);
            *q++ = '.';
            *q++ = 'w';
            *q = '\0';
          }
        }
        /* Process a file */
        {
          pass1(source_name);
          current_sector = 1;
          prev_sector = 1;
          if (tex_flag) {
            if (html_flag) {
              int saved_number_flag = number_flag;
              number_flag = TRUE;
              collect_numbers(aux_name);
              write_html(source_name, tex_name, 0/*Dummy */);
              number_flag = saved_number_flag;
            }
            else {
              collect_numbers(aux_name);
              write_tex(source_name, tex_name);
            }
          }
          if (output_flag)
            write_files(file_names);
          arena_free();
        }
      }
      arg++;
    } while (arg < argc);
  }
  exit(0);
}

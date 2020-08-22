#include "global.h"
void write_files(files)
     Name *files;
{
  while (files) {
    write_files(files->llink);
    /* Write out \verb|files->spelling| */
    {
      static char temp_name[FILENAME_MAX];
      static char real_name[FILENAME_MAX];
      static int temp_name_count = 0;
      char indent_chars[MAX_INDENT];
      int temp_file_fd;
      FILE *temp_file;

      /* Find a free temporary file */
      
      for( temp_name_count = 0; temp_name_count < 10000; temp_name_count++) {
        sprintf(temp_name,"%s%snw%06d", dirpath, path_sep, temp_name_count);
      #ifdef O_EXCL
        if (-1 != (temp_file_fd = open(temp_name, O_CREAT|O_WRONLY|O_EXCL))) {
           temp_file = fdopen(temp_file_fd, "w");
           break;
        }
      #else
        if (0 != (temp_file = fopen(temp_name, "a"))) {
           if ( 0L == ftell(temp_file)) {
              break;
           } else {
              fclose(temp_file);
              temp_file = 0;
           }
        }
      #endif
      }
      if (!temp_file) {
        fprintf(stderr, "%s: can't create %s for a temporary file\n",
                command_name, temp_name);
        exit(-1);
      }
      

      sprintf(real_name, "%s%s%s", dirpath, path_sep, files->spelling);
      if (verbose_flag)
        fprintf(stderr, "writing %s [%s]\n", files->spelling, temp_name);
      write_scraps(temp_file, files->spelling, files->defs, 0, indent_chars,
                   files->debug_flag, files->tab_flag, files->indent_flag,
                   files->comment_flag, NULL, NULL, 0, files->spelling);
      fclose(temp_file);

      /* Move the temporary file to the target, if required */
      
      if (compare_flag)
        /* Compare the temp file and the old file */
        {
          FILE *old_file = fopen(real_name, "r");
          if (old_file) {
            int x, y;
            temp_file = fopen(temp_name, "r");
            do {
              x = getc(old_file);
              y = getc(temp_file);
            } while (x == y && x != EOF);
            fclose(old_file);
            fclose(temp_file);
            if (x == y)
              remove(temp_name);
            else {
              remove(real_name);
              /* Rename the temporary file to the target */
              
              if (0 != rename(temp_name, real_name)) {
                fprintf(stderr, "%s: can't rename output file to %s\n",
                        command_name, real_name);
              }
              
            }
          }
          else
            /* Rename the temporary file to the target */
            
            if (0 != rename(temp_name, real_name)) {
              fprintf(stderr, "%s: can't rename output file to %s\n",
                      command_name, real_name);
            }
            
        }
      else {
        remove(real_name);
        /* Rename the temporary file to the target */
        
        if (0 != rename(temp_name, real_name)) {
          fprintf(stderr, "%s: can't rename output file to %s\n",
                  command_name, real_name);
        }
        
      }
      
    }
    files = files->rlink;
  }
}

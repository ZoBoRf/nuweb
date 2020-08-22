/* Include files */

/* #include <fcntl.h> */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <signal.h>
#include <locale.h>

/* Type declarations */
#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif

#define MAX_INDENT 500
typedef struct scrap_node {
  struct scrap_node *next;
  int scrap;
  char quoted;
} Scrap_Node;
typedef struct name {
  char *spelling;
  struct name *llink;
  struct name *rlink;
  Scrap_Node *defs;
  Scrap_Node *uses;
  char * arg[9];
  int mark;
  char tab_flag;
  char indent_flag;
  char debug_flag;
  unsigned char comment_flag;
  unsigned char sector;
} Name;
#define ARG_CHR '\001'
typedef struct arglist
{Name * name;
struct arglist * args;
struct arglist * next;
} Arglist;
typedef struct embed {
   Scrap_Node * defs;
   Arglist * args;
} Embed_Node;
typedef struct uses {
  struct uses *next;
  Name *defn;
} Uses;
typedef struct l_node
{
   struct l_node * left, * right;
   int scrap, seq;
   char name[1];
} label_node;

/* Limits */

#ifndef MAX_NAME_LEN
#define MAX_NAME_LEN 1024
#endif

/* Global variable declarations */
extern int tex_flag;      /* if FALSE, don't emit the documentation file */
extern int html_flag;     /* if TRUE, emit HTML instead of LaTeX scraps. */
extern int output_flag;   /* if FALSE, don't emit the output files */
extern int compare_flag;  /* if FALSE, overwrite without comparison */
extern int verbose_flag;  /* if TRUE, write progress information */
extern int number_flag;   /* if TRUE, use a sequential numbering scheme */
extern int scrap_flag;    /* if FALSE, don't print list of scraps */
extern int dangling_flag;    /* if FALSE, don't print dangling identifiers */
extern int xref_flag; /* If TRUE, print cross-references in scrap comments */
extern int prepend_flag;  /* If TRUE, prepend a path to the output file names */
extern char * dirpath;    /* The prepended directory path */
extern char * path_sep;   /* How to join path to filename */
extern int listings_flag;   /* if TRUE, use listings package for scrap formatting */
extern int version_info_flag; /* If TRUE, set up version string */
extern char *  version_string; /* What to print for @v */
extern int hyperref_flag; /* Are we preparing for hyperref
                             package. */
extern int hyperopt_flag; /* Are we preparing for hyperref options */
extern char * hyperoptions; /* The options to pass to the
                               hyperref package */
extern int includepath_flag; /* Do we have an include path? */
extern struct incl{char * name; struct incl * next;} * include_list;
                       /* The list of include paths */
extern int nw_char;
extern char *command_name;
unsigned char current_sector;
unsigned char prev_sector;
char blockBuff[6400];
extern int extra_scraps;
extern char *source_name;  /* name of the current file */
extern int source_line;    /* current line in the source file */
extern int already_warned;
extern Name *file_names;
extern Name *macro_names;
extern Name *user_names;
extern int scrap_name_has_parameters;
extern int scrap_ended_with;
extern label_node * label_tab;

/* Function prototypes */
extern void pass1();
extern void write_tex();
void initialise_delimit_scrap_array(void);
void update_delimit_scrap();
extern int has_sector(Name *, unsigned char);
extern void write_html();
extern void write_files();
extern void source_open(); /* pass in the name of the source file */
extern int source_get();   /* no args; returns the next char or EOF */
extern int source_last;   /* what last source_get() returned. */
extern int source_peek;   /* The next character to get */
extern void source_ungetc(int*);
extern void init_scraps();
extern int collect_scrap();
extern int write_scraps();
extern void write_scrap_ref();
extern void write_single_scrap_ref();
extern int num_scraps();
extern int is_first_scrap();
extern void add_to_use(Name * name, int current_scrap);
Arglist * instance();
extern void collect_numbers();
extern Name *collect_file_name();
extern Name *collect_macro_name();
extern Arglist *collect_scrap_name();
extern Name *name_add();
extern Name *prefix_add();
extern char *save_string();
extern void reverse_lists();
extern int robs_strcmp(char*, char*);
extern Name *install_args();
extern void search();
extern void format_uses_refs(FILE *, int);
extern void format_defs_refs(FILE *, int);
void write_label(char label_name[], FILE * file);
extern void *arena_getmem();
extern void arena_free();

/* Operating System Dependencies */

#if defined(VMS)
#define PATH_SEP(c) (c==']'||c==':')
#define PATH_SEP_CHAR ""
#define DEFAULT_PATH ""
#elif defined(MSDOS)
#define PATH_SEP(c) (c=='\\')
#define PATH_SEP_CHAR "\\"
#define DEFAULT_PATH "."
#else
#define PATH_SEP(c) (c=='/')
#define PATH_SEP_CHAR "/"
#define DEFAULT_PATH "."
#endif
typedef int *Parameters;

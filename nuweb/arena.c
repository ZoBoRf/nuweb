#include "global.h"
typedef struct chunk {
  struct chunk *next;
  char *limit;
  char *avail;
} Chunk;
static Chunk first = { NULL, NULL, NULL };
static Chunk *arena = &first;
void *arena_getmem(n)
     size_t n;
{
  char *q;
  char *p = arena->avail;
  n = (n + 7) & ~7;             /* ensuring alignment to 8 bytes */
  q = p + n;
  if (q <= arena->limit) {
    arena->avail = q;
    return p;
  }
  /* Find a new chunk of memory */
  {
    Chunk *ap = arena;
    Chunk *np = ap->next;
    while (np) {
      char *v = sizeof(Chunk) + (char *) np;
      if (v + n <= np->limit) {
        np->avail = v + n;
        arena = np;
        return v;
      }
      ap = np;
      np = ap->next;
    }
    /* Allocate a new chunk of memory */
    {
      size_t m = n + 10000;
      np = (Chunk *) malloc(m);
      np->limit = m + (char *) np;
      np->avail = n + sizeof(Chunk) + (char *) np;
      np->next = NULL;
      ap->next = np;
      arena = np;
      return sizeof(Chunk) + (char *) np;
    }
  }
}
void arena_free()
{
  arena = &first;
}

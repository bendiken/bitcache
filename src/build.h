/* This is free and unencumbered software released into the public domain. */

#ifndef _BITCACHE_BUILD_H
#define _BITCACHE_BUILD_H

#ifdef __cplusplus
extern "C" {
#endif

/* private headers for the build process only */
#include "config.h"
#include "arch.h"

/* libcprime headers */
#include <cprime.h>
#include <cprime/memory.h>

/* public headers included from <bitcache.h> */
#include "id.h"
#include "filter.h"
#include "map.h"
#include "set.h"
#include "tree.h"

#ifdef __cplusplus
}
#endif

#endif /* _BITCACHE_BUILD_H */
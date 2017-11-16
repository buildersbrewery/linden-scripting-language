## Words

### some

* `AGENT_LIST_*` are flags
* fix `HTTP_BODY_TRUNCATED`
* fix related `PARCEL_DETAILS_*`
* fix `PARCEL_MEDIA_*`
* `PSYS_SRC_PATTERN_*` are flags
* `PRIM_MEDIA_MAX_*`
  * are flags
  * check values
* add completions for `PRIM_TYPE_*`
* `PRIM_TYPE_LEGACY`
  * fix "fake" docs
* `PRIM_SCULPT_TYPE_MASK`
  * fix docs
* `STATUS_CAST_SHADOWS`
  * fix status
    * fix tooltips
    * remove completions
    * change syntax
* `OBJECT_TEMP_ON_REZ`
  *  check if `FALSE` for avatars or attachments or temp attachments
* `PASS_NEVER` has version 1.40.2

### all

* fix sorting by most used for performance
  * of tooltip entries
  * of regex patterns in syntax file
* add "related"
* add "required_perms"
  * <http://wiki.secondlife.com/wiki/Category:LSL_Requires_Permissions>
* add "snippets"
* add "usage"
  * PRIM_MEDIA_MAX_HEIGHT_PIXELS
  * PRIM_MEDIA_MAX_URL_LENGTH
  * PRIM_MEDIA_MAX_WHITELIST_COUNT
  * PRIM_MEDIA_MAX_WHITELIST_SIZE
  * PRIM_MEDIA_MAX_WIDTH_PIXELS
  * PRIM_MEDIA_PARAM_MAX

## Final check

* make simple LSL syntax for tooltips, only containing word lists (and maybe strings)
* check metadata files against new syntax
* fix macros
* "ZERO_VECTOR.x" is not valid LSL in the syntax file
* JSON files do NOT have comments
* add other <https://en.wikipedia.org/wiki/Indentation_style>

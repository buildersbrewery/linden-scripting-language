;;; lsl-mode.el --- lsl-mode -- Major mode for LSL (Linden Scripting Language).

;;; Commentary:
;;;
;;; Major mode for editing LSL (Linden Scripting Language) files.
;;;
;;; See
;;; https://github.com/buildersbrewery/linden-scripting-language/tree/master/emacs
;;; for more details.

;;; Code:

(require 'thingatpt )

(defvar lsl-mode-version)
(setq lsl-mode-version "2015-05-01")

(defgroup lsl-mode nil
  "Major mode for editing LSL (Linden Scripting Language)."
  :group 'languages)

(defcustom lsl-mode-format-style 1
  "Set autoformatting style below:

0 = no automatic formatting
1 = formating style like LSL client
2 = formatting style as in `c-mode'"
  :type '(integer)
  :group 'lsl-mode)

(defcustom lsl-reference-url "https://wiki.secondlife.com/w/index.php?search="
  "URL for LSL reference guide."
  :type '(string)
  :group 'lsl-mode)

(defvar lsl-mode-hook nil "Standard hook for `lsl-mode'.")

(defvar lsl-mode-map nil "Keymap for `lsl-mode'.")

(when (not lsl-mode-map)
  (setq lsl-mode-map (make-sparse-keymap))
  (define-key lsl-mode-map (kbd "C-c C-c") 'lsl-copy-all)
  (define-key lsl-mode-map (kbd "C-c C-r") 'lsl-lookup-lsl-ref)
  (define-key lsl-mode-map (kbd "M-TAB") 'lsl-complete-symbol)
  (define-key lsl-mode-map [remap comment-dwim] 'lsl-comment-dwim)
  (define-key lsl-mode-map [menu-bar] (make-sparse-keymap))
  (let ((menuMap (make-sparse-keymap "LSL")))
    (define-key lsl-mode-map [menu-bar lsl] (cons "LSL" menuMap))
    (define-key menuMap [goto-home-page] '("Goto lsl-mode website" . (lambda () (interactive) (browse-url "https://github.com/buildersbrewery/linden-scripting-language/blob/master/emacs/"))))
    (define-key menuMap [customize] '("Customize lsl-mode" . (lambda () (interactive) (customize-group 'lsl-mode))))
    (define-key menuMap [separator] '("--"))
    (define-key menuMap [copy-all] '("Copy whole buffer" . lsl-copy-all))
    (define-key menuMap [lookup-onlne-doc] '("Lookup ref on current word" . lsl-lookup-lsl-ref))
    (define-key menuMap [keyword-completion] '("Keyword Completion" . lsl-complete-symbol))))
(
defvar lsl-mode-syntax-table
  (let ((synTable (make-syntax-table)))
    (modify-syntax-entry ?\/ ". 12b" synTable)
    (modify-syntax-entry ?\n "> b" synTable)
    (modify-syntax-entry ?= "." synTable)
    (modify-syntax-entry ?< "." synTable)
    (modify-syntax-entry ?> "." synTable)
    (modify-syntax-entry ?+ "." synTable)
    (modify-syntax-entry ?- "." synTable)
    (modify-syntax-entry ?* "." synTable)
    (modify-syntax-entry ?& "." synTable)
    (modify-syntax-entry ?| "." synTable)
    synTable)
  "Syntax table for `lsl-mode'.")

(defun lsl-copy-all ()
  (interactive)
  (kill-ring-save (point-min) (point-max))
  (message "Buffer content copied."))

(defun lsl-comment-dwim (arg)
  (interactive "*P")
  (require 'newcomment)
  (let ((deactivate-mark nil) (comment-start "//") (comment-end ""))
    (comment-dwim arg)))

(defun lsl-lookup-lsl-site (site-url)
  (let (pos1 pos2 bds meat myurl)
    (if (and transient-mark-mode mark-active)
        (setq pos1 (region-beginning)
              pos2 (region-end))
      (progn
        (setq bds (bounds-of-thing-at-point 'symbol))
        (setq pos1 (car bds) pos2 (cdr bds))))
    (setq meat
      (if (and pos1 pos2 )
          (buffer-substring-no-properties pos1 pos2)
        nil ))
    (if meat
        (progn
          (setq meat (replace-regexp-in-string " " "%20" meat))
          (setq myurl (concat site-url meat))
          (browse-url myurl))
      (progn (ding) (message "No word under cursor to lookup.")))))

(defun lsl-lookup-lsl-ref ()
  (interactive) (lsl-lookup-lsl-site lsl-reference-url)
)

(defvar lsl-keywords
  '("do" "else" "for" "if" "jump" "return" "state" "while")
  "LSL keywords.")

(defvar lsl-types
  '("float" "integer" "key" "list" "quaternion" "rotation" "string" "vector")
  "LSL types.")

(defvar lsl-constants
  '("ACTIVE" "AGENT" "AGENT_ALWAYS_RUN" "AGENT_ATTACHMENTS" "AGENT_AUTOMATED" "AGENT_AUTOPILOT" "AGENT_AWAY" "AGENT_BUSY" "AGENT_BY_LEGACY_NAME" "AGENT_BY_USERNAME" "AGENT_CROUCHING" "AGENT_FLOATING_VIA_SCRIPTED_ATTACHMENT" "AGENT_FLYING" "AGENT_IN_AIR" "AGENT_LIST_PARCEL" "AGENT_LIST_PARCEL_OWNER" "AGENT_LIST_REGION" "AGENT_MOUSELOOK" "AGENT_ON_OBJECT" "AGENT_SCRIPTED" "AGENT_SITTING" "AGENT_TYPING" "AGENT_WALKING" "ALL_SIDES" "ANIM_ON" "ATTACH_ANY_HUD" "ATTACH_AVATAR_CENTER" "ATTACH_BACK" "ATTACH_BELLY" "ATTACH_CHEST" "ATTACH_CHIN" "ATTACH_FACE_JAW" "ATTACH_FACE_LEAR" "ATTACH_FACE_LEYE" "ATTACH_FACE_REAR" "ATTACH_FACE_REYE" "ATTACH_FACE_TONGUE" "ATTACH_GROIN" "ATTACH_HEAD" "ATTACH_HIND_LFOOT" "ATTACH_HIND_RFOOT" "ATTACH_HUD_BOTTOM" "ATTACH_HUD_BOTTOM_LEFT" "ATTACH_HUD_BOTTOM_RIGHT" "ATTACH_HUD_CENTER_1" "ATTACH_HUD_CENTER_2" "ATTACH_HUD_TOP_CENTER" "ATTACH_HUD_TOP_LEFT" "ATTACH_HUD_TOP_RIGHT" "ATTACH_LEAR" "ATTACH_LEFT_PEC" "ATTACH_LEYE" "ATTACH_LFOOT" "ATTACH_LHAND" "ATTACH_LHAND_RING1" "ATTACH_LHIP" "ATTACH_LLARM" "ATTACH_LLLEG" "ATTACH_LPEC" "ATTACH_LSHOULDER" "ATTACH_LUARM" "ATTACH_LULEG" "ATTACH_LWING" "ATTACH_MOUTH" "ATTACH_NECK" "ATTACH_NOSE" "ATTACH_PELVIS" "ATTACH_REAR" "ATTACH_REYE" "ATTACH_RFOOT" "ATTACH_RHAND" "ATTACH_RHAND_RING1" "ATTACH_RHIP" "ATTACH_RIGHT_PEC" "ATTACH_RLARM" "ATTACH_RLLEG" "ATTACH_RPEC" "ATTACH_RSHOULDER" "ATTACH_RUARM" "ATTACH_RULEG" "ATTACH_RWING" "ATTACH_TAIL_BASE" "ATTACH_TAIL_TIP" "AVOID_CHARACTERS" "AVOID_DYNAMIC_OBSTACLES" "AVOID_NONE" "BEACON_MAP" "CAMERA_ACTIVE" "CAMERA_BEHINDNESS_ANGLE" "CAMERA_BEHINDNESS_LAG" "CAMERA_DISTANCE" "CAMERA_FOCUS" "CAMERA_FOCUS_LAG" "CAMERA_FOCUS_LOCKED" "CAMERA_FOCUS_OFFSET" "CAMERA_FOCUS_THRESHOLD" "CAMERA_PITCH" "CAMERA_POSITION" "CAMERA_POSITION_LAG" "CAMERA_POSITION_LOCKED" "CAMERA_POSITION_THRESHOLD" "CHANGED_ALLOWED_DROP" "CHANGED_COLOR" "CHANGED_INVENTORY" "CHANGED_LINK" "CHANGED_MEDIA" "CHANGED_OWNER" "CHANGED_REGION" "CHANGED_REGION_START" "CHANGED_RENDER_MATERIAL" "CHANGED_SCALE" "CHANGED_SHAPE" "CHANGED_TELEPORT" "CHANGED_TEXTURE" "CHARACTER_ACCOUNT_FOR_SKIPPED_FRAMES" "CHARACTER_AVOIDANCE_MODE" "CHARACTER_CMD_JUMP" "CHARACTER_CMD_SMOOTH_STOP" "CHARACTER_CMD_STOP" "CHARACTER_DESIRED_SPEED" "CHARACTER_DESIRED_TURN_SPEED" "CHARACTER_LENGTH" "CHARACTER_MAX_ACCEL" "CHARACTER_MAX_DECEL" "CHARACTER_MAX_SPEED" "CHARACTER_MAX_TURN_RADIUS" "CHARACTER_ORIENTATION" "CHARACTER_RADIUS" "CHARACTER_STAY_WITHIN_PARCEL" "CHARACTER_TYPE" "CHARACTER_TYPE_A" "CHARACTER_TYPE_B" "CHARACTER_TYPE_C" "CHARACTER_TYPE_D" "CHARACTER_TYPE_NONE" "CLICK_ACTION_BUY" "CLICK_ACTION_DISABLED" "CLICK_ACTION_IGNORE" "CLICK_ACTION_NONE" "CLICK_ACTION_OPEN" "CLICK_ACTION_OPEN_MEDIA" "CLICK_ACTION_PAY" "CLICK_ACTION_PLAY" "CLICK_ACTION_SIT" "CLICK_ACTION_TOUCH" "CLICK_ACTION_ZOOM" "COMBAT_CHANNEL" "COMBAT_LOG_ID" "CONTENT_TYPE_ATOM" "CONTENT_TYPE_FORM" "CONTENT_TYPE_HTML" "CONTENT_TYPE_JSON" "CONTENT_TYPE_LLSD" "CONTENT_TYPE_RSS" "CONTENT_TYPE_TEXT" "CONTENT_TYPE_XHTML" "CONTENT_TYPE_XML" "CONTROL_BACK" "CONTROL_DOWN" "CONTROL_FWD" "CONTROL_LBUTTON" "CONTROL_LEFT" "CONTROL_ML_LBUTTON" "CONTROL_RIGHT" "CONTROL_ROT_LEFT" "CONTROL_ROT_RIGHT" "CONTROL_UP" "DAMAGEABLE" "DAMAGE_TYPE_ACID" "DAMAGE_TYPE_BLUDGEONING" "DAMAGE_TYPE_COLD" "DAMAGE_TYPE_ELECTRIC" "DAMAGE_TYPE_EMOTIONAL" "DAMAGE_TYPE_FIRE" "DAMAGE_TYPE_FORCE" "DAMAGE_TYPE_GENERIC" "DAMAGE_TYPE_IMPACT" "DAMAGE_TYPE_NECROTIC" "DAMAGE_TYPE_PIERCING" "DAMAGE_TYPE_POISON" "DAMAGE_TYPE_PSYCHIC" "DAMAGE_TYPE_RADIANT" "DAMAGE_TYPE_SLASHING" "DAMAGE_TYPE_SONIC" "DATA_BORN" "DATA_NAME" "DATA_ONLINE" "DATA_PAYINFO" "DATA_RATING" "DATA_SIM_POS" "DATA_SIM_RATING" "DATA_SIM_STATUS" "DEBUG_CHANNEL" "DEG_TO_RAD" "DENSITY" "DEREZ_DIE" "DEREZ_MAKE_TEMP" "DEREZ_TO_INVENTORY" "ENVIRONMENT_DAYINFO" "ENV_INVALID_AGENT" "ENV_INVALID_RULE" "ENV_NOT_EXPERIENCE" "ENV_NO_ENVIRONMENT" "ENV_NO_EXPERIENCE_LAND" "ENV_NO_EXPERIENCE_PERMISSION" "ENV_NO_PERMISSIONS" "ENV_THROTTLE" "ENV_VALIDATION_FAIL" "EOF" "ERR_GENERIC" "ERR_MALFORMED_PARAMS" "ERR_PARCEL_PERMISSIONS" "ERR_RUNTIME_PERMISSIONS" "ERR_THROTTLED" "ESTATE_ACCESS_ALLOWED_AGENT_ADD" "ESTATE_ACCESS_ALLOWED_AGENT_REMOVE" "ESTATE_ACCESS_ALLOWED_GROUP_ADD" "ESTATE_ACCESS_ALLOWED_GROUP_REMOVE" "ESTATE_ACCESS_BANNED_AGENT_ADD" "ESTATE_ACCESS_BANNED_AGENT_REMOVE" "FALSE" "FILTER_FLAGS" "FILTER_FLAG_HUDS" "FILTER_INCLUDE" "FORCE_DIRECT_PATH" "FRICTION" "GAME_CONTROL_AXIS_LEFTX" "GAME_CONTROL_AXIS_LEFTY" "GAME_CONTROL_AXIS_RIGHTX" "GAME_CONTROL_AXIS_RIGHTY" "GAME_CONTROL_AXIS_TRIGGERLEFT" "GAME_CONTROL_AXIS_TRIGGERRIGHT" "GAME_CONTROL_BUTTON_A" "GAME_CONTROL_BUTTON_B" "GAME_CONTROL_BUTTON_BACK" "GAME_CONTROL_BUTTON_DPAD_DOWN" "GAME_CONTROL_BUTTON_DPAD_LEFT" "GAME_CONTROL_BUTTON_DPAD_RIGHT" "GAME_CONTROL_BUTTON_DPAD_UP" "GAME_CONTROL_BUTTON_GUIDE" "GAME_CONTROL_BUTTON_LEFTSHOULDER" "GAME_CONTROL_BUTTON_LEFTSTICK" "GAME_CONTROL_BUTTON_MISC1" "GAME_CONTROL_BUTTON_PADDLE1" "GAME_CONTROL_BUTTON_PADDLE2" "GAME_CONTROL_BUTTON_PADDLE3" "GAME_CONTROL_BUTTON_PADDLE4" "GAME_CONTROL_BUTTON_RIGHTSHOULDER" "GAME_CONTROL_BUTTON_RIGHTSTICK" "GAME_CONTROL_BUTTON_START" "GAME_CONTROL_BUTTON_TOUCHPAD" "GAME_CONTROL_BUTTON_X" "GAME_CONTROL_BUTTON_Y" "GCNP_GET_WALKABILITY" "GCNP_RADIUS" "GCNP_STATIC" "GRAVITY_MULTIPLIER" "HORIZONTAL" "HTTP_ACCEPT" "HTTP_BODY_MAXLENGTH" "HTTP_BODY_TRUNCATED" "HTTP_CUSTOM_HEADER" "HTTP_EXTENDED_ERROR" "HTTP_METHOD" "HTTP_MIMETYPE" "HTTP_PRAGMA_NO_CACHE" "HTTP_USER_AGENT" "HTTP_VERBOSE_THROTTLE" "HTTP_VERIFY_CERT" "IMG_USE_BAKED_AUX1" "IMG_USE_BAKED_AUX2" "IMG_USE_BAKED_AUX3" "IMG_USE_BAKED_EYES" "IMG_USE_BAKED_HAIR" "IMG_USE_BAKED_HEAD" "IMG_USE_BAKED_LEFTARM" "IMG_USE_BAKED_LEFTLEG" "IMG_USE_BAKED_LOWER" "IMG_USE_BAKED_SKIRT" "IMG_USE_BAKED_UPPER" "INVENTORY_ALL" "INVENTORY_ANIMATION" "INVENTORY_BODYPART" "INVENTORY_CLOTHING" "INVENTORY_GESTURE" "INVENTORY_LANDMARK" "INVENTORY_MATERIAL" "INVENTORY_NONE" "INVENTORY_NOTECARD" "INVENTORY_OBJECT" "INVENTORY_SCRIPT" "INVENTORY_SETTING" "INVENTORY_SOUND" "INVENTORY_TEXTURE" "JSON_APPEND" "JSON_ARRAY" "JSON_DELETE" "JSON_FALSE" "JSON_INVALID" "JSON_NULL" "JSON_NUMBER" "JSON_OBJECT" "JSON_STRING" "JSON_TRUE" "KFM_CMD_PAUSE" "KFM_CMD_PLAY" "KFM_CMD_STOP" "KFM_COMMAND" "KFM_DATA" "KFM_FORWARD" "KFM_LOOP" "KFM_MODE" "KFM_PING_PONG" "KFM_REVERSE" "KFM_ROTATION" "KFM_TRANSLATION" "LAND_LARGE_BRUSH" "LAND_LEVEL" "LAND_LOWER" "LAND_MEDIUM_BRUSH" "LAND_NOISE" "LAND_RAISE" "LAND_REVERT" "LAND_SMALL_BRUSH" "LAND_SMOOTH" "LEGACY_MASS_FACTOR" "LINKSETDATA_DELETE" "LINKSETDATA_EMEMORY" "LINKSETDATA_ENOKEY" "LINKSETDATA_EPROTECTED" "LINKSETDATA_MULTIDELETE" "LINKSETDATA_NOTFOUND" "LINKSETDATA_NOUPDATE" "LINKSETDATA_OK" "LINKSETDATA_RESET" "LINKSETDATA_UPDATE" "LINK_ALL_CHILDREN" "LINK_ALL_OTHERS" "LINK_ROOT" "LINK_SET" "LINK_THIS" "LIST_STAT_GEOMETRIC_MEAN" "LIST_STAT_MAX" "LIST_STAT_MEAN" "LIST_STAT_MEDIAN" "LIST_STAT_MIN" "LIST_STAT_NUM_COUNT" "LIST_STAT_RANGE" "LIST_STAT_STD_DEV" "LIST_STAT_SUM" "LIST_STAT_SUM_SQUARES" "LOOP" "MASK_BASE" "MASK_COMBINED" "MASK_EVERYONE" "MASK_GROUP" "MASK_NEXT" "MASK_OWNER" "NAK" "NAVIGATE_TO_GOAL_REACHED_DIST" "NULL_KEY" "OBJECT_ACCOUNT_LEVEL" "OBJECT_ANIMATED_COUNT" "OBJECT_ANIMATED_SLOTS_AVAILABLE" "OBJECT_ATTACHED_POINT" "OBJECT_ATTACHED_SLOTS_AVAILABLE" "OBJECT_BODY_SHAPE_TYPE" "OBJECT_CHARACTER_TIME" "OBJECT_CLICK_ACTION" "OBJECT_CREATION_TIME" "OBJECT_CREATOR" "OBJECT_DAMAGE" "OBJECT_DAMAGE_TYPE" "OBJECT_DESC" "OBJECT_GROUP" "OBJECT_GROUP_TAG" "OBJECT_HEALTH" "OBJECT_HOVER_HEIGHT" "OBJECT_LAST_OWNER_ID" "OBJECT_LINK_NUMBER" "OBJECT_MASS" "OBJECT_MATERIAL" "OBJECT_NAME" "OBJECT_OMEGA" "OBJECT_OWNER" "OBJECT_PATHFINDING_TYPE" "OBJECT_PERMS" "OBJECT_PERMS_COMBINED" "OBJECT_PHANTOM" "OBJECT_PHYSICS" "OBJECT_PHYSICS_COST" "OBJECT_POS" "OBJECT_PRIM_COUNT" "OBJECT_PRIM_EQUIVALENCE" "OBJECT_RENDER_WEIGHT" "OBJECT_RETURN_PARCEL" "OBJECT_RETURN_PARCEL_OWNER" "OBJECT_RETURN_REGION" "OBJECT_REZZER_KEY" "OBJECT_REZ_TIME" "OBJECT_ROOT" "OBJECT_ROT" "OBJECT_RUNNING_SCRIPT_COUNT" "OBJECT_SCALE" "OBJECT_SCRIPT_MEMORY" "OBJECT_SCRIPT_TIME" "OBJECT_SELECT_COUNT" "OBJECT_SERVER_COST" "OBJECT_SIT_COUNT" "OBJECT_STREAMING_COST" "OBJECT_TEMP_ATTACHED" "OBJECT_TEMP_ON_REZ" "OBJECT_TEXT" "OBJECT_TEXT_ALPHA" "OBJECT_TEXT_COLOR" "OBJECT_TOTAL_INVENTORY_COUNT" "OBJECT_TOTAL_SCRIPT_COUNT" "OBJECT_UNKNOWN_DETAIL" "OBJECT_VELOCITY" "OPT_AVATAR" "OPT_CHARACTER" "OPT_EXCLUSION_VOLUME" "OPT_LEGACY_LINKSET" "OPT_MATERIAL_VOLUME" "OPT_OTHER" "OPT_STATIC_OBSTACLE" "OPT_WALKABLE" "OVERRIDE_GLTF_BASE_ALPHA" "OVERRIDE_GLTF_BASE_ALPHA_MASK" "OVERRIDE_GLTF_BASE_ALPHA_MODE" "OVERRIDE_GLTF_BASE_COLOR_FACTOR" "OVERRIDE_GLTF_BASE_DOUBLE_SIDED" "OVERRIDE_GLTF_EMISSIVE_FACTOR" "OVERRIDE_GLTF_METALLIC_FACTOR" "OVERRIDE_GLTF_ROUGHNESS_FACTOR" "PARCEL_COUNT_GROUP" "PARCEL_COUNT_OTHER" "PARCEL_COUNT_OWNER" "PARCEL_COUNT_SELECTED" "PARCEL_COUNT_TEMP" "PARCEL_COUNT_TOTAL" "PARCEL_DETAILS_AREA" "PARCEL_DETAILS_DESC" "PARCEL_DETAILS_FLAGS" "PARCEL_DETAILS_GROUP" "PARCEL_DETAILS_ID" "PARCEL_DETAILS_LANDING_LOOKAT" "PARCEL_DETAILS_LANDING_POINT" "PARCEL_DETAILS_NAME" "PARCEL_DETAILS_OWNER" "PARCEL_DETAILS_PRIM_CAPACITY" "PARCEL_DETAILS_PRIM_USED" "PARCEL_DETAILS_SCRIPT_DANGER" "PARCEL_DETAILS_SEE_AVATARS" "PARCEL_DETAILS_TP_ROUTING" "PARCEL_FLAG_ALLOW_ALL_OBJECT_ENTRY" "PARCEL_FLAG_ALLOW_CREATE_GROUP_OBJECTS" "PARCEL_FLAG_ALLOW_CREATE_OBJECTS" "PARCEL_FLAG_ALLOW_DAMAGE" "PARCEL_FLAG_ALLOW_FLY" "PARCEL_FLAG_ALLOW_GROUP_OBJECT_ENTRY" "PARCEL_FLAG_ALLOW_GROUP_SCRIPTS" "PARCEL_FLAG_ALLOW_LANDMARK" "PARCEL_FLAG_ALLOW_SCRIPTS" "PARCEL_FLAG_ALLOW_TERRAFORM" "PARCEL_FLAG_LINDEN_HOMES" "PARCEL_FLAG_LOCAL_SOUND_ONLY" "PARCEL_FLAG_RESTRICT_PUSHOBJECT" "PARCEL_FLAG_USE_ACCESS_GROUP" "PARCEL_FLAG_USE_ACCESS_LIST" "PARCEL_FLAG_USE_BAN_LIST" "PARCEL_FLAG_USE_LAND_PASS_LIST" "PARCEL_MEDIA_COMMAND_AGENT" "PARCEL_MEDIA_COMMAND_AUTO_ALIGN" "PARCEL_MEDIA_COMMAND_DESC" "PARCEL_MEDIA_COMMAND_LOOP" "PARCEL_MEDIA_COMMAND_LOOP_SET" "PARCEL_MEDIA_COMMAND_PAUSE" "PARCEL_MEDIA_COMMAND_PLAY" "PARCEL_MEDIA_COMMAND_SIZE" "PARCEL_MEDIA_COMMAND_STOP" "PARCEL_MEDIA_COMMAND_TEXTURE" "PARCEL_MEDIA_COMMAND_TIME" "PARCEL_MEDIA_COMMAND_TYPE" "PARCEL_MEDIA_COMMAND_UNLOAD" "PARCEL_MEDIA_COMMAND_URL" "PARCEL_SALE_AGENT" "PARCEL_SALE_OBJECTS" "PARCEL_SALE_PRICE" "PARCEL_SALE_OK" "PARCEL_SALE_ERROR_NO_PARCEL" "PARCEL_SALE_ERROR_NO_PERMISSIONS" "PARCEL_SALE_ERROR_IN_ESCROW" "PARCEL_SALE_ERROR_INVALID_PRICE" "PARCEL_SALE_ERROR_BAD_PARAMS" "PASSIVE" "PASS_ALWAYS" "PASS_IF_NOT_HANDLED" "PASS_NEVER" "PATROL_PAUSE_AT_WAYPOINTS" "PAYMENT_INFO_ON_FILE" "PAYMENT_INFO_USED" "PAY_DEFAULT" "PAY_HIDE" "PERMISSION_DEBIT" "PERMISSION_TAKE_CONTROLS" "PERMISSION_REMAP_CONTROLS" "PERMISSION_TRIGGER_ANIMATION" "PERMISSION_ATTACH" "PERMISSION_RELEASE_OWNERSHIP" "PERMISSION_CHANGE_LINKS" "PERMISSION_CHANGE_JOINTS" "PERMISSION_CHANGE_PERMISSIONS" "PERMISSION_TRACK_CAMERA" "PERMISSION_CONTROL_CAMERA" "PERMISSION_TELEPORT" "PERMISSION_SILENT_ESTATE_MANAGEMENT" "PERMISSION_OVERRIDE_ANIMATIONS" "PERMISSION_RETURN_OBJECTS" "PERMISSION_PRIVILEGED_LAND_ACCESS" "PERM_ALL" "PERM_COPY" "PERM_MODIFY" "PERM_MOVE" "PERM_TRANSFER" "PI" "PING_PONG" "PI_BY_TWO" "PRIM_ALLOW_UNSIT" "PRIM_ALPHA_MODE" "PRIM_ALPHA_MODE_BLEND" "PRIM_ALPHA_MODE_EMISSIVE" "PRIM_ALPHA_MODE_MASK" "PRIM_ALPHA_MODE_NONE" "PRIM_BUMP_BARK" "PRIM_BUMP_BLOBS" "PRIM_BUMP_BRICKS" "PRIM_BUMP_BRIGHT" "PRIM_BUMP_CHECKER" "PRIM_BUMP_CONCRETE" "PRIM_BUMP_DARK" "PRIM_BUMP_DISKS" "PRIM_BUMP_GRAVEL" "PRIM_BUMP_LARGETILE" "PRIM_BUMP_NONE" "PRIM_BUMP_SHINY" "PRIM_BUMP_SIDING" "PRIM_BUMP_STONE" "PRIM_BUMP_STUCCO" "PRIM_BUMP_SUCTION" "PRIM_BUMP_TILE" "PRIM_BUMP_WEAVE" "PRIM_BUMP_WOOD" "PRIM_CAST_SHADOWS" "PRIM_CLICK_ACTION" "PRIM_COLLISION_SOUND" "PRIM_COLOR" "PRIM_DAMAGE" "PRIM_DESC" "PRIM_FLEXIBLE" "PRIM_FULLBRIGHT" "PRIM_GLOW" "PRIM_GLTF_ALPHA_MODE_BLEND" "PRIM_GLTF_ALPHA_MODE_MASK" "PRIM_GLTF_ALPHA_MODE_OPAQUE" "PRIM_GLTF_BASE_COLOR" "PRIM_GLTF_EMISSIVE" "PRIM_GLTF_METALLIC_ROUGHNESS" "PRIM_GLTF_NORMAL" "PRIM_HEALTH" "PRIM_HOLE_CIRCLE" "PRIM_HOLE_DEFAULT" "PRIM_HOLE_SQUARE" "PRIM_HOLE_TRIANGLE" "PRIM_LINK_TARGET" "PRIM_MATERIAL" "PRIM_MATERIAL_DENSITY" "PRIM_MATERIAL_FLESH" "PRIM_MATERIAL_FRICTION" "PRIM_MATERIAL_GLASS" "PRIM_MATERIAL_GRAVITY_MULTIPLIER" "PRIM_MATERIAL_LIGHT" "PRIM_MATERIAL_METAL" "PRIM_MATERIAL_PLASTIC" "PRIM_MATERIAL_RESTITUTION" "PRIM_MATERIAL_RUBBER" "PRIM_MATERIAL_STONE" "PRIM_MATERIAL_WOOD" "PRIM_MEDIA_ALT_IMAGE_ENABLE" "PRIM_MEDIA_AUTO_LOOP" "PRIM_MEDIA_AUTO_PLAY" "PRIM_MEDIA_AUTO_SCALE" "PRIM_MEDIA_AUTO_ZOOM" "PRIM_MEDIA_CONTROLS" "PRIM_MEDIA_CONTROLS_MINI" "PRIM_MEDIA_CONTROLS_STANDARD" "PRIM_MEDIA_CURRENT_URL" "PRIM_MEDIA_FIRST_CLICK_INTERACT" "PRIM_MEDIA_HEIGHT_PIXELS" "PRIM_MEDIA_HOME_URL" "PRIM_MEDIA_MAX_HEIGHT_PIXELS" "PRIM_MEDIA_MAX_URL_LENGTH" "PRIM_MEDIA_MAX_WHITELIST_COUNT" "PRIM_MEDIA_MAX_WHITELIST_SIZE" "PRIM_MEDIA_MAX_WIDTH_PIXELS" "PRIM_MEDIA_PARAM_MAX" "PRIM_MEDIA_PERMS_CONTROL" "PRIM_MEDIA_PERMS_INTERACT" "PRIM_MEDIA_PERM_ANYONE" "PRIM_MEDIA_PERM_GROUP" "PRIM_MEDIA_PERM_NONE" "PRIM_MEDIA_PERM_OWNER" "PRIM_MEDIA_WHITELIST" "PRIM_MEDIA_WHITELIST_ENABLE" "PRIM_MEDIA_WIDTH_PIXELS" "PRIM_NAME" "PRIM_NORMAL" "PRIM_OMEGA" "PRIM_PHANTOM" "PRIM_PHYSICS" "PRIM_PHYSICS_SHAPE_CONVEX" "PRIM_PHYSICS_SHAPE_NONE" "PRIM_PHYSICS_SHAPE_PRIM" "PRIM_PHYSICS_SHAPE_TYPE" "PRIM_POINT_LIGHT" "PRIM_POSITION" "PRIM_POS_LOCAL" "PRIM_PROJECTOR" "PRIM_REFLECTION_PROBE" "PRIM_REFLECTION_PROBE_BOX" "PRIM_REFLECTION_PROBE_DYNAMIC" "PRIM_REFLECTION_PROBE_MIRROR" "PRIM_RENDER_MATERIAL" "PRIM_ROTATION" "PRIM_ROT_LOCAL" "PRIM_SCRIPTED_SIT_ONLY" "PRIM_SCULPT_FLAG_ANIMESH" "PRIM_SCULPT_FLAG_INVERT" "PRIM_SCULPT_FLAG_MIRROR" "PRIM_SCULPT_TYPE_CYLINDER" "PRIM_SCULPT_TYPE_MASK" "PRIM_SCULPT_TYPE_MESH" "PRIM_SCULPT_TYPE_PLANE" "PRIM_SCULPT_TYPE_SPHERE" "PRIM_SCULPT_TYPE_TORUS" "PRIM_SHINY_HIGH" "PRIM_SHINY_LOW" "PRIM_SHINY_MEDIUM" "PRIM_SHINY_NONE" "PRIM_SIT_FLAGS" "PRIM_SIT_TARGET" "PRIM_SIZE" "PRIM_SLICE" "PRIM_SPECULAR" "PRIM_TEMP_ON_REZ" "PRIM_TEXGEN" "PRIM_TEXGEN_DEFAULT" "PRIM_TEXGEN_PLANAR" "PRIM_TEXT" "PRIM_TEXTURE" "PRIM_TYPE" "PRIM_TYPE_BOX" "PRIM_TYPE_CYLINDER" "PRIM_TYPE_PRISM" "PRIM_TYPE_RING" "PRIM_TYPE_SCULPT" "PRIM_TYPE_SPHERE" "PRIM_TYPE_TORUS" "PRIM_TYPE_TUBE" "PROFILE_NONE" "PROFILE_SCRIPT_MEMORY" "PSYS_PART_BF_DEST_COLOR" "PSYS_PART_BF_ONE" "PSYS_PART_BF_ONE_MINUS_DEST_COLOR" "PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA" "PSYS_PART_BF_ONE_MINUS_SOURCE_COLOR" "PSYS_PART_BF_SOURCE_ALPHA" "PSYS_PART_BF_SOURCE_COLOR" "PSYS_PART_BF_ZERO" "PSYS_PART_BLEND_FUNC_DEST" "PSYS_PART_BLEND_FUNC_SOURCE" "PSYS_PART_BOUNCE_MASK" "PSYS_PART_EMISSIVE_MASK" "PSYS_PART_END_ALPHA" "PSYS_PART_END_COLOR" "PSYS_PART_END_GLOW" "PSYS_PART_END_SCALE" "PSYS_PART_FLAGS" "PSYS_PART_FOLLOW_SRC_MASK" "PSYS_PART_FOLLOW_VELOCITY_MASK" "PSYS_PART_INTERP_COLOR_MASK" "PSYS_PART_INTERP_SCALE_MASK" "PSYS_PART_MAX_AGE" "PSYS_PART_RIBBON_MASK" "PSYS_PART_START_ALPHA" "PSYS_PART_START_COLOR" "PSYS_PART_START_GLOW" "PSYS_PART_START_SCALE" "PSYS_PART_TARGET_LINEAR_MASK" "PSYS_PART_TARGET_POS_MASK" "PSYS_PART_WIND_MASK" "PSYS_SRC_ACCEL" "PSYS_SRC_ANGLE_BEGIN" "PSYS_SRC_ANGLE_END" "PSYS_SRC_BURST_PART_COUNT" "PSYS_SRC_BURST_RADIUS" "PSYS_SRC_BURST_RATE" "PSYS_SRC_BURST_SPEED_MAX" "PSYS_SRC_BURST_SPEED_MIN" "PSYS_SRC_INNERANGLE" "PSYS_SRC_MAX_AGE" "PSYS_SRC_OBJ_REL_MASK" "PSYS_SRC_OMEGA" "PSYS_SRC_OUTERANGLE" "PSYS_SRC_PATTERN" "PSYS_SRC_PATTERN_ANGLE" "PSYS_SRC_PATTERN_ANGLE_CONE" "PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY" "PSYS_SRC_PATTERN_DROP" "PSYS_SRC_PATTERN_EXPLODE" "PSYS_SRC_TARGET_KEY" "PSYS_SRC_TEXTURE" "PUBLIC_CHANNEL" "PURSUIT_FUZZ_FACTOR" "PURSUIT_GOAL_TOLERANCE" "PURSUIT_INTERCEPT" "PURSUIT_OFFSET" "PU_EVADE_HIDDEN" "PU_EVADE_SPOTTED" "PU_FAILURE_DYNAMIC_PATHFINDING_DISABLED" "PU_FAILURE_INVALID_GOAL" "PU_FAILURE_INVALID_START" "PU_FAILURE_NO_NAVMESH" "PU_FAILURE_NO_VALID_DESTINATION" "PU_FAILURE_OTHER" "PU_FAILURE_PARCEL_UNREACHABLE" "PU_FAILURE_TARGET_GONE" "PU_FAILURE_UNREACHABLE" "PU_GOAL_REACHED" "PU_SLOWDOWN_DISTANCE_REACHED" "RAD_TO_DEG" "RCERR_CAST_TIME_EXCEEDED" "RCERR_SIM_PERF_LOW" "RCERR_UNKNOWN" "RC_DATA_FLAGS" "RC_DETECT_PHANTOM" "RC_GET_LINK_NUM" "RC_GET_NORMAL" "RC_GET_ROOT_KEY" "RC_MAX_HITS" "RC_REJECT_AGENTS" "RC_REJECT_LAND" "RC_REJECT_NONPHYSICAL" "RC_REJECT_PHYSICAL" "RC_REJECT_TYPES" "REGION_FLAG_ALLOW_DAMAGE" "REGION_FLAG_ALLOW_DIRECT_TELEPORT" "REGION_FLAG_BLOCK_FLY" "REGION_FLAG_BLOCK_FLYOVER" "REGION_FLAG_BLOCK_TERRAFORM" "REGION_FLAG_DISABLE_COLLISIONS" "REGION_FLAG_DISABLE_PHYSICS" "REGION_FLAG_FIXED_SUN" "REGION_FLAG_RESTRICT_PUSHOBJECT" "REGION_FLAG_SANDBOX" "REMOTE_DATA_CHANNEL" "REMOTE_DATA_REPLY" "REMOTE_DATA_REQUEST" "REQUIRE_LINE_OF_SIGHT" "RESTITUTION" "REVERSE" "REZ_ACCEL" "REZ_DAMAGE" "REZ_DAMAGE_TYPE" "REZ_FLAGS" "REZ_FLAG_BLOCK_GRAB_OBJECT" "REZ_FLAG_DIE_ON_COLLIDE" "REZ_FLAG_DIE_ON_NOENTRY" "REZ_FLAG_NO_COLLIDE_FAMILY" "REZ_FLAG_NO_COLLIDE_OWNER" "REZ_FLAG_PHANTOM" "REZ_FLAG_PHYSICAL" "REZ_FLAG_TEMP" "REZ_LOCK_AXES" "REZ_OMEGA" "REZ_PARAM" "REZ_PARAM_STRING" "REZ_POS" "REZ_ROT" "REZ_SOUND" "REZ_SOUND_COLLIDE" "REZ_TORQUE" "REZ_VEL" "ROTATE" "SCALE" "SCRIPTED" "SIM_STAT_ACTIVE_SCRIPT_COUNT" "SIM_STAT_AGENT_COUNT" "SIM_STAT_AGENT_MS" "SIM_STAT_AGENT_UPDATES" "SIM_STAT_AI_MS" "SIM_STAT_ASSET_DOWNLOADS" "SIM_STAT_ASSET_UPLOADS" "SIM_STAT_CHILD_AGENT_COUNT" "SIM_STAT_FRAME_MS" "SIM_STAT_IMAGE_MS" "SIM_STAT_IO_PUMP_MS" "SIM_STAT_NET_MS" "SIM_STAT_OTHER_MS" "SIM_STAT_PACKETS_IN" "SIM_STAT_PACKETS_OUT" "SIM_STAT_PCT_CHARS_STEPPED" "SIM_STAT_PHYSICS_FPS" "SIM_STAT_PHYSICS_MS" "SIM_STAT_PHYSICS_OTHER_MS" "SIM_STAT_PHYSICS_SHAPE_MS" "SIM_STAT_PHYSICS_STEP_MS" "SIM_STAT_SCRIPT_EPS" "SIM_STAT_SCRIPT_MS" "SIM_STAT_SCRIPT_RUN_PCT" "SIM_STAT_SLEEP_MS" "SIM_STAT_SPARE_MS" "SIM_STAT_UNACKED_BYTES" "SIT_FLAG_ALLOW_UNSIT" "SIT_FLAG_NO_COLLIDE" "SIT_FLAG_NO_DAMAGE" "SIT_FLAG_SCRIPTED_ONLY" "SIT_FLAG_SIT_TARGET" "SIT_INVALID_AGENT" "SIT_INVALID_LINK" "SIT_INVALID_OBJECT" "SIT_NOT_EXPERIENCE" "SIT_NO_ACCESS" "SIT_NO_EXPERIENCE_PERMISSION" "SIT_NO_SIT_TARGET" "SKY_ABSORPTION_CONFIG" "SKY_AMBIENT" "SKY_BLUE" "SKY_CLOUDS" "SKY_CLOUD_TEXTURE" "SKY_DENSITY_PROFILE_COUNTS" "SKY_DOME" "SKY_GAMMA" "SKY_GLOW" "SKY_HAZE" "SKY_LIGHT" "SKY_MIE_CONFIG" "SKY_MOON" "SKY_MOON_TEXTURE" "SKY_PLANET" "SKY_RAYLEIGH_CONFIG" "SKY_REFLECTION_PROBE_AMBIANCE" "SKY_REFRACTION" "SKY_STAR_BRIGHTNESS" "SKY_SUN" "SKY_SUN_TEXTURE" "SKY_TEXTURE_DEFAULTS" "SKY_TRACKS" "SMOOTH" "SOUND_LOOP" "SOUND_PLAY" "SOUND_SYNC" "SOUND_TRIGGER" "SQRT2" "STATUS_BLOCK_GRAB" "STATUS_BLOCK_GRAB_OBJECT" "STATUS_BOUNDS_ERROR" "STATUS_CAST_SHADOWS" "STATUS_DIE_AT_EDGE" "STATUS_DIE_AT_NO_ENTRY" "STATUS_INTERNAL_ERROR" "STATUS_MALFORMED_PARAMS" "STATUS_NOT_FOUND" "STATUS_NOT_SUPPORTED" "STATUS_OK" "STATUS_PHANTOM" "STATUS_PHYSICS" "STATUS_RETURN_AT_EDGE" "STATUS_ROTATE_X" "STATUS_ROTATE_Y" "STATUS_ROTATE_Z" "STATUS_SANDBOX" "STATUS_TYPE_MISMATCH" "STATUS_WHITELIST_FAILED" "STRING_TRIM" "STRING_TRIM_HEAD" "STRING_TRIM_TAIL" "TARGETED_EMAIL_OBJECT_OWNER" "TARGETED_EMAIL_ROOT_CREATOR" "TERRAIN_DETAIL_1" "TERRAIN_DETAIL_2" "TERRAIN_DETAIL_3" "TERRAIN_DETAIL_4" "TERRAIN_HEIGHT_RANGE_NE" "TERRAIN_HEIGHT_RANGE_NW" "TERRAIN_HEIGHT_RANGE_SE" "TERRAIN_HEIGHT_RANGE_SW" "TERRAIN_PBR_OFFSET_1" "TERRAIN_PBR_OFFSET_2" "TERRAIN_PBR_OFFSET_3" "TERRAIN_PBR_OFFSET_4" "TERRAIN_PBR_ROTATION_1" "TERRAIN_PBR_ROTATION_2" "TERRAIN_PBR_ROTATION_3" "TERRAIN_PBR_ROTATION_4" "TERRAIN_PBR_SCALE_1" "TERRAIN_PBR_SCALE_2" "TERRAIN_PBR_SCALE_3" "TERRAIN_PBR_SCALE_4" "TEXTURE_BLANK" "TEXTURE_DEFAULT" "TEXTURE_MEDIA" "TEXTURE_PLYWOOD" "TEXTURE_TRANSPARENT" "TOUCH_INVALID_FACE" "TOUCH_INVALID_TEXCOORD" "TOUCH_INVALID_VECTOR" "TP_ROUTING_BLOCKED" "TP_ROUTING_FREE" "TP_ROUTING_LANDINGP" "TRANSFER_BAD_OPTS" "TRANSFER_BAD_ROOT" "TRANSFER_DEST" "TRANSFER_FLAGS" "TRANSFER_FLAG_COPY" "TRANSFER_FLAG_RESERVED" "TRANSFER_FLAG_TAKE" "TRANSFER_NO_ATTACHMENT" "TRANSFER_NO_ITEMS" "TRANSFER_NO_PERMS" "TRANSFER_NO_TARGET" "TRANSFER_OK" "TRANSFER_THROTTLE" "TRAVERSAL_TYPE" "TRAVERSAL_TYPE_FAST" "TRAVERSAL_TYPE_NONE" "TRAVERSAL_TYPE_SLOW" "TRUE" "TWO_PI" "TYPE_FLOAT" "TYPE_INTEGER" "TYPE_INVALID" "TYPE_KEY" "TYPE_ROTATION" "TYPE_STRING" "TYPE_VECTOR" "URL_REQUEST_DENIED" "URL_REQUEST_GRANTED" "VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY" "VEHICLE_ANGULAR_DEFLECTION_TIMESCALE" "VEHICLE_ANGULAR_FRICTION_TIMESCALE" "VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE" "VEHICLE_ANGULAR_MOTOR_DIRECTION" "VEHICLE_ANGULAR_MOTOR_TIMESCALE" "VEHICLE_BANKING_EFFICIENCY" "VEHICLE_BANKING_MIX" "VEHICLE_BANKING_TIMESCALE" "VEHICLE_BUOYANCY" "VEHICLE_FLAG_BLOCK_INTERFERENCE" "VEHICLE_FLAG_CAMERA_DECOUPLED" "VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT" "VEHICLE_FLAG_HOVER_TERRAIN_ONLY" "VEHICLE_FLAG_HOVER_UP_ONLY" "VEHICLE_FLAG_HOVER_WATER_ONLY" "VEHICLE_FLAG_LIMIT_MOTOR_UP" "VEHICLE_FLAG_LIMIT_ROLL_ONLY" "VEHICLE_FLAG_MOUSELOOK_BANK" "VEHICLE_FLAG_MOUSELOOK_STEER" "VEHICLE_FLAG_NO_DEFLECTION_UP" "VEHICLE_FLAG_NO_FLY_UP" "VEHICLE_HOVER_EFFICIENCY" "VEHICLE_HOVER_HEIGHT" "VEHICLE_HOVER_TIMESCALE" "VEHICLE_LINEAR_DEFLECTION_EFFICIENCY" "VEHICLE_LINEAR_DEFLECTION_TIMESCALE" "VEHICLE_LINEAR_FRICTION_TIMESCALE" "VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE" "VEHICLE_LINEAR_MOTOR_DIRECTION" "VEHICLE_LINEAR_MOTOR_OFFSET" "VEHICLE_LINEAR_MOTOR_TIMESCALE" "VEHICLE_REFERENCE_FRAME" "VEHICLE_TYPE_AIRPLANE" "VEHICLE_TYPE_BALLOON" "VEHICLE_TYPE_BOAT" "VEHICLE_TYPE_CAR" "VEHICLE_TYPE_NONE" "VEHICLE_TYPE_SLED" "VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY" "VEHICLE_VERTICAL_ATTRACTION_TIMESCALE" "VERTICAL" "WANDER_PAUSE_AT_WAYPOINTS" "WATER_BLUR_MULTIPLIER" "WATER_FOG" "WATER_FRESNEL" "WATER_NORMAL_SCALE" "WATER_NORMAL_TEXTURE" "WATER_REFRACTION" "WATER_TEXTURE_DEFAULTS" "WATER_WAVE_DIRECTION" "XP_ERROR_EXPERIENCES_DISABLED" "XP_ERROR_EXPERIENCE_DISABLED" "XP_ERROR_EXPERIENCE_SUSPENDED" "XP_ERROR_INVALID_EXPERIENCE" "XP_ERROR_INVALID_PARAMETERS" "XP_ERROR_KEY_NOT_FOUND" "XP_ERROR_MATURITY_EXCEEDED" "XP_ERROR_NONE" "XP_ERROR_NOT_FOUND" "XP_ERROR_NOT_PERMITTED" "XP_ERROR_NOT_PERMITTED_LAND" "XP_ERROR_NO_EXPERIENCE" "XP_ERROR_QUOTA_EXCEEDED" "XP_ERROR_REQUEST_PERM_TIMEOUT" "XP_ERROR_RETRY_UPDATE" "XP_ERROR_STORAGE_EXCEPTION" "XP_ERROR_STORE_DISABLED" "XP_ERROR_THROTTLED" "XP_ERROR_UNKNOWN_ERROR" "ZERO_ROTATION" "ZERO_VECTOR")
  "LSL constants.")

(defvar lsl-events
  '("at_rot_target" "at_target" "attach" "changed" "collision" "collision_end" "collision_start" "control" "dataserver" "email" "experience_permissions" "experience_permissions_denied" "final_damage" "game_control" "http_request" "http_response" "land_collision" "land_collision_end" "land_collision_start" "link_message" "linkset_data" "listen" "money" "moving_end" "moving_start" "no_sensor" "not_at_rot_target" "not_at_target" "object_rez" "on_damage" "on_death" "on_rez" "path_update" "remote_data" "run_time_permissions" "sensor" "state_entry" "state_exit" "timer" "touch" "touch_end" "touch_start" "transaction_result")
  "LSL events.")

(defvar lsl-functions
  '("llAbs" "llAcos" "llAddToLandBanList" "llAddToLandPassList" "llAdjustDamage" "llAdjustSoundVolume" "llAgentInExperience" "llAllowInventoryDrop" "llAngleBetween" "llApplyImpulse" "llApplyRotationalImpulse" "llAsin" "llAtan2" "llAttachToAvatar" "llAttachToAvatarTemp" "llAvatarOnLinkSitTarget" "llAvatarOnSitTarget" "llAxes2Rot" "llAxisAngle2Rot" "llBase64ToInteger" "llBase64ToString" "llBreakAllLinks" "llBreakLink" "llCSV2List" "llCastRay" "llCeil" "llChar" "llClearCameraParams" "llClearExperience" "llClearExperiencePermissions" "llClearLinkMedia" "llClearPrimMedia" "llCloseRemoteDataChannel" "llCloud" "llCollisionFilter" "llCollisionSound" "llCollisionSprite" "llComputeHash" "llCos" "llCreateCharacter" "llCreateKeyValue" "llCreateLink" "llDamage" "llDataSizeKeyValue" "llDeleteCharacter" "llDeleteKeyValue" "llDeleteSubList" "llDeleteSubString" "llDerezObject" "llDetachFromAvatar" "llDetectedDamage" "llDetectedGrab" "llDetectedGroup" "llDetectedKey" "llDetectedLinkNumber" "llDetectedName" "llDetectedOwner" "llDetectedPos" "llDetectedRezzer" "llDetectedRot" "llDetectedTouchBinormal" "llDetectedTouchFace" "llDetectedTouchNormal" "llDetectedTouchPos" "llDetectedTouchST" "llDetectedTouchUV" "llDetectedType" "llDetectedVel" "llDialog" "llDie" "llDumpList2String" "llEdgeOfWorld" "llEjectFromLand" "llEmail" "llEscapeURL" "llEuler2Rot" "llEvade" "llExecCharacterCmd" "llFabs" "llFindNotecardTextCount" "llFindNotecardTextSync" "llFleeFrom" "llFloor" "llForceMouselook" "llFrand" "llGenerateKey" "llGetAccel" "llGetAgentInfo" "llGetAgentLanguage" "llGetAgentList" "llGetAgentSize" "llGetAlpha" "llGetAndResetTime" "llGetAnimation" "llGetAnimationList" "llGetAnimationOverride" "llGetAttached" "llGetAttachedList" "llGetAttachedListFiltered" "llGetBoundingBox" "llGetCameraAspect" "llGetCameraFOV" "llGetCameraPos" "llGetCameraRot" "llGetCenterOfMass" "llGetClosestNavPoint" "llGetColor" "llGetCreator" "llGetDate" "llGetDayLength" "llGetDayOffset" "llGetDisplayName" "llGetEnergy" "llGetEnv" "llGetEnvironment" "llGetExperienceDetails" "llGetExperienceErrorMessage" "llGetExperienceList" "llGetForce" "llGetFreeMemory" "llGetFreeURLs" "llGetGMTclock" "llGetGeometricCenter" "llGetHTTPHeader" "llGetHealth" "llGetInventoryAcquireTime" "llGetInventoryCreator" "llGetInventoryDesc" "llGetInventoryKey" "llGetInventoryName" "llGetInventoryNumber" "llGetInventoryPermMask" "llGetInventoryType" "llGetKey" "llGetLandOwnerAt" "llGetLinkKey" "llGetLinkMedia" "llGetLinkName" "llGetLinkNumber" "llGetLinkNumberOfSides" "llGetLinkPrimitiveParams" "llGetLinkSitFlags" "llGetListEntryType" "llGetListLength" "llGetLocalPos" "llGetLocalRot" "llGetMass" "llGetMassMKS" "llGetMaxScaleFactor" "llGetMemoryLimit" "llGetMinScaleFactor" "llGetMoonDirection" "llGetMoonRotation" "llGetNextEmail" "llGetNotecardLine" "llGetNotecardLineSync" "llGetNumberOfNotecardLines" "llGetNumberOfPrims" "llGetNumberOfSides" "llGetObjectAnimationNames" "llGetObjectDesc" "llGetObjectDetails" "llGetObjectLinkKey" "llGetObjectMass" "llGetObjectName" "llGetObjectPermMask" "llGetObjectPrimCount" "llGetOmega" "llGetOwner" "llGetOwnerKey" "llGetParcelDetails" "llGetParcelFlags" "llGetParcelMaxPrims" "llGetParcelMusicURL" "llGetParcelPrimCount" "llGetParcelPrimOwners" "llGetPermissions" "llGetPermissionsKey" "llGetPhysicsMaterial" "llGetPos" "llGetPrimMediaParams" "llGetPrimitiveParams" "llGetRegionAgentCount" "llGetRegionCorner" "llGetRegionDayLength" "llGetRegionDayOffset" "llGetRegionFPS" "llGetRegionFlags" "llGetRegionMoonDirection" "llGetRegionMoonRotation" "llGetRegionName" "llGetRegionSunDirection" "llGetRegionSunRotation" "llGetRegionTimeDilation" "llGetRegionTimeOfDay" "llGetRenderMaterial" "llGetRootPosition" "llGetRootRotation" "llGetRot" "llGetSPMaxMemory" "llGetScale" "llGetScriptName" "llGetScriptState" "llGetSimStats" "llGetSimulatorHostname" "llGetStartParameter" "llGetStartString" "llGetStaticPath" "llGetStatus" "llGetSubString" "llGetSunDirection" "llGetSunRotation" "llGetTexture" "llGetTextureOffset" "llGetTextureRot" "llGetTextureScale" "llGetTime" "llGetTimeOfDay" "llGetTimestamp" "llGetTorque" "llGetUnixTime" "llGetUsedMemory" "llGetUsername" "llGetVel" "llGetVisualParams" "llGetWallclock" "llGiveAgentInventory" "llGiveInventory" "llGiveInventoryList" "llGiveMoney" "llGodLikeRezObject" "llGround" "llGroundContour" "llGroundNormal" "llGroundRepel" "llGroundSlope" "llHMAC" "llHTTPRequest" "llHTTPResponse" "llHash" "llInsertString" "llInstantMessage" "llIntegerToBase64" "llIsFriend" "llIsLinkGLTFMaterial" "llJson2List" "llJsonGetValue" "llJsonSetValue" "llJsonValueType" "llKey2Name" "llKeyCountKeyValue" "llKeysKeyValue" "llLinear2sRGB" "llLinkAdjustSoundVolume" "llLinkParticleSystem" "llLinkPlaySound" "llLinkSetSoundQueueing" "llLinkSetSoundRadius" "llLinkSitTarget" "llLinkStopSound" "llLinksetDataAvailable" "llLinksetDataCountFound" "llLinksetDataCountKeys" "llLinksetDataDelete" "llLinksetDataDeleteFound" "llLinksetDataDeleteProtected" "llLinksetDataFindKeys" "llLinksetDataListKeys" "llLinksetDataRead" "llLinksetDataReadProtected" "llLinksetDataReset" "llLinksetDataWrite" "llLinksetDataWriteProtected" "llList2CSV" "llList2Float" "llList2Integer" "llList2Json" "llList2Key" "llList2List" "llList2ListSlice" "llList2ListStrided" "llList2Rot" "llList2String" "llList2Vector" "llListFindList" "llListFindListNext" "llListFindStrided" "llListInsertList" "llListRandomize" "llListReplaceList" "llListSort" "llListSortStrided" "llListStatistics" "llListen" "llListenControl" "llListenRemove" "llLoadURL" "llLog" "llLog10" "llLookAt" "llLoopSound" "llLoopSoundMaster" "llLoopSoundSlave" "llMD5String" "llMakeExplosion" "llMakeFire" "llMakeFountain" "llMakeSmoke" "llManageEstateAccess" "llMapBeacon" "llMapDestination" "llMessageLinked" "llMinEventDelay" "llModPow" "llModifyLand" "llMoveToTarget" "llName2Key" "llNavigateTo" "llOffsetTexture" "llOpenFloater" "llOpenRemoteDataChannel" "llOrd" "llOverMyLand" "llOwnerSay" "llParcelMediaCommandList" "llParcelMediaQuery" "llParseString2List" "llParseStringKeepNulls" "llParticleSystem" "llPassCollisions" "llPassTouches" "llPatrolPoints" "llPlaySound" "llPlaySoundSlave" "llPointAt" "llPow" "llPreloadSound" "llPursue" "llPushObject" "llReadKeyValue" "llRefreshPrimURL" "llRegionSay" "llRegionSayTo" "llReleaseCamera" "llReleaseControls" "llReleaseURL" "llRemoteDataReply" "llRemoteDataSetRegion" "llRemoteLoadScript" "llRemoteLoadScriptPin" "llRemoveFromLandBanList" "llRemoveFromLandPassList" "llRemoveInventory" "llRemoveVehicleFlags" "llReplaceAgentEnvironment" "llReplaceEnvironment" "llReplaceSubString" "llRequestAgentData" "llRequestDisplayName" "llRequestExperiencePermissions" "llRequestInventoryData" "llRequestPermissions" "llRequestSecureURL" "llRequestSimulatorData" "llRequestURL" "llRequestUserKey" "llRequestUsername" "llResetAnimationOverride" "llResetLandBanList" "llResetLandPassList" "llResetOtherScript" "llResetScript" "llResetTime" "llReturnObjectsByID" "llReturnObjectsByOwner" "llRezAtRoot" "llRezObject" "llRezObjectWithParams" "llRot2Angle" "llRot2Axis" "llRot2Euler" "llRot2Fwd" "llRot2Left" "llRot2Up" "llRotBetween" "llRotLookAt" "llRotTarget" "llRotTargetRemove" "llRotateTexture" "llRound" "llSHA1String" "llSHA256String" "llSameGroup" "llSay" "llScaleByFactor" "llScaleTexture" "llScriptDanger" "llScriptProfiler" "llSendRemoteData" "llSensor" "llSensorRemove" "llSensorRepeat" "llSetAgentEnvironment" "llSetAgentRot" "llSetAlpha" "llSetAngularVelocity" "llSetAnimationOverride" "llSetBuoyancy" "llSetCameraAtOffset" "llSetCameraEyeOffset" "llSetCameraParams" "llSetClickAction" "llSetColor" "llSetContentType" "llSetDamage" "llSetEnvironment" "llSetExperienceKey" "llSetForce" "llSetForceAndTorque" "llSetGroundTexture" "llSetHoverHeight" "llSetInventoryPermMask" "llSetKeyframedMotion" "llSetLinkAlpha" "llSetLinkCamera" "llSetLinkColor" "llSetLinkGLTFOverrides" "llSetLinkMedia" "llSetLinkPrimitiveParams" "llSetLinkPrimitiveParamsFast" "llSetLinkRenderMaterial" "llSetLinkSitFlags" "llSetLinkTexture" "llSetLinkTextureAnim" "llSetLocalRot" "llSetMemoryLimit" "llSetObjectDesc" "llSetObjectName" "llSetObjectPermMask" "llSetParcelForSale" "llSetParcelMusicURL" "llSetPayPrice" "llSetPhysicsMaterial" "llSetPos" "llSetPrimMediaParams" "llSetPrimURL" "llSetPrimitiveParams" "llSetRegionPos" "llSetRemoteScriptAccessPin" "llSetRenderMaterial" "llSetRot" "llSetScale" "llSetScriptState" "llSetSitText" "llSetSoundQueueing" "llSetSoundRadius" "llSetStatus" "llSetText" "llSetTexture" "llSetTextureAnim" "llSetTimerEvent" "llSetTorque" "llSetTouchText" "llSetVehicleFlags" "llSetVehicleFloatParam" "llSetVehicleRotationParam" "llSetVehicleType" "llSetVehicleVectorParam" "llSetVelocity" "llShout" "llSignRSA" "llSin" "llSitOnLink" "llSitTarget" "llSleep" "llSound" "llSoundPreload" "llSqrt" "llStartAnimation" "llStartObjectAnimation" "llStopAnimation" "llStopHover" "llStopLookAt" "llStopMoveToTarget" "llStopObjectAnimation" "llStopPointAt" "llStopSound" "llStringLength" "llStringToBase64" "llStringTrim" "llSubStringIndex" "llTakeCamera" "llTakeControls" "llTan" "llTarget" "llTargetOmega" "llTargetRemove" "llTargetedEmail" "llTeleportAgent" "llTeleportAgentGlobalCoords" "llTeleportAgentHome" "llTextBox" "llToLower" "llToUpper" "llTransferLindenDollars" "llTransferOwnership" "llTriggerSound" "llTriggerSoundLimited" "llUnSit" "llUnescapeURL" "llUpdateCharacter" "llUpdateKeyValue" "llVecDist" "llVecMag" "llVecNorm" "llVerifyRSA" "llVolumeDetect" "llWanderWithin" "llWater" "llWhisper" "llWind" "llWorldPosToHUD" "llXorBase64" "llXorBase64Strings" "llXorBase64StringsCorrect" "llsRGB2Linear")
  "LSL functions.")

(defvar lsl-keywords-regexp (regexp-opt lsl-keywords 'words))
(defvar lsl-type-regexp (regexp-opt lsl-types 'words))
(defvar lsl-constant-regexp (regexp-opt lsl-constants 'words))
(defvar lsl-event-regexp (regexp-opt lsl-events 'words))
(defvar lsl-function-regexp (regexp-opt lsl-functions 'words))

(defvar lsl-font-lock-keywords)
(setq lsl-font-lock-keywords
  `(
    (,lsl-type-regexp . font-lock-type-face)
    (,lsl-constant-regexp . font-lock-constant-face)
    (,lsl-event-regexp . font-lock-builtin-face)
    (,lsl-function-regexp . font-lock-function-name-face)
    (,lsl-keywords-regexp . font-lock-keyword-face)
))

(defvar lsl-kwdList nil "LSL keywords.")

(setq lsl-kwdList (make-hash-table :test 'equal))
(mapc (lambda (x) (puthash x t lsl-kwdList)) lsl-keywords)
(mapc (lambda (x) (puthash x t lsl-kwdList)) lsl-types)
(mapc (lambda (x) (puthash x t lsl-kwdList)) lsl-constants)
(mapc (lambda (x) (puthash x t lsl-kwdList)) lsl-events)
(mapc (lambda (x) (puthash x t lsl-kwdList)) lsl-functions)
(put 'lsl-kwdList 'risky-local-variable t)

(defun lsl-complete-symbol ()
  "Complete LSL symbol at `point'."
  (interactive)
  (let ((posEnd (point))
         (meat (thing-at-point 'symbol))
         maxMatchResult)
    (when (not meat) (setq meat ""))
    (setq maxMatchResult (try-completion meat lsl-kwdList))
    (cond ((eq maxMatchResult t))
          ((null maxMatchResult)
           (message "Can't find completion for '%s'" meat)
           (ding))
          ((not (string= meat maxMatchResult))
           (delete-region (- posEnd (length meat)) posEnd)
           (insert maxMatchResult))
          (t (message "Making completion list...")
             (with-output-to-temp-buffer "*Completions*"
               (display-completion-list (all-completions meat lsl-kwdList))) ;;; meat
             (message "Making completion list...%s" "done")))))

(setq lsl-keywords nil)
(setq lsl-types nil)
(setq lsl-constants nil)
(setq lsl-events nil)
(setq lsl-functions nil)
(defvar c-basic-offset)

(defun lsl-mode ()
  (interactive)
  (kill-all-local-variables)
  (cond
   ((= lsl-mode-format-style 0) nil)
   ((= lsl-mode-format-style 1) (progn
                                   (c-mode)
                                   (setq indent-tabs-mode nil)
                                   (setq c-basic-offset 4)
                                   (c-set-offset 'substatement-open 0)
                                   (c-set-offset 'block-open 0)
                                   (c-set-offset 'statement-cont 0)))
   ((= lsl-mode-format-style 2) (c-mode)))
  (setq major-mode 'lsl-mode)
  (setq mode-name "LSL")
  (set-syntax-table lsl-mode-syntax-table)
  (use-local-map lsl-mode-map)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '((lsl-font-lock-keywords) nil nil))
  (setq lsl-keywords-regexp nil)
  (setq lsl-type-regexp nil)
  (setq lsl-constant-regexp nil)
  (setq lsl-event-regexp nil)
  (setq lsl-function-regexp nil)
  (when
      (and
       (fboundp 'linum-mode)
       (>= emacs-major-version 23)
       (>= emacs-minor-version 1)
       )
    (linum-mode 1)
    )
  (run-mode-hooks 'lsl-mode-hook))

(provide 'lsl-mode)

;;; lsl-mode.el ends here

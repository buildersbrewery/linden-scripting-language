<?php
$language_data = array(
    'LANG_NAME' => 'LSL',
    'COMMENT_SINGLE' => array(
        1 => '//'
    ),
    'COMMENT_MULTI' => array(
        '/*' => '*/'
    ),
    'CASE_KEYWORDS' => GESHI_CAPS_NO_CHANGE,
    'QUOTEMARKS' => array(
        '"'
    ),
    'ESCAPE_CHAR' => '\\',
    'ESCAPE_REGEXP' => array(
      1 => '\\\\',
      2 => '\\"',
      3 => '\\n',
      4 => '\\t'
    ),
    'KEYWORDS' => array(
        1 => '\b(?:(state)\s+([A-Za-z_]\w*)|(default))\b',
        2 => '\b(?:state_(?:entry|exit)|touch(?:_(?:start|end))?|(?:land_)?collision(?:_(?:start|end))?|timer|listen|(?:no_)?sensor|control|(?:not_)?at_(?:rot_)?target|money|email|experience_permissions(?:_denied)?|run_time_permissions|changed|attach|dataserver|moving_(?:start|end)|link_message|(?:on|object)_rez|remote_data|http_re(?:sponse|quest)|path_update|transaction_result)\b',
        3 => '\b(?:ll(?:AgentInExperience|(?:Create|DataSize|Delete|KeyCount|Keys|Read|Update)KeyValue|GetExperience(?:Details|ErrorMessage)|ReturnObjectsBy(?:ID|Owner)|Json(?:2List|[GS]etValue|ValueType)|Sin|Cos|Tan|Atan2|Sqrt|Pow|Abs|Fabs|Frand|Floor|Ceil|Round|Vec(?:Mag|Norm|Dist)|Rot(?:Between|2(?:Euler|Fwd|Left|Up))|(?:Euler|Axes)2Rot|Whisper|(?:Region|Owner)?Say|Shout|Listen(?:Control|Remove)?|Sensor(?:Repeat|Remove)?|Detected(?:Name|Key|Owner|Type|Pos|Vel|Grab|Rot|Group|LinkNumber)|Die|Ground|Wind|(?:[GS]et)(?:AnimationOverride|MemoryLimit|PrimMediaParams|ParcelMusicURL|Object(?:Desc|Name)|PhysicsMaterial|Status|Scale|Color|Alpha|Texture|Pos|Rot|Force|Torque)|ResetAnimationOverride|(?:Scale|Offset|Rotate)Texture|(?:Rot)?Target(?:Remove)?|(?:Stop)?MoveToTarget|Apply(?:Rotational)?Impulse|Set(?:KeyframedMotion|ContentType|RegionPos|(?:Angular)?Velocity|Buoyancy|HoverHeight|ForceAndTorque|TimerEvent|ScriptState|Damage|TextureAnim|Sound(?:Queueing|Radius)|Vehicle(?:Type|(?:Float|Vector|Rotation)Param)|(?:Touch|Sit)?Text|Camera(?:Eye|At)Offset|PrimitiveParams|ClickAction|Link(?:Alpha|Color|PrimitiveParams(?:Fast)?|Texture(?:Anim)?|Camera|Media)|RemoteScriptAccessPin|PayPrice|LocalRot)|ScaleByFactor|Get(?:(?:Max|Min)ScaleFactor|ClosestNavPoint|StaticPath|SimStats|Env|PrimitiveParams|Link(?:PrimitiveParams|Number(?:OfSides)?|Key|Name|Media)|HTTPHeader|FreeURLs|Object(?:Details|PermMask|PrimCount)|Parcel(?:MaxPrims|Details|Prim(?:Count|Owners))|Attached(?:List)?|(?:SPMax|Free|Used)Memory|Region(?:Name|TimeDilation|FPS|Corner|AgentCount)|Root(?:Position|Rotation)|UnixTime|(?:Parcel|Region)Flags|(?:Wall|GMT)clock|SimulatorHostname|BoundingBox|GeometricCenter|Creator|NumberOf(?:Prims|NotecardLines|Sides)|Animation(?:List)?|(?:Camera|Local)(?:Pos|Rot)|Vel|Accel|Omega|Time(?:stamp|OfDay)|(?:Object|CenterOf)?Mass|MassMKS|Energy|Owner|(?:Owner)?Key|SunDirection|Texture(?:Offset|Scale|Rot)|Inventory(?:Number|Name|Key|Type|Creator|PermMask)|Permissions(?:Key)?|StartParameter|List(?:Length|EntryType)|Date|Agent(?:Size|Info|Language|List)|LandOwnerAt|NotecardLine|Script(?:Name|State))|(?:Get|Reset|GetAndReset)Time|PlaySound(?:Slave)?|LoopSound(?:Master|Slave)?|(?:Trigger|Stop|Preload)Sound|(?:(?:Get|Delete)Sub|Insert)String|To(?:Upper|Lower)|Give(?:InventoryList|Money)|RezObject|(?:Stop)?LookAt|Sleep|CollisionFilter|(?:Take|Release)Controls|DetachFromAvatar|AttachToAvatar(?:Temp)?|InstantMessage|(?:GetNext)?Email|StopHover|MinEventDelay|RotLookAt|String(?:Length|Trim)|(?:Start|Stop)Animation|TargetOmega|Request(?:Experience)?Permissions|(?:Create|Break)Link|BreakAllLinks|(?:Give|Remove)Inventory|Water|PassTouches|Request(?:Agent|Inventory)Data|TeleportAgent(?:Home|GlobalCoords)?|ModifyLand|CollisionSound|ResetScript|MessageLinked|PushObject|PassCollisions|AxisAngle2Rot|Rot2(?:Axis|Angle)|A(?:cos|sin)|AngleBetween|AllowInventoryDrop|SubStringIndex|List2(?:CSV|Integer|Json|Float|String|Key|Vector|Rot|List(?:Strided)?)|DeleteSubList|List(?:Statistics|Sort|Randomize|(?:Insert|Find|Replace)List)|EdgeOfWorld|AdjustSoundVolume|Key2Name|TriggerSoundLimited|EjectFromLand|(?:CSV|ParseString)2List|OverMyLand|SameGroup|UnSit|Ground(?:Slope|Normal|Contour)|GroundRepel|(?:Set|Remove)VehicleFlags|SitOnLink|(?:AvatarOn)?(?:Link)?SitTarget|Script(?:Danger|Profiler)|Dialog|VolumeDetect|ResetOtherScript|RemoteLoadScriptPin|(?:Open|Close)RemoteDataChannel|SendRemoteData|RemoteDataReply|(?:Integer|String)ToBase64|XorBase64|Log(?:10)?|Base64To(?:String|Integer)|ParseStringKeepNulls|RezAtRoot|RequestSimulatorData|ForceMouselook|(?:Load|Release|(?:E|Une)scape)URL|ParcelMedia(?:CommandList|Query)|ModPow|MapDestination|(?:RemoveFrom|AddTo|Reset)Land(?:Pass|Ban)List|(?:Set|Clear)CameraParams|HTTP(?:Request|Response)|TextBox|DetectedTouch(?:UV|Face|Pos|(?:N|Bin)ormal|ST)|(?:MD5|SHA1|DumpList2)String|Request(?:Secure)?URL|Clear(?:Prim|Link)Media|(?:Link)?ParticleSystem|(?:Get|Request)(?:Username|DisplayName)|RegionSayTo|CastRay|GenerateKey|TransferLindenDollars|ManageEstateAccess|(?:Create|Delete)Character|ExecCharacterCmd|Evade|FleeFrom|NavigateTo|PatrolPoints|Pursue|UpdateCharacter|WanderWithin))\b',
        4 => '\b(?:DEG_TO_RAD|PI(?:_BY_TWO)?|RAD_TO_DEG|SQRT2|TWO_PI)\b',
        5 => '\b(?:XP_ERROR_(?:EXPERIENCES_DISABLED|EXPERIENCE_(?:DISABLED|SUSPENDED)|INVALID_(?:EXPERIENCE|PARAMETERS)|KEY_NOT_FOUND|MATURITY_EXCEEDED|NONE|NOT_(?:FOUND|PERMITTED(?:_LAND)?)|NO_EXPERIENCE|QUOTA_EXCEEDED|RETRY_UPDATE|STORAGE_EXCEPTION|STORE_DISABLED|THROTTLED|UNKNOWN_ERROR)|JSON_APPEND|STATUS_(?:PHYSICS|ROTATE_[XYZ]|PHANTOM|SANDBOX|BLOCK_GRAB(?:_OBJECT)?|(?:DIE|RETURN)_AT_EDGE|CAST_SHADOWS|OK|MALFORMED_PARAMS|TYPE_MISMATCH|BOUNDS_ERROR|NOT_(?:FOUND|SUPPORTED)|INTERNAL_ERROR|WHITELIST_FAILED)|AGENT(?:_(?:BY_(?:LEGACY_|USER)NAME|FLYING|ATTACHMENTS|SCRIPTED|MOUSELOOK|SITTING|ON_OBJECT|AWAY|WALKING|IN_AIR|TYPING|CROUCHING|BUSY|ALWAYS_RUN|AUTOPILOT|LIST_(?:PARCEL(?:_OWNER)?|REGION)))?|CAMERA_(?:PITCH|DISTANCE|BEHINDNESS_(?:ANGLE|LAG)|(?:FOCUS|POSITION)(?:_(?:THRESHOLD|LOCKED|LAG))?|FOCUS_OFFSET|ACTIVE)|ANIM_ON|LOOP|REVERSE|PING_PONG|SMOOTH|ROTATE|SCALE|ALL_SIDES|LINK_(?:ROOT|SET|ALL_(?:OTHERS|CHILDREN)|THIS)|ACTIVE|PASS(?:IVE|_(?:ALWAYS|IF_NOT_HANDLED|NEVER))|SCRIPTED|CONTROL_(?:FWD|BACK|(?:ROT_)?(?:LEFT|RIGHT)|UP|DOWN|(?:ML_)?LBUTTON)|PERMISSION_(?:RETURN_OBJECTS|DEBIT|OVERRIDE_ANIMATIONS|SILENT_ESTATE_MANAGEMENT|TAKE_CONTROLS|TRIGGER_ANIMATION|ATTACH|CHANGE_LINKS|(?:CONTROL|TRACK)_CAMERA|TELEPORT)|INVENTORY_(?:TEXTURE|SOUND|OBJECT|SCRIPT|LANDMARK|CLOTHING|NOTECARD|BODYPART|ANIMATION|GESTURE|ALL|NONE)|CHANGED_(?:INVENTORY|COLOR|SHAPE|SCALE|TEXTURE|LINK|ALLOWED_DROP|OWNER|REGION(?:_START)?|TELEPORT|MEDIA)|OBJECT_(?:CLICK_ACTION|HOVER_HEIGHT|LAST_OWNER_ID|(?:PHYSICS|SERVER|STREAMING)_COST|UNKNOWN_DETAIL|CHARACTER_TIME|PHANTOM|PHYSICS|TEMP_(?:ATTACHED|ON_REZ)|NAME|DESC|POS|PRIM_(?:COUNT|EQUIVALENCE)|RETURN_(?:PARCEL(?:_OWNER)?|REGION)|REZZER_KEY|ROO?T|VELOCITY|OMEGA|OWNER|GROUP(?:_TAG)?|CREATOR|ATTACHED_(?:POINT|SLOTS_AVAILABLE)|RENDER_WEIGHT|(?:BODY_SHAPE|PATHFINDING)_TYPE|(?:RUNNING|TOTAL)_SCRIPT_COUNT|TOTAL_INVENTORY_COUNT|SCRIPT_(?:MEMORY|TIME))|TYPE_(?:INTEGER|FLOAT|STRING|KEY|VECTOR|ROTATION|INVALID)|(?:DEBUG|PUBLIC)_CHANNEL|ATTACH_(?:AVATAR_CENTER|CHEST|HEAD|BACK|PELVIS|MOUTH|CHIN|NECK|NOSE|BELLY|[LR](?:SHOULDER|HAND|FOOT|EAR|EYE|[UL](?:ARM|LEG)|HIP)|(?:LEFT|RIGHT)_PEC|HUD_(?:CENTER_[12]|TOP_(?:RIGHT|CENTER|LEFT)|BOTTOM(?:_(?:RIGHT|LEFT))?)|[LR]HAND_RING1|TAIL_(?:BASE|TIP)|[LR]WING|FACE_(?:JAW|[LR]EAR|[LR]EYE|TOUNGE)|GROIN|HIND_[LR]FOOT)|LAND_(?:LEVEL|RAISE|LOWER|SMOOTH|NOISE|REVERT)|DATA_(?:ONLINE|NAME|BORN|SIM_(?:POS|STATUS|RATING)|PAYINFO)|PAYMENT_INFO_(?:ON_FILE|USED)|REMOTE_DATA_(?:CHANNEL|REQUEST|REPLY)|PSYS_(?:PART_(?:BF_(?:ZERO|ONE(?:_MINUS_(?:DEST_COLOR|SOURCE_(ALPHA|COLOR)))?|DEST_COLOR|SOURCE_(ALPHA|COLOR))|BLEND_FUNC_(DEST|SOURCE)|FLAGS|(?:START|END)_(?:COLOR|ALPHA|SCALE|GLOW)|MAX_AGE|(?:RIBBON|WIND|INTERP_(?:COLOR|SCALE)|BOUNCE|FOLLOW_(?:SRC|VELOCITY)|TARGET_(?:POS|LINEAR)|EMISSIVE)_MASK)|SRC_(?:MAX_AGE|PATTERN|ANGLE_(?:BEGIN|END)|BURST_(?:RATE|PART_COUNT|RADIUS|SPEED_(?:MIN|MAX))|ACCEL|TEXTURE|TARGET_KEY|OMEGA|PATTERN_(?:DROP|EXPLODE|ANGLE(?:_CONE(?:_EMPTY)?)?)))|VEHICLE_(?:REFERENCE_FRAME|TYPE_(?:NONE|SLED|CAR|BOAT|AIRPLANE|BALLOON)|(?:LINEAR|ANGULAR)_(?:FRICTION_TIMESCALE|MOTOR_DIRECTION)|LINEAR_MOTOR_OFFSET|HOVER_(?:HEIGHT|EFFICIENCY|TIMESCALE)|BUOYANCY|(?:LINEAR|ANGULAR)_(?:DEFLECTION_(?:EFFICIENCY|TIMESCALE)|MOTOR_(?:DECAY_)?TIMESCALE)|VERTICAL_ATTRACTION_(?:EFFICIENCY|TIMESCALE)|BANKING_(?:EFFICIENCY|MIX|TIMESCALE)|FLAG_(?:NO_DEFLECTION_UP|LIMIT_(?:ROLL_ONLY|MOTOR_UP)|HOVER_(?:(?:WATER|TERRAIN|UP)_ONLY|GLOBAL_HEIGHT)|MOUSELOOK_(?:STEER|BANK)|CAMERA_DECOUPLED))|PRIM_(?:ALLOW_UNSIT|ALPHA_MODE(?:_(?:BLEND|EMISSIVE|MASK|NONE))?|NORMAL|SPECULAR|TYPE(?:_(?:BOX|CYLINDER|PRISM|SPHERE|TORUS|TUBE|RING|SCULPT))?|HOLE_(?:DEFAULT|CIRCLE|SQUARE|TRIANGLE)|MATERIAL(?:_(?:STONE|METAL|GLASS|WOOD|FLESH|PLASTIC|RUBBER))?|SHINY_(?:NONE|LOW|MEDIUM|HIGH)|BUMP_(?:NONE|BRIGHT|DARK|WOOD|BARK|BRICKS|CHECKER|CONCRETE|TILE|STONE|DISKS|GRAVEL|BLOBS|SIDING|LARGETILE|STUCCO|SUCTION|WEAVE)|TEXGEN_(?:DEFAULT|PLANAR)|SCRIPTED_SIT_ONLY|SCULPT_(?:TYPE_(?:SPHERE|TORUS|PLANE|CYLINDER|MASK)|FLAG_(?:MIRROR|INVERT))|PHYSICS(?:_(?:SHAPE_(?:CONVEX|NONE|PRIM|TYPE)))?|(?:POS|ROT)_LOCAL|SLICE|TEXT|FLEXIBLE|POINT_LIGHT|TEMP_ON_REZ|PHANTOM|POSITION|SIT_TARGET|SIZE|ROTATION|TEXTURE|NAME|OMEGA|DESC|LINK_TARGET|COLOR|BUMP_SHINY|FULLBRIGHT|TEXGEN|GLOW|MEDIA_(?:ALT_IMAGE_ENABLE|CONTROLS|(?:CURRENT|HOME)_URL|AUTO_(?:LOOP|PLAY|SCALE|ZOOM)|FIRST_CLICK_INTERACT|(?:WIDTH|HEIGHT)_PIXELS|WHITELIST(?:_ENABLE)?|PERMS_(?:INTERACT|CONTROL)|PARAM_MAX|CONTROLS_(?:STANDARD|MINI)|PERM_(?:NONE|OWNER|GROUP|ANYONE)|MAX_(?:URL_LENGTH|WHITELIST_(?:SIZE|COUNT)|(?:WIDTH|HEIGHT)_PIXELS)))|MASK_(?:BASE|OWNER|GROUP|EVERYONE|NEXT)|PERM_(?:TRANSFER|MODIFY|COPY|MOVE|ALL)|PARCEL_(?:MEDIA_COMMAND_(?:STOP|PAUSE|PLAY|LOOP|TEXTURE|URL|TIME|AGENT|UNLOAD|AUTO_ALIGN|TYPE|SIZE|DESC|LOOP_SET)|FLAG_(?:ALLOW_(?:FLY|(?:GROUP_)?SCRIPTS|LANDMARK|TERRAFORM|DAMAGE|CREATE_(?:GROUP_)?OBJECTS)|USE_(?:ACCESS_(?:GROUP|LIST)|BAN_LIST|LAND_PASS_LIST)|LOCAL_SOUND_ONLY|RESTRICT_PUSHOBJECT|ALLOW_(?:GROUP|ALL)_OBJECT_ENTRY)|COUNT_(?:TOTAL|OWNER|GROUP|OTHER|SELECTED|TEMP)|DETAILS_(?:NAME|DESC|OWNER|GROUP|AREA|ID|SEE_AVATARS))|LIST_STAT_(?:MAX|MIN|MEAN|MEDIAN|STD_DEV|SUM(?:_SQUARES)?|NUM_COUNT|GEOMETRIC_MEAN|RANGE)|PAY_(?:HIDE|DEFAULT)|REGION_FLAG_(?:ALLOW_DAMAGE|FIXED_SUN|BLOCK_TERRAFORM|SANDBOX|DISABLE_(?:COLLISIONS|PHYSICS)|BLOCK_FLY|ALLOW_DIRECT_TELEPORT|RESTRICT_PUSHOBJECT)|HTTP_(?:METHOD|MIMETYPE|BODY_(?:MAXLENGTH|TRUNCATED)|CUSTOM_HEADER|PRAGMA_NO_CACHE|VERBOSE_THROTTLE|VERIFY_CERT)|SIT_(?:INVALID_(?:AGENT|LINK_OBJECT)|NO(?:T_EXPERIENCE|_(?:ACCESS|EXPERIENCE_PERMISSION|SIT_TARGET)))|STRING_(?:TRIM(?:_(?:HEAD|TAIL))?)|CLICK_ACTION_(?:NONE|TOUCH|SIT|BUY|PAY|OPEN(?:_MEDIA)?|PLAY|ZOOM)|TOUCH_INVALID_FACE|PROFILE_(?:NONE|SCRIPT_MEMORY)|RC_(?:DATA_FLAGS|DETECT_PHANTOM|GET_(?:LINK_NUM|NORMAL|ROOT_KEY)|MAX_HITS|REJECT_(?:TYPES|AGENTS|(?:NON)?PHYSICAL|LAND))|RCERR_(?:CAST_TIME_EXCEEDED|SIM_PERF_LOW|UNKNOWN)|ESTATE_ACCESS_(?:ALLOWED_(?:AGENT|GROUP)_(?:ADD|REMOVE)|BANNED_AGENT_(?:ADD|REMOVE))|DENSITY|FRICTION|RESTITUTION|GRAVITY_MULTIPLIER|KFM_(?:COMMAND|CMD_(?:PLAY|STOP|PAUSE)|MODE|FORWARD|LOOP|PING_PONG|REVERSE|DATA|ROTATION|TRANSLATION)|ERR_(?:GENERIC|PARCEL_PERMISSIONS|MALFORMED_PARAMS|RUNTIME_PERMISSIONS|THROTTLED)|CHARACTER_(?:CMD_(?:(?:SMOOTH_)?STOP|JUMP)|DESIRED_(?:TURN_)?SPEED|RADIUS|STAY_WITHIN_PARCEL|LENGTH|ORIENTATION|ACCOUNT_FOR_SKIPPED_FRAMES|AVOIDANCE_MODE|TYPE(?:_(?:[ABCD]|NONE))?|MAX_(?:DECEL|TURN_RADIUS|(?:ACCEL|SPEED)))|PURSUIT_(?:OFFSET|FUZZ_FACTOR|GOAL_TOLERANCE|INTERCEPT)|REQUIRE_LINE_OF_SIGHT|FORCE_DIRECT_PATH|VERTICAL|HORIZONTAL|AVOID_(?:CHARACTERS|DYNAMIC_OBSTACLES|NONE)|PU_(?:EVADE_(?:HIDDEN|SPOTTED)|FAILURE_(?:DYNAMIC_PATHFINDING_DISABLED|INVALID_(?:GOAL|START)|NO_(?:NAVMESH|VALID_DESTINATION)|OTHER|TARGET_GONE|(?:PARCEL_)?UNREACHABLE)|(?:GOAL|SLOWDOWN_DISTANCE)_REACHED)|TRAVERSAL_TYPE(?:_(?:FAST|NONE|SLOW))?|CONTENT_TYPE_(?:ATOM|FORM|HTML|JSON|LLSD|RSS|TEXT|XHTML|XML)|GCNP_(?:RADIUS|STATIC)|(?:PATROL|WANDER)_PAUSE_AT_WAYPOINTS|OPT_(?:AVATAR|CHARACTER|EXCLUSION_VOLUME|LEGACY_LINKSET|MATERIAL_VOLUME|OTHER|STATIC_OBSTACLE|WALKABLE)|SIM_STAT_PCT_CHARS_STEPPED)\b',
        6 => '\b(?:FALSE|TRUE)\b',
        7 => '\b(?:ZERO_ROTATION)\b',
        8 => '\b(?:EOF|JSON_(?:ARRAY|DELETE|FALSE|INVALID|NULL|NUMBER|OBJECT|STRING|TRUE)|NULL_KEY|TEXTURE_(?:BLANK|DEFAULT|MEDIA|PLYWOOD|TRANSPARENT)|URL_REQUEST_(?:GRANTED|DENIED))\b',
        9 => '\b(?:TOUCH_INVALID_(?:TEXCOORD|VECTOR)|ZERO_VECTOR)\b',
        10 => '\b(?:float|integer|key|list|quaternion|rotation|string|vector)\b',
        11 => '\b(do|else|for|if|jump|return|while)\b',
        12 => '\b(?:print)\b',
        13 => '\b(?:ll(?:GodLikeRezObject|Set(?:Inventory|Object)PermMask))\b',
        14 => '\b(?:LAND_(?:LARGE|MEDIUM|SMALL)_BRUSH)\b',
        15 => '\b(?:ATTACH_[LR]PEC|DATA_RATING|OBJECT_ATTACHMENT_(?:GEOMETRY_BYTES|SURFACE_AREA)|PRIM_(?:CAST_SHADOWS|MATERIAL_LIGHT|TYPE_LEGACY)|PSYS_SRC_(?:INNER|OUTER)ANGLE|VEHICLE_FLAG_NO_FLY_UP)\b',
        16 => '\b(?:ll(?:ClearExperiencePermissions|Cloud|GetExperienceList|Make(?:Explosion|Fountain|Smoke|Fire)|RemoteDataSetRegion|Sound(?:Preload)?|XorBase64Strings(?:Correct)?))\b',
        17 => '\b(?:CHARACTER_(?:MAX_ANGULAR_(?:ACCEL|SPEED)|TURN_SPEED_MULTIPLIER)|KFM_CMD_SET_MODE|PERMISSION_(?:CHANGE_(?:JOINTS|PERMISSIONS)|EXPERIENCE|RELEASE_OWNERSHIP|REMAP_CONTROLS)|PRIM_PHYSICS_MATERIAL|PSYS_SRC_OBJ_REL_MASK|XP_ERROR_REQUEST_PERM_TIMEOUT)\b',
        18 => '\b(?:ll(?:CollisionSprite|(?:Stop)?PointAt|(?:(?:Refresh|Set)Prim)URL|(?:Take|Release)Camera|RemoteLoadScript))\b',
        19 => '\b(?:event)\b'
    ),
    'SYMBOLS' => '\\+\\+|\\-\\-|&lt;|&gt;&gt;|&amp;&amp;?|\\|\\|?|\\^|~|[!%&lt;&gt;=*+\\-\\/]=?',
    'CASE_SENSITIVE' => array(
        GESHI_COMMENTS => false,
        1 => true,
        2 => true,
        3 => true,
        4 => true,
        5 => true,
        6 => true,
        7 => true,
        8 => true,
        9 => true,
        10 => true,
        11 => true,
        12 => true,
        13 => true,
        14 => true,
        15 => true,
        16 => true,
        17 => true,
        18 => true,
        19 => true
    ),
    'STYLES' => array(
        'KEYWORDS' => array(
            1 => 'color: #801a4d;',
            2 => 'color: #004d80;',
            3 => 'color: #820124;',
            4 => 'color: #4d1a80;',
            5 => 'color: #1a1a80;',
            6 => 'color: #1a1a80;',
            7 => 'color: #663366;',
            8 => 'color: #1a4d80;',
            9 => 'color: #663366;',
            10 => 'color: #1a4d1a;',
            11 => 'color: #0000cd;',
            12 => 'color: #333333; outline: #ffcc66 double 3px;',
            13 => 'color: #820124; outline: #ffcc66 double 3px;',
            14 => 'color: #1a1a80; outline: #f2777a double 3px;',
            15 => 'color: #1a1a80; outline: #f2777a double 3px;',
            16 => 'color: #820124; outline: #f2777a double 3px;',
            17 => 'color: #1a1a80; outline: #f2777a double 3px;',
            18 => 'color: #820124; outline: #f2777a double 3px;',
            19 => 'color: #333333; outline: #f2777a double 3px;'
        ),
        'COMMENTS' => array(
            1 => 'color: #cd4d26; font-style: italic;',
            'MULTI' => 'color: #cd4d26; font-style: italic;'
        ),
        'ESCAPE_CHAR' => array(
            0 => 'color: #cd4d26;',
            1 => 'color: #cd4d26;',
            2 => 'color: #cd4d26;',
            3 => 'color: #cd4d26;',
            4 => 'color: #cd4d26;'
        ),
        'BRACKETS' => array(
            0 => 'color: #333333;'
        ),
        'STRINGS' => array(
            0 => 'color: #003300;'
        ),
        'NUMBERS' => array(
            0 => 'color: #f2777a;'
        ),
        'METHODS' => array(),
        'SYMBOLS' => array(
            0 => 'color: #333333;'
        ),
        'REGEXPS' => array(),
        'SCRIPT' => array()
    ),
    'URLS' => array(
        1 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        2 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        3 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        4 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        5 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        6 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        7 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        8 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        9 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        10 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        11 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        12 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        13 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        14 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        15 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        16 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        17 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        18 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}',
        19 => 'http://wiki.secondlife.com/w/index.php?search={FNAME}'
    ),
    'OOLANG' => false,
    'OBJECT_SPLITTERS' => array(),
    'REGEXPS' => array(),
    'STRICT_MODE_APPLIES' => GESHI_NEVER,
    'SCRIPT_DELIMITERS' => array(),
    'HIGHLIGHT_STRICT_BLOCK' => array(),
    'TAB_WIDTH' => 4
);
?>

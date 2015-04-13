<?php
// --------------------------------------------------------------------------
// FSH build env
// --------------------------------------------------------------------------

// Change layout
$GLOBALS[DATA]['tpl'] = 'full.void.tpl.htm';

// --------------------------------------------------------------------------
// __dev/index.php const
// --------------------------------------------------------------------------
define('DO_PRODUCTION', 0);
define('DO_REDIRECT', 'http://devhost/somepath.html'); // + REDIRECT_TIMEOUT
define('REDIRECT_TIMEOUT', 0); // default 0.3
define('DO_SKIPCSS', 1);       // skip SCSS build
define('DO_CLOSEWINDOW', 1);

// --------------------------------------------------------------------------
// __dev/var/param.php const
// --------------------------------------------------------------------------
$param = array(
	'APIKEY'         => md5(SALT.LOGIN.PASSW),
	'HOST_DEPLOY'    => "'deployhost.tld'",
	'SU_DEPMAIN'     => 'robots.txt:e:i:index.php:favicon.ico:../def.production.php',

	'DIR_BUCKET'       => 'DIR_TMP . "bucket/"',
	'BUCKET_LIVETIME'  => 'TIME_DAY',

	'YAWM_IDEF' => '"predefined_yawm_profile"',
	'SU_HIDEPATH' => "'/term/:/dict/'",

	// const?
	// suffix?
);

// --------------------------------------------------------------------------
// __dev/var/param.php const
// --------------------------------------------------------------------------
$var = array(
	'sql' => array(
		'type' => 'class',
		'value' => 'fshSqlUnsafe',
		'param' => array(
			array('var' => 'db'),
			array('value' => array(
					'[CAT]' => 'cat',
					'[STRUCT]' => 'fsh_site',
				)
			)
		)
	),
);

?>
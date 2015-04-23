<?php
// --------------------------------------------------------------------------
// Data processing tpls
// --------------------------------------------------------------------------

r('ALLOW_ARTICLE');
$arr = _var('site')->PageGetByAddr('/news/'); $_sid_news = $arr['parent_id'];
$arr = _var('site')->PageGetByAddr('/articles/'); $_sid_article = $arr['parent_id'];

$pre = array_merge(
	text_news($_sid_news),
	text_articles($_sid_article),
);

$was = array();
$done = $err = 0;
foreach($pre as $k=>$v) {
	$id = $v['id'];
	while(isset($was[$id])) {
		$id++;
	}
	$was[$id] = '';
	unset($v['id']);
	if(_var('article')->ItemSet($id, $v)) {
		$done++;
	} else {
		$err++;
	}
}
r('Articles (humor, news, article) added '.$done.', failed '.$err);

function text_news($sid) {
	$pre = _var('sql')->__sql('SELECT * FROM [EM_NEWS] ORDER BY `idn` LIMIT 30000');
	$res = array();

	foreach($pre as $k=>$v) {
		$res[] = array(
			'sid' => $sid,
			'id' => $v['idn'], // plus
			'name' => $v['subj'],
			'sort' => sort_str($v['subj']),
			'small' => '',
			'short' => '',
			'content' => $v['news'],
			'title' => "",
			'description' => "",
			'keywords' => "",
			'ts_edit' => strtotime($v['dat']),
			'ts_pub' => "0",
			'img' => "",
			'pop' => 0,
			'is_hide' => 0,
			'is_ready' => 0,
			'is_top' => $v['ontop'],
		);
	}

	return $res;
}

?>
<?

// --------------------------------------------------------------------------
// --------------------------------------------------------------------------
// --------------------------------------------------------------------------
function prepare_cards($arr) {
	if(!$arr 
	 	|| !@$arr['debt']
	) {
	 	return array();
	}

	unset(
		$arr['cashback'],
		$arr['addcard']
	);

	$arr['city'] = correct_city(@$arr['city']);
	$arr['currency'] = correct_currency(@$arr['currency']);
	$arr['verification'] = correct_verification(@$arr['verification']);

	return array($arr);
}

function correct_verif($s) {
	$s = trim($s);
	if($s === "") {
		return "NA";
	}
	$tr = array(
		'sdvsdvs' => 0,
		'sdsdv' => 1, 
		'sdvsddv' => 1,
		'dvsdv' => 2,
	);
	if(isset($tr[$s])) {
		return $tr[$s];
	}
	return $s;
}

function my_ser($arr) {
	return plain_ser($arr);
}

function plain_ser($arr) {
	if(is_scalar($arr)) {
		return $arr;
	}
	$arr = (array) $arr;
	$r = '';
	foreach(as_array($arr) as $k=>$v) {
		$r.= $k.':'.plain_ser($v) . "\t";
	}
	return rtrim($r);
}


?>
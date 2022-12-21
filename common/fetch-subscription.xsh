#!/usr/bin/env xonsh

import datetime

datestring = (datetime.datetime.now() - datetime.timedelta(hours=14)).strftime("%Y/%m/%Y%m%d")
$url = f"https://clashnode.com/wp-content/uploads/{datestring}.yaml"

while ($content := $(curl $url)).startswith('https://'):
    $url = $content

print($content)
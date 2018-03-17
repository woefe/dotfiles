#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import requests
import sys

url = "https://api.cryptowat.ch/markets/kraken/%s/price" % sys.argv[1]

try:
    result = requests.get(url)
    if result.ok:
        print(round(result.json().get("result", {}).get("price", -1)), end="")
except:
    pass
finally:
    print("")

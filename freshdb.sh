#!/usr/local/bin/bash
mysql -u andrewroth -p < freshdb.sql
mysql -u spt -p < phoenix/andrew_dev_Oct_27_2006.sql


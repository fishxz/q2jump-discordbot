#!/bin/bash

printf "\xFF\xFF\xFF\xFFrcon fxJmwzsQLnCm5rG $1\n" | nc -u -n -w 1 46.165.236.118 28910 | sed -ne ':x;/\xFF/{N;s/\xFF\xFF\xFF\xFFprint\n//;tx};/^$/d;p'

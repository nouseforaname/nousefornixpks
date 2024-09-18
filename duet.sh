#!/bin/bash
declare -A PAIRS
PAIRS[rk]="Ruben Koster:rkoster@vmware.com"
PAIRS[gs]="Gareth Smith:sgareth@vmware.com"
PAIRS[gb]="George Blue:gblue@vmware.com"
PAIRS[dl]="Diego Lemos:dlemos@vmware.com"
PAIRS[ks]="Konstantin Semenov:konstantin.semenov@broadcom.com"
PAIRS[rv]="Ramkumar Vengadakrishnan:ramkumar.vengadakrishnan@broadcom.com"
PAIRS[if]="Iain Findlay:iain.findlay@broadcom.com"
PAIRS[fm]="Felisia Martini:fmartini@pivotal.io"

echo "export GIT_AUTHOR_NAME='$(echo ${PAIRS[$1]} | cut -f1 -d:)'"
echo "export GIT_AUTHOR_EMAIL='$(echo ${PAIRS[$1]} | cut -f2 -d:)'"
echo "export GIT_COMMITER_NAME=\"Konstantin Kiess\""
echo "export GIT_COMMITER_EMAIL=\"konstantin.kiess@broadcom.com\""

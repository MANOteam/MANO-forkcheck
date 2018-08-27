#!/bin/bash
# saved as forkcheck.sh
# credits https://steemit.com/pivx/@givanse/how-to-check-if-your-pivx-wallet-has-forked

set -e

manocli=~/$USER/mano-cli

function getBlockNumber() {
  $manocli getinfo | grep blocks | sed "s/.*: \([0-9]\+\).*/\1/"
}

function getLocalBlockHash() {
  $manocli getblockhash $1
}

function getRemoteBlockHash() {
  curl -# 'https://explorer.manocoin.org/api/getblockhash?index='$1
}

blockNumber=`getBlockNumber`
localBlockHash=`getLocalBlockHash $blockNumber`
remoteBlockHash=`getRemoteBlockHash $blockNumber`

echo '            block: '$blockNumber
echo ' block hash local: '$localBlockHash
echo 'block hash remote: '$remoteBlockHash

if [ $localBlockHash == $remoteBlockHash ]; then
  echo 'GOOD: still on main chain'
else
  echo 'BAD: you are on a fork, got to re-sync'
fi

exit 0

#!/bin/bash
# $MY_PATH="."
# $MY_FOLDER = "png"
#
# mkdir -p "$MY_PATH/$dir"
dir='../graphs'
mkdir -p "$dir"
dir+="/"

graph_name='graph'
if [ ! -z $2 ]
then
      graph_name=$2
fi
clear
mona $1.mona

printf "\n\n------------------------------\n\n"
mona -gw $1.mona > $dir"whole_$graph_name.dot"

if [ ! -s $dir"whole_$graph_name.dot" ]
then
  echo "------ Suppression de whole graph"
  rm $dir"whole_$graph_name.dot"
else
  echo "Génération du dot : OK."
fi

# open $dir

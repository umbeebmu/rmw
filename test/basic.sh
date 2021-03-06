#!/bin/sh

# include VARS file
. ./VARS

echo "== On first run, directories should get created"
# show commands that are run
set -x
$BIN_DIR/rmw -c $CONFIG

err=$?

set +x

if [ $err != 0 ]; then
  echo "Test failure"
  exit $err
fi

echo "\n\n == List the waste folders"
set -x
$BIN_DIR/rmw -c $CONFIG -l

err=$?

set +x

if [ $err != 0 ]; then
  echo "Test failure"
  exit $err
fi

# Make some temporary files
mkdir tmp-home/tmp-files
cd tmp-home/tmp-files
echo "\n\n == creating temporary files to be deleted"
set -x
for file in 1 2 3
do
  touch $file
done
cd $HOME/..
echo "\n\n == rmw should be able to operate on multiple files\n"
$BIN_DIR/rmw --verbose -c $CONFIG $HOME/tmp-files/*

err=$?
set +x

if [ $err != 0 ]; then
  echo "Test failure"
  exit $err
fi

echo "\n\n == Show contents of the files and info directories"
set -x

ls -al $HOME/.trash.rmw/files
err=$?
set +x
if [ $err != 0 ]; then
  echo "Test failure"
  exit $err
fi

set -x

ls -al $HOME/.trash.rmw/info
err=$?
set +x
if [ $err != 0 ]; then
  echo "Test failure"
  exit $err
fi


echo "\n\n == Display contents of 1.trashinfo "
set -x
cat $HOME/.trash.rmw/info/1.trashinfo

err=$?
set +x
if [ $err != 0 ]; then
  echo "Test failure"
  exit $err
fi

echo "\n\ntest undo/restore feature\n\n"

set -x
$BIN_DIR/rmw --verbose -c $CONFIG -u

err=$?
set +x
if [ $err != 0 ]; then
  echo "Test failure"
  exit $err
fi

echo "\n\n == show that the temp files are restored to their previous locations"

set -x

ls -al $HOME/tmp-files

err=$?
set +x
if [ $err != 0 ]; then
  echo "Test failure"
  exit $err
fi

echo "\n\n == show that the .trashinfo files have been removed"

set -x
ls -al $HOME/.trash.rmw/info

err=$?
set +x
if [ $err != 0 ]; then
  echo "Test failure"
  exit $err
fi

echo "Basic tests passed"
exit 0

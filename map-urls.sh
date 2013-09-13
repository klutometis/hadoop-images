#!/usr/bin/env bash

# [[file:~/prg/org/hadoop-images/TODO.org::*Streaming][Streaming:2]]

csc -o crawl crawl.scm

hadoop fs -rmr /urls
hadoop jar ${HADOOP_PREFIX}/contrib/streaming/hadoop-streaming*.jar \
    -D mapred.reduce.tasks=0 \
    -input /urls-hadoop.txt \
    -output /urls \
    -file crawl \
    -mapper crawl

# Streaming:2 ends here

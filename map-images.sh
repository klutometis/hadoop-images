#!/usr/bin/env bash

# [[file:~/prg/org/hadoop-images/TODO.org::*Streaming][Streaming:2]]

hadoop fs -rmr /images
hadoop jar ${HADOOP_PREFIX}/contrib/streaming/hadoop-streaming*.jar \
    -D mapred.reduce.tasks=0 \
    -input /images-head.txt \
    -output /images \
    -mapper 'download-images.sh hadoop' \
    -file download-images.sh

# Streaming:2 ends here

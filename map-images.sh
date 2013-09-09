#!/usr/bin/env bash

# [[file:~/prg/org/hadoop-images/TODO.org::*Streaming][Streaming:2]]

hadoop fs -rmr /images
hadoop jar ${HADOOP_PREFIX}/contrib/streaming/hadoop-streaming*.jar \
    -D mapred.reduce.tasks=0 \
    -input /images-hadoop.txt \
    -output /images \
    -file download-images.sh \
    -mapper 'download-images.sh hadoop'

# Streaming:2 ends here

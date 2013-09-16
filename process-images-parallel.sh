#!/usr/bin/env bash

# [[file:~/prg/org/hadoop-images/TODO.org::*Streaming][Streaming:2]]

hadoop fs -rmr /images
hadoop jar ${HADOOP_PREFIX}/contrib/streaming/hadoop-streaming*.jar \
    -D mapred.reduce.tasks=0 \
    -input /urls \
    -output /images \
    -file process-images.sh \
    -mapper 'process-images.sh hadoop'

# Streaming:2 ends here

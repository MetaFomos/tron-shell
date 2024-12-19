#!/bin/bash

# Update package list
sudo apt-get update

# Install OpenJDK
sudo apt-get install -y openjdk-8-jdk

# Clone 'java-tron' repo
git clone https://github.com/tronprotocol/java-tron.git
cd java-tron
git checkout -t origin/master

# Build 'java-tron'
./gradlew clean build -x test
cd build/libs

# Make config
git clone https://github.com/inapeace0/node-tron-config.git
cp node-tron-config/* node-tron-config/..
rm -r node-tron-config

# Define the base URL
BASE_URL="https://database.nileex.io/"
STORAGE_BASE_URL="https://nile-snapshots.s3-accelerate.amazonaws.com/"

# Use curl to get the directory listing and grep to filter folders
LAST_FOLDER=$(curl -s $BASE_URL | grep -o 'backup[0-9]\{8\}/' | sort | tail -n 1)

# Download and unzip a snapshot
wget "${STORAGE_BASE_URL}${LAST_FOLDER}LiteFullNode_output-directory.tgz"
wget "${STORAGE_BASE_URL}${LAST_FOLDER}LiteFullNode_output-directory.tgz.md5sum"

# Unzip the downloaded snapshot
tar -xzf LiteFullNode_output-directory.tgz

# Run the lite fullnode
nohup java -Xms9G -Xmx9G -XX:ReservedCodeCacheSize=256m \
    -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m \
    -XX:MaxDirectMemorySize=1G -XX:+PrintGCDetails \
    -XX:+PrintGCDateStamps -Xloggc:gc.log \
    -XX:+UseConcMarkSweepGC -XX:NewRatio=2 \
    -XX:+CMSScavengeBeforeRemark -XX:+ParallelRefProcEnabled \
    -XX:+HeapDumpOnOutOfMemoryError \
    -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 \
    -jar FullNode.jar --es -c test_net_config.conf >> start.log 2>&1 &
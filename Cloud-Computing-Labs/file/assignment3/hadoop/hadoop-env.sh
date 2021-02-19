# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set Hadoop-specific environment variables here.

# The only required environment variable is JAVA_HOME.  All others are
# optional.  When running a distributed configuration it is best to
# set JAVA_HOME in this file, so that it is correctly defined on
# remote nodes.

# The java implementation to use.
export JAVA_HOME=${JAVA_HOME}

# The jsvc implementation to use. Jsvc is required to run secure datanodes
# that bind to privileged ports to provide authentication of data transfer
# protocol.  Jsvc is not required if SASL is configured for authentication of
# data transfer protocol using non-privileged ports.
#export JSVC_HOME=${JSVC_HOME}

export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"/home/hadoop/conf"}

# Extra Java CLASSPATH elements.  Automatically insert capacity-scheduler.
for f in $HADOOP_HOME/contrib/capacity-scheduler/*.jar; do
  if [ "$HADOOP_CLASSPATH" ]; then
    export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$f
  else
    export HADOOP_CLASSPATH=$f
  fi
done


export hadoop_pid_dir_prefix=/var/run/hadoop-hdfs
export hdfs_log_dir_prefix=/var/log/hadoop-hdfs

# The maximum amount of heap to use, in MB. Default is 1000.
#export HADOOP_HEAPSIZE=
#export HADOOP_NAMENODE_INIT_HEAPSIZE=""
export HADOOP_HEAPSIZE=1024
export HADOOP_USER_CLASSPATH_FIRST=true

export HADOOP_NAMENODE_HEAPSIZE=3072
export HADOOP_DATANODE_HEAPSIZE=3413


export namenode_opt_newsize=128m
export namenode_opt_maxnewsize=128m
export namenode_heapsize=${HADOOP_NAMENODE_HEAPSIZE}m
export dtnode_heapsize=${HADOOP_DATANODE_HEAPSIZE}m


# Enable extra debugging of Hadoop's JAAS binding, used to set up
# Kerberos security.
# export HADOOP_JAAS_DEBUG=true

# Extra Java runtime options.  Empty by default.
# For Kerberos debugging, an extended option set logs more invormation
# export HADOOP_OPTS="-Djava.net.preferIPv4Stack=true -Dsun.security.krb5.debug=true -Dsun.security.spnego.debug"
export HADOOP_OPTS="$HADOOP_OPTS -Djava.net.preferIPv4Stack=true"


SHARED_HADOOP_NAMENODE_OPTS="-server -XX:ParallelGCThreads=8 -XX:+UseConcMarkSweepGC -XX:ErrorFile=${hdfs_log_dir_prefix}/hs_err_pid%p.log -XX:NewSize=${namenode_opt_newsize} -XX:MaxNewSize=${namenode_opt_maxnewsize} -Xloggc:$hdfs_log_dir_prefix/gc.log-`date +'%Y%m%d%H%M'` -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:CMSInitiatingOccupancyFraction=70 -XX:+UseCMSInitiatingOccupancyOnly -Xms${namenode_heapsize} -Xmx${namenode_heapsize} -Dhadoop.security.logger=INFO,DRFAS -Dhdfs.audit.logger=INFO,RFAAUDIT"

export HADOOP_NAMENODE_OPTS="${SHARED_HADOOP_NAMENODE_OPTS} -XX:OnOutOfMemoryError=\"/usr/hdp/current/hadoop-hdfs-namenode/bin/kill-name-node\" -Dorg.mortbay.jetty.Request.maxFormContentSize=-1 ${HADOOP_NAMENODE_OPTS}"

export HADOOP_DATANODE_OPTS="-server -XX:ParallelGCThreads=4 -XX:+UseConcMarkSweepGC -XX:ErrorFile=${hdfs_log_dir_prefix}/hs_err_pid%p.log -XX:NewSize=200m -XX:MaxNewSize=200m -Xloggc:${hdfs_log_dir_prefix}/gc.log-`date +'%Y%m%d%H%M'` -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -Xms${dtnode_heapsize} -Xmx${dtnode_heapsize} -Dhadoop.security.logger=INFO,DRFAS -Dhdfs.audit.logger=INFO,RFAAUDIT ${HADOOP_DATANODE_OPTS} -XX:CMSInitiatingOccupancyFraction=70 -XX:+UseCMSInitiatingOccupancyOnly"


export HADOOP_NFS3_OPTS="$HADOOP_NFS3_OPTS"
export HADOOP_PORTMAP_OPTS="-Xmx512m $HADOOP_PORTMAP_OPTS"

# The following applies to multiple commands (fs, dfs, fsck, distcp etc)
export HADOOP_CLIENT_OPTS="$HADOOP_CLIENT_OPTS"
# set heap args when HADOOP_HEAPSIZE is empty
if [ "$HADOOP_HEAPSIZE" = "" ]; then
  export HADOOP_CLIENT_OPTS="-Xmx512m $HADOOP_CLIENT_OPTS"
fi
#HADOOP_JAVA_PLATFORM_OPTS="-XX:-UsePerfData $HADOOP_JAVA_PLATFORM_OPTS"

# On secure datanodes, user to run the datanode as after dropping privileges.
# This **MUST** be uncommented to enable secure HDFS if using privileged ports
# to provide authentication of data transfer protocol.  This **MUST NOT** be
# defined if SASL is configured for authentication of data transfer protocol
# using non-privileged ports.
export HADOOP_SECURE_DN_USER=${HADOOP_SECURE_DN_USER}

# Where log files are stored.  $HADOOP_HOME/logs by default.
export HADOOP_LOG_DIR=$hdfs_log_dir_prefix

# Where log files are stored in the secure data environment.
#export HADOOP_SECURE_DN_LOG_DIR=${HADOOP_LOG_DIR}/${HADOOP_HDFS_USER}

###
# HDFS Mover specific parameters
###
# Specify the JVM options to be used when starting the HDFS Mover.
# These options will be appended to the options specified as HADOOP_OPTS
# and therefore may override any similar flags set in HADOOP_OPTS
#
# export HADOOP_MOVER_OPTS=""

###
# Advanced Users Only!
###

# The directory where pid files are stored. /tmp by default.
# NOTE: this should be set to a directory that can only be written to by 
#       the user that will run the hadoop daemons.  Otherwise there is the
#       potential for a symlink attack.
export HADOOP_PID_DIR=$hadoop_pid_dir_prefix
export HADOOP_SECURE_DN_PID_DIR=${HADOOP_PID_DIR}

# A string representing this instance of hadoop. $USER by default.
export HADOOP_IDENT_STRING=$USER
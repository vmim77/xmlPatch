#!/bin/bash

### Path
path=$1

### Deploy Date
today=`date "+%Y%m%d"`

### Tomcat PID
tomcatPID=`ps -ef | grep apache-tomcat | grep -v grep | awk '{print $2}'`

echo "[INFO] Start xml_patch.sh"

if [ ! -d /prd/app/backup/$today ] ; then 
	mkdir /prd/app/backup/$today
fi

if $path -o $path ; then
	echo "[INFO] Stop apache-tomcat"
	/prd/app/apache-tomcat/bin/catalina.sh stop
	sleep 30
	
	if $path ; then
		if [ -e $path/tomcat.war ] ; then
			echo "[INFO] Replace tomcat.war"
			
			cp /prd/app/ui/tomcat.war /prd/app/backup/$today
			rm -rf /prd/app/ui/tomcat*		
			cp $path/tomcat.war /prd/app/ui
			sleep 3
		fi
	fi

	if [ `ps -ef | grep $tomcatPID | grep -v grep | wc -l` -ne 0 ] ; then
		echo "Kill $tomcatPID"
		kill -9 $tomcatPID
		sleep 3
	fi

	echo "[INFO] Start apache-tomcat"
	/prd/app/apache-tomcat/bin/catalina.sh start
	sleep 3
fi

echo "[INFO] End xml_patch.sh"



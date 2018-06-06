#!/bin/bash
baseDir=$(cd `dirname $0`; pwd)
init=0
total_step=5
check_root()
{
   if [ ! `id -u` -eq 0 ]
   then
      echo "Must run with root user"
      exit 1
   fi
   i=$(($i+1))
   echo "[Step $i/$total_step] check root user [PASS]"
}

install_dependcy()
{
    # check docker 
    if [ `type docker >/dev/null 2>/tmp/install.tmp|cat /tmp/install.tmp|grep not |wc -l` -eq 1 ]
    then
		init=1
		echo "Begin Install Docker"
		curl https://releases.rancher.com/install-docker/1.12.sh | sh
    fi
    # check docker compose
    if [ `type docker-compose >/dev/null 2>/tmp/install.tmp|cat /tmp/install.tmp|grep not |wc -l` -eq 1 ]
    then
		init=1
		echo "Begin Install Docker Compose"
		curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
		chmod +x /usr/local/bin/docker-compose
    fi    
    # check java
    if [ ! -d "$baseDir/jdk1.8.0_171" ]
    then
		init=1
        echo "Install JAVA $baseDir/java"
        wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz  -P $baseDir
        tar -zxf jdk-8u171-linux-x64.tar.gz
        mv jdk-8u171-linux-x64.tar.gz tomcat
        ln -s $baseDir/jdk1.8.0_171  $baseDir/java
    fi
    # check maven
    if [ ! -d "$baseDir/apache-maven-3.5.3" ]
    then
		init=1
        echo "Install Maven $baseDir/maven"
        wget http://mirror.bit.edu.cn/apache/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz -P $baseDir
        tar -zxf apache-maven-3.5.3-bin.tar.gz
        rm -rf apache-maven-3.5.3-bin.tar.gz
        ln -s $baseDir/apache-maven-3.5.3 $baseDir/apache-maven
    fi
    if [ ! -f "$baseDir/tomcat/apache-tomcat-8.5.8.tar.gz" ];
    then
		init=1
		echo "Install Apache "
		wget http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.8/bin/apache-tomcat-8.5.8.tar.gz -P $baseDir/tomcat
    fi
    mkdir -p $baseDir/postgres/data
    chmod -R 777 $baseDir/postgres/data
    export JAVA_HOME=$baseDir/java
    export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
    export PATH=$JAVA_HOME/bin:$PATH
    export M2_HOME=$baseDir/apache-maven
    export M2=$M2_HOME/bin
    export MAVEN_OPTS="-Xms256m -Xmx512m"
    export PATH=$M2:$PATH:$HOME/bin
    i=$(($i+1))
	echo "[Step $i/$total_step] install dependcy [PASS]"   
	
}

init_database()
{
	if [ $init -eq 1 ];
	then
		cd $baseDir>/dev/null
		docker exec -it $( docker ps |grep postgres|awk '{print $1}') psql -U postgres -c 'create database epark;'
		docker cp init_table.sql $( docker ps |grep postgres|awk '{print $1}'):/tmp
		docker exec -it $( docker ps |grep postgres|awk '{print $1}') psql -d epark -U postgres -f /tmp/init_table.sql
		i=$(($i+1))
		echo "[Step $i/$total_step] Init DataBase [PASS]"
	fi
}

package()
{
   yes|cp $baseDir/zfbinfo.properties ../src/main/resources/zfbinfo.properties
   cd ../ >/dev/null
   mvn clean package
   cd - >/dev/null
   i=$(($i+1))
   echo "[Step $i/$total_step] compiler code [PASS]"
}

deploy()
{
   mkdir -p $baseDir/tomcat/webapp
   mkdir -p $baseDir/tomcat/logs
   rm -rf  $baseDir/tomcat/webapp/epark*
   mv ../target/epark-*-SNAPSHOT.war $baseDir/tomcat/webapp/epark.war
   chmod -R 777 $baseDir/tomcat/webapp
   docker-compose down
   docker-compose up -d 
   i=$(($i+1))
   echo "[Step $i/$total_step] deploy code [PASS]"
}
main()
{
   cd $baseDir >/dev/null
   echo "-------------------------------------"
   echo "Begin Install EPARK SYSTEM"
   echo "-------------------------------------"
   i=0
   check_root
   install_dependcy
   package
   deploy
   
   i=$(($i+1))
}
main

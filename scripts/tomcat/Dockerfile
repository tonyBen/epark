FROM centos
MAINTAINER tony.ben "benyoupeng@gmail.com"

#RUN yum install -y wget

ADD ./ /tmp

RUN mkdir /var/tmp/jdk
RUN mkdir /var/tmp/tomcat
# install tomcat
RUN cd /tmp && tar -xzf apache-tomcat-8.5.8.tar.gz -C /var/tmp/tomcat && rm -rf /var/tmp/tomcat/apache-tomcat-8.5.8.tar.gz
RUN cd /tmp && tar -xzf jdk-8u171-linux-x64.tar.gz -C /var/tmp/jdk && rm -rf /var/tmp/jdk/jdk-8u171-linux-x64.tar.gz
#RUN cd /tmp && cp epark.war /var/tmp/tomcat/apache-tomcat-8.5.8/webapps/epark.war 
RUN rm -rf /tmp/*


ENV JAVA_HOME /var/tmp/jdk/jdk1.8.0_171
ENV CATALINA_HOME /var/tmp/tomcat/apache-tomcat-8.5.8
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin

EXPOSE 8080

CMD ["./var/tmp/tomcat/apache-tomcat-8.5.8/bin/catalina.sh","run"] && tail -f /var/tmp/tomcat/apache-tomcat-8.5.8/logs/catalina.out 

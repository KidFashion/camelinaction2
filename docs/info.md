# Use Case

1. Input receive lumberjack protocol data
2. Transform is applied
3. Output is based on AMQ (ActiveMQ 7.9)

# Configuration

## Input

 - [Install filebeat](https://www.elastic.co/guide/en/beats/filebeat/current/setup-repositories.html)

### Instructions

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

sudo apt-get install apt-transport-https

echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list

sudo apt-get update && sudo apt-get install filebeat

Per lanciarlo come systemd: sudo systemctl enable filebeat

filebeat -c /root/camelinaction2/workspace/filebeat/filebeat.yml -e

#### Use in codespace

Needs to create /var/lib/filebeat as sudo and chown it to codespace user

 - `sudo mkdir /var/lib/filebeat`
 - `chown codespace /var/lib/filebeat`

After that filebeat can be launched with:

`filebeat -c /workspaces/camelinaction2/workspace/filebeat/filebeat.yml -e -v`

NB: Ensure to chech that file path in `/workspaces/camelinaction2/workspace/filebeat/filebeat.yml` is still correct

## Output

 - [Install Artemis](https://medium.com/@hasnat.saeed/setup-activemq-artemis-on-ubuntu-18-04-76bb4975308b)

### Instructions

sudo groupadd artemis

sudo useradd -s /bin/false -g artemis -d /opt/artemis artemis

cd /opt

sudo wget https://archive.apache.org/dist/activemq/activemq-artemis/2.9.0/apache-artemis-2.9.0-bin.tar.gz

sudo tar -xvzf apache-artemis-2.9.0-bin.tar.gz

sudo mv apache-artemis-2.9.0 artemis

sudo chown -R artemis: artemis

sudo chmod o+x /opt/artemis/bin/

cd /var/lib

/opt/artemis/bin/artemis create test-broker

Modify /var/lib/test-broker/bin/artemis to add "--illegal-access=permit \" as JAVA command line parameter

Modify /var/lib/test-broker/etc/bootstrap.xml (change bind from localhost from 0.0.0.0)

Modify /var/lib/test-broker/etc/jolokia-access.xml (remove localhost from allow-origin)

/var/lib/test-broker/bin/artemis run

*I've looked into it and updated the Gradle version of the HelloWorld to be compatible with Java16.
To use Java16, you also have to add the following to the build.gradle JVMArgs << "--illegal-access=permit"(or something similar for maven)*
To use Java 17 illegal-access does not work anymore, add-opens needs to be added instead (see https://github.com/NationalSecurityAgency/ghidra/issues/3355).

--add-opens=java.base/java.util=ALL-UNNAMED
--add-opens=java.base/java.lang=ALL-UNNAMED
--add-opens=java.base/java.net=ALL-UNNAMED

NB: User is **test** with the usual password.

## Configure Lumberjack input

As described at https://camel.apache.org/components/3.15.x/lumberjack-component.html

Added dependency to pom file

# Configure AMQP output

As described at https://camel.apache.org/components/3.15.x/amqp-component.html

Added dependency to pom file

Port 5672

# Java

Remember you need to be in the folder containing the src folder (i.e. /workspaces/camelinaction2/workspace/file-copy)

mvn compile exec:java -Dexec.mainClass=camelinaction.BeatsToFolderWithCamel
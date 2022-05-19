#!/bin/bash
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

echo "Modify /var/lib/test-broker/bin/artemis to add \"--illegal-access=permit \\\" as JAVA command line parameter"

echo "Modify /var/lib/test-broker/etc/bootstrap.xml (change bind from localhost from 0.0.0.0)"

echo "Modify /var/lib/test-broker/etc/jolokia-access.xml (remove localhost from allow-origin)"

echo "/var/lib/test-broker/bin/artemis run"

echo "connect to port 8161: http://0.0.0.0:

npx -q codespaces-port <port> 
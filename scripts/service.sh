#!/bin/bash
sudo apt -y update
sudo apt install -y maven
git clone https://github.com/DevQAC/QA-Portal.git -b development
cd QA-Portal/qa-portal-services
mvn clean package

sudo useradd serviceadmin 

sudo chown -R serviceadmin /etc/systemd/system
sudo chown -R serviceadmin ~/JarScripts/scripts/QA-Portal/qa-portal-services/
sudo chown -R serviceadmin /usr/bin/java

#If the filename does have api in the title please insert in VAR, if not insert below into VAR2

VAR=("core-api" "user-api")

for val2 in ${VAR[*]}; do
	sudo mkdir /opt/$val2
	sudo cp ~/JarScripts/scripts/QA-Portal/qa-portal-services/$val2/target/$val2-0.0.1-SNAPSHOT.jar /opt/$val2/
	sudo chown -R serviceadmin /opt/$val2
	sudo systemctl daemon-reload
done

for val in ${VAR[*]}; do
	sudo systemctl stop $val
	ls
	cd ~/JarScripts/scripts/
	ls
	sudo sed "s/{{NAME}}/$val/g" example.service | sudo tee /etc/systemd/system/$val.service 
	sudo systemctl start $val
	sudo systemctl daemon-reload
done

VAR2=("self-reflection")

for val3 in ${VAR2[*]}; do
      	sudo mkdir /opt/$val3
	sudo cp ~/JarScripts/scripts/QA-Portal/qa-portal-services/$val3/target/$val3-api-0.0.1-SNAPSHOT.jar /opt/$val3/
	sudo chown -R serviceadmin /opt/$val3
	 sudo systemctl daemon-reload
done

for val3 in ${VAR2[*]}; do
        sudo systemctl stop $val3
	ls
	cd ~/JarScripts/scripts
        sudo sed "s/{{NAME}}/$val3/g" template-api.service | sudo tee /etc/systemd/system/$val3.service
        sudo systemctl start $val3
	sudo systemctl daemon-reload
done

VAR3=("self-reflection" "user-api" "core-api")


for value in ${VAR3[*]}; do
	sudo systemctl daemon-reload
	sudo systemctl stop $value
	sudo systemctl start $value
done

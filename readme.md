# Updates for XLP system

> If you do not know what you are going to see next, you have probably come to the wrong place.

For more information on and basic configurations for XLP system, please go to 
https://github.com/benkoo/TensorCloud

Newly added plugins, additional micro-services required, modified configurations will be stored in this repository.
These updates will be in the form of

- modified docker-compose.yml file
- new .conf file
- plugins for Mediawiki and other micro-services
- shell scripts for automatic upgrading
- other forms of updates

## Environment (Defaults)

- All data are mounted at /data/xlpsystem/
- The system is set up using https://github.com/RunTimeError2/XLP_AutoDeploy where the docker-compose.yml file is located at directory 'XLP_AutoDeploy' so that the names of containers have the prefix 'xlp_autodeploy_'

## Updates finished

- to be added

## Updates to be done

- Extension:Capiunto and Extension:Cite for Mediawiki
- Add Logstash to form an ELK structure
- Cluster deployment using Kubernetes, Istio, Apache:Kafka or other tools
- After Kubernetes, add Brigade and its visualizing tool Kashti
- more to be added

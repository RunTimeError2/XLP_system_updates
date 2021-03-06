# Updates for XLP system 2

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
- If you set up the system using this repository, the prefix of containers would be 'xlp_system_updates_', please take care of it.

## Updates finished

- Several .yml configurations, respectively containing different combinations of containers.
- Extensions: VisualEditor, Cite
- Logstash: Container (conf. in docker-compose.yml), Configuration(supporting tcp, file, jdbc) 
and incremental synchonization of multiple tables
- Extension:Math (support LaTeX, but only have documents on http://toyhouse.cc:81/index.php/%E6%95%B0%E5%AD%A6%E5%85%AC%E5%BC%8F%E4%B8%8ELaTeX%E7%9A%84%E6%94%AF%E6%8C%81)

## Updates to be done

- Extension:SemanticMediawiki (a lot of problems)
- Extension:HavardReferences (failed)
- Cluster deployment using Kubernetes, Istio, Apache:Kafka or other tools
- After Kubernetes, add Brigade and its visualizing tool Kashti
- more to be added

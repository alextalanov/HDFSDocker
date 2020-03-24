#!/usr/local/bin/python3
import json
from os import environ as env
from os import system as bash
from sys import argv
from pathlib import Path
import xml.etree.ElementTree as Xml
from xml.dom import minidom


def create_xml(file: Path, configuration: dict):
    root = Xml.Element('configuration')

    if configuration:
        for key, val in configuration.items():
            _property = Xml.Element('property')
            name = Xml.SubElement(_property, 'name')
            name.text = key
            value = Xml.SubElement(_property, 'value')
            value.text = str(val)
            root.append(_property)

    rough_string = Xml.tostring(root, 'utf-8')
    pretty_xml = minidom.parseString(rough_string).toprettyxml()

    with file.open(mode='wb') as xml_file:
        xml_file.write(bytes(pretty_xml, encoding='utf-8'))

def generate_configs(configuration: Path):
    with configuration.open(mode='r') as config_file:
        config = json.load(config_file)

    core_site = Path(env['HADOOP_CONFIG']) / "core-site.xml"
    create_xml(file=core_site, configuration=config.get('core_site'))

    hdfs_site = Path(env['HADOOP_CONFIG']) / "hdfs-site.xml"
    create_xml(file=hdfs_site, configuration=config.get('hdfs_site'))

    yarn_site = Path(env['HADOOP_CONFIG']) / "yarn-site.xml"
    create_xml(file=yarn_site, configuration=config.get('yarn_site'))


command = argv[1]

if len(argv) > 2:
    generate_configs(configuration=Path(argv[2]))


bash_command='hadoop-daemon.sh --config $HADOOP_CONFIG --script {}'.format(command)
print("Start using bash command: {}".format(bash_command))
status = bash(bash_command)

print("POSIX Status: {}".format(status))

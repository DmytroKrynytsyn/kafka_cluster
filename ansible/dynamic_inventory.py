#!/usr/bin/env python
import json
import boto3

def get_ec2s_by_tag(tag_key, tag_value):
    ec2_client = boto3.client('ec2')

    response = ec2_client.describe_instances(
        Filters=[
            { 'Name': 'instance-state-name', 'Values': ['running'] },
            { 'Name': f'tag:{tag_key}', 'Values': [tag_value] }
        ]
    )

    instances = []
    reservations = response['Reservations']
    for reservation in reservations:
        instances.extend(reservation['Instances'])

    return instances


def get_public_ip_by_role(role: str) -> str:
    return get_ec2s_by_tag("Role", role)[0]['PublicIpAddress']

def get_private_ip_by_role(role: str) -> str:
    return get_ec2s_by_tag("Role", role)[0]['PrivateIpAddress']


def get_public_and_private_ip_by_role(role: str) -> list[tuple[str, str]]:
    return [ ( ec2['PublicIpAddress'], ec2['PrivateIpAddress'] ) for ec2 in get_ec2s_by_tag("Role", role) ]

def main():

    kafka_brokers = get_public_and_private_ip_by_role('kafka_broker')

    controller_quorum_voters = []
    hostvars = {}
    hosts = []

    for i, kafka_broker in enumerate(kafka_brokers):

        node_id = i + 1

        public_ip = kafka_broker[0]
        private_ip = kafka_broker[1]

        hostvars[public_ip] = {
            'ansible_user': 'ec2-user',
            'ansible_ssh_private_key_file': './cks.pem', 
            'ansible_ssh_common_args': '-o StrictHostKeyChecking=no',
            'node_id' : node_id,
            'private_ip' : private_ip
        }

        hosts.append(public_ip)
        controller_quorum_voters.append(f"{node_id}@{private_ip}:9093")

    inventory = {
        "_meta": {
            "hostvars": hostvars,
        },

        'kafka_broker': {
            'hosts': hosts,
            'vars': {
                'controller_quorum_voters': ','.join(controller_quorum_voters)
            }
        },
    }

    print(json.dumps(inventory, indent=2))

if __name__ == '__main__':
    main()
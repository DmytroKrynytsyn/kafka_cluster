# **Kafka Cluster, High Availability (HA) Architecture, Raft Protocol (KRaft Mode) - No Zookeeper**

![kafka_cluster](https://github.com/user-attachments/assets/def46304-1cbe-438c-8c1c-d0b18b825821)

This project demonstrates the provisioning and configuration of a Kafka cluster. It showcases a DevOps workflow integrating Terraform, Terragrunt, and Ansible, following best practices with modular and reusable Ansible roles.

The architecture is designed to meet high availability (HA) requirements for enterprise-grade solutions, ensuring reliability, fault tolerance, and scalability.

## Project Highlights
# High Availability (HA) Architecture:
Designed with three brokers to ensure continuity of operations in case of failure.
It provides redundancy and supports load balancing for read-heavy workloads, reducing downtime risks.
# Infrastructure as Code (IaC):
Utilized Terraform and Terragrunt to define and provision cloud resources.
Configuration Management:
Leveraged Ansible for automating Kafka cluster setup.
Created reusable and modular Ansible roles for clean and scalable configurations.
# Enterprise-Ready Design:
Built to support critical applications where uptime and data reliability are essential.
# Technologies Used
* Terraform: Provisioned infrastructure.
* Terragrunt: Simplified Terraform workflows with DRY principles.
* Ansible: Automated server configuration and application setup.
* Kafka: Open-source, in-memory key-value store for high-performance caching and data storage.
## Features
* High Availability: Ensures reliable performance for mission-critical applications.
* Automated Setup: End-to-end automation of infrastructure provisioning and cluster configuration.
* Modular Design: Separate Ansible roles for enhanced reusability.
* Enterprise High Availability Compliance

# This architecture adheres to enterprise-level high availability (HA) standards by:
* Minimizing Single Points of Failure: The configuration ensures redundancy, reducing the risk of service interruption.
* Scalability: Easily extendable to include more replicas or cluster-based configurations for larger systems. This approach aligns with HA requirements often found in industries like finance, e-commerce, and technology where uptime and reliability are paramount.

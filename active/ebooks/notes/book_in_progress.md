# Modern Development

## Initial Stack

I noticed that with terraform, upon failed operations rollbacks were not complete and I had to do a lot of manual work to restore state alignment between terraform and the cloud deployment I was attempting to automate the management of.

I am hoping CloudFormation works better.

1. Security
1. Docker: Containers
1. Networking: IP
1. CloudFormation: IaC
1. Kubernetes: Container Orchestration
    - etcd (distributed KV-store)
1. Messaging
    - redis, kafka, *MQ
1. Distributed Filesystems: FSx for Lustre
1. Workflow: NextFlow, Snakemake
1. System Code: C/Rust
1. Application Logic: C++, Rust, GoLang, Python, Javascript
1. UI: Javascript, React, (*)->WASM
1. Machine Learning: Tensorflow & PyTorch

# Modern Development

## Initial Stack

I noticed that with terraform, upon failed operations rollbacks were not complete and I had to do a lot of manual work to restore state alignment between terraform and the cloud deployment I was attempting to automate the management of.

I am hoping CloudFormation works better. This will combine the usage of terraform with CloudFormation for heterogeneous cloud systems, but still gaining the advantage native AWS enables in the space of IaC.

If terraform is used, additional methods will be used to implement rollbacks. e.g. Project namespace properties on rules, and a separate script that can remove a project namespace at a time. Then at least with proper project definitions, project-rollbacks can be used to reset state, in which case the terraform tfstate file can be removed for the project on failure and redeployed. Here if there are repeated issues an alert would be generated. This could happen if a service changes its requirements after update, etc. This implies I may want to then keep individual projects within one terraform file to simplify maintenance.

I believe there are also some AWS services in which CloudFormation doesn't support. For these terraform may be used. This is just a note so that I do the research necessary to validate and document properly in the book.


1. Security
1. Docker: Containers
1. Networking: IP
1. CloudFormation: IaC
1. Kubernetes: Container Orchestration
    - etcd (distributed KV-store)
1. Messaging
    - redis, kafka, *MQ
1. Distributed Filesystems: Lustre (AWS FSx for Lustre)
1. Workflow: NextFlow, Snakemake
1. System Code: C/Rust
1. Application Logic: C++, Rust, GoLang, Python, Javascript
1. UI: Javascript, React, HTML, CSS, (*)->WASM
1. Machine Learning: Tensorflow & PyTorch

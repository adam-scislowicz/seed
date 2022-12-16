# eSymbiote

A device promoting generative interaction, with both other people and autonomous systems.

## Definitions

* symbiote (noun): An organism in a partnership with another such that each profits from their being together.
* symbiont (noun): An organism in a symbiotic relationship.

## Features

* IPv4 and IPv6
* Ethernet, Wifi, and/or Cellular Uplink
* edge-to-cloud encrypted tunnels (UDP w/ TCP Fallback)
* encrypted domain name service (DNS) lookups using dnscrypt
* additional TLD (.eight) with internal resolver (eSymbiote internal name service)
* multi-site secure networking: edge-to-edge VLAN
* secure and reliable device-to-device messaging
* git over SSH server with versioned caching object store
    * enables efficient big-data pipeline processing
    * supports external storage devices
    * supports secure-backup service
    * versioned caching object store also deployable as a cloud-provider-agnostic service for efficient near-compute object access (e.g. aws, azure, gcloud, etc.)
* Local execution engines: WASM, ONNX, tensorflow/pytorch native models.


## Models

* edge-basic: Raspberry Pi
* edge-ml-nano: NVidia Jetson Nano
* edge-ml-hp: NVidia Jetson Xavier

## Form Factors

* Industrial
* Hobbyist / Prototyping

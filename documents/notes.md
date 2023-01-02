# Notes

My New Number: +1 509 388 0496


## TODO

1. Continue Indigogo campaign. Need to start doing product placement / branding. Have a working prototype so you can list it as such on indigogo. Focus on this from the perspective of a marketing campaign.
1. Look into using a multi-stage build strategy in the combined dockerfile to reduce its size.
1. Build minimal Dockerfile's for use with kubernetes, these will obviously be very different than the aggregated seed Dockerfile which is as wide as possible to support discovery/exploration.
    - Build images for
        - caching 'proxy' for APT, PIP, NPM, etc. These will be used as the sources for contaier building.
1. Continue working on extropic.net/xnetworks-controld. This will drive aws iam, cloudformation, terraform, etc. Consider running it as a kubernetes service and having it get its configuration from etcd. It should be pretty easy to mate viper with etcd as an alternative to loading from a YAML file. E.g. initially loading a YAML file would push the configuration data to etcd. I can then look into using a distribtued DB also within kubernetes along with a message system to implement xnetworks-controld as a distributed highly available system.
    - Get kubernetes up and add a DB and reliable message passing system and other support systems needed to support xnetworks-controld keeping its state in a reliable, distributed fashion.
    - Create a Cloudformation stack for kubernetes so that you can test it when cloud-hosted as well. e.g. Use ECS/EKS.

## General Notes

- GEL: pulse alone
- XSL-08: continue, but increase dosage
    - Below if possible after MIA-602 suppresses GHRH:
        - JDJGYWSEMW restart, only while XSL-08 is effective
        - HFSH: restart, only use short acting and time with peak XSL-08
— new are below, important, sourcing please, these are probably somewhat hard to obtain in the proper dosages. —
    - GHRH Antagonist MIA-602 sub-q. Can reverse remodelling in some animals
    - trodusquemine (novel protein tyrosine phosphatase PTP-1B inhibitor)

If the new compounds cannot be sourced, see if a nearby clinic/hospital is willing to administer them. Also have the new compounds reviewed by an expert. Is it a reasonable experiment? There have been MI reverse-remodelling observations in animal models with MIA-602 with similar pre-conditions.

If the above fails, look into the following:

Intravascular lithotripsy, or I.V.L, less risk than rotational sanding devices for reducing arterial plaques. Not even sure if this is relavent.

## Extropic.net

### Marketing

Crowd Funding Sites

- Indigogo *this is often rated highly, maybe it has the most purchaser traffic in the segments I will be addressing?
- Crowd Supply *this looks good for tech focused products
- Kickstarter *still big

Facebook advertising. I should start experiments with this next month. Experiments can be run for a few hundred dollars at a time. This will be used to finish product placement and branding and to build an email list of likely purchasers. e.g. to prepare for a crowdfunding raise.

Iterate to build a Launch Email List
	Product Placement
	Branding	

When the Launch Email List is big enough
	Start crowdfunding campaign

### xnetworks software

- xnetworks-controld protocol
    - daemon: xnetworks-controld: kubernetes hosted control daemon
    - cli app: xnetworks: cli to communicate with the control daemon

#### xnetworks-controld

Track state in etcd and a distributed transactional database.


### Seattle, Notes

Billing

Address: Virginia Mason Medical Center, 1100 9th Ave, Seattle, WA 98101
Phone: +1 206 624 1144


### Semiconductor Ecosystem

https://www.piie.com/research/piie-charts/major-semiconductor-producing-countries-rely-each-other-different-types-chips
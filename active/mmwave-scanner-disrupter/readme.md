# Adiabator

The first generation adiabator intends to be similar to an MRI but with the capability to add sufficient entropy at a high enough power level to destroy $mm^2$ voxels in addition to its scanning capabilities.

The early device intends to be effective for many forms of cancer, and also as part of an anti-aging protocol where damages cells can be detected and destroyed at a rate sufficient for the immune system to keep up with clearance. Protocols may support immune boosting, utilize stem cells, and/or pharmaceuticals.

## Initial Due Diligence.

A basic prototype will be co-constructed along with a digital model of the prototype.

The prototype will be used to validate the digital model, and will be used to scan and disrupt model volumes.

## Early Ideas

1. THz band transceivers as they are available and already used to successfully scan ~mm scale features
2. A rigid, extremely stable ring-array base for mounting the antennas connected to the transceivers. The goal is that the relative positions of the antennas not change during operation.
3. Likely need a CPU, GPU, and FPGA combo system for prototyping.

FPGA Boards:  Xilinx ZCU111 ~12k$ USD (ref: https://unlab.tech/wp-content/uploads/2020/07/RFSoC_based_Multichannel_Ultra_Broadband_Links.pdf)

System: Intel board w/ NVidia GPU & PCIe based FPGA

Frame: Needs investigation. Must be extremely rigid

THz Transceivers: Built off the FPGA along with some analog components. Contact paper authors above and then talk to places like BittWare who have domain experience.

Antennas: Needs investigation

Antenna Mounts: Needs investigation

### Antenna Modelling

Questions:
1. Radiation patterning: omni, parabolic, or other
2. Static or dual-axis drive. Risk is any drive system would introduce too much noise or require too much time for recalibration between adjustments.
3. Number of antennas, active in pairs or larger sets. One ZCU111 has 8 channels DAC, and 8 ADC. Likely static array of 8 antennas.

### System Design

1. FPGA for THz freq. handling of the antenna I/O and timing calibration. Timing calibration being the signals deltas between the n-set antenna arrays used to induce an effect at a specific voxel.
2. GPU for the machine learning based parameterization of the FPGAs real-time control system.
3. CPU for basic system management.
4. Rings of antenna arrays large enough to surround a human. Likely a very precise linear actuator that can move one or more of such rings.
    * precise linear actuators: https://www.nanoactuators.com/nano-actuator.php

### Notes

#### Xilinx ZCU111
This kit features a Zynq UltraScale+ RFSoC supporting 8 12-bit 4.096GSPS ADCs, 8 14-bit 6.554GSPS DACs.

May need the XM500 Balun board for proper physical I/O ports.

This part doesn't appear to be available as a PCIe board. Look for similar parts, also see Xilinx's new DFE subsystem. Not sure if that is helpful or not.

Similar Boards in a PCIe Form Factor:
1. BittWare RFX-8440 Data Acquisition Card
    * Xilinx XCZU43 in an E1156 package
    * 4x DACs 10 Gsps
    * 4x ADCs 5 Gsps
    * 8 lanes of PCIe Gen4
    * FPGA <-> GPU comms to bypass system memory and CPU: ref: https://link.springer.com/article/10.1007/s10586-013-0280-9
    * https://www.bittware.com/fpga/
2. ADM-XRC-9R1 (8I, 8O)
    * https://www.alpha-data.com/products/fpga-cards/
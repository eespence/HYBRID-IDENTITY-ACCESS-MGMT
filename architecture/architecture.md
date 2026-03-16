# Network Architecture - IAM/PAM Lab

## Network Topology

![IAM/PAM Lab Network Architecture](network-diagram-proxmox-3000series.png)

*Figure 1: Complete network architecture showing Proxmox host, network bridges (vmbr0, vmbrPAM, vmbrNAT), and all lab VMs including ID-SYNC01 (VM 3999) with the hybrid identity connectivity model.*

---

## Architecture Overview

This environment simulates a small enterprise hybrid identity deployment integrating on-premises Active Directory with Microsoft Entra ID while enforcing privileged access segmentation and secure network boundaries.

---

## Physical Network

* **Subnet:** 192.168.8.0/24
* **Proxmox Host:** 192.168.8.100
* **Gateway / Router:** 192.168.8.1

---

## Proxmox Virtual Networking (Bridges)

* **vmbr0** – WAN uplink / external connectivity

  * 192.168.8.0/24
  * Used for Proxmox management and outbound NAT traffic

* **vmbrNAT** – Internet access network (NAT Masquerade)

  * 192.168.100.0/24
  * Provides controlled outbound internet access for selected VMs

* **vmbrPAM** – Isolated IAM/PAM internal network

  * 172.31.100.0/24
  * Dedicated to identity, authentication, and privileged traffic

---

## Security Zones

### Isolated Systems (No Internet Access)

These systems are connected **only to vmbrPAM** and have no outbound NAT route.

* **DC01** (172.31.100.10)
  Domain Controller / DNS / Kerberos KDC

* **CLIENT01** (172.31.100.30)
  Domain-joined user workstation

* **LINUX01** (172.31.100.40)
  Privileged Linux target system

---

### Dual-Homed Systems (Internal + NAT Internet Access)

These systems connect to:

* **vmbrPAM** for internal identity and management traffic

* **vmbrNAT** for controlled outbound internet access

* **MGMT01** (172.31.100.20)
  Management / Jump Server

* **PAM01** (172.31.100.50)
  Privileged Access Management Platform

* **SIEM01** (172.31.100.60)
  Logging / Monitoring Server

* **ID-SYNC01 (VM 3999)** (172.31.100.25)
  Microsoft Entra Connect Sync Server (Hybrid Identity Bridge)

---

## Network Flow

### 1. Internal Identity & Management Traffic

All east-west internal communication occurs over:

```
172.31.100.0/24 (vmbrPAM)
```

This includes:

* Kerberos
* LDAP / LDAPS
* DNS
* PAM session brokering
* SIEM log forwarding

---

### 2. Controlled Outbound Internet Access

Dual-homed systems use the following path for internet connectivity:

```
vmbrPAM → vmbrNAT → NAT Masquerade → vmbr0 → Internet
```

Only systems that require updates, integrations, or cloud communication are granted NAT access.

---

### 3. Hybrid Identity Synchronization (Critical Trust Boundary)

**ID-SYNC01 (VM 3999)** performs directory synchronization:

* **ID-SYNC01 → DC01**

  * LDAP (389)
  * LDAPS (636)
  * Kerberos (88)

* **ID-SYNC01 → Microsoft Entra ID**

  * HTTPS (443 outbound only)

This design ensures:

* On-prem AD remains the authoritative identity source
* Cloud sync is controlled and monitored
* Domain Controllers are never directly internet exposed

---

## Security Design Principles

* **Network Segmentation**
  Identity infrastructure is separated from internet-facing services.

* **Least Exposure**
  Domain controllers and endpoints have zero direct internet access.

* **Explicit Identity Bridge**
  ID-SYNC01 is intentionally dual-homed to act as the controlled trust boundary between on-prem AD and cloud identity.

* **NAT Masquerading**
  Internal IP space is never directly exposed externally.

* **Defense-in-Depth**
  Isolation, privilege boundaries, and role separation reduce blast radius in the event of compromise.

---

**Document Owner:** Edward E. Spence
**Environment:** Fairmont Manufacturing Identity Security Lab
**Document Type:** Network Architecture Runbook
**Last Reviewed:** February 2026

 
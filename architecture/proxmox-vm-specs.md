← [Back to Main README](../README.md)

![Proxmox](https://img.shields.io/badge/Proxmox-E57000?style=flat&logo=proxmox&logoColor=white)
![Windows Server](https://img.shields.io/badge/Windows_Server_2022-0078D4?style=flat&logo=windows&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu_22.04-E95420?style=flat&logo=ubuntu&logoColor=white)

# Virtual Infrastructure Asset Register
## Fairmont Manufacturing Identity Security Lab
### Proxmox Virtual Machine Specifications

**Status:** Complete  
**Operational State:** Active Lab Environment  
**Last Reviewed:** February 2026  

This document serves as the configuration and ownership register for systems participating in the Fairmont Manufacturing Identity Security Lab.

---

## Resource Allocation Summary

| VM ID | Name | vCPU | RAM (GB) | Disk (GB) | OS | Storage | Status |
|------|------|------|------|------|------|------|------|
| 3000 | DC01 | 2 | 4 | 60 | Windows Server 2022 | local-lvm | ✅ |
| 3001 | MGMT01 | 2 | 6 | 80 | Windows Server 2022 | local-lvm | ✅ |
| 3002 | CLIENT01 | 2 | 4 | 60 | Windows 11 Pro | local-lvm | ✅ |
| 3003 | LINUX01 | 2 | 4 | 40 | Ubuntu 22.04 LTS | local-lvm | ✅ |
| 3004 | PAM01 | 4 | 8 | 80 | Ubuntu 22.04 LTS | local-lvm | ✅ |
| 3005 | SIEM01 | 4 | 8 | 100 | Ubuntu 22.04 LTS | local-lvm | ✅ |
| 3999 | ID-SYNC01 | 2 | 4 | 60 | Windows Server 2022 | local-lvm | ✅ |

**Total Resources:** 18 vCPU, 38 GB RAM, 480 GB Storage  

---

## Identity Role Classification

| System | Identity Function | Security Role |
|-------|------------------|--------------|
| DC01 | Active Directory Domain Controller | Authentication Authority |
| MGMT01 | Administrative workstation | Privileged Access Entry Point |
| CLIENT01 | Standard user endpoint | User Authentication Source |
| LINUX01 | Linux server | Privileged Access Target |
| PAM01 | Privileged Access Platform | Credential Vault and Session Broker |
| SIEM01 | Logging and monitoring | Audit and Compliance System |
| ID-SYNC01 | Entra Connect synchronization server | Identity Synchronization Authority |

---

## Detailed VM Configuration

### VM 3000 — DC01 (Domain Controller)

| Setting | Value |
|--------|------|
| VM ID | 3000 |
| Hostname | DC01 |
| OS | Windows Server 2022 |
| vCPU | 2 |
| RAM | 4 GB |
| Disk | 60 GB (SCSI, local-lvm) |
| Network | vmbrPAM (172.31.100.10/24) |
| BIOS | OVMF (UEFI) |
| Guest Agent | ✅ Installed |
| Status | ✅ Running |

---

### VM 3001 — MGMT01 (Management Server)

| Setting | Value |
|--------|------|
| VM ID | 3001 |
| Hostname | MGMT01 |
| OS | Windows Server 2022 |
| vCPU | 2 |
| RAM | 6 GB |
| Disk | 80 GB (SCSI, local-lvm) |
| Network 1 | vmbrPAM (172.31.100.20/24) |
| Network 2 | vmbrNAT (DHCP) |
| BIOS | OVMF (UEFI) |
| Guest Agent | ✅ Installed |
| Status | ✅ Running |

---

### VM 3002 — CLIENT01 (User Workstation)

| Setting | Value |
|--------|------|
| VM ID | 3002 |
| Hostname | CLIENT01 |
| OS | Windows 11 Pro |
| vCPU | 2 |
| RAM | 4 GB |
| Disk | 60 GB (SCSI, local-lvm) |
| Network | vmbrPAM (172.31.100.30/24) |
| BIOS | OVMF (UEFI) |
| TPM | ✅ 2.0 (Required for Windows 11) |
| Guest Agent | ✅ Installed |
| Status | ✅ Running |

---

### VM 3003 — LINUX01 (Privileged Linux Target)

| Setting | Value |
|--------|------|
| VM ID | 3003 |
| Hostname | LINUX01 |
| OS | Ubuntu 22.04 |
| vCPU | 2 |
| RAM | 4 GB |
| Disk | 40 GB (SCSI, local-lvm) |
| Network | vmbrPAM (172.31.100.40/24) |
| BIOS | SeaBIOS |
| SSH | ✅ Enabled |
| Guest Agent | ✅ Installed |
| Status | ✅ Running |

---

### VM 3004 — PAM01 (PAM Platform)

| Setting | Value |
|--------|------|
| VM ID | 3004 |
| Hostname | PAM01 |
| OS | Ubuntu 22.04 |
| vCPU | 4 |
| RAM | 8 GB |
| Disk | 80 GB (SCSI, local-lvm) |
| Network 1 | vmbrPAM (172.31.100.50/24) |
| Network 2 | vmbrNAT (DHCP) |
| BIOS | SeaBIOS |
| SSH | ✅ Enabled |
| Guest Agent | ✅ Installed |
| Status | ✅ Running |

---

### VM 3005 — SIEM01 (SIEM Server)

| Setting | Value |
|--------|------|
| VM ID | 3005 |
| Hostname | SIEM01 |
| OS | Ubuntu 22.04 |
| vCPU | 4 |
| RAM | 8 GB |
| Disk | 100 GB (SCSI, local-lvm) |
| Network 1 | vmbrPAM (172.31.100.60/24) |
| Network 2 | vmbrNAT (DHCP) |
| BIOS | SeaBIOS |
| SSH | ✅ Enabled |
| Guest Agent | ✅ Installed |
| Status | ✅ Running |

---

### VM 3999 — ID-SYNC01 (Identity Sync Server)

| Setting | Value |
|--------|------|
| VM ID | 3999 |
| Hostname | ID-SYNC01 |
| OS | Windows Server 2022 |
| vCPU | 2 |
| RAM | 4 GB |
| Disk | 60 GB (SCSI, local-lvm) |
| Network 1 | vmbrPAM (172.31.100.50/24) |
| Network 2 | vmbrNAT (DHCP) |
| BIOS | OVMF (UEFI) |
| Guest Agent | ✅ Installed |
| Role | Entra Connect / Identity Sync |
| Status | ✅ Running |

---

## Network Configuration

| VM | Primary Network | Secondary Network | Internet |
|----|----------------|------------------|----------|
| DC01 | vmbrPAM | N/A | No |
| MGMT01 | vmbrPAM | vmbrNAT | Yes |
| CLIENT01 | vmbrPAM | N/A | No |
| LINUX01 | vmbrPAM | N/A | No |
| PAM01 | vmbrPAM | vmbrNAT | Yes |
| SIEM01 | vmbrPAM | vmbrNAT | Yes |
| ID-SYNC01 | vmbrPAM | vmbrNAT | Yes |

---

## Engineering Notes

- All systems follow **segmented network design**
- Identity infrastructure isolated on **vmbrPAM**
- Internet access controlled via **vmbrNAT**
- Management systems are **dual-homed**
- Windows systems leverage **UEFI (OVMF)** for modern compatibility
- Linux systems use **SeaBIOS for lightweight deployment**
- QEMU Guest Agent enabled for automation, snapshots, and control
- CLIENT01 configured with **TPM 2.0 for Windows 11 compliance**

---

**Document Owner:** Edward E. Spence  
**Environment:** Fairmont Manufacturing Identity Security Lab  
**Type:** Infrastructure Asset Register  
**Status:** Production-Ready  

---

**E.E. Spence — Identity Engineering | IAMPAM.LAB**
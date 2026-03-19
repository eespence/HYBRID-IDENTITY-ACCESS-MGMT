← [Back to Main README](../README.md)

---

![Proxmox](https://img.shields.io/badge/Proxmox-E57000?style=flat\&logo=proxmox\&logoColor=white)
![Windows Server](https://img.shields.io/badge/Windows_Server_2022-0078D4?style=flat\&logo=windows\&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu_22.04-E95420?style=flat\&logo=ubuntu\&logoColor=white)

---

# Identity Infrastructure Addressing Plan

**Status:** ✅ Active | **Last Reviewed:** February 2026

This document defines the network addressing, VM inventory, snapshot register, and security design rationale for the IAMPAM.LAB environment.

---

## Network Summary

| Network          | Subnet           | Gateway       | Purpose          | Type       |
| ---------------- | ---------------- | ------------- | ---------------- | ---------- |
| Physical (vmbr0) | 192.168.8.0/24   | 192.168.8.1   | WAN connection   | Existing   |
| vmbrPAM          | 172.31.100.0/24  | 172.31.100.1  | IAM/PAM isolated | Configured |
| vmbrNAT          | 192.168.100.0/24 | 192.168.100.1 | NAT for internet | Configured |

---

## VM Inventory (VM ID 3000-3005 Series + 3999)

| VM ID | Hostname  | Role                                | IP (vmbrPAM)  | IP (vmbrNAT) | Internet | Status    |
| ----- | --------- | ----------------------------------- | ------------- | ------------ | -------- | --------- |
| 3000  | DC01      | Domain Controller                   | 172.31.100.10 | N/A          | ❌ No     | ✅ Running |
| 3001  | MGMT01    | Management Server                   | 172.31.100.20 | DHCP         | ✅ Yes    | ✅ Running |
| 3002  | CLIENT01  | User Workstation                    | 172.31.100.30 | N/A          | ❌ No     | ✅ Running |
| 3003  | LINUX01   | Privileged Target                   | 172.31.100.40 | N/A          | ❌ No     | ✅ Running |
| 3004  | PAM01     | PAM Platform                        | 172.31.100.50 | DHCP         | ✅ Yes    | ✅ Running |
| 3005  | SIEM01    | Logging/SIEM                        | 172.31.100.60 | DHCP         | ✅ Yes    | ✅ Running |
| 3999  | ID-SYNC01 | Microsoft Entra Connect Sync Server | 172.31.100.25 | DHCP         | ✅ Yes    | ✅ Running |

---

## Snapshots Status

| VM ID | Hostname  | Snapshot Name               | Date       | Status     | Description                                                                                                       |
| ----- | --------- | --------------------------- | ---------- | ---------- | ----------------------------------------------------------------------------------------------------------------- |
| 3000  | DC01      | BASELINE-DC01-20260211      | 2026-02-11 | ✅ Complete | Windows Server 2022: Baseline system state prior to directory services deployment                                 |
| 3001  | MGMT01    | BASELINE-MGMT01-20260211    | 2026-02-11 | ✅ Complete | Windows Server 2022: Operational configuration validated, dual-homed management host ready for domain integration |
| 3002  | CLIENT01  | BASELINE-CLIENT01-20260211  | 2026-02-11 | ✅ Complete | Windows 11 Pro: Baseline system state prior to domain enrollment                                                  |
| 3003  | LINUX01   | BASELINE-LINUX01-20260211   | 2026-02-11 | ✅ Complete | Ubuntu Server: Baseline system state prior to privileged access controls                                          |
| 3004  | PAM01     | BASELINE-PAM01-20260211     | 2026-02-11 | ✅ Complete | Ubuntu Server: Operational configuration validated, privileged access platform staging state                      |
| 3005  | SIEM01    | BASELINE-SIEM01-20260211    | 2026-02-11 | ✅ Complete | Ubuntu Server: Operational configuration validated, logging infrastructure staging state                          |
| 3999  | ID-SYNC01 | BASELINE-ID-SYNC01-20260211 | 2026-02-11 | ✅ Complete | Windows Server 2022: Hybrid identity synchronization server staged prior to Entra Connect configuration           |

---

## IP Address Details

### vmbrPAM Network (172.31.100.0/24)

| IP                | Hostname  | Role                                |
| ----------------- | --------- | ----------------------------------- |
| 172.31.100.1      | Gateway   | vmbrPAM bridge gateway              |
| 172.31.100.10     | DC01      | Domain Controller                   |
| 172.31.100.20     | MGMT01    | Management Server                   |
| 172.31.100.30     | CLIENT01  | User Workstation                    |
| 172.31.100.40     | LINUX01   | Privileged Linux Target             |
| 172.31.100.50     | PAM01     | PAM Platform                        |
| 172.31.100.60     | SIEM01    | Logging/SIEM Server                 |
| 172.31.100.25     | ID-SYNC01 | Microsoft Entra Connect Sync Server |
| 172.31.100.71-254 | Reserved  | Future expansion                    |

---

### vmbrNAT Network (192.168.100.0/24)

| IP Range           | Purpose                                   |
| ------------------ | ----------------------------------------- |
| 192.168.100.1      | Gateway (vmbrNAT bridge)                  |
| 192.168.100.2-50   | DHCP for MGMT01, PAM01, SIEM01, ID-SYNC01 |
| 192.168.100.51-254 | Reserved                                  |

---

## Security Notes

1. **Domain Controller Isolation**: DC01 has NO internet access to prevent external attacks
2. **Management Segmentation**: MGMT01 is dual-homed to manage internal systems and download updates
3. **PAM Vault Security**: PAM01 is dual-homed to access privileged systems and external API integrations
4. **SIEM Connectivity**: SIEM01 needs internet for threat intelligence feeds and log forwarding
5. **Hybrid Identity Boundary**: ID-SYNC01 is the only system authorized to communicate with both internal AD and external Microsoft Entra ID services

---

**Document Owner:** Edward E. Spence
**Environment:** Fairmont Manufacturing Identity Security Lab
**Document Type:** Addressing & Snapshot Allocation Register
**Operational State:** ✅ Active Lab Environment
**Last Reviewed:** February 2026

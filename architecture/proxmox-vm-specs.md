# Virtual Infrastructure Asset Register
## Fairmont Manufacturing Identity Security Lab
### Proxmox Virtual Machine Specifications

This document serves as the configuration and ownership register for systems participating in the Fairmont Manufacturing Identity Security Lab.

This register tracks systems participating in authentication, authorization, privileged access management, and security auditing workflows within the simulated enterprise environment.

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

**Total Resources:** 16 vCPU, 34 GB RAM, 420 GB Storage

---

## Identity Role Classification

| System | Identity Function | Security Role |
|-------|-------|-------|
| DC01 | Active Directory Domain Controller | Authentication Authority |
| MGMT01 | Administrative workstation | Privileged Access Entry Point |
| CLIENT01 | Standard user endpoint | User Authentication Source |
| LINUX01 | Linux server | Privileged Access Target |
| PAM01 | Privileged Access Platform | Credential Vault and Session Broker |
| SIEM01 | Logging and monitoring | Audit and Compliance System |

---

## Detailed VM Configuration

### VM 3000 - DC01 (Domain Controller)

| Setting | Value |
|---------|-------|
| VM ID | 3000 |
| Hostname | DC01 |
| OS | Windows Server 2022 Standard (Desktop Experience) |
| vCPU | 2 cores |
| RAM | 4 GB |
| Disk | 60 GB (SCSI, local-lvm) |
| Network | vmbrPAM (172.31.100.10/24) |
| BIOS | OVMF (UEFI) |
| Guest Agent | ✅ Installed |
| Firewall | Disabled during build phase (enabled during security hardening stage) |
| Status | ✅ Running |

---

### VM 3001 - MGMT01 (Management Server)

| Setting | Value |
|---------|-------|
| VM ID | 3001 |
| Hostname | MGMT01 |
| OS | Windows Server 2022 Standard (Desktop Experience) |
| vCPU | 2 cores |
| RAM | 6 GB |
| Disk | 80 GB (SCSI, local-lvm) |
| Network 1 | vmbrPAM (172.31.100.20/24) - Primary |
| Network 2 | vmbrNAT (DHCP) - Internet |
| BIOS | OVMF (UEFI) |
| Guest Agent | ✅ Installed |
| Firewall | Disabled during build phase (enabled during security hardening stage) |
| Status | ✅ Running |

---

### VM 3002 - CLIENT01 (User Workstation)

| Setting | Value |
|---------|-------|
| VM ID | 3002 |
| Hostname | CLIENT01 |
| OS | Windows 11 Pro |
| vCPU | 2 cores |
| RAM | 4 GB |
| Disk | 60 GB (SCSI, local-lvm) |
| Network | vmbrPAM (172.31.100.30/24) |
| BIOS | OVMF (UEFI) |
| TPM | ✅ 2.0 (Required for Windows 11) |
| Guest Agent | ✅ Installed |
| Firewall | Disabled during build phase (enabled during security hardening stage) |
| Status | ✅ Running |

---

### VM 3003 - LINUX01 (Privileged Linux Target)

| Setting | Value |
|---------|-------|
| VM ID | 3003 |
| Hostname | linux01 |
| OS | Ubuntu 22.04 LTS Server |
| vCPU | 2 cores |
| RAM | 4 GB |
| Disk | 40 GB (SCSI, local-lvm) |
| Network | vmbrPAM (172.31.100.40/24) |
| BIOS | SeaBIOS |
| SSH | ✅ Enabled |
| Guest Agent | ✅ Installed |
| Status | ✅ Running |

---

### VM 3004 - PAM01 (PAM Platform)

| Setting | Value |
|---------|-------|
| VM ID | 3004 |
| Hostname | pam01 |
| OS | Ubuntu 22.04 LTS Server |
| vCPU | 4 cores |
| RAM | 8 GB |
| Disk | 80 GB (SCSI, local-lvm) |
| Network 1 | vmbrPAM (172.31.100.50/24) - Primary |
| Network 2 | vmbrNAT (DHCP) - Internet |
| BIOS | SeaBIOS |
| SSH | ✅ Enabled |
| Guest Agent | ✅ Installed |
| Status | ✅ Running |

---

### VM 3005 - SIEM01 (Logging/SIEM Server)

| Setting | Value |
|---------|-------|
| VM ID | 3005 |
| Hostname | siem01 |
| OS | Ubuntu 22.04 LTS Server |
| vCPU | 4 cores |
| RAM | 8 GB |
| Disk | 100 GB (SCSI, local-lvm) |
| Network 1 | vmbrPAM (172.31.100.60/24) - Primary |
| Network 2 | vmbrNAT (DHCP) - Internet |
| BIOS | SeaBIOS |
| SSH | ✅ Enabled |
| Guest Agent | ✅ Installed |
| Status | ✅ Running |

---


## Network Configuration

| VM ID | Name | NIC 0 (Primary) | NIC 1 (Secondary) | Internet |
|-------|------|-----------------|-------------------|----------|
| 3000 | DC01 | virtio → vmbrPAM | N/A | No |
| 3001 | MGMT01 | virtio → vmbrPAM | virtio → vmbrNAT | Yes |
| 3002 | CLIENT01 | virtio → vmbrPAM | N/A | No |
| 3003 | LINUX01 | virtio → vmbrPAM | N/A | No |
| 3004 | PAM01 | virtio → vmbrPAM | virtio → vmbrNAT | Yes |
| 3005 | SIEM01 | virtio → vmbrPAM | virtio → vmbrNAT | Yes |

---

## Guest Agent Status

All VMs have **QEMU Guest Agent** installed and enabled for:
- Graceful VM shutdown
- Snapshot consistency
- File transfer support
- Command execution

**Verification**:
```bash
# Windows
Get-Service QEMU-GA

# Linux
sudo systemctl status qemu-guest-agent
```
---


Document Owner: Edward E. Spence
Environment: Fairmont Manufacturing Identity Security Lab
Document Type: Virtual Infrastructure Asset Register
Operational State: Active Lab Environment
Last Reviewed: February 2026
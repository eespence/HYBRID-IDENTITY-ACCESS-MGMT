# Module 01: Infrastructure & Network Architecture

**Module**: 01 - Infrastructure & Network Architecture  
**VM Series**: 3000-3005  
**Status**: ✅ **COMPLETE**  
**Built by**: Edward E. Spence  
**Date**: February 2026  
**Purpose**: Enterprise-style IAM/PAM lab environment demonstrating enterprise architecture, security operations, and identity governance best practices

---

## 📋 Module Overview

This module establishes a dedicated, isolated IAM/PAM network environment on Proxmox VE that supports enterprise-grade identity operations.

### What You've Built ✅

- ✅ Dedicated network `172.31.100.0/24` on vmbrPAM
- ✅ NAT network `192.168.100.0/24` on vmbrNAT
- ✅ 6 virtual machines (VM IDs 3000-3005)
- ✅ Network isolation and security design
- ✅ Professional infrastructure documentation
- ✅ Baseline snapshots on all VMs
- ✅ Connectivity validation across all systems
- ✅ Screenshot evidence captured

---

## 🖥️ Your Proxmox Environment

**Host**: 192.168.8.100  
**Storage**: local-zfs  

**ISOs Used**:
- SERVER_EVAL_x64FRE_en-us.iso (Windows Server 2022)
- Win11_23H2_English_x64v2.iso (Windows 11)
- ubuntu-22.04.5-live-server-amd64.iso (Ubuntu 22.04)

---

## Network Architecture

| Network | Subnet | Gateway | Connected Systems | Purpose |
|--------|-------|-------|-------|-------|
| vmbrPAM | 172.31.100.0/24 | 172.31.100.1 | DC01, MGMT01, CLIENT01, LINUX01, PAM01, SIEM01 | Isolated IAM/PAM network |
| vmbrNAT | 192.168.100.0/24 | 192.168.100.1 | MGMT01, PAM01, SIEM01 | Internet access via NAT |
| vmbr0 | 192.168.8.0/24 | 192.168.8.1 | Proxmox Host (192.168.8.100) | Physical network |

### System Inventory

| VM ID | Hostname | Network (vmbrPAM) | Network (vmbrNAT) | OS | Status |
|------|------|------|------|------|------|
| 3000 | DC01 | 172.31.100.10 | N/A | Windows Server 2022 | ✅ |
| 3001 | MGMT01 | 172.31.100.20 | DHCP | Windows Server 2022 | ✅ |
| 3002 | CLIENT01 | 172.31.100.30 | N/A | Windows 11 Pro | ✅ |
| 3003 | LINUX01 | 172.31.100.40 | N/A | Ubuntu 22.04 LTS | ✅ |
| 3004 | PAM01 | 172.31.100.50 | DHCP | Ubuntu 22.04 LTS | ✅ |
| 3005 | SIEM01 | 172.31.100.60 | DHCP | Ubuntu 22.04 LTS | ✅ |

---

## 📚 Reference Documentation

For detailed information, see:

- **Network Details**: `architecture/network-config.md`
- **Full Architecture**: `architecture/ARCHITECTURE.md`
- **IP Allocation**: `architecture/IP-ALLOCATION.md`
- **VM Specifications**: `architecture/PROXMOX-VM-SPECS.md`

---

## ✅ Module 01 Completion Checklist

### Network Configuration ✅ **COMPLETE**
- [x] vmbrPAM created (172.31.100.1/24)
- [x] vmbrNAT created (192.168.100.1/24)
- [x] IP forwarding enabled
- [x] NAT masquerading configured
- [x] iptables rules saved
- [x] Network bridges verified

### VM Provisioning ✅ **COMPLETE**
- [x] VMs 3000-3005 created with disks
- [x] ISOs attached to all VMs
- [x] OS installations completed (all 6 VMs)
- [x] Network configuration on all VMs
- [x] Guest agents installed/verified

### Snapshots ✅ **COMPLETE**
- [x] BASELINE-DC01-20260211 - Windows Server 2022, vmbrPAM only
- [x] BASELINE-MGMT01-20260211 - Windows Server 2022, dual-NIC
- [x] BASELINE-CLIENT01-20260211 - Windows 11 Pro, vmbrPAM only
- [x] BASELINE-LINUX01-20260211 - Ubuntu 22.04 LTS, vmbrPAM only
- [x] BASELINE-PAM01-20260211 - Ubuntu 22.04 LTS, dual-NIC
- [x] BASELINE-SIEM01-20260211 - Ubuntu 22.04 LTS, dual-NIC

### Testing & Validation ✅ **COMPLETE**
- [x] All VMs ping each other on vmbrPAM
- [x] MGMT01/PAM01/SIEM01 reach internet via NAT
- [x] DC01/CLIENT01/LINUX01 isolated (no internet)
- [x] Connectivity tests passed on all 6 VMs
- [x] Network configuration validated

### Documentation ✅ **COMPLETE**
- [x] README.md created
- [x] network-config.md created
- [x] ARCHITECTURE.md created
- [x] IP-ALLOCATION.md created
- [x] PROXMOX-VM-SPECS.md created
- [x] 01-infrastructure.md created
- [x] Screenshots captured (baseline, network-config, connectivity)
- [x] Network diagram saved
- [x] Baseline snapshots documented

---

## 📸 Evidence & Documentation

### **Baseline Snapshots**
All 6 VMs have baseline snapshots with:
- Proper naming: `BASELINE-{VM}-20260211`
- Professional descriptions
- Full OS installation validated

### **Network Configuration Screenshots**
Captured from each VM showing:
- Static IP assignments (vmbrPAM)
- Network adapter configuration
- Gateway and DNS settings

### **Connectivity Validation**
Direct console login on each VM with:
- Ping tests to other VMs on vmbrPAM
- Gateway connectivity verification
- Internet access tests (for dual-homed systems)

---

## 📊 VM Inventory - Final Status

| VM ID | Hostname | OS | vCPU | RAM | Status | Snapshot |
|------|------|------|------|------|------|------|
| 3000 | DC01 | Windows Server 2022 | 2 | 4 GB | ✅ Ready | BASELINE-DC01-20260211 |
| 3001 | MGMT01 | Windows Server 2022 | 2 | 6 GB | ✅ Ready | BASELINE-MGMT01-20260211 |
| 3002 | CLIENT01 | Windows 11 Pro | 2 | 4 GB | ✅ Ready | BASELINE-CLIENT01-20260211 |
| 3003 | LINUX01 | Ubuntu 22.04 LTS | 2 | 4 GB | ✅ Ready | BASELINE-LINUX01-20260211 |
| 3004 | PAM01 | Ubuntu 22.04 LTS | 4 | 8 GB | ✅ Ready | BASELINE-PAM01-20260211 |
| 3005 | SIEM01 | Ubuntu 22.04 LTS | 4 | 8 GB | ✅ Ready | BASELINE-SIEM01-20260211 |

---

## 🎓 What You've Mastered

✅ **Proxmox virtualization** - VM provisioning, storage, networking  
✅ **Network segmentation** - Isolated security zones with NAT  
✅ **Dual-homing strategy** - Internet access with network isolation  
✅ **Manual infrastructure provisioning and configuration** using Proxmox and operating system tools  
✅ **Enterprise design** - Defense-in-depth, security best practices  
✅ **Professional documentation** - Architecture as code  
✅ **Hands-on validation** - Direct system testing and evidence capture  
✅ **Snapshot management** - Baseline preservation and naming conventions  

---

## 🚀 Ready for Module 02

**Foundation infrastructure is operational and validated.**

All systems are:
- ✅ Built and tested
- ✅ Networked and validated
- ✅ Documented professionally
- ✅ Snapshotted for recovery
- ✅ Ready for identity services

---

## 📝 Module 01 Summary

| Aspect | Status | Evidence |
|------|------|------|
| Network Design | ✅ Complete | architecture/ARCHITECTURE.md |
| VM Provisioning | ✅ Complete | 6 VMs running, all snapshots created |
| OS Installation | ✅ Complete | Mixed Windows/Linux, all functional |
| Network Config | ✅ Complete | Screenshots captured, validated |
| Connectivity | ✅ Complete | Ping tests, internet access verified |
| Documentation | ✅ Complete | 5 markdown files + screenshots |
| Snapshots | ✅ Complete | All 6 VMs with baseline snapshots |

---

## 🎯 Next Phase: Module 02 - Active Directory

**Ready to begin:**
- Installing Active Directory Domain Services on DC01
- Creating IAMPAM.LAB domain
- Domain joining MGMT01 and CLIENT01
- Creating test users and organizational units

---

**Module 01 Status**: ✅ **COMPLETE**

**Built by**: Edward E. Spence  
**Completion Date**: February 13, 2026  
**Duration**: 2 days  
**Platform**: Proxmox VE  
**VM Series**: 3000-3005  
**Storage**: local-zfs

---

Foundation infrastructure is operational, validated, and documented.  
The platform provides a stable network and compute environment for deployment of Active Directory and subsequent identity services.


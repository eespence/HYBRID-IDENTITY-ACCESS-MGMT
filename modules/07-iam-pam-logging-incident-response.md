# Module 07: IAM & PAM Logging / Incident Response

**Module**: 07 - IAM & PAM Logging / Incident Response
**Status**: ✅ COMPLETE (Identity Monitoring & Incident Detection Validated)
**Built by**: Edward E. Spence
**Completed**: March 2026
**Purpose**: Implement centralized identity monitoring and incident detection within the hybrid identity architecture using Splunk Enterprise, enabling visibility into authentication events, privileged access activity, and cross-platform identity telemetry.

---

## Overview

Module 07 introduces **centralized identity monitoring and incident detection** within the hybrid identity architecture.

Previous modules established the foundation of the identity platform:

• Active Directory authentication infrastructure
• Hybrid identity synchronization with Microsoft Entra ID
• Identity governance controls
• Privileged access management and administrative workstation enforcement

With these controls in place, the next phase focuses on **visibility and detection**.

Identity systems generate critical security telemetry during authentication and privileged access operations. Monitoring this activity allows administrators to detect:

• abnormal authentication behavior
• failed login attempts
• privileged account activity
• group membership changes
• elevated command execution on Linux systems

In this module, authentication telemetry from Windows and Linux systems is centralized using **Splunk Enterprise**.

This allows the identity platform to detect suspicious activity and investigate potential identity-related security incidents.

---

# Architecture Context

The logging architecture integrates directly with the existing **IAMPAM.LAB identity network**.

```
Identity Systems
        ↓
Splunk Universal Forwarders
        ↓
TCP 9997
        ↓
SIEM01 — Splunk Enterprise
```

Forwarders installed on identity infrastructure systems transmit authentication logs to the central monitoring server.

---

## Systems Providing Identity Telemetry

| System    | Role                       | Identity Signals Collected                      |
| --------- | -------------------------- | ----------------------------------------------- |
| DC01      | Domain Controller          | Authentication events, group membership changes |
| MGMT01    | Administrative Workstation | Privileged logins                               |
| CLIENT01  | Domain Workstation         | User authentication activity                    |
| ID-SYNC01 | Entra Connect Server       | Administrative access activity                  |
| LINUX01   | Privileged Linux Server    | sudo usage and authentication logs              |

---

## Identity Monitoring Objectives

The monitoring platform provides visibility into:

• Windows authentication events
• privileged administrative logins
• failed login attempts
• privileged group membership changes
• Linux privileged command execution
• centralized identity telemetry across the environment

This telemetry allows administrators to investigate potential identity abuse.

---

# Implementation

## Step 1 — Splunk Enterprise Installation

The logging platform was deployed on **SIEM01**.

Splunk Enterprise was installed and initialized to serve as the centralized log aggregation system.

The Splunk Web interface was made available on port **8000**.

### Evidence

![Splunk Installation](../screenshots/module-07/module7_01_splunk_install.png)

### Control Demonstrated

Centralized Identity Logging Platform

---

## Step 2 — Splunk Log Receiver Configuration

Splunk was configured to receive forwarded log data from identity infrastructure systems.

The **Splunk Forwarding Receiver** was enabled on:

```
TCP 9997
```

### Evidence

![Receiving Port 9997](../screenshots/module-07/module7_02_receiving_port_9997.png)

### Control Demonstrated

Secure Log Ingestion Channel

---

## Step 3 — Identity Log Index Creation

Dedicated indexes were created to separate authentication telemetry.

```
wineventlog
syslog
```

This separation improves log organization and simplifies investigation.

### Evidence

![Splunk Index Creation](../screenshots/module-07/module7_03_index_creation.png)

### Control Demonstrated

Structured Identity Telemetry Storage

---

## Step 4 — Forwarder Deployment Staging

Splunk Universal Forwarder packages were staged on **MGMT01**, which serves as the administrative staging host.

The staging directory was created:

```
C:\Software\Splunk
```

This location stores installation packages for Windows and Linux forwarders.

### Evidence

![Splunk Forwarder Staging](../screenshots/module-07/module7_04_mgmt01_splunk_staging.png)

### Control Demonstrated

Controlled Software Distribution

---

## Step 5 — Windows Forwarder Deployment

Splunk Universal Forwarder was deployed to Windows systems:

```
DC01
CLIENT01
MGMT01
ID-SYNC01
```

The forwarder collects Windows Event Logs including:

• Security
• System
• Application

These logs contain authentication and administrative activity.

### Evidence

![Windows Forwarder Installation](../screenshots/module-07/module7_05_forwarder_install_windows.png)

### Control Demonstrated

Windows Authentication Telemetry Collection

---

## Step 6 — Linux Forwarder Deployment

A Splunk Universal Forwarder was installed on **LINUX01** to collect authentication activity from the Linux system.

The forwarder monitors:

```
/var/log/auth.log
```

These logs capture:

• sudo commands
• SSH authentication
• session creation and termination

### Evidence

![Linux Forwarder Configuration](../screenshots/module-07/module7_06_linux_forwarder_configured_and_connected.png)

### Control Demonstrated

Cross-Platform Identity Monitoring

---

## Step 7 — SIEM Host Visibility Verification

After forwarders were deployed, Splunk queries confirmed that all identity infrastructure systems were reporting telemetry.

Example search:

```
index=* earliest=-30m
| stats count by host
| sort -count
```

This confirms active log ingestion from all monitored systems.

### Evidence

![Splunk Host Visibility](../screenshots/module-07/module7_07_splunk_host_visibility.png)

### Control Demonstrated

Centralized Identity Telemetry Visibility

---

## Step 8 — Windows Authentication Event Monitoring

Authentication activity was verified by querying Windows event logs.

Relevant security events include:

| Event ID | Description      |
| -------- | ---------------- |
| 4624     | Successful login |
| 4625     | Failed login     |
| 4672     | Privileged login |

Example search:

```
index=wineventlog earliest=-30m (EventCode=4624 OR EventCode=4625 OR EventCode=4672)
| table _time host EventCode user Message
```

### Evidence

![Windows Identity Events](../screenshots/module-07/module7_08_windows_identity_events.png)

### Control Demonstrated

Windows Authentication Monitoring

---

## Step 9 — Linux Authentication Monitoring

Authentication activity on Linux systems was verified using logs forwarded from **LINUX01**.

Example query:

```
index=syslog host=linux01
| table _time host source _raw
```

These logs include:

• SSH login activity
• sudo command execution
• session start and termination

### Evidence

![Linux Authentication Logs](../screenshots/module-07/module7_09_linux_authentication_logs.png)

### Control Demonstrated

Linux Privileged Activity Monitoring

---

# Engineering Notes & Lessons Learned

During deployment several operational issues were encountered and resolved.

These engineering observations reflect real-world identity monitoring challenges.

### Windows vs Linux Forwarder Initialization

Windows forwarders were installed using MSI silent installation.

Linux forwarders required manual creation of the **initial Splunk administrator account** during first startup.

This behavior differs between operating systems and must be accounted for in automated deployments.

---

### Configuration Files Not Automatically Created

Several Splunk configuration files did not exist by default on the forwarders.

The following files were manually created:

```
inputs.conf
outputs.conf
```

These files define:

• log sources to monitor
• destination SIEM servers

---

### PowerShell Path Execution Behavior

Commands referencing paths under **Program Files** must be executed using:

```
& "path\to\executable"
```

Without this syntax PowerShell may misinterpret commands.

---

### Network Prerequisites for Remote Deployment

Remote software installation required several network services to be available:

• SMB (TCP 445)
• WinRM / PowerShell Remoting
• Splunk forwarding port (9997)

Firewall rules had to be enabled before remote deployment could succeed.

---

### Forwarder Verification Methods

Several techniques were used to validate correct forwarder operation:

Windows:

```
Get-Service SplunkForwarder
splunk.exe list forward-server
```

Linux:

```
splunk status
splunk list forward-server
```

These commands confirm:

• forwarder service state
• connection to the SIEM indexer

---

# Security Controls Demonstrated

This module introduced identity monitoring controls across the environment.

* Authentication activity monitoring
* Failed login detection
* Privileged login monitoring
* Linux sudo activity monitoring
* Centralized identity telemetry
* Cross-platform authentication visibility
* SIEM-based investigation capability

These controls provide operational visibility into identity activity across the enterprise environment.

---

# Summary

Module 07 establishes **identity monitoring and incident investigation capabilities** within the hybrid identity platform.

Authentication telemetry from Windows and Linux systems is centralized in Splunk Enterprise, allowing administrators to monitor login activity, detect privileged access usage, and investigate suspicious authentication behavior.

With centralized logging in place, the identity platform now supports **operational detection and investigation of identity-related security events**.

This completes the monitoring layer required for a mature identity security architecture.

---

# Next Module

Module 08 will introduce **identity automation and policy enforcement**, focusing on operational automation of identity management workflows.

---

**Built by**: Edward E. Spence
**Environment**: IAMPAM.LAB
**Systems**: DC01, MGMT01, CLIENT01, ID-SYNC01, LINUX01, SIEM01
**Platform**: Proxmox VE | Active Directory | Microsoft Entra ID | Splunk Enterprise


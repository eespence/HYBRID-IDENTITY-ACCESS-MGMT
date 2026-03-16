# Module 08: Identity Automation & Policy Enforcement

**Module**: 08 - Identity Automation & Policy Enforcement
**Status**: ✅ COMPLETE (Identity Automation & Policy Enforcement Validated)
**Built by**: Edward E. Spence
**Completed**: March 2026
**Purpose**: Implement automated identity monitoring and enforcement within the hybrid identity architecture using Splunk scheduled detections, enabling automated detection of suspicious authentication behavior and alert generation across Windows and Linux identity systems.

---

## Overview

Module 08 introduces **automated identity monitoring and enforcement** within the IAMPAM.LAB environment using Splunk scheduled detections.

Previous modules established the foundation of the identity platform:

• Active Directory authentication authority
• Hybrid identity federation
• Privileged access management controls
• Centralized log ingestion using Splunk

With centralized identity telemetry already available, this module introduces the **automation layer** of the identity monitoring architecture.

The objective of this module is to demonstrate how security operations teams detect authentication anomalies and automate response workflows using SIEM detection rules.

This capability allows the identity platform to automatically identify:

• repeated failed login attempts
• suspicious authentication sequences
• privileged account activity
• Linux privilege escalation events

---

# Architecture Context

The detection platform operates within the existing **IAMPAM.LAB identity monitoring architecture**.

```
Windows / Linux Hosts
        ↓
Splunk Universal Forwarder
        ↓
TCP 9997
        ↓
SIEM01 — Splunk Enterprise
        ↓
Scheduled Detection Searches
        ↓
Automated Alerts
```

Authentication telemetry generated across the environment is forwarded to the SIEM where automated searches evaluate activity patterns.

---

## Systems Providing Identity Telemetry

| System    | Role                       |
| --------- | -------------------------- |
| DC01      | Domain Controller          |
| MGMT01    | Administrative Workstation |
| CLIENT01  | Domain Workstation         |
| LINUX01   | Privileged Linux Server    |
| ID-SYNC01 | Entra Connect Server       |
| SIEM01    | Splunk Enterprise          |

Network segment:

```
172.31.100.0/24
```

---

## Identity Automation Objectives

The automation layer enables the environment to automatically detect:

• repeated failed authentication attempts
• suspicious login patterns
• privileged logon activity
• Linux privilege escalation events
• abnormal identity behavior across the environment

These automated detections simulate real-world SOC monitoring workflows.

---

# Implementation

## Step 1 — Windows Log Ingestion Validation

The first step verifies that Windows authentication logs are successfully ingested into Splunk.

Query used:

```
index=wineventlog host IN ("DC01","CLIENT01","MGMT01","ID-SYNC01") earliest=-24h
| stats latest(_time) as LastSeen count as EventCount by host
| convert ctime(LastSeen)
| sort host
```

This query confirms that all Windows systems are forwarding identity telemetry.

### Evidence

![Index Validation](../screenshots/module-08/module8_01_index_validation.png)

### Control Demonstrated

Identity Telemetry Validation

---

## Step 2 — Failed Login Detection

Failed authentication events were generated using a non-privileged test account.

Example event:

```
Event ID 4625
```

Detection query:

```
index=wineventlog EventCode=4625 earliest=-24h
| stats count as FailedLogons by host Account_Name
| rename Account_Name as User
| sort - FailedLogons
```

This query identifies repeated authentication failures.

### Evidence

![Failed Login Detection](../screenshots/module-08/module8_02_failed_logins_detection.png)

### Control Demonstrated

Failed Authentication Monitoring

---

## Step 3 — Authentication Sequence Investigation

This scenario demonstrates investigation of failed authentication attempts followed by a successful login.

Observed pattern:

```
4625 → 4624
```

Investigation query:

```
index=wineventlog (EventCode=4625 OR EventCode=4624) earliest=-24h
| search Account_Name="testuser"
| table _time host Account_Name EventCode
| sort _time
```

This query enables analysts to identify suspicious login sequences.

### Evidence

![Authentication Sequence](../screenshots/module-08/module8_03_login_sequence_detection.png)

### Control Demonstrated

Authentication Sequence Investigation

---

## Step 4 — Privileged Logon Detection

Privileged account activity is monitored using Windows event:

```
Event ID 4672
```

Detection query:

```
index=wineventlog EventCode=4672 earliest=-24h
| eval User=lower(Account_Name)
| search User="admin.dc01"
| table _time host User EventCode
| sort - _time
```

This query validates that privileged logons are visible to the SIEM.

### Evidence

![Privileged Login Detection](../screenshots/module-08/module8_04_privileged_login_detection.png)

### Control Demonstrated

Privileged Authentication Monitoring

---

## Step 5 — Linux Privilege Escalation Monitoring

Privilege escalation on Linux systems was validated using a `sudo` command.

Command executed:

```
sudo whoami
```

Expected output:

```
root
```

Detection query:

```
index=syslog host=LINUX01 ("sudo:" OR "COMMAND=") earliest=-24h
| table _time host _raw
| sort - _time
```

This query confirms that privileged commands executed on Linux are captured by the SIEM.

### Evidence

![Linux Sudo Activity](../screenshots/module-08/module8_05_linux_sudo_activity.png)

### Control Demonstrated

Linux Privilege Escalation Monitoring

---

## Step 6 — Automated Detection Rule Creation

A Splunk scheduled detection rule was created to automatically detect repeated failed login attempts.

Detection rule logic:

```
More than two failed login attempts within five minutes.
```

Detection query:

```
index=wineventlog EventCode=4625 earliest=-5m
| stats count as FailedLogons by Account_Name
| where FailedLogons > 2
| sort - FailedLogons
```

Alert configuration:

| Setting           | Value                 |
| ----------------- | --------------------- |
| Alert Type        | Scheduled             |
| Schedule          | Cron (*/5 * * * *)    |
| Time Range        | Last 15 minutes       |
| Trigger Condition | Number of Results > 0 |
| Trigger           | Once                  |

### Evidence

![Failed Login Alert Creation](../screenshots/module-08/module8_06_failed_login_alert_creation.png)

### Control Demonstrated

Automated Identity Threat Detection

---

## Step 7 — Alert Trigger Validation

The detection rule was validated by generating multiple failed authentication attempts.

Validation steps:

1. Multiple incorrect logins attempted on CLIENT01
2. Windows Event 4625 generated
3. Scheduled search executed
4. Alert triggered in Splunk

Triggered alerts appear under:

```
Activity → Triggered Alerts
```

### Evidence

![Alert Triggered](../screenshots/module-08/module8_07_failed_login_alert_triggered.png)

### Control Demonstrated

Automated Incident Detection

---

# Security Controls Demonstrated

This module introduced automated identity monitoring across the environment.

* Automated failed login detection
* Authentication sequence investigation
* Privileged login monitoring
* Linux privilege escalation monitoring
* SIEM alert automation
* Cross-platform identity monitoring

These controls simulate the identity detection capabilities used by modern security operations teams.

---

# Summary

Module 08 completes the **automation layer of identity monitoring** within the hybrid identity platform.

The SIEM now continuously evaluates authentication telemetry and automatically generates alerts when suspicious identity activity occurs.

This capability mirrors real-world security operations workflows used to detect credential abuse, brute-force authentication attempts, and privilege escalation events.

---

# Next Phase

With identity automation implemented, the IAMPAM.LAB environment now demonstrates a full enterprise identity security lifecycle including:

• identity infrastructure
• hybrid federation
• identity governance
• privileged access management
• identity monitoring
• automated detection and response

---

**Built by**: Edward E. Spence
**Environment**: IAMPAM.LAB
**Systems**: DC01, MGMT01, CLIENT01, ID-SYNC01, LINUX01, SIEM01
**Platform**: Proxmox VE | Active Directory | Microsoft Entra ID | Splunk Enterprise


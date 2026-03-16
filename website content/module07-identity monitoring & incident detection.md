# Module 07 — Identity Monitoring & Incident Detection (IAM / PAM Logging)

## Project Objective

Module 07 introduces **centralized identity monitoring** within the hybrid IAM/PAM environment.
After implementing identity governance and privileged access management in previous modules, the next critical capability is **visibility into authentication and administrative activity**.

This module demonstrates how enterprise environments monitor identity systems to detect:

* suspicious login activity
* privileged account usage
* failed authentication attempts
* administrative access behavior
* cross-platform identity activity (Windows and Linux)

To accomplish this, **Splunk Enterprise** was deployed as a centralized monitoring platform to collect authentication telemetry from identity infrastructure systems.

---

## Identity Monitoring Architecture

Authentication events from domain systems and privileged infrastructure are forwarded to a centralized SIEM platform.

```
Identity Infrastructure
        ↓
Splunk Universal Forwarders
        ↓
Secure Log Forwarding (TCP 9997)
        ↓
SIEM01 — Splunk Enterprise
```

This architecture allows authentication telemetry to be aggregated and analyzed from multiple systems across the environment.

---

## Systems Monitored

The monitoring platform collects identity signals from the following systems:

| System        | Role                       | Monitoring Focus                           |
| ------------- | -------------------------- | ------------------------------------------ |
| **DC01**      | Domain Controller          | Authentication events, privilege elevation |
| **MGMT01**    | Administrative Workstation | Administrative logins                      |
| **CLIENT01**  | Domain Workstation         | User authentication activity               |
| **ID-SYNC01** | Entra Connect Server       | Hybrid identity administrative access      |
| **LINUX01**   | Privileged Linux Server    | sudo usage and SSH authentication          |
| **SIEM01**    | Monitoring Platform        | Identity event aggregation                 |

This allows administrators to analyze authentication behavior across the entire identity infrastructure.

---

## Monitoring Capabilities Implemented

The platform provides visibility into key identity security signals including:

* Windows authentication events
* privileged login activity
* failed authentication attempts
* privileged account usage
* Linux sudo command execution
* SSH authentication activity
* centralized identity telemetry

These signals allow administrators to identify abnormal identity behavior and investigate potential security incidents.

---

## Example Identity Detection Queries

### Windows Authentication Monitoring

Authentication activity can be reviewed using Windows security events:

```
index=wineventlog earliest=-30m (EventCode=4624 OR EventCode=4625 OR EventCode=4672)
| table _time host EventCode user Message
```

Relevant events include:

| Event ID | Description               |
| -------- | ------------------------- |
| 4624     | Successful authentication |
| 4625     | Failed authentication     |
| 4672     | Privileged login          |

---

### Linux Authentication Monitoring

Linux authentication events are collected from `/var/log/auth.log`.

Example query:

```
index=syslog host=linux01
| table _time host source _raw
```

These logs capture:

* SSH login attempts
* sudo command execution
* session creation and termination

---

## Operational Validation

After forwarder deployment, Splunk confirmed that all identity infrastructure systems were successfully sending telemetry.

Example verification query:

```
index=* earliest=-30m
| stats count by host
| sort -count
```

This confirmed active event ingestion from:

* DC01
* MGMT01
* CLIENT01
* ID-SYNC01
* LINUX01

---

## Engineering Challenges Encountered

Several deployment challenges were encountered and resolved during implementation.

### Forwarder Initialization Differences

Windows forwarders installed silently via MSI, while Linux forwarders required manual initialization of the Splunk administrator account during first startup.

---

### Configuration File Creation

Some Splunk configuration files were not created automatically during installation.

The following files were manually created:

```
inputs.conf
outputs.conf
```

These files define monitored log sources and the destination SIEM indexer.

---

### PowerShell Path Execution Behavior

Commands executed from `Program Files` required PowerShell execution syntax:

```
& "path\to\executable"
```

Without this syntax PowerShell may not correctly interpret the command.

---

### Network Requirements for Forwarder Deployment

Forwarder deployment required several network services to be accessible:

* SMB (TCP 445)
* WinRM / PowerShell Remoting
* Splunk Forwarding Port (TCP 9997)

Firewall rules were updated to enable remote deployment.

---

## Security Controls Demonstrated

This module implements several important identity security monitoring controls:

* centralized authentication logging
* privileged access monitoring
* failed login detection
* cross-platform identity telemetry
* SIEM-based identity investigation capability

These controls provide visibility into identity activity across the enterprise environment.

---

## Outcome

At the completion of Module 07, the identity environment now includes a **centralized monitoring capability for authentication and privileged access activity**.

By aggregating authentication telemetry from Windows and Linux systems into Splunk Enterprise, the platform enables administrators to detect abnormal login behavior, review privileged access activity, and investigate identity-related security events.

This monitoring capability forms a critical layer of defense in enterprise IAM and PAM architectures.

---

**Environment:** IAMPAM.LAB
**Platform:** Proxmox VE | Active Directory | Microsoft Entra ID | Splunk Enterprise
**Systems:** DC01, MGMT01, CLIENT01, ID-SYNC01, LINUX01, SIEM01
**Author:** Edward E. Spence


# Module 08 — Identity Automation & Policy Enforcement

## Project Objective

Module 08 introduces **automated identity monitoring and policy enforcement** within the hybrid IAM/PAM environment.

After implementing centralized identity monitoring in Module 07, the next step is enabling the platform to **automatically detect suspicious authentication behavior and generate alerts** without requiring manual investigation.

This module demonstrates how enterprise security operations teams automate identity monitoring to detect:

* repeated authentication failures
* suspicious login sequences
* privileged account activity
* Linux privilege escalation events
* abnormal authentication patterns across identity infrastructure

To accomplish this, **Splunk scheduled detection searches** were implemented to continuously evaluate authentication telemetry collected from the identity environment.

---

## Identity Automation Architecture

Authentication telemetry generated across Windows and Linux systems is forwarded to the SIEM where automated searches analyze event patterns.

```
Identity Infrastructure
        ↓
Splunk Universal Forwarders
        ↓
Secure Log Forwarding (TCP 9997)
        ↓
SIEM01 — Splunk Enterprise
        ↓
Scheduled Detection Searches
        ↓
Automated Security Alerts
```

This architecture enables the environment to automatically detect abnormal identity behavior across multiple systems.

---

## Systems Participating in Automated Monitoring

Automated detection rules analyze authentication telemetry from the following systems:

| System        | Role                       | Detection Focus                             |
| ------------- | -------------------------- | ------------------------------------------- |
| **DC01**      | Domain Controller          | Authentication events and privileged logons |
| **MGMT01**    | Administrative Workstation | Administrative login activity               |
| **CLIENT01**  | Domain Workstation         | User authentication behavior                |
| **ID-SYNC01** | Entra Connect Server       | Hybrid identity administrative access       |
| **LINUX01**   | Privileged Linux Server    | sudo usage and privilege escalation         |
| **SIEM01**    | Splunk Enterprise          | Identity telemetry analysis and alerting    |

This ensures that identity activity across the entire infrastructure is continuously evaluated.

---

## Automated Identity Monitoring Capabilities

The detection rules implemented in this module provide automated monitoring for:

* repeated failed authentication attempts
* authentication sequences indicating password guessing
* privileged account logon activity
* Linux privilege escalation using sudo
* abnormal authentication patterns across monitored systems

These capabilities simulate the automated identity detection mechanisms used by modern security operations centers.

---

## Detection Scenario 1 — Windows Log Ingestion Validation

Before enabling automated detection rules, it was necessary to confirm that authentication telemetry was successfully reaching the SIEM.

Example validation query:

```
index=wineventlog host IN ("DC01","CLIENT01","MGMT01","ID-SYNC01") earliest=-24h
| stats latest(_time) as LastSeen count as EventCount by host
| convert ctime(LastSeen)
| sort host
```

This query confirms that Windows systems are actively forwarding authentication events to the monitoring platform.

---

## Detection Scenario 2 — Failed Login Monitoring

A detection rule was implemented to identify repeated failed authentication attempts.

Example query:

```
index=wineventlog EventCode=4625 earliest=-24h
| stats count as FailedLogons by host Account_Name
| rename Account_Name as User
| sort - FailedLogons
```

Relevant Windows authentication events include:

| Event ID | Description               |
| -------- | ------------------------- |
| 4624     | Successful authentication |
| 4625     | Failed authentication     |
| 4672     | Privileged logon          |

Monitoring repeated failures allows administrators to detect potential brute-force login attempts.

---

## Detection Scenario 3 — Authentication Sequence Investigation

A common indicator of suspicious behavior is a series of failed logins followed by a successful authentication.

Observed sequence:

```
4625 → 4624
```

Example investigation query:

```
index=wineventlog (EventCode=4625 OR EventCode=4624) earliest=-24h
| search Account_Name="testuser"
| table _time host Account_Name EventCode
| sort _time
```

This detection pattern allows analysts to identify potential password guessing or credential abuse attempts.

---

## Detection Scenario 4 — Privileged Logon Detection

Privileged account activity is monitored using Windows event:

```
Event ID 4672
```

Example detection query:

```
index=wineventlog EventCode=4672 earliest=-24h
| eval User=lower(Account_Name)
| search User="admin.dc01"
| table _time host User EventCode
| sort - _time
```

Monitoring privileged authentication events helps identify when administrative identities are used within the environment.

---

## Detection Scenario 5 — Linux Privilege Escalation Monitoring

Privileged command execution on Linux systems was validated using a sudo command.

Command executed:

```
sudo whoami
```

Example detection query:

```
index=syslog host=LINUX01 ("sudo:" OR "COMMAND=") earliest=-24h
| table _time host _raw
| sort - _time
```

These logs confirm when administrative commands are executed through the sudo privilege escalation mechanism.

---

## Automated Detection Rule Implementation

A scheduled detection rule was created in Splunk to automatically identify repeated failed login attempts.

Detection rule logic:

```
More than two failed login attempts within five minutes
```

Example detection query:

```
index=wineventlog EventCode=4625 earliest=-5m
| stats count as FailedLogons by Account_Name
| where FailedLogons > 2
| sort - FailedLogons
```

Alert configuration included:

| Setting           | Value                 |
| ----------------- | --------------------- |
| Alert Type        | Scheduled             |
| Schedule          | Every 5 minutes       |
| Time Range        | Last 15 minutes       |
| Trigger Condition | Number of Results > 0 |
| Trigger           | Once                  |

When triggered, the alert indicates potential brute-force authentication behavior.

---

## Alert Validation

To validate the detection rule, multiple failed login attempts were intentionally generated on **CLIENT01**.

The validation process involved:

1. Generating multiple incorrect login attempts
2. Triggering Windows authentication failures (Event 4625)
3. Running the scheduled detection search
4. Confirming alert generation in Splunk

Triggered alerts appear under:

```
Activity → Triggered Alerts
```

This confirms that the SIEM can automatically detect suspicious authentication behavior.

---

## Security Controls Demonstrated

Module 08 introduces automated identity monitoring capabilities including:

* automated failed login detection
* authentication sequence analysis
* privileged login monitoring
* Linux privilege escalation monitoring
* SIEM-based automated alert generation
* cross-platform identity activity monitoring

These controls simulate the automated detection capabilities used in enterprise security operations environments.

---

## Outcome

At the completion of Module 08, the identity environment now supports **automated detection of abnormal authentication behavior across Windows and Linux systems**.

By combining centralized identity telemetry from Module 07 with automated detection rules, the platform can continuously monitor authentication activity and generate alerts when suspicious patterns are observed.

This automation capability represents the final layer of the identity security architecture, enabling proactive detection of credential abuse, brute-force authentication attempts, and privilege escalation activity.

---

**Environment:** IAMPAM.LAB
**Platform:** Proxmox VE | Active Directory | Microsoft Entra ID | Splunk Enterprise
**Systems:** DC01, MGMT01, CLIENT01, ID-SYNC01, LINUX01, SIEM01
**Author:** Edward E. Spence


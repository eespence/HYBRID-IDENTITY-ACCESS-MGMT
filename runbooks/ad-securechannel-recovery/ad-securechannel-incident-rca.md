← [Back to Main README](../README.md)

---

![Active Directory](https://img.shields.io/badge/Active_Directory-0078D4?style=flat\&logo=microsoft\&logoColor=white)
![Kerberos](https://img.shields.io/badge/Kerberos-Authentication-blue?style=flat)
![Windows Server](https://img.shields.io/badge/Windows_Server_2022-0078D4?style=flat\&logo=windows\&logoColor=white)

---

# Active Directory Authentication Incident Report & Root Cause Analysis

**Environment:** IAMPAM.LAB
**Primary System:** DC01 (Domain Controller)
**Affected Systems:** MGMT01, CLIENT01
**Severity:** SEV-1 Authentication Outage
**Status:** Resolved

---

## 1. Summary

A domain authentication failure occurred when attempting to sign in to domain-joined systems using domain credentials.
Users were unable to log in because a domain controller was not consistently available to process authentication requests.

Investigation revealed the domain controller (DC01) was shutting down approximately 15–20 minutes after startup. When the domain controller became unavailable, domain logins failed because no authentication provider was reachable.

During troubleshooting of the domain controller configuration, an additional issue was discovered: the Windows Time Service was synchronizing using the Local CMOS Clock rather than a reliable upstream time source.

Although not the initial trigger of the outage, this condition would have resulted in Kerberos authentication failures even while the domain controller remained online. The time hierarchy was corrected and the workstation secure channel was repaired to ensure reliable authentication.

---

## 2. User Impact

* Domain users could not log into MGMT01 or CLIENT01
* Remote Desktop authentication failed
* Domain resources were inaccessible
* Administrative access to systems was interrupted

This simulated a domain authentication outage condition.

---

## 3. Initial Observation

When attempting login from a domain workstation, authentication failed with a trust relationship error.

### Observed Authentication Failure

![Secure Channel Failure](./screenshots/01_securechannel_fail.png)

*File: `./screenshots/01_securechannel_fail.png`*

The workstation reported it could not establish a secure trust relationship with the domain.

---

## 4. Investigation

The workstation itself was functional and accessible via the local administrator account, indicating the operating system was not the source of the issue.

Attention shifted to the domain controller as the authentication provider.

### FSMO Role Verification

![FSMO Roles](./screenshots/02_fsmo_roles.png)

*File: `./screenshots/02_fsmo_roles.png`*

FSMO roles were reviewed to identify the PDC Emulator, which provides the domain time authority.

---

## 5. Key Discovery

While examining the domain controller configuration, the Windows Time Service was checked.

### Incorrect Time Source Discovered

![Local CMOS Clock](./screenshots/03_cmos_clock.png)

*File: `./screenshots/03_cmos_clock.png`*

DC01 was synchronizing time using the Local CMOS Clock instead of the network NTP provider.

Kerberos authentication requires synchronized time across domain members.
If time differs beyond tolerance, Kerberos ticket validation fails.

---

## 6. Contributing Condition

The lab environment is intentionally isolated from direct internet access. The domain controller (DC01) therefore had no reachable external Network Time Protocol (NTP) source.

Because no upstream time provider was available, Windows Time Service defaulted to Local CMOS Clock. While the system remained powered on, this configuration can appear functional, but in virtualized environments clock drift occurs and violates Kerberos timestamp tolerance.

This condition was not the immediate trigger of the outage but represented a latent authentication failure condition. Even if DC01 remained online, Kerberos authentication would eventually fail due to time skew between domain members and the domain controller.

---

## 7. Resolution

To restore a reliable Kerberos time hierarchy while maintaining network isolation, an internal time authority was implemented.

MGMT01 was configured as an internal NTP relay server because it is dual-homed:
• Connected to the isolated domain network (vmbrPAM)
• Connected to an external network via NAT (vmbrNAT)

The resulting Active Directory time hierarchy:

External NTP → MGMT01 → DC01 (PDC Emulator) → Domain Members

Actions performed:

1. Disabled virtualization time provider on domain systems
2. Configured MGMT01 to synchronize with external NTP servers
3. Enabled NTP server functionality on MGMT01
4. Allowed UDP 123 through MGMT01 firewall
5. Configured DC01 to use MGMT01 as its time source
6. Forced time resynchronization
7. Verified Kerberos ticket issuance
8. Verified secure channel restoration

---

## 8. Validation

Post-remediation validation confirmed that authentication services were fully restored and stable.

Validation steps included:

* Successful domain logins from CLIENT01 and MGMT01
* Verified Kerberos ticket issuance using `klist`
* Confirmed DC01 time synchronization with MGMT01
* Verified no further trust relationship errors
* Confirmed stable uptime of domain controller

---

## 9. Root Cause

The authentication outage occurred when the domain controller became unavailable, preventing authentication processing.

During investigation, a critical configuration flaw was discovered: the PDC Emulator was operating without a reliable upstream time source and was synchronizing from the Local CMOS Clock.

Active Directory Kerberos authentication depends on synchronized time across all domain systems. Because the PDC Emulator is the domain time authority, any time drift propagates to all domain members.

The absence of a proper time hierarchy created a latent authentication failure condition that would have resulted in persistent Kerberos authentication failures.

The issue was therefore both:
• A domain controller availability outage
• An incorrect Active Directory time hierarchy configuration

---

## 10. Lessons Learned

* Active Directory authentication depends on domain controller availability
* Kerberos authentication requires accurate time synchronization
* The PDC Emulator functions as the domain time authority
* Trust relationship errors may indicate authentication infrastructure problems rather than credential issues
* Investigating infrastructure dependencies can reveal hidden risks

---

## 11. Preventative Actions

* Ensure the PDC Emulator synchronizes from a designated internal time authority
* Periodically verify domain controller time configuration
* Maintain an authentication recovery runbook
* Document infrastructure dependencies for authentication services

---

**Maintained by:** Edward E. Spence
**Lab:** Fairmont Manufacturing Identity Security Lab
**Document Type:** Incident Report / Root Cause Analysis
**Last Reviewed:** February 2026

---

**E.E. Spence — Identity Engineering | IAMPAM.LAB**

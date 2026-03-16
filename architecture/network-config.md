# Identity Infrastructure Network Configuration Runbook

---

## Network Bridges

| Bridge  | IP Address        | Function                           | NAT         | Operational State |
| ------- | ----------------- | ---------------------------------- | ----------- | ----------------- |
| vmbr0   | 192.168.xx.xxx/xx | External network connectivity      | N/A         | Active            |
| vmbrPAM | 172.31.100.1/24   | Isolated identity services network | No          | Active            |
| vmbrNAT | 192.168.100.1/24  | Management and update network      | Yes → vmbr0 | Active            |

---

## Routing and NAT Configuration

### Enable IP Forwarding

File: `/etc/sysctl.conf`

```
net.ipv4.ip_forward=1
```

Apply configuration:

```bash
sysctl -p
```

### NAT Masquerade Rule

```bash
iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o vmbr0 -j MASQUERADE
```

---

## Operational Verification

### Verify IP Forwarding

```bash
cat /proc/sys/net/ipv4/ip_forward
```

Expected output:

```
1
```

### Verify Bridge Interfaces

```bash
ip addr show vmbrPAM | grep inet
ip addr show vmbrNAT | grep inet
```

Expected:

```
vmbrPAM returns 172.31.100.1/24
vmbrNAT returns 192.168.100.1/24
```

### Verify NAT Rule

```bash
iptables -t nat -L POSTROUTING -n | grep MASQUERADE
```

Expected:

```
MASQUERADE  all  --  192.168.100.0/24  0.0.0.0/0
```

---

## Security Design Rationale

The network segmentation model separates identity services from external connectivity.

Domain controllers and user endpoints reside on an isolated identity network.

Management and monitoring systems are dual-homed to allow updates and log forwarding.

NAT prevents internal addressing from being exposed externally.

Only designated management systems can reach external resources.

This structure mirrors enterprise identity environments where authentication infrastructure is protected from direct internet exposure while administrative systems retain controlled external access.

---

Operations Owner: Edward E. Spence
Environment: Fairmont Manufacturing Identity Security Lab
Document Type: Network Configuration Runbook
Last Reviewed: February 2026


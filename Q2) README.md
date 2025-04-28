# Q2) Scenario Troubleshooting Internal Web Service Connectivity

This repository contains the troubleshooting steps, commands, and solutions for diagnosing and fixing issues with an internal web dashboard (`internal.example.com`) that became unreachable. This guide follows a systematic approach to identify DNS, network, and service-related issues and offers the necessary fixes to restore connectivity.

## **Problem Overview**

Your internal web dashboard, hosted on `internal.example.com`, became unreachable. While the service seems to be running, users encountered ```“host not found”``` errors. The root cause could be due to DNS misconfigurations, network issues, or service unavailability.

## **Solution Overview**

- a. **Verifying DNS resolution** using the system's configured DNS servers and comparing with Google's DNS ```(8.8.8.8)```.
- b. **Diagnosing the service reachability** on the resolved IP, checking the service’s status, and confirming that ports 80/443 are accessible.
- c. **Tracing the issue**, listing potential causes including DNS, network, and service issues.
- d. **Proposing and applying fixes** to address the identified issues.
- e. **Bonus**: Configuring a local `/etc/hosts` entry and persisting DNS settings using systemd-resolved or NetworkManager.

---

## **Troubleshooting Steps**

### 1. Verify DNS Resolution
To compare DNS resolution between local configuration and Google's DNS:

```bash
dig internal.example.com
```
or
```
nslookup internal.example.com
```
Then, compare with Google's DNS:
```
dig @8.8.8.8 internal.example.com
```
or
```
nslookup internal.example.com 8.8.8.8
```
### 2. Diagnose Service Reachability 
- Check if the web service is reachable:
```
curl -v http://internal.example.com
```
- Check if the web service is listening on port 80/443:
```
sudo netstat -tuln | grep ':80\|:443'
```
or
```
sudo ss -tuln | grep ':80\|:443'
```
- Test connectivity using telnet or nc:
```
telnet internal.example.com 80
```
or
```
nc -zv internal.example.com 80
```
### 3. Trace the Issue – List All Possible Causes

DNS	- Internal DNS server down
- Wrong DNS entry for ```internal.example.com```
- ```/etc/resolv.conf``` misconfigured

Network	- Firewall blocking port 80/443
- Routing issue between client and server

Service	- Web server not running
- Service not listening on the correct IP or port

System	- ```/etc/hosts``` file misconfigured (wrong mapping)

### 4. Apply Fixes
- Problem 1: Internal DNS Server is Misconfigured or Down
Confirm: Use ```dig``` or ```nslookup``` with the internal DNS server.

Fix: Restart the DNS service:
```
sudo systemctl restart named
```
- Problem 2: Wrong /etc/resolv.conf
Confirm: Check ```/etc/resolv.conf``` for incorrect DNS.

Fix: Edit ```/etc/resolv.conf```:
```
sudo nano /etc/resolv.conf
```
- Problem 3: Firewall Blocking Port 80/443
Confirm: Check iptables or firewall settings.

Fix: Allow ports 80 and 443:
```
sudo firewall-cmd --add-port=80/tcp --permanent
```
```
sudo firewall-cmd --add-port=443/tcp --permanent
```
```
sudo firewall-cmd --reload
```
- Problem 4: Web Service Not Running
Confirm: Check if the web service is running (nginx, apache).

Fix: Start or restart the service:
```
sudo systemctl start nginx
sudo systemctl enable nginx
```
### Bonus
Configure /etc/hosts to Bypass DNS
Add a manual entry for testing purposes:
```
sudo nano /etc/hosts
```
```
10.1.1.50 internal.example.com
```
Test:
```
ping internal.example.com
```
Persist DNS Settings
If using systemd-resolved:
Edit ```/etc/systemd/resolved.conf```:
```
sudo nano /etc/systemd/resolved.conf
```
Set DNS configuration:
```
DNS=<your-dns-ip>
FallbackDNS=8.8.8.8
Restart systemd-resolved:
```
```
sudo systemctl restart systemd-resolved
```
If using NetworkManager:
Modify connection settings:
```
nmcli connection modify <connection-name> ipv4.dns <dns-ip>
nmcli connection up <connection-name>
```

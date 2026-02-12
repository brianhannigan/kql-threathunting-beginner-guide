🔎 KQL Log Analysis & Threat Hunting – Complete Beginner to Practitioner Guide

A practical, end-to-end walkthrough of using Kusto Query Language (KQL) for enterprise log analysis and threat hunting in Microsoft environments (Sentinel, Defender, Log Analytics).

📚 Table of Contents

Why KQL Matters

What Logs Actually Are

How Logs Are Stored (Log Analytics Workspace)

Core Security Tables Explained

KQL Fundamentals

Investigation Workflow Framework

Full Threat Hunt Walkthrough (20 Flags)

Reusable Query Cheat Sheet

Using AI to Accelerate Threat Hunting

Final Lessons & Career Impact

🎯 Why KQL Matters

If you want to work in:

SOC (Security Operations Center)

Threat Hunting

Incident Response

Cloud Security (Azure)

Microsoft Defender / Sentinel environments

👉 KQL is near essential.

KQL is used to:

Investigate alerts

Perform threat hunts

Build dashboards

Create detections

Tune alerts

Analyze breaches

It is one of the biggest differentiators between:

L1 analyst

L2/L3 analyst

Security engineer

If you can think in KQL, you can think in:

SQL

SPL

Other SIEM query languages

🧾 What Logs Actually Are

Logs are:

📌 Digital records of activity on systems.

Examples of events that generate logs:

Logon success / failure

Process execution (PowerShell, cmd, certutil)

File creation / deletion

Network connections

Registry modifications

Scheduled task creation

Firewall activity

Think of logs as:

🎥 Security cameras for your IT environment — but in text form.

Without logs:

You cannot investigate.

You cannot prove compromise.

You cannot detect attacks.

🗄️ How Logs Are Stored (Log Analytics Workspace)

In enterprise environments:

Logs from:

Endpoints

Azure

Firewalls

Identity systems

Are forwarded to a central repository.

In Microsoft environments, that’s usually:

Log Analytics Workspace

Sometimes Azure Data Explorer

You can think of it like:

🧮 Millions of gigantic Excel spreadsheets (called tables).

But instead of 1 million rows…

You might have:

Millions

Hundreds of millions

Billions

Which is why:

You cannot manually “scroll logs.”

You must query them.

🗂️ Core Security Tables Explained

These are the most important tables for threat hunting:

🔐 DeviceLogonEvents

Used for:

RDP activity

Logon success/failure

Remote IP identification

Common fields:

AccountName

RemoteIP

ActionType

LogonType

🖥️ DeviceProcessEvents

Used for:

Command execution

PowerShell activity

LOLBins (certutil, bitsadmin, mstsc, schtasks)

Credential dumping tools

Common fields:

FileName

ProcessCommandLine

InitiatingProcessCommandLine

📁 DeviceFileEvents

Used for:

File creation

Folder creation

ZIP archive staging

Malware placement

Common fields:

FileName

FolderPath

ActionType

🌐 DeviceNetworkEvents

Used for:

Command & Control (C2)

Data exfiltration

Remote connections

Port identification

Common fields:

RemoteIP

RemotePort

RemoteUrl

InitiatingProcessFileName

🧩 DeviceRegistryEvents

Used for:

Defender exclusions

Persistence changes

Security configuration tampering

Common fields:

RegistryKey

RegistryValueName

RegistryValueData

🧠 KQL Fundamentals
1️⃣ Start Small (Never Dump Entire Table)
DeviceLogonEvents
| take 10

2️⃣ Filter with where
DeviceLogonEvents
| where DeviceName == "TARGET-VM"

3️⃣ Control Time

Last 24 hours:

| where TimeGenerated > ago(1d)


Specific range:

| where TimeGenerated between (datetime(2025-01-01) .. datetime(2025-01-02))

4️⃣ Reduce Columns with project
| project TimeGenerated, AccountName, RemoteIP, ActionType

5️⃣ Count / Summarize Activity
| summarize count() by RemoteIP


Rename count field:

| summarize LoginAttempts=count() by RemoteIP

6️⃣ Sort
| sort by TimeGenerated asc

7️⃣ Distinct Values
| distinct RegistryValueName

🔄 Investigation Workflow Framework

Every investigation follows this mental model:

Narrow to time window

Filter by device

Identify compromised account

Find suspicious commands

Identify persistence

Identify C2

Identify exfiltration

Identify anti-forensics

Identify lateral movement

This creates a timeline story.

🕵️ Full Threat Hunt Walkthrough (20 Flags)

Below is a complete end-to-end attack chain example.

🔥 Phase 1 — Initial Access
Flag 1 – RDP Source IP
DeviceLogonEvents
| where DeviceName == "TARGET-VM"
| where ActionType == "LogonSuccess"
| where isnotempty(RemoteIP)
| project TimeGenerated, AccountName, RemoteIP, RemoteIPType
| sort by TimeGenerated asc


Answer:

First public RemoteIP

Flag 2 – Compromised Account

From previous query:

| project AccountName

🔍 Phase 2 — Discovery
Flag 3 – Network Enumeration Command
DeviceProcessEvents
| where DeviceName == "TARGET-VM"
| where ProcessCommandLine has "arp"
| project TimeGenerated, ProcessCommandLine


Example found:

arp -a

🛡️ Phase 3 — Defense Evasion
Flag 4 – Malware Staging Directory
DeviceFileEvents
| where DeviceName == "TARGET-VM"
| project TimeGenerated, FolderPath, FileName
| sort by TimeGenerated asc


Look for suspicious directories like:

C:\ProgramData\WindowsCache\

Flag 5 – Defender Extension Exclusions
DeviceRegistryEvents
| where RegistryKey has "Exclusions"
| distinct RegistryValueName


Count them.

Flag 6 – Defender Folder Exclusion
DeviceRegistryEvents
| where RegistryKey has "Exclusions\\Paths"
| project RegistryValueName

Flag 7 – LOLBin Used to Download Malware
DeviceProcessEvents
| where ProcessCommandLine has "certutil"
| project ProcessCommandLine

♻️ Phase 4 — Persistence
Flag 8 – Scheduled Task Name
DeviceProcessEvents
| where FileName =~ "schtasks.exe"
| project ProcessCommandLine


Look for:

/TN "WindowsUpdateCheck"

Flag 9 – Scheduled Task Target

Find /TR parameter in command line.

🌐 Phase 5 — Command & Control
Flag 10 – C2 IP
DeviceNetworkEvents
| where DeviceName == "TARGET-VM"
| where InitiatingProcessFolderPath has "ProgramData"
| project RemoteIP, RemotePort

Flag 11 – C2 Port

Same query — check RemotePort.

🔓 Phase 6 — Credential Access
Flag 12 – Credential Dumping Tool
DeviceProcessEvents
| where ProcessCommandLine has "sekurlsa"
| project FileName, ProcessCommandLine


Often:

mm.exe (renamed mimikatz)

Flag 13 – Module Used

Look inside command line:

sekurlsa::logonpasswords

📦 Phase 7 — Collection & Exfiltration
Flag 14 – ZIP Archive
DeviceFileEvents
| where FileName endswith ".zip"
| project FileName, FolderPath

Flag 15 – Cloud Service Used
DeviceNetworkEvents
| where RemoteUrl has "discord"
| project RemoteUrl

🧹 Phase 8 — Anti-Forensics
Flag 16 – First Log Cleared
DeviceProcessEvents
| where ProcessCommandLine has "wevtutil"
| sort by TimeGenerated asc


Look for:

wevtutil cl security

👤 Phase 9 — Backdoor Account
Flag 17 – Hidden Admin User
DeviceProcessEvents
| where ProcessCommandLine has "net user"
| project ProcessCommandLine


Example:

net user support P@ssw0rd /add

📜 Phase 10 — Attack Script
Flag 18 – PowerShell Script
DeviceProcessEvents
| where ProcessCommandLine endswith ".ps1"
| project ProcessCommandLine

🔁 Phase 11 — Lateral Movement
Flag 19 – Target IP
DeviceProcessEvents
| where ProcessCommandLine has "mstsc"
| project ProcessCommandLine

Flag 20 – Remote Access Tool Used

Likely:

mstsc.exe

🧰 Reusable Query Cheat Sheet
Logons
DeviceLogonEvents
| where TimeGenerated > ago(7d)
| project TimeGenerated, AccountName, ActionType, RemoteIP

Processes
DeviceProcessEvents
| where TimeGenerated > ago(7d)
| project TimeGenerated, FileName, ProcessCommandLine

Files
DeviceFileEvents
| where TimeGenerated > ago(7d)
| project FileName, FolderPath

Network
DeviceNetworkEvents
| where TimeGenerated > ago(7d)
| project RemoteIP, RemotePort, RemoteUrl

🤖 Using AI to Accelerate Hunting

You can:

Export query results

Upload CSV to ChatGPT/Claude

Ask:

“Identify suspicious command usage”

“Find credential dumping indicators”

“Identify LOLBins”

“Explain this process chain”

⚠️ Always verify back in KQL.

AI is an assistant — not a replacement.

🚀 Final Lessons & Career Impact

By completing a hunt like this, you demonstrate:

Real log analysis capability

Multi-table pivoting skill

Attack chain understanding

MITRE ATT&CK alignment

Practical SOC-level investigation experience

This is resume-ready experience.

🎓 What You Should Now Be Able To Do

Filter massive log datasets

Identify suspicious IPs

Detect credential dumping

Identify persistence mechanisms

Track C2 activity

Detect exfiltration channels

Recognize anti-forensics

Pivot between tables

Use summarize intelligently

Explain an attack chain end-to-end

🏁 Closing

KQL is not about memorizing syntax.

It’s about learning to think:

“What evidence would this action leave behind — and in which table?”

Master that…

And you can hunt anything. 🔥

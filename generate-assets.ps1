# generate-assets.ps1
# Creates folder structure + generates SVG diagrams for the repo
# Run from repo root: powershell -ExecutionPolicy Bypass -File .\generate-assets.ps1

$ErrorActionPreference = "Stop"

function Ensure-Dir([string]$path) {
  if (-not (Test-Path -LiteralPath $path)) {
    New-Item -ItemType Directory -Path $path | Out-Null
  }
}

function Write-Utf8NoBom([string]$path, [string]$content) {
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
}

# --- Create folders ---
Ensure-Dir "docs"
Ensure-Dir "docs/diagrams"
Ensure-Dir "docs/images"
Ensure-Dir "assets"

# --- SVG: hero.svg ---
$heroSvg = @'
<svg xmlns="http://www.w3.org/2000/svg" width="1600" height="420" viewBox="0 0 1600 420" role="img" aria-label="KQL Threat Hunting — Beginner Guide">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#0B1220"/>
      <stop offset="1" stop-color="#0F1B33"/>
    </linearGradient>

    <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
      <path d="M40 0H0V40" fill="none" stroke="#9FB3C8" stroke-opacity="0.08" stroke-width="1"/>
    </pattern>

    <filter id="softGlow" x="-20%" y="-20%" width="140%" height="140%">
      <feGaussianBlur stdDeviation="6" result="b"/>
      <feColorMatrix in="b" type="matrix" values="
        1 0 0 0 0
        0 1 0 0 0
        0 0 1 0 0
        0 0 0 0.35 0" result="g"/>
      <feMerge>
        <feMergeNode in="g"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>

    <linearGradient id="pulseGrad" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0" stop-color="#67B8FF" stop-opacity="0"/>
      <stop offset="0.5" stop-color="#67B8FF" stop-opacity="0.9"/>
      <stop offset="1" stop-color="#67B8FF" stop-opacity="0"/>
    </linearGradient>

    <linearGradient id="accentGrad" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#67B8FF"/>
      <stop offset="1" stop-color="#8BE9A8"/>
    </linearGradient>

    <clipPath id="clip">
      <rect x="36" y="28" width="1528" height="364" rx="24"/>
    </clipPath>
  </defs>

  <!-- Card -->
  <rect x="24" y="20" width="1552" height="380" rx="28" fill="url(#bg)" stroke="#A8B7CC" stroke-opacity="0.12"/>

  <g clip-path="url(#clip)">
    <!-- Grid -->
    <rect x="36" y="28" width="1528" height="364" fill="url(#grid)"/>

    <!-- Subtle diagonal wash -->
    <path d="M-200 420 L900 -80 L1800 420 Z" fill="#67B8FF" opacity="0.06"/>

    <!-- Static guide rails -->
    <path d="M120 310 C420 220, 680 250, 980 170 C1180 120, 1340 110, 1520 150"
          fill="none" stroke="#67B8FF" stroke-opacity="0.18" stroke-width="2"/>
    <path d="M80 270 C380 180, 650 210, 960 130 C1140 85, 1330 80, 1540 120"
          fill="none" stroke="#8BE9A8" stroke-opacity="0.14" stroke-width="2"/>

    <!-- Animated pulse line -->
    <g filter="url(#softGlow)">
      <path id="pulsePath"
            d="M120 310 C420 220, 680 250, 980 170 C1180 120, 1340 110, 1520 150"
            fill="none" stroke="url(#pulseGrad)" stroke-width="6" stroke-linecap="round"
            stroke-dasharray="120 1400">
        <animate attributeName="stroke-dashoffset" from="0" to="-1520" dur="3.2s" repeatCount="indefinite"/>
      </path>
    </g>

    <!-- Left accent bar -->
    <rect x="70" y="80" width="6" height="260" rx="3" fill="url(#accentGrad)" opacity="0.9"/>

    <!-- Header text -->
    <text x="110" y="140" font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial"
          font-size="44" font-weight="800" fill="#EAF2FF">
      KQL Threat Hunting
    </text>
    <text x="110" y="178" font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial"
          font-size="22" font-weight="600" fill="#CFE0F7" opacity="0.95">
      Beginner Guide • Microsoft Sentinel / Defender XDR • Investigation-first workflow
    </text>

    <!-- Badge chips -->
    <g font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial" font-size="14" font-weight="700">
      <rect x="110" y="210" width="110" height="34" rx="17" fill="#111A2E" stroke="#A8B7CC" stroke-opacity="0.15"/>
      <text x="136" y="232" fill="#CFE0F7">KQL</text>

      <rect x="230" y="210" width="170" height="34" rx="17" fill="#111A2E" stroke="#A8B7CC" stroke-opacity="0.15"/>
      <text x="254" y="232" fill="#CFE0F7">Threat Hunting</text>

      <rect x="410" y="210" width="170" height="34" rx="17" fill="#111A2E" stroke="#A8B7CC" stroke-opacity="0.15"/>
      <text x="434" y="232" fill="#CFE0F7">MITRE ATT&amp;CK</text>

      <rect x="590" y="210" width="160" height="34" rx="17" fill="#111A2E" stroke="#A8B7CC" stroke-opacity="0.15"/>
      <text x="614" y="232" fill="#CFE0F7">Evidence Chain</text>
    </g>

    <!-- Right panel: minimal “telemetry” cards -->
    <g transform="translate(980 88)" font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial">
      <rect x="0" y="0" width="520" height="250" rx="18" fill="#0E1730" stroke="#A8B7CC" stroke-opacity="0.14"/>
      <text x="24" y="44" font-size="16" font-weight="800" fill="#EAF2FF">Telemetry → Hunt Pivots</text>
      <text x="24" y="72" font-size="13" font-weight="600" fill="#CFE0F7" opacity="0.9">
        DeviceLogonEvents • DeviceProcessEvents • DeviceNetworkEvents
      </text>

      <!-- tiny bars -->
      <g opacity="0.95">
        <rect x="24" y="100" width="180" height="10" rx="5" fill="#67B8FF" opacity="0.65"/>
        <rect x="24" y="122" width="320" height="10" rx="5" fill="#8BE9A8" opacity="0.55"/>
        <rect x="24" y="144" width="260" height="10" rx="5" fill="#67B8FF" opacity="0.45"/>
        <rect x="24" y="166" width="370" height="10" rx="5" fill="#8BE9A8" opacity="0.40"/>
      </g>

      <!-- mini timeline -->
      <g transform="translate(24 196)">
        <path d="M0 18H472" stroke="#CFE0F7" stroke-opacity="0.18" stroke-width="2" stroke-linecap="round"/>
        <circle cx="70" cy="18" r="6" fill="#67B8FF" opacity="0.9"/>
        <circle cx="190" cy="18" r="6" fill="#8BE9A8" opacity="0.85"/>
        <circle cx="320" cy="18" r="6" fill="#67B8FF" opacity="0.8"/>
        <circle cx="430" cy="18" r="6" fill="#8BE9A8" opacity="0.75"/>
        <circle cx="70" cy="18" r="12" fill="#67B8FF" opacity="0.16">
          <animate attributeName="r" values="10;16;10" dur="2.2s" repeatCount="indefinite"/>
          <animate attributeName="opacity" values="0.16;0.06;0.16" dur="2.2s" repeatCount="indefinite"/>
        </circle>
      </g>
    </g>
  </g>

  <!-- Footer hint -->
  <text x="52" y="404" font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial"
        font-size="12" fill="#AFC3DE" opacity="0.65">
    docs/diagrams/hero.svg
  </text>
</svg>
'@

# --- SVG: hunt-flow.svg ---
$huntFlowSvg = @'
<svg xmlns="http://www.w3.org/2000/svg" width="1600" height="520" viewBox="0 0 1600 520" role="img" aria-label="Hunting lifecycle flow">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#0B1220"/>
      <stop offset="1" stop-color="#0F1B33"/>
    </linearGradient>
    <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
      <path d="M40 0H0V40" fill="none" stroke="#9FB3C8" stroke-opacity="0.08" stroke-width="1"/>
    </pattern>
    <linearGradient id="accent" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0" stop-color="#67B8FF"/>
      <stop offset="1" stop-color="#8BE9A8"/>
    </linearGradient>
    <filter id="soft" x="-20%" y="-20%" width="140%" height="140%">
      <feGaussianBlur stdDeviation="4" result="b"/>
      <feMerge>
        <feMergeNode in="b"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
    <marker id="arrow" markerWidth="12" markerHeight="12" refX="10" refY="6" orient="auto">
      <path d="M0,0 L12,6 L0,12 Z" fill="#CFE0F7" opacity="0.45"/>
    </marker>
  </defs>

  <rect x="24" y="20" width="1552" height="480" rx="28" fill="url(#bg)" stroke="#A8B7CC" stroke-opacity="0.12"/>
  <rect x="36" y="32" width="1528" height="456" rx="22" fill="url(#grid)"/>

  <text x="60" y="86" font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial"
        font-size="28" font-weight="900" fill="#EAF2FF">Threat Hunting Lifecycle</text>
  <text x="60" y="116" font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial"
        font-size="14" font-weight="600" fill="#CFE0F7" opacity="0.9">
    Scope → Query → Pivot → Validate → Map to MITRE → Convert to Detection
  </text>

  <!-- Connector line -->
  <path d="M120 300 H1480" stroke="url(#accent)" stroke-width="6" stroke-linecap="round" opacity="0.18"/>

  <!-- Animated pulse -->
  <path d="M120 300 H1480" stroke="url(#accent)" stroke-width="6" stroke-linecap="round"
        stroke-dasharray="140 1400" filter="url(#soft)" opacity="0.9">
    <animate attributeName="stroke-dashoffset" from="0" to="-1480" dur="3.4s" repeatCount="indefinite"/>
    <animate attributeName="opacity" values="0.15;0.75;0.15" dur="3.4s" repeatCount="indefinite"/>
  </path>

  <!-- Nodes -->
  <g font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial">
    <!-- helper function via repeated groups -->
    <!-- 1 -->
    <g transform="translate(120 200)">
      <rect width="220" height="140" rx="18" fill="#0E1730" stroke="#A8B7CC" stroke-opacity="0.16"/>
      <rect x="18" y="18" width="48" height="48" rx="14" fill="#111A2E" stroke="#67B8FF" stroke-opacity="0.35"/>
      <text x="36" y="50" font-size="18" font-weight="900" fill="#67B8FF">1</text>
      <text x="18" y="92" font-size="16" font-weight="900" fill="#EAF2FF">Scope</text>
      <text x="18" y="116" font-size="13" font-weight="600" fill="#CFE0F7" opacity="0.9">
        Define hypothesis &amp; time window
      </text>
    </g>

    <!-- 2 -->
    <g transform="translate(390 200)">
      <rect width="220" height="140" rx="18" fill="#0E1730" stroke="#A8B7CC" stroke-opacity="0.16"/>
      <rect x="18" y="18" width="48" height="48" rx="14" fill="#111A2E" stroke="#67B8FF" stroke-opacity="0.35"/>
      <text x="36" y="50" font-size="18" font-weight="900" fill="#67B8FF">2</text>
      <text x="18" y="92" font-size="16" font-weight="900" fill="#EAF2FF">Query</text>
      <text x="18" y="116" font-size="13" font-weight="600" fill="#CFE0F7" opacity="0.9">
        Filter, project, summarize
      </text>
    </g>

    <!-- 3 -->
    <g transform="translate(660 200)">
      <rect width="220" height="140" rx="18" fill="#0E1730" stroke="#A8B7CC" stroke-opacity="0.16"/>
      <rect x="18" y="18" width="48" height="48" rx="14" fill="#111A2E" stroke="#8BE9A8" stroke-opacity="0.35"/>
      <text x="36" y="50" font-size="18" font-weight="900" fill="#8BE9A8">3</text>
      <text x="18" y="92" font-size="16" font-weight="900" fill="#EAF2FF">Pivot</text>
      <text x="18" y="116" font-size="13" font-weight="600" fill="#CFE0F7" opacity="0.9">
        Chain evidence across tables
      </text>
    </g>

    <!-- 4 -->
    <g transform="translate(930 200)">
      <rect width="220" height="140" rx="18" fill="#0E1730" stroke="#A8B7CC" stroke-opacity="0.16"/>
      <rect x="18" y="18" width="48" height="48" rx="14" fill="#111A2E" stroke="#8BE9A8" stroke-opacity="0.35"/>
      <text x="36" y="50" font-size="18" font-weight="900" fill="#8BE9A8">4</text>
      <text x="18" y="92" font-size="16" font-weight="900" fill="#EAF2FF">Validate</text>
      <text x="18" y="116" font-size="13" font-weight="600" fill="#CFE0F7" opacity="0.9">
        Reduce false positives
      </text>
    </g>

    <!-- 5 -->
    <g transform="translate(1200 200)">
      <rect width="280" height="140" rx="18" fill="#0E1730" stroke="#A8B7CC" stroke-opacity="0.16"/>
      <rect x="18" y="18" width="48" height="48" rx="14" fill="#111A2E" stroke="#67B8FF" stroke-opacity="0.35"/>
      <text x="36" y="50" font-size="18" font-weight="900" fill="#67B8FF">5</text>
      <text x="18" y="92" font-size="16" font-weight="900" fill="#EAF2FF">Operationalize</text>
      <text x="18" y="116" font-size="13" font-weight="600" fill="#CFE0F7" opacity="0.9">
        Map to ATT&amp;CK → analytics rule + tuning
      </text>
    </g>
  </g>

  <!-- subtle arrows -->
  <g opacity="0.55">
    <path d="M340 270 L390 270" stroke="#CFE0F7" stroke-width="2" marker-end="url(#arrow)"/>
    <path d="M610 270 L660 270" stroke="#CFE0F7" stroke-width="2" marker-end="url(#arrow)"/>
    <path d="M880 270 L930 270" stroke="#CFE0F7" stroke-width="2" marker-end="url(#arrow)"/>
    <path d="M1150 270 L1200 270" stroke="#CFE0F7" stroke-width="2" marker-end="url(#arrow)"/>
  </g>

  <text x="60" y="468" font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial"
        font-size="12" fill="#AFC3DE" opacity="0.65">docs/diagrams/hunt-flow.svg</text>
</svg>
'@

# --- SVG: data-sources.svg ---
$dataSourcesSvg = @'
<svg xmlns="http://www.w3.org/2000/svg" width="1600" height="560" viewBox="0 0 1600 560" role="img" aria-label="Data sources and tables map">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#0B1220"/>
      <stop offset="1" stop-color="#0F1B33"/>
    </linearGradient>
    <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
      <path d="M40 0H0V40" fill="none" stroke="#9FB3C8" stroke-opacity="0.08" stroke-width="1"/>
    </pattern>
    <linearGradient id="accent" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0" stop-color="#67B8FF"/>
      <stop offset="1" stop-color="#8BE9A8"/>
    </linearGradient>
  </defs>

  <rect x="24" y="20" width="1552" height="520" rx="28" fill="url(#bg)" stroke="#A8B7CC" stroke-opacity="0.12"/>
  <rect x="36" y="32" width="1528" height="496" rx="22" fill="url(#grid)"/>

  <text x="60" y="86" font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial"
        font-size="28" font-weight="900" fill="#EAF2FF">Microsoft Security Data Sources</text>
  <text x="60" y="116" font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial"
        font-size="14" font-weight="600" fill="#CFE0F7" opacity="0.9">
    Where the tables come from (Defender XDR / Log Analytics / Sentinel)
  </text>

  <!-- Left: sources -->
  <g font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial">
    <g transform="translate(80 160)">
      <rect width="420" height="140" rx="18" fill="#0E1730" stroke="#A8B7CC" stroke-opacity="0.16"/>
      <rect x="18" y="18" width="6" height="104" rx="3" fill="url(#accent)" opacity="0.9"/>
      <text x="40" y="54" font-size="18" font-weight="900" fill="#EAF2FF">Microsoft Defender XDR</text>
      <text x="40" y="82" font-size="13" font-weight="600" fill="#CFE0F7" opacity="0.9">Advanced Hunting / MDE telemetry</text>
      <text x="40" y="110" font-size="12" font-weight="600" fill="#AFC3DE" opacity="0.9">
        Device* tables (logon, process, network, file, registry)
      </text>
    </g>

    <g transform="translate(80 320)">
      <rect width="420" height="140" rx="18" fill="#0E1730" stroke="#A8B7CC" stroke-opacity="0.16"/>
      <rect x="18" y="18" width="6" height="104" rx="3" fill="url(#accent)" opacity="0.9"/>
      <text x="40" y="54" font-size="18" font-weight="900" fill="#EAF2FF">Log Analytics Workspace</text>
      <text x="40" y="82" font-size="13" font-weight="600" fill="#CFE0F7" opacity="0.9">Central store for queries + retention</text>
      <text x="40" y="110" font-size="12" font-weight="600" fill="#AFC3DE" opacity="0.9">
        Kusto engine, custom tables, ingestion
      </text>
    </g>
  </g>

  <!-- Right: table families -->
  <g transform="translate(560 160)" font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial">
    <rect width="980" height="300" rx="22" fill="#0E1730" stroke="#A8B7CC" stroke-opacity="0.16"/>
    <text x="28" y="54" font-size="18" font-weight="900" fill="#EAF2FF">Core Tables (Beginner Guide)</text>
    <text x="28" y="80" font-size="13" font-weight="600" fill="#CFE0F7" opacity="0.9">Most common pivot points for investigations</text>

    <!-- Table list -->
    <g font-size="14" font-weight="700" fill="#CFE0F7">
      <rect x="28" y="110" width="924" height="46" rx="14" fill="#111A2E" stroke="#A8B7CC" stroke-opacity="0.12"/>
      <text x="48" y="140">DeviceLogonEvents</text>
      <text x="520" y="140" opacity="0.85">Authentication, RDP, account anomalies</text>

      <rect x="28" y="164" width="924" height="46" rx="14" fill="#111A2E" stroke="#A8B7CC" stroke-opacity="0.12"/>
      <text x="48" y="194">DeviceProcessEvents</text>
      <text x="520" y="194" opacity="0.85">Execution, PowerShell, LOLBins, tasks</text>

      <rect x="28" y="218" width="924" height="46" rx="14" fill="#111A2E" stroke="#A8B7CC" stroke-opacity="0.12"/>
      <text x="48" y="248">DeviceNetworkEvents</text>
      <text x="520" y="248" opacity="0.85">Outbound connections, ports, domains</text>

      <rect x="28" y="272" width="924" height="46" rx="14" fill="#111A2E" stroke="#A8B7CC" stroke-opacity="0.12"/>
      <text x="48" y="302">DeviceFileEvents</text>
      <text x="520" y="302" opacity="0.85">Staging, drops, archives, exfil prep</text>

      <rect x="28" y="326" width="924" height="46" rx="14" fill="#111A2E" stroke="#A8B7CC" stroke-opacity="0.12"/>
      <text x="48" y="356">DeviceRegistryEvents</text>
      <text x="520" y="356" opacity="0.85">Defender tampering, persistence keys</text>
    </g>
  </g>

  <!-- Connectors -->
  <g opacity="0.45">
    <path d="M500 230 C560 230, 560 230, 560 230" stroke="url(#accent)" stroke-width="4" fill="none"/>
    <path d="M500 390 C560 390, 560 390, 560 390" stroke="url(#accent)" stroke-width="4" fill="none"/>
    <circle cx="500" cy="230" r="6" fill="#67B8FF"/>
    <circle cx="500" cy="390" r="6" fill="#8BE9A8"/>
  </g>

  <text x="60" y="520" font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial"
        font-size="12" fill="#AFC3DE" opacity="0.65">docs/diagrams/data-sources.svg</text>
</svg>
'@

# --- SVG: attack-chain.svg ---
$attackChainSvg = @'
<svg xmlns="http://www.w3.org/2000/svg" width="1600" height="560" viewBox="0 0 1600 560" role="img" aria-label="Evidence chain diagram">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#0B1220"/>
      <stop offset="1" stop-color="#0F1B33"/>
    </linearGradient>
    <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
      <path d="M40 0H0V40" fill="none" stroke="#9FB3C8" stroke-opacity="0.08" stroke-width="1"/>
    </pattern>
    <linearGradient id="accent" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0" stop-color="#67B8FF"/>
      <stop offset="1" stop-color="#8BE9A8"/>
    </linearGradient>
    <marker id="arrow" markerWidth="12" markerHeight="12" refX="10" refY="6" orient="auto">
      <path d="M0,0 L12,6 L0,12 Z" fill="#CFE0F7" opacity="0.45"/>
    </marker>
    <filter id="softGlow" x="-20%" y="-20%" width="140%" height="140%">
      <feGaussianBlur stdDeviation="6" result="b"/>
      <feMerge>
        <feMergeNode in="b"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
  </defs>

  <rect x="24" y="20" width="1552" height="520" rx="28" fill="url(#bg)" stroke="#A8B7CC" stroke-opacity="0.12"/>
  <rect x="36" y="32" width="1528" height="496" rx="22" fill="url(#grid)"/>

  <text x="60" y="86" font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial"
        font-size="28" font-weight="900" fill="#EAF2FF">Evidence / Attack Chain</text>
  <text x="60" y="116" font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial"
        font-size="14" font-weight="600" fill="#CFE0F7" opacity="0.9">
    Build investigations by chaining pivots across tables (logon → process → network → registry → file)
  </text>

  <!-- Main chain rail -->
  <path d="M120 300 H1480" stroke="url(#accent)" stroke-width="6" stroke-linecap="round" opacity="0.18"/>
  <path d="M120 300 H1480" stroke="url(#accent)" stroke-width="6" stroke-linecap="round"
        stroke-dasharray="140 1400" filter="url(#softGlow)" opacity="0.9">
    <animate attributeName="stroke-dashoffset" from="0" to="-1480" dur="3.8s" repeatCount="indefinite"/>
    <animate attributeName="opacity" values="0.12;0.7;0.12" dur="3.8s" repeatCount="indefinite"/>
  </path>

  <g font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial">
    <!-- Node template repeated -->
    <g transform="translate(120 190)">
      <rect width="250" height="180" rx="20" fill="#0E1730" stroke="#A8B7CC" stroke-opacity="0.16"/>
      <rect x="18" y="18" width="8" height="144" rx="4" fill="#67B8FF" opacity="0.9"/>
      <text x="42" y="56" font-size="16" font-weight="900" fill="#EAF2FF">Logon</text>
      <text x="42" y="82" font-size="12" font-weight="700" fill="#AFC3DE" opacity="0.95">DeviceLogonEvents</text>
      <text x="42" y="116" font-size="12" font-weight="600" fill="#CFE0F7" opacity="0.9">
        Who logged in? From where? RDP? New device?
      </text>
    </g>

    <g transform="translate(410 190)">
      <rect width="250" height="180" rx="20" fill="#0E1730" stroke="#A8B7CC" stroke-opacity="0.16"/>
      <rect x="18" y="18" width="8" height="144" rx="4" fill="#67B8FF" opacity="0.85"/>
      <text x="42" y="56" font-size="16" font-weight="900" fill="#EAF2FF">Process</text>
      <text x="42" y="82" font-size="12" font-weight="700" fill="#AFC3DE" opacity="0.95">DeviceProcessEvents</text>
      <text x="42" y="116" font-size="12" font-weight="600" fill="#CFE0F7" opacity="0.9">
        What executed? PowerShell? LOLBins? Scheduled tasks?
      </text>
    </g>

    <g transform="translate(700 190)">
      <rect width="250" height="180" rx="20" fill="#0E1730" stroke="#A8B7CC" stroke-opacity="0.16"/>
      <rect x="18" y="18" width="8" height="144" rx="4" fill="#8BE9A8" opacity="0.85"/>
      <text x="42" y="56" font-size="16" font-weight="900" fill="#EAF2FF">Network</text>
      <text x="42" y="82" font-size="12" font-weight="700" fill="#AFC3DE" opacity="0.95">DeviceNetworkEvents</text>
      <text x="42" y="116" font-size="12" font-weight="600" fill="#CFE0F7" opacity="0.9">
        Where did it connect? Domain, IP, port, frequency?
      </text>
    </g>

    <g transform="translate(990 190)">
      <rect width="250" height="180" rx="20" fill="#0E1730" stroke="#A8B7CC" stroke-opacity="0.16"/>
      <rect x="18" y="18" width="8" height="144" rx="4" fill="#8BE9A8" opacity="0.8"/>
      <text x="42" y="56" font-size="16" font-weight="900" fill="#EAF2FF">Registry</text>
      <text x="42" y="82" font-size="12" font-weight="700" fill="#AFC3DE" opacity="0.95">DeviceRegistryEvents</text>
      <text x="42" y="116" font-size="12" font-weight="600" fill="#CFE0F7" opacity="0.9">
        Defender tampering? persistence keys? policy changes?
      </text>
    </g>

    <g transform="translate(1280 190)">
      <rect width="250" height="180" rx="20" fill="#0E1730" stroke="#A8B7CC" stroke-opacity="0.16"/>
      <rect x="18" y="18" width="8" height="144" rx="4" fill="#67B8FF" opacity="0.75"/>
      <text x="42" y="56" font-size="16" font-weight="900" fill="#EAF2FF">File</text>
      <text x="42" y="82" font-size="12" font-weight="700" fill="#AFC3DE" opacity="0.95">DeviceFileEvents</text>
      <text x="42" y="116" font-size="12" font-weight="600" fill="#CFE0F7" opacity="0.9">
        What was dropped/staged? archives? suspicious paths?
      </text>
    </g>
  </g>

  <!-- arrows between nodes -->
  <g opacity="0.55">
    <path d="M370 300 L410 300" stroke="#CFE0F7" stroke-width="2" marker-end="url(#arrow)"/>
    <path d="M660 300 L700 300" stroke="#CFE0F7" stroke-width="2" marker-end="url(#arrow)"/>
    <path d="M950 300 L990 300" stroke="#CFE0F7" stroke-width="2" marker-end="url(#arrow)"/>
    <path d="M1240 300 L1280 300" stroke="#CFE0F7" stroke-width="2" marker-end="url(#arrow)"/>
  </g>

  <text x="60" y="520" font-family="ui-sans-serif, system-ui, Segoe UI, Roboto, Arial"
        font-size="12" fill="#AFC3DE" opacity="0.65">docs/diagrams/attack-chain.svg</text>
</svg>
'@

# --- Write files ---
Write-Utf8NoBom "docs/diagrams/hero.svg" $heroSvg
Write-Utf8NoBom "docs/diagrams/hunt-flow.svg" $huntFlowSvg
Write-Utf8NoBom "docs/diagrams/data-sources.svg" $dataSourcesSvg
Write-Utf8NoBom "docs/diagrams/attack-chain.svg" $attackChainSvg

Write-Host "✅ Done."
Write-Host "Created:"
Write-Host " - docs/diagrams/hero.svg"
Write-Host " - docs/diagrams/hunt-flow.svg"
Write-Host " - docs/diagrams/data-sources.svg"
Write-Host " - docs/diagrams/attack-chain.svg"
Write-Host " - docs/images/ (empty placeholder)"
Write-Host " - assets/ (optional placeholder)"

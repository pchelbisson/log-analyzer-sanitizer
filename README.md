# Linux Log Analyzer & Sanitizer

## Overview

This Bash script is a **realistic DevOps utility** to process log files.  
It performs three main tasks:

1. **Clean the log** — removes comments (except the shebang), empty lines, and normalizes spaces.  
2. **Sanitize the log** — masks sensitive data like IP addresses and email addresses.  
3. **Generate an analysis report** — counts total lines, ERROR/WARN occurrences, and shows first/last events.  

> ⚠️ This is a **learning project**. The code is a bit raw, but fully functional and honest.

---

## Features

- Handles input file validation and output directory creation.  
- Protects the shebang line from sanitization.  
- Optional `--sanitize` mode to mask IPs and emails.  
- Generates a simple but readable **analysis report**.  
- Fully written in Bash, using `sed`, `grep`, `awk`, and basic shell tools.  

---

## Usage

```bash
./log_analyzer.sh <log_file> <output_dir> [--sanitize]
```
<log_file> — path to the input log file
<output_dir> — directory where clean, sanitized logs and report will be saved
[--sanitize] — optional flag to mask sensitive data

Example:
```bash
./log_analyzer.sh /var/log/app.log ./output --sanitize
```

---

## How it Works
1. Clean Log

    - Replaces tabs with spaces

    - Trims leading/trailing spaces

    - Collapses multiple spaces

    - Removes empty lines

    - Removes comment lines except the shebang

2. Sanitize (optional)

    - Masks IP addresses (e.g., 192.168.1.10 → xxx.xxx.xxx.xxx)

    - Masks email addresses (e.g., user@mail.com → xxxxx@xxxxx.xx)

    - Skips the first line (shebang)

3. Analysis Report

    - Counts total lines

    - Counts ERROR and WARN occurrences

    - Shows first and last events

    - Saved as ANALYS_<log_filename>.txt

---

## Notes
- The script is designed to be simple, understandable, and safe.

- Sanitized log and analysis report are saved in the output directory.

- The code is “honest”: not over-engineered, but fully working.

- This project demonstrates Bash scripting, log processing, and basic DevOps practices.
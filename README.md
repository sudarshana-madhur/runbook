# Runbook

Runbook is an utility application designed to bundle various useful tools into a single, convenient interface. It aims to simplify specific digital tasks with privacy-focused, local-processing tools.
It is deployed as a web application with support for PWA in firebase.

## Tools

### 1. Instagram Unfollower Hunter

This tool helps you find Instagram accounts that you follow but who do not follow you back. It works by analyzing your official Instagram data export.

**How to use:**

1.  **Export Data:** Request your information from Instagram (Settings &rarr; Your information and permissions &rarr; Download your information).
    - **Category:** Select only **Followers and Following** (selecting all data will make the file too large).
    - **Format:** Ensure the format is set to **JSON**.
2.  **Upload:** Once the export is ready, download the ZIP file to your phone.
3.  **Hunt:** Open the Unfollower Hunter in this app, upload the ZIP file, and click "HUNT!" to see the results.

_Note: All data processing happens locally on your device._

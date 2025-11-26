# Recon
Automated subdomain enumeration and URL extraction toolchain using Subfinder, Amass, Assetfinder, Katana, Hakrawler, Gau, Waybackurls, and more. Fully automates recon with live host filtering and crawling.

Quick start — run the script
# make the script executable (once)
chmod +x recon-script.sh

# run it (replace example.com)
./recon-script.sh example.com

The script will create a working folder recon-example.com and produce these primary outputs:

~ finalsubdomains.txt — all discovered subdomains (unique)
~ livedomains.txt — alive subdomains (via httpx-toolkit)
~ urlsorted.txt — gathered URLs for the main domain
~ urlforallunique.txt — gathered URLs across all live domains

Requirements (tools used by the script)

This script calls many external tools. Install the ones you plan to use. Below are common install methods — pick the package manager that matches your OS (Debian/Ubuntu, Amazon Linux / Fedora/RHEL (dnf), macOS (brew)) or install via go install when shown.

{ subfinder, assetfinder, alterx, amass, subdominator, httpx-toolkit (or httpx / httpx-toolkit if you use projectdiscovery/httpx-toolkit), katana, gau (getallurls / gau), waybackurls, getallurls (hakluke/getallurls), waymore, hakrawler, common utilities: grep, awk, sort, curl, jq (optional) }

Optional: API keys & config for better coverage
~ Some tools (e.g., subfinder, theHarvester, Shodan integrations) give far better results when you add API keys. Add them to configuration files for the tools:
~ subfinder provider config: ~/.config/subfinder/provider-config.yaml
~ Shodan, VirusTotal, SecurityTrails, Censys — add API keys to the provider config files (see each tool’s docs)
~ DO NOT commit API keys or tokens to GitHub. Use a .gitignore and environment variables or config files stored outside the repo.

Final notes

This script is a great starting point — adapt it to your toolset and goals.
Keep your environment tidy (use virtualenv / pipx for Python tools, and keep Go binaries in $GOPATH/bin).

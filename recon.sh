!/bin/bash

# Subdomain Enumeration + URL Extraction Automation Script

# Ask for domain
read -p "Enter target domain (e.g., example.com): " domain

# Create working directory
mkdir -p recon-$domain
cd recon-$domain || exit

echo "[*] Starting recon for $domain..."


# Step 1: Subdomain Enumeration


echo "[*] Running Subfinder..."
subfinder -d $domain >> 1.txt

echo "[*] Running Assetfinder..."
assetfinder $domain >> 2.txt
assetfinder --subs-only $domain >> 2.txt
cat 2.txt | grep $domain >> assetfinderResult.txt

echo "[*] Running AlterX..."
echo $domain | alterx >> 3.txt

echo "[*] Running Amass..."
amass enum -passive  -d $domain -o  amass_raw_P.txt -timeout 20  -max-dns-queries 9999

amass enum -active  -d $domain -o  amass_raw_A.txt -timeout 20  -max-dns-queries 9999

awk '{print $1}' amass_raw_P.txt | grep -v "local" | sort -u >  4.txt
awk '{print $1}' amass_raw_A.txt | grep -v "local" | sort -u > 5.txt

awk '{print $2}' amass_raw_P.txt | grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}" | sort -u > ips_onl_P.txt
awk '{print $2}' amass_raw_A.txt | grep -v "([0-9]{1,3}\.){3}[0-9]{1,3}" | sort -u > ips_only_A.txt


echo "[*] Running Subdominator..."
subdominator -d $domain -o 6.txt

# Merge all subdomains
cat 1.txt 2.txt 3.txt 4.txt 5.txt 6.txt  >> subdomains.txt

# Remove duplicates
cat subdomains.txt | sort -u >> finalsubdomains.txt
echo "[+] Subdomain enumeration complete → finalsubdomains.txt"


# Step 2: Live Host Filtering


httpx-toolkit -l finalsubdomains.txt -sc -title -tech-detect -server -ip -cname -o httpx-results.txt

httpx-toolkit -l finalsubdomains.txt -o livedomains.txt 
echo "[+] Live domains saved → livedomains.txt"


# Step 3: Crawling (Single Domain)


echo "[*] Crawling single domain with gau, waybackurls, katana, waymore, hakrawler..."

echo $domain | gau >> url1.txt
echo $domain | waybackurls >> url2.txt
echo $domain | katana >> url3.txt
echo $domain | getallurls >> url4.txt
waymore -i $domain -mode U >> url5.txt
echo $domain | hakrawler -d 2  >> url6.txt

# Merge
cat url1.txt url2.txt url3.txt url4.txt url5.txt url6.txt >> urlfinal.txt

# Unique filter
cat urlfinal.txt | sort -u >> urlsorted.txt
echo "[+] Final single-domain URLs → urlsorted.txt"


# Step 4: Crawling (Multiple Domains)


echo "[*] Crawling multiple live domains..."

katana -u livedomains.txt -o urlforall1.txt
cat livedomains.txt | hakrawler >> urlforall2.txt

# Merge
cat urlforall1.txt urlforall2.txt  >> urlforallfinal.txt

# Unique filter
cat urlforallfinal.txt | sort -u >> urlforallunique.txt
echo "[+] Final multi-domain URLs → urlforallunique.txt"


# Final Outputs


echo -e "\n[✔] Recon completed for $domain"
echo "-----------------------------------"
echo "1. finalsubdomains.txt   → All subdomains"
echo "2. livedomains.txt       → Only live subdomains (via sudo httpx)"
echo "3. urlsorted.txt         → URLs for single domain"
echo "4. urlforallunique.txt   → URLs for all live domains"
echo "-----------------------------------"




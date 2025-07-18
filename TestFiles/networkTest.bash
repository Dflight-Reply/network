#!/bin/bash
# Network Test - DFlight Architecture
# Test coerente con l'architettura implementata

# --- IP CORRETTI dalle EC2 create ---
PU_A_IP="10.0.0.231"
PU_B_IP="10.0.2.254"
PU_C_IP="10.0.5.126"
PR_A_IP="10.0.18.161"
PR_B_IP="10.0.33.27"
PR_C_IP="10.0.60.4"
PRD_A_IP="10.0.78.229"
PRD_B_IP="10.0.84.253"
PRD_C_IP="10.0.98.225"

echo "== Test coerenti con architettura DFlight =="
echo "EC2 corrente: $(hostname) - IP: $(hostname -I)"

echo ""
echo "== Test 1: Internet (dovrebbe essere OK per tutte le EC2) =="
curl -s --connect-timeout 5 https://www.google.com > /dev/null
if [ $? -eq 0 ]; then echo "✅ OK: Internet raggiungibile"; else echo "❌ KO: Internet NON raggiungibile"; fi

echo ""
echo "== Test 2: DNS (dovrebbe essere OK per tutte le EC2) =="
nslookup amazon.com > /dev/null 2>&1
if [ $? -eq 0 ]; then echo "✅ OK: DNS funzionante"; else echo "❌ KO: DNS NON funzionante"; fi

echo ""
echo "== Test 3: Ping all'interno dello stesso VPC (dipende dalle Security Group) =="
echo "Ping verso EC2 Public:"
for ip in $PU_A_IP $PU_B_IP $PU_C_IP; do
  ping -c 2 $ip > /dev/null 2>&1
  if [ $? -eq 0 ]; then echo "✅ OK: Ping verso $ip"; else echo "❌ KO: Ping verso $ip (Security Group?)"; fi
done

echo "Ping verso EC2 Private Logic:"
for ip in $PR_A_IP $PR_B_IP $PR_C_IP; do
  ping -c 2 $ip > /dev/null 2>&1
  if [ $? -eq 0 ]; then echo "✅ OK: Ping verso $ip"; else echo "❌ KO: Ping verso $ip (Security Group?)"; fi
done

echo "Ping verso EC2 Private Data:"
for ip in $PRD_A_IP $PRD_B_IP $PRD_C_IP; do
  ping -c 2 $ip > /dev/null 2>&1
  if [ $? -eq 0 ]; then echo "✅ OK: Ping verso $ip"; else echo "❌ KO: Ping verso $ip (Security Group?)"; fi
done

echo ""
echo "== Test 4: VPC Endpoints SSM (OK per Public e Private-Logic, KO per Private-Data) =="
curl -s --connect-timeout 5 https://ssm.eu-south-1.amazonaws.com > /dev/null 2>&1
if [ $? -eq 0 ]; then echo "✅ OK: VPC Endpoint SSM raggiungibile"; else echo "❌ KO: VPC Endpoint SSM NON raggiungibile"; fi

echo ""
echo "== Test 5: AWS CLI (dipende dai permessi IAM) =="
aws sts get-caller-identity --region eu-south-1 > /dev/null 2>&1
if [ $? -eq 0 ]; then echo "✅ OK: AWS CLI funzionante"; else echo "❌ KO: AWS CLI NON funzionante (IAM?)"; fi

echo ""
echo "== Test 6: Routing NAT =="
IP_PUBBLICO=$(curl -s --connect-timeout 5 ifconfig.me)
if [[ $IP_PUBBLICO =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "✅ OK: IP pubblico visto: $IP_PUBBLICO"
else
  echo "❌ KO: Non riesco a vedere l'IP pubblico"
fi

echo ""
echo "== Test completati =="
#!/bin/bash

# WAF Testing Script for DFlight
# Note: ALB is managed by EKS project, use the actual ALB DNS name
ALB_DNS="dflight-alb-560851243.eu-south-1.elb.amazonaws.com"
WAF_ARN=$(terraform output -raw waf_web_acl_arn)
echo "Testing WAF configuration for: $ALB_DNS"
echo "WAF ARN: $WAF_ARN"
echo "=================================="

# Test 1: Normal request (should pass)
echo "1. Testing normal request..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "http://$ALB_DNS/health")
if [ "$RESPONSE" = "200" ] || [ "$RESPONSE" = "404" ]; then
    echo "✅ Normal request: PASSED ($RESPONSE)"
else
    echo "❌ Normal request: FAILED ($RESPONSE)"
fi

# Test 2: SQL Injection (should be blocked)
echo "2. Testing SQL injection..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "http://$ALB_DNS/?id=1' OR '1'='1")
if [ "$RESPONSE" = "403" ]; then
    echo "✅ SQL injection: BLOCKED ($RESPONSE)"
else
    echo "❌ SQL injection: NOT BLOCKED ($RESPONSE)"
fi

# Test 3: XSS (should be blocked)
echo "3. Testing XSS..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "http://$ALB_DNS/?q=<script>alert('xss')</script>")
if [ "$RESPONSE" = "403" ]; then
    echo "✅ XSS: BLOCKED ($RESPONSE)"
else
    echo "❌ XSS: NOT BLOCKED ($RESPONSE)"
fi

# Test 4: Directory traversal (should be blocked)
echo "4. Testing directory traversal..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "http://$ALB_DNS/../../../etc/passwd")
if [ "$RESPONSE" = "403" ]; then
    echo "✅ Directory traversal: BLOCKED ($RESPONSE)"
else
    echo "❌ Directory traversal: NOT BLOCKED ($RESPONSE)"
fi

# Test 5: Rate limiting (simplified test)
echo "5. Testing rate limiting (sending 10 quick requests)..."
BLOCKED=0
for i in {1..10}; do
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "http://$ALB_DNS/")
    if [ "$RESPONSE" = "403" ]; then
        BLOCKED=$((BLOCKED + 1))
    fi
done
echo "Rate limiting test: $BLOCKED/10 requests blocked"

echo "=================================="
echo "WAF testing completed!"
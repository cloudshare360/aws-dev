#!/bin/bash

echo "🧪 Testing Route 53 Learning Site Navigation..."
echo "=============================================="

BASE_URL="http://localhost:4000/AWS-Abhishek-Veeramalla/day-6-route53"

# Test main page
echo "📋 Testing main page..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/)
if [ $STATUS -eq 200 ]; then
    echo "✅ Main page: OK ($STATUS)"
else
    echo "❌ Main page: FAILED ($STATUS)"
fi

# Test diagram directories exist
echo -e "\n📁 Testing diagram directories..."
for dir in "diagrams" "diagrams-enhanced"; do
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/$dir/)
    if [ $STATUS -eq 200 ]; then
        echo "✅ Directory $dir: OK ($STATUS)"
    else
        echo "❌ Directory $dir: FAILED ($STATUS)"
    fi
done

# Test specific diagram files
echo -e "\n🎨 Testing diagram files..."
diagrams=(
    "dns-fundamentals.md"
    "dns-record-types.md"
    "hosted-zones.md"
    "routing-policies.md"
    "health-checks.md"
    "domain-registration.md"
    "aws-integration.md"
    "route53-overview.md"
)

for diagram in "${diagrams[@]}"; do
    echo "Testing: $diagram"
    
    # Test basic version
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/diagrams/$diagram)
    if [ $STATUS -eq 200 ]; then
        echo "  ✅ Basic version: OK ($STATUS)"
    else
        echo "  ❌ Basic version: FAILED ($STATUS)"
    fi
    
    # Test enhanced version
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/diagrams-enhanced/$diagram)
    if [ $STATUS -eq 200 ]; then
        echo "  ✅ Enhanced version: OK ($STATUS)"
    else
        echo "  ❌ Enhanced version: FAILED ($STATUS)"
    fi
done

# Test additional directories
echo -e "\n📝 Testing additional resources..."
for dir in "manula-notes" "notebook-nlm"; do
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/$dir/)
    if [ $STATUS -eq 200 ]; then
        echo "✅ Directory $dir: OK ($STATUS)"
    else
        echo "❌ Directory $dir: FAILED ($STATUS)"
    fi
done

echo -e "\n🎉 Navigation test completed!"
echo "📱 You can now browse the site at: $BASE_URL/"
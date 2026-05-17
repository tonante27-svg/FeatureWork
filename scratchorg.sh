#!/bin/bash
# 1. Silently remove any expired or deleted scratch orgs from the local list
sf org list --clean --no-prompt
# 2. Get User INput
while [ -z "$ORG_NAME" ] 
do
    echo "❓ Please enter a name for your scratch org: "
    read ORG_NAME
done

while [ -z "$ORG_DAYS" ] 
do
    echo "❓ Please enter the no of days for your scratch org: "
    read ORG_DAYS
done
# 3. Create or Skip
echo "🔄 Checking if org '$ORG_NAME' already exists..."

# Check if the alias is already in use
sf org display --target-org "$ORG_NAME" > /dev/null 2>&1

if [ "$?" = "0" ]; then
    echo "ℹ️  Org '$ORG_NAME' already exists. Skipping creation and moving to deploy..."
else
    echo "🔄 Building your new org, please wait..."
    sf org create scratch --definition-file config/project-scratch-def.json --alias "$ORG_NAME" --duration-days "$ORG_DAYS" --set-default
    
    if [ "$?" != "0" ]; then
        echo "❌ Can't create your org. Check if the name is globally unique."
        exit 1
    fi
    echo "✅ Scratch org created."
fi
# 4. Push Code
echo -e "\n🔄 Pushing the code, please wait. It may take a while."

# Now that the naming is fixed (Angela.png + Angela.resource-meta.xml), this should work!
sf project deploy start --target-org "$ORG_NAME"

if [ "$?" != "0" ]; then 
    echo "❌ Can't push your source."
    exit 1
fi

echo -e "✅ Code pushed successfully.\n"
# 5. Open and Finish
echo "🚀 Opening your org..."
sf org open --target-org "$ORG_NAME"


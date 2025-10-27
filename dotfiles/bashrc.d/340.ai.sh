ai() {
    # Check if API key is set
    if [ -z "$ANTHROPIC_API_KEY" ]; then
        echo "Error: ANTHROPIC_API_KEY environment variable not set"
        return 1
    fi
    
    # Get user goal from all arguments
    local user_goal="$*"
    
    if [ -z "$user_goal" ]; then
        echo "Usage: ai <your goal>"
        return 1
    fi
    
    # Construct the prompt
    local prompt="Please write a one-line bash script to achieve the user goal. Only share ONE command, and put it in a codeblock\n\nUser goal: $user_goal"
    
    # Make API call
    local response=$(curl -s https://api.anthropic.com/v1/messages \
        -H "content-type: application/json" \
        -H "x-api-key: $ANTHROPIC_API_KEY" \
        -H "anthropic-version: 2023-06-01" \
        -d '{
            "model": "claude-sonnet-4-5-20250929",
            "max_tokens": 1024,
            "messages": [{
                "role": "user",
                "content": "'"$prompt"'"
            }]
        }')
    
    # Extract the text content from response
    local content=$(echo "$response" | jq -r '.content[0].text')
    
    # Extract command from code block (handles both ```bash and ``` formats)
    local command=$(echo "$content" | sed -n '/```/,/```/p' | sed '1d;$d' | sed 's/^bash$//' | grep -v '^[[:space:]]*$' | head -1)
    
    if [ -z "$command" ]; then
        echo "Error: Could not extract command from response"
        return 1
    fi
    
    echo -e "\n\033[33m$command\033[0m\n"
    read -p "Execute? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        eval "$command"
    else
        echo "Command not executed"
    fi
}

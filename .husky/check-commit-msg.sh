# .husky/check-commit-msg.sh

#!/bin/bash

# Path to the commit message file
commit_msg_file="$1"
commit_msg=$(cat "$commit_msg_file")

# Extract the first line as the subject, remaining lines as body/footer
subject_line=$(echo "$commit_msg" | head -n 1)
body_footer=$(echo "$commit_msg" | tail -n +2)

# Check 1: Subject line should be less than 50 characters
if [ ${#subject_line} -gt 50 ]; then
    echo "Error: Subject line should be less than 50 characters."
    exit 1
fi

# Check 2: Subject line should be in the imperative mood
imperatives="Fix Add Update Remove Refactor Implement Create Change Improve Resolve Correct"

if ! echo "$subject_line" | grep -qE "^($(echo $imperatives | sed 's/ /|/g'))"; then
    echo "Error: Subject line should be in the imperative mood (e.g., 'Fix login bug')."
    exit 1
fi

# Check 3: First word should be capitalized, no ending period
if [[ ! "$subject_line" =~ ^[A-Z] || "$subject_line" =~ \.$ ]]; then
    echo "Error: Subject line should start with a capital letter and have no ending period."
    exit 1
fi

# Check 4: Body lines should be wrapped at 72 characters (if a body is present)
if [ -n "$body_footer" ]; then
    while IFS= read -r line; do
        if [ ${#line} -gt 72 ]; then
            echo "Error: Body lines should not exceed 72 characters."
            exit 1
        fi
    done <<< "$body_footer"
fi

# Check 5: Footer includes issue numbers if provided (e.g., "Closes #123")
if echo "$body_footer" | grep -q "Closes"; then
    if ! echo "$body_footer" | grep -qE "Closes #[0-9]+"; then
        echo "Error: Footer should include issue numbers in the format 'Closes #123'."
        exit 1
    fi
fi

# All checks passed
echo "✅ All checks passed. Proceeding with commit."
exit 0

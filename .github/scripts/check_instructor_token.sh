#!/bin/bash

# Check for INSTRUCTOR_TESTS_TOKEN and provide helpful messaging
# This script is used by GitHub Actions to verify instructor access is configured

check_instructor_token() {
    if [ -z "$INSTRUCTOR_TESTS_TOKEN" ]; then
        echo "🔐 INSTRUCTOR_TESTS_TOKEN Setup Required"
        echo "=========================================="
        echo ""
        echo "📋 Current Status: Token not yet configured"
        echo ""
        echo "📝 What this means:"
        echo "   • Your assignment repository needs instructor access configured"
        echo "   • This allows automated testing of your submissions"
        echo "   • No action required from you as a student"
        echo ""
        echo "⏳ Next Steps:"
        echo "   • Your instructor will configure this token shortly"
        echo "   • Once configured, automatic testing will begin"
        echo "   • You can continue working on your assignment"
        echo ""
        echo "💡 In the meantime:"
        echo "   • Complete your work in ${STUDENT_NOTEBOOK:-your assignment notebook}"
        echo "   • Test your code manually to ensure it works"
        echo "   • Submit your assignment as normal"
        echo ""
        echo "🎯 Expected Timeline:"
        echo "   • Token setup typically completed within 24-48 hours"
        echo "   • Automated feedback will be available once configured"
        echo ""
        echo "❓ Questions? Contact your instructor or TA"
        echo ""
        exit 1
    else
        echo "✅ INSTRUCTOR_TESTS_TOKEN is configured"
        echo "📋 Proceeding with automated testing..."
    fi
}

# Run the check
check_instructor_token

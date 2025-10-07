#!/bin/bash

# HossAI Agent Manager Setup Script
echo "🚀 Setting up HossAI Agent Manager..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed. Please install Xcode from the App Store."
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "HossAIAgentManager.xcodeproj/project.pbxproj" ]; then
    echo "❌ Please run this script from the HossAIAgentManager directory."
    exit 1
fi

echo "✅ Project files found"

# Open the project in Xcode
echo "📱 Opening project in Xcode..."
open HossAIAgentManager.xcodeproj

echo ""
echo "🎯 Next steps:"
echo "1. In Xcode, select the project in the navigator"
echo "2. Go to 'Signing & Capabilities' tab"
echo "3. Remove 'App Sandbox' capability"
echo "4. Add 'Apple Events' capability"
echo "5. Set deployment target to macOS 13.0+"
echo "6. Press ⌘R to build and run"
echo "7. Grant all requested permissions when prompted"
echo ""
echo "📋 Required permissions:"
echo "   • Accessibility (for window detection)"
echo "   • Automation/Apple Events (for Cursor integration)"
echo "   • Microphone (for voice input)"
echo "   • Speech Recognition (for voice transcription)"
echo ""
echo "✨ Happy coding!"

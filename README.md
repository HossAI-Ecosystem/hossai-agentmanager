# HossAI Agent Manager

A macOS application for managing AI agents with window detection, voice control, and Cursor integration.

## Features

- **Agent Management**: Monitor and control multiple AI agents (ProductOwner, DevPortal, AIEng, DevOps)
- **Window Detection**: Automatically detect and allocate Cursor windows to appropriate agents
- **Voice Control**: Speech-to-text input with microphone support
- **Cursor Integration**: Send commands to Cursor without stealing focus
- **Real-time Logs**: Monitor system activity and agent status
- **Health Monitoring**: Track agent status (healthy, degraded, offline)

## Setup Instructions

### 1. Open in Xcode
1. Open Xcode
2. File → Open → Select the `HossAIAgentManager.xcodeproj` file
3. Select the project in the navigator
4. Go to "Signing & Capabilities" tab

### 2. Configure Project Settings
- **Remove App Sandbox**: Uncheck "App Sandbox" capability
- **Add Apple Events**: Add "Apple Events" capability for automation
- **Set Deployment Target**: Ensure macOS 13.0+ is selected

### 3. Required Permissions
The app will request these permissions when first launched:
- **Accessibility**: For window detection and control
- **Automation (System Events)**: For sending commands to Cursor
- **Microphone**: For voice input
- **Speech Recognition**: For transcribing voice

### 4. Build and Run
- Press ⌘R to build and run
- Grant all requested permissions when prompted

## Usage

### Agent Cards (Left Sidebar)
- **Test Button**: Refreshes window detection
- **GitHub Button**: Opens the agent's repository
- **Task Button**: Simulates running a task (agent becomes busy for 2 seconds)

### Windows Tab
- **Refresh Button**: Manually scan for Cursor windows
- **Detected Windows**: Shows all found Cursor windows
- **Agent Allocations**: Shows which windows are assigned to which agents

### Control Tab
- **Agent Picker**: Select which agent to send commands to
- **Mic Button**: Toggle voice input
- **Text Input**: Type or speak commands
- **Send Button**: Send command to Cursor
- **Chat**: View conversation history

### Logs Tab
- Real-time system logs
- Scanner, messenger, info, and error messages

## Technical Details

- **Window Detection**: Uses Accessibility APIs to detect Cursor windows
- **Cursor Integration**: Uses CGEvent to send keystrokes without focus stealing
- **Voice Recognition**: Uses Speech framework for speech-to-text
- **Text-to-Speech**: Uses AVSpeechSynthesizer for voice output
- **Health Logic**: Agents are healthy when they have windows and are ready

## Troubleshooting

- **Buttons not working**: Ensure all permissions are granted
- **No windows detected**: Make sure Cursor is running and accessibility permission is granted
- **Voice not working**: Check microphone and speech recognition permissions
- **Cursor integration failing**: Verify automation permission is granted

## Customization

- **Colors and styling**: Edit `Theme.swift`
- **Agent allocation rules**: Modify `AppVM.rebuildAllocations(from:)`
- **Health policies**: Update health logic in the same method
- **Voice settings**: Adjust `VoiceService.swift` parameters

# FAST (Field Agent Support Technology)

Field Agent Support Technology - real-time dialog support from hybrid LLM / human team

## Overview

FAST is a real-time dialog support system that provides contextually relevant suggestions and responses through a user's earbuds during conversations. The system processes live audio, transcribes speech, analyzes conversation context, and generates appropriate response suggestions.

## System Architecture

FAST is built on a modular, agent-based architecture with the following components:

### Core Components

1. **UniLang Agent System**
   - FAST operates as a UniLang agent, enabling communication with other agents
   - Message-passing architecture for distributed processing

2. **Speech Recognition**
   - Integrates with whisper-ctranslate2 for real-time speech-to-text capabilities
   - Processes audio input from the user's environment through earbuds

3. **Dialog Management**
   - Maintains structured conversation history
   - Tracks utterances with contextual metadata
   - Implements timing controls for appropriate response generation

4. **LLM Integration**
   - Uses template-based approach for prompting language models
   - Communicates with LLM services via the FAST::LLMClient module
   - Generates contextually relevant responses based on conversation history

5. **Response Delivery**
   - Text-to-speech synthesis using espeak
   - Audio playback to the user's earbuds

## Technical Implementation

### Key Files and Modules

- **FAST.pm**: Core module implementing the UniLang agent functionality
- **fast**: Main executable script that initializes the system
- **FAST/LLMClient.pm**: Client for LLM integration and templating
- **FAST/Util/LLMClientClient.pm**: Utility for asynchronous LLM interactions
- **scripts/fast-asr**: Script for ASR (Automatic Speech Recognition) processing
- **scripts/start-echelon.pl**: Script to initialize the whisper-ctranslate2 environment
- **scripts/fast-aggregator.pl**: Implementation for response selection and aggregation

### Data Structure

Each utterance in the dialog history contains:
```
{
    utterance: "transcribed text",
    timestamp: [time value],
    metadata: {
        is_user: [boolean],
        context_tags: [],
        social_cues: {
            // Data on tone, urgency, emotional state
        },
        response_metrics: {
            response_time: [value],
            was_helpful: [boolean],
            user_followed_suggestion: [boolean]
        }
    }
}
```

## Setup and Usage

### Prerequisites
- Perl environment with required modules:
  - UniLang::Agent
  - Expect
  - JSON
  - Time::HiRes
- Python 3.9 environment for whisper-ctranslate2
- espeak for text-to-speech functionality
- mplayer for audio playback

### Installation
1. Clone the repository
2. Install required Perl modules
3. Set up conda environment for whisper-ctranslate2: `conda create -n whisper-ctranslate2 python==3.9`
4. Install whisper-ctranslate2 in the conda environment

### Running FAST
1. Start the UniLang server if not already running
2. Launch FAST as a UniLang agent: `./fast -u`
3. Start the ASR component: `./scripts/fast-asr`
4. Begin conversation after the "ready player one" trigger phrase

## Future Development

Based on the to.do file and existing code structure, planned features include:

1. **Speaker Diarization**: Identify and distinguish between different speakers
2. **Simulation Mode**: Role-playing capability where FAST simulates conversation partners
3. **Multi-Agent Response Aggregation**: Implement hierarchical response selection from multiple AI agents
4. **Enhanced Context Analysis**: Improved understanding of conversation dynamics
5. **User Feedback Integration**: Learning from the effectiveness of suggested responses

## Project Structure
```
fast/
├── FAST.pm                          # Core module
├── fast                             # Main executable
├── README.md                        # This file
├── to.do                            # Development notes
├── frdcsa/
│   └── FRDCSA.xml                   # System metadata
├── FAST/
│   ├── LLMClient.pm                 # LLM integration
│   └── Util/
│       └── LLMClientClient.pm       # Utility functions
├── data-git/
│   └── prompts/
│       └── flp/
│           └── fast_retort.tt       # LLM prompt template
└── scripts/
    ├── start-echelon.pl             # ASR initialization
    ├── fast-aggregator.pl           # Response aggregation
    └── fast-asr                     # Speech recognition
```

## License

GPLv3

---

*FAST: Enhancing real-time communication with contextually relevant assistance*

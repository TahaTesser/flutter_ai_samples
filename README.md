# Flutter Samples

This repository contains automatically generated Flutter widget samples using OpenAI's GPT API. New samples are generated every 10 minutes and automatically committed to the repository.

## How it works

1. A GitHub Action runs every 10 minutes
2. It uses OpenAI's GPT API to generate a new Flutter widget sample
3. The sample is added to the `lib/samples` directory
4. The main.dart file is updated to include the new sample
5. The version number is incremented
6. Changes are automatically committed and pushed

## Setup

To set up automatic sample generation, you need to:

1. Add `OPENAI_API_KEY` secret to your repository settings
2. Add `GH_PAT` (GitHub Personal Access Token) secret with repo access
3. Enable GitHub Actions for your repository

## Contributing

While this repository is primarily maintained through automated generation, contributions are welcome! Feel free to:

- Submit bug fixes
- Improve the sample generation prompt
- Enhance the GitHub Action workflow
- Add manual samples

## License

[Your license information here]

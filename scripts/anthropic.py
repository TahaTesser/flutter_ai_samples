from anthropic import Anthropic
import os
from datetime import datetime

# Create samples directory if it doesn't exist
samples_dir = "samples"
os.makedirs(samples_dir, exist_ok=True)

client = Anthropic(
    api_key=os.environ.get("ANTHROPIC_API_KEY"),  # This is the default and can be omitted
)

# Get today's date in YYYYMMDD format
today = datetime.now().strftime("%Y%m%d")

# Replace placeholders like {{FLUTTER_CONCEPT}} with real values,
# because the SDK does not support variables.
message = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=4096,
    temperature=0,
    messages=[
        {
            "role": "user",
            "content": [
                {
                    "type": "text", 
                    "text": "You are tasked with creating a unique and useful self-contained Flutter sample that demonstrates a specific Flutter concept. This sample should be comprehensive, runnable, and resemble a real-world use case. Follow these instructions carefully:\n\n1. The Flutter concept you will be demonstrating is:\n<flutter_concept>\n{{FLUTTER_CONCEPT}}\n</flutter_concept>\n\n2. Create a single Dart file that includes all necessary code, including the main function, to make the sample runnable. The file should be placed in a \"samples\" folder and named according to this convention:\n   flutter_sample_{{TODAYS_DATE}}.dart\n\n3. Ensure your sample incorporates and showcases the Flutter concept mentioned above in a practical and meaningful way.\n\n4. Structure your sample to include:\n   a. Necessary import statements\n   b. A main() function that runs the app\n   c. At least one custom StatefulWidget or StatelessWidget class\n   d. Implementation of the specified Flutter concept\n   e. If applicable, multiple pages or screens to demonstrate navigation\n\n5. Your code should be well-formatted and include comments explaining key parts of the implementation, especially those related to the specified Flutter concept.\n\n6. Make sure the sample is self-contained and doesn't rely on external assets or packages that are not part of the standard Flutter framework.\n\n7. The sample should be between 100-300 lines of code, striking a balance between being comprehensive and manageable.\n\nWhen you're ready to provide the sample, please output your entire response within <flutter_sample> tags. Begin with a brief description of what the sample demonstrates, followed by the complete Dart code.\n\nRemember to make the sample unique, practical, and focused on demonstrating the specified Flutter concept in a way that resembles a real use case."
                }
            ]
        }
    ]
)

# Extract the content between <flutter_sample> tags
response_content = message.content[0].text
start_tag = "<flutter_sample>"
end_tag = "</flutter_sample>"
start_index = response_content.find(start_tag) + len(start_tag)
end_index = response_content.find(end_tag)
flutter_sample = response_content[start_index:end_index].strip()

# Save to file
filename = f"flutter_sample_{today}.dart"
filepath = os.path.join(samples_dir, filename)
with open(filepath, "w") as f:
    f.write(flutter_sample)

print(f"Flutter sample saved to: {filepath}")

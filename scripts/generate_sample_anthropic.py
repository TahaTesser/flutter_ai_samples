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
                    "text": """
                    1. Avoid using third-party packages
                    2. Use Flutter framework only code
                    3. Create real world use cases and uniquer code sample
                    4. Make sure the sample is ruinable (include things like main function, MaterialApp or CupertinoApp)
                    5. Be creative 
                    6. Make samples long and detailed.
                    7. Combine different widgets to form real-world use cases.
                    8. Only return the flutter code as in the response. Don't say anything else
                    7. Return response shouldn't enclased in ```dart and ``` (highlight). Just the code itself. 
                    """
                }
            ]
        }
    ]
)

response_content = message.content[0].text
flutter_sample = response_content.strip()

# Save to file
filename = f"flutter_sample_{today}.dart"
filepath = os.path.join(samples_dir, filename)
with open(filepath, "w") as f:
    f.write(flutter_sample)

print(f"Flutter sample saved to: {filepath}")

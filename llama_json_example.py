import json
from llama_cpp import Llama
from my_secret_manager import my_secret_manager

# Initialize the LLaMA model with the path to your model file
LLM = Llama(model_path=my_secret_manager.get_blob_path())

def generate_response(user_input):
    # Updated prompt for clarity
    prompt = (
        f"Analyze the following statement: '{user_input}'.\n"
        "What is the emotion expressed in this statement? Choose from: happy, energetic, sad, depressed, neutral.\n"
        "Provide your answer in the format:\n"
        "answer: [emotion]\n"
        "justification: [provide a justification for your answer]."
    )

    output = LLM(prompt)
    response_text = output["choices"][0]["text"].strip()

    # Debug: Print the raw output for troubleshooting
    print("Raw output from LLaMA model:\n", response_text)

    # Initialize answer and justification
    emotion = "unknown"
    justification = "no justification available"

    # Extract emotion and justification based on the observed format
    if "I would say that the emotion expressed in this statement is:" in response_text:
        try:
            # Extract emotion
            emotion_part = response_text.split("I would say that the emotion expressed in this statement is:")[-1].strip()
            # Remove any punctuation if needed
            emotion = emotion_part.rstrip('.').strip()
        
        except Exception as e:
            print(f"Error extracting emotion: {e}")

    # Check for justification
    if "justification" in response_text:
        try:
            justification_start = response_text.index("justification") + len("justification")
            justification = response_text[justification_start:].strip()
            # Remove any unwanted characters or extra lines
            justification = justification.replace("\n", "").strip()
        except Exception as e:
            print(f"Error extracting justification: {e}")

    # Construct JSON response with the desired structure
    response_json = {
        "question": user_input,
        "emotion": emotion,
        "justification": justification
    }
    
    return json.dumps(response_json, indent=4)

def main():
    user_input = input("You: ")
    response = generate_response(user_input)
    print(response + "\n")  # No "Chat:" substring

if __name__ == "__main__":
    main()

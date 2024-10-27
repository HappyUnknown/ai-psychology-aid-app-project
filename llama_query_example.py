# load the large language model file
from llama_cpp import Llama
from my_secret_manager import my_secret_manager

LLM = Llama(model_path=my_secret_manager.get_blob_path())

# create a text prompt
prompt = "Q: What are the names of the days of week? \n\n What is the emotion of this text (choose exactly one of words: happy, energetic, sad, depressed, neutral)?"

# generate a response (takes several seconds)
output = LLM(prompt)

# display the response
print(output["choices"][0]["text"])
import json

import whisper
import torch
import pandas as pd

def process_audio(model, audio_path):
    # model = whisper.load_model("medium")
    result = model.transcribe(audio_path)
    return result

def process_audio_files(model, questions_and_audio_paths):
    results = []
    for question, audio_path in questions_and_audio_paths:
        # audio = whisper.load_audio(audio_path)
        # audio = whisper.pad_or_trim(audio)
        #
        # mel = whisper.log_mel_spectrogram(audio, n_mels=model.dims.n_mels).to(model.device)
        # _, probs = model.detect_language(mel)
        # print(f'Detected language {max(probs, key=probs.get)}')

        # result = whisper.decode(model, mel, options=whisper.DecodingOptions())
        result = model.transcribe(audio_path, language="uk", fp16=False)
        print(result['text'])

        results.append({"question" :question, "answer" : result['text']})

    with open('question_transcripts.json', 'w+', encoding="utf-8") as json_file:
        json.dump(results, json_file, ensure_ascii=False, indent=4)

# def read_from_json(filename):
#     # returns a list of tuples (question, answer)
#

def to_csv(filename):
    df = pd.read_json('question_transcripts.json')
    print(df.keys())
    print(df.dropna())
    df.to_csv('question_transcripts.csv')
    # with open('question_transcripts.csv', 'w+', encoding="utf-8") as file:
    #     file.write()









if __name__ == "__main__":
    # model = whisper.load_model("medium", device="cuda")
    # print(torch.cuda.is_available())
    # # all the files that I have prepared so far 18:50
    # questions_and_audio_paths = [
    #     ("", "audio_tracks/whatsappvoice1.dat.unknown"),
    #     ("What is the meaning of life?", "audio_tracks/whatsappvoice2.dat.unknown"),
    #     ("What is the meaning of life?", "audio_tracks/whatsappvoice3.dat.unknown"),
    #     ("What is the meaning of life?", "audio_tracks/whatsappvoice4.dat.unknown"),
    #     ("What is the meaning of life?", "audio_tracks/whatsappvoice5.dat.unknown"),
    #     ("What is the meaning of life?", "audio_tracks/whatsappvoice6.dat.unknown"),
    #     ("What is the meaning of life?", "audio_tracks/whatsappvoice7.dat.unknown"),
    #     ("What is the meaning of life?", "audio_tracks/whatsappvoice8.dat.unknown"),
    #     ("What is the meaning of life?", "audio_tracks/whatsappvoice9.dat.unknown"),
    #     ("", "audio_tracks/whatsappvoice10.dat.unknown"),
    # ]
    # process_audio_files(model, questions_and_audio_paths)
    to_csv("question_transcripts.json")
    # to_csv(results)


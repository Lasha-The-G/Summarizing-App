import torch
from transformers import AutoModelForSpeechSeq2Seq, AutoProcessor, pipeline
import librosa
import numpy as np
from deepmultilingualpunctuation import PunctuationModel

def transcribe_audio(file_path):
    try:
        # Load model only when needed
        device = "cuda:0" if torch.cuda.is_available() else "cpu"
        torch_dtype = torch.float16 if torch.cuda.is_available() else torch.float32
        model_id = "openai/whisper-large-v3-turbo"

        model = AutoModelForSpeechSeq2Seq.from_pretrained(
            model_id, torch_dtype=torch_dtype, low_cpu_mem_usage=True
        ).to(device)

        processor = AutoProcessor.from_pretrained(model_id)
        pipe = pipeline(
            "automatic-speech-recognition",
            model=model,
            tokenizer=processor.tokenizer, 
            feature_extractor=processor.feature_extractor,
            chunk_length_s=20,
            batch_size=16,  
            torch_dtype=torch_dtype,
            device=0 if torch.cuda.is_available() else -1,
        )

        punctuation_model = PunctuationModel()

        # Load and process audio
        audio, sr = librosa.load(file_path, sr=16000)
        audio_chunks = (
            [audio[i : i + 20 * sr] for i in range(0, len(audio), 20 * sr)]
            if len(audio) > 20 * sr
            else [audio]
        )

        results = []
        for chunk in audio_chunks:
            result = pipe({"array": chunk, "sampling_rate": 16000})
            results.append(result["text"])

        full_transcription = " ".join(results)
        punctuated_text = punctuation_model.restore_punctuation(full_transcription)

        # Cleanup
        del model, pipe, punctuation_model
        torch.cuda.empty_cache()

        return punctuated_text

    except Exception as e:
        print(f"Error during transcription: {e}")


# import torch
# from transformers import AutoModelForSpeechSeq2Seq, AutoProcessor, pipeline
# import librosa

# def transcribe_audio(file_path):
#     try:
#         # Load model only when needed
#         device = "cuda:0" if torch.cuda.is_available() else "cpu"
#         torch_dtype = torch.float16 if torch.cuda.is_available() else torch.float32
#         model_id = "openai/whisper-large-v3-turbo"

#         model = AutoModelForSpeechSeq2Seq.from_pretrained(
#             model_id, torch_dtype=torch_dtype, low_cpu_mem_usage=True
#         ).to(device)

#         processor = AutoProcessor.from_pretrained(model_id)
#         pipe = pipeline(
#             "automatic-speech-recognition",
#             model=model,
#             tokenizer=processor.tokenizer, 
#             feature_extractor=processor.feature_extractor,
#             chunk_length_s=20,
#             batch_size=16,  
#             torch_dtype=torch_dtype,
#             device=0 if torch.cuda.is_available() else -1,
#         )

#         # Load and transcribe audio
#         audio, sr = librosa.load(file_path, sr=16000)
#         result = pipe({"array": audio, "sampling_rate": 16000})

#         # Cleanup
#         del model, pipe
#         torch.cuda.empty_cache()

#         return result["text"]

#     except Exception as e:
#         print(f"Error during transcription: {e}")





# import torch
# from transformers import AutoModelForSpeechSeq2Seq, AutoProcessor, pipeline
# import torchaudio
# import librosa
# import numpy as np

# device = "cuda:0" if torch.cuda.is_available() else "cpu"
# torch_dtype = torch.float16 if torch.cuda.is_available() else torch.float32
# # torch_dtype = torch.float32

# model_id = "openai/whisper-large-v3-turbo"
# model = AutoModelForSpeechSeq2Seq.from_pretrained(
#     model_id, torch_dtype=torch_dtype, low_cpu_mem_usage=True
# )
# model.to(device)

# processor = AutoProcessor.from_pretrained(model_id)

# pipe = pipeline(
#     "automatic-speech-recognition",
#     model=model,
#     tokenizer=processor.tokenizer, 
#     feature_extractor=processor.feature_extractor,
#     chunk_length_s=20,
#     batch_size=16,  
#     torch_dtype=torch_dtype,
#     device=0 if torch.cuda.is_available() else -1,
# )

# def load_audio(file_path, target_sr=16000):
#     audio, sr = librosa.load(file_path, sr=target_sr)
#     return audio

# def chunk_audio(audio, chunk_size=30, sr=16000):
#     chunk_length = chunk_size * sr
#     return [audio[i:i + chunk_length] for i in range(0, len(audio), chunk_length)]

# def transcribe_audio(file_path):
#     try:
#         audio = load_audio(file_path)
        
#         audio_chunks = chunk_audio(audio) if len(audio) > 30 * 16000 else [audio]

#         results = []
#         for chunk in audio_chunks:
#             result = pipe({"array": chunk, "sampling_rate": 16000})
#             results.append(result["text"])
        
#         full_transcription = " ".join(results)
#         # print(f"\nFinal Transcription:", full_transcription)

#         # del model   # I apologize for interviening
#         torch.cuda.empty_cache()

#         return full_transcription

#     except Exception as e:
#         print(f"Error during transcription: {e}")

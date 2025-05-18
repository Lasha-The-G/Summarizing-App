from transformers import pipeline
import torch

def summarize_long_text(ARTICLE):
    try:
        # Load model only when needed
        summarizer = pipeline("summarization", model="facebook/bart-large-cnn")

        # Chunk text
        chunked_texts = [ARTICLE] if len(ARTICLE.split()) < 1024 else [
            ARTICLE[i:i+1024] for i in range(0, len(ARTICLE.split()), 1024)
        ]

        # Summarize each chunk
        summaries = [
            summarizer(chunk, max_length=400, min_length=50, do_sample=True)[0]['summary_text']
            for chunk in chunked_texts
        ]

        # Cleanup
        del summarizer
        torch.cuda.empty_cache()

        return " ".join(summaries)

    except Exception as e:
        print(f"Error during summarization: {e}")






# from transformers import pipeline
# import torch # just to clear the v-ram

# summarizer = pipeline("summarization", model="facebook/bart-large-cnn")

# def chunk_text(text, max_length=1024):
#     words = text.split()
#     chunked_texts, chunk = [], []

#     for word in words:
#         chunk.append(word)
#         chunk_text = ' '.join(chunk)
#         if len(summarizer.tokenizer(chunk_text)["input_ids"]) > max_length:
#             chunked_texts.append(' '.join(chunk[:-1]))
#             chunk = [word]

#     if chunk:
#         chunked_texts.append(' '.join(chunk))

#     return chunked_texts

# def summarize_long_text(ARTICLE):
#     chunked_article = chunk_text(ARTICLE, max_length=1024)

#     summaries = []
#     for chunk in chunked_article:
#         summary = summarizer(
#             chunk, 
#             max_length=400, min_length=50, 
#             do_sample=True, 
#             temperature=0.9, 
#             top_k=50, 
#             top_p=0.8, 
#             num_beams=4  # Encourages paraphrasing
#         )
#         summaries.append(summary[0]['summary_text'])

#     # del summarizer
#     torch.cuda.empty_cache()

#     return ' '.join(summaries)



# from transformers import pipeline

# summarizer = pipeline("summarization", model="facebook/bart-large-cnn")

# def chunk_text(text, max_length=1024):
#     words = text.split()
#     chunked_texts, chunk = [], []

#     for word in words:
#         chunk.append(word)
#         chunk_text = ' '.join(chunk)
#         if len(summarizer.tokenizer(chunk_text)["input_ids"]) > max_length:
#             chunked_texts.append(' '.join(chunk[:-1]))
#             chunk = [word]

#     if chunk:
#         chunked_texts.append(' '.join(chunk))

#     return chunked_texts

# ARTICLE = """In the realm of technology, the emergence of artificial intelligence (AI) has brought forth profound transformations in various sectors, from healthcare to finance. This revolution, marked by advanced algorithms and machine learning techniques, enables systems to analyze large datasets, recognize patterns, and make informed decisions, often with speed and efficiency surpassing human capabilities. In healthcare, AI assists in diagnosing diseases through the analysis of medical images and patient data, leading to earlier interventions and personalized treatment plans. In finance, algorithms evaluate creditworthiness, detect fraudulent activities, and automate trading, significantly reducing human error and risk. However, the rapid adoption of AI also raises ethical and privacy concerns, as the potential for bias in algorithms and misuse of personal data necessitate careful oversight. Policymakers and industry leaders are increasingly recognizing the need for regulations to ensure responsible AI development and deployment. The balance between innovation and ethical considerations will be essential in shaping the future landscape of AI. As we move forward, public engagement and interdisciplinary collaboration will play crucial roles in navigating the complexities of this technology, fostering an environment where AI contributes positively to society while addressing its inherent challenges. The dialogue between stakeholders will be key in determining the trajectory of AI's impact."""

# chunked_article = chunk_text(ARTICLE, max_length=1024)

# summaries = []
# for chunk in chunked_article:
#     summary = summarizer(
#         chunk, 
#         max_length=400, min_length=50, 
#         do_sample=True, 
#         temperature=0.9, 
#         top_k=50, 
#         top_p=0.8, 
#         num_beams=4  # Encourages paraphrasing
#     )
#     summaries.append(summary[0]['summary_text'])

# final_summary = ' '.join(summaries)
# print(final_summary)
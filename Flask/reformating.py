import ollama

def reformat_summarization(toReformat, reformatLen):
    
    detail_level = round(reformatLen)  

    instruction = f"""You are an assistant that refactors text into structured bullet points with relevant section titles.
    - The level of detail should be proportional to {detail_level}/100, with 0 being the most concise and 100 being the most detailed.
    - If {detail_level} is high, try to make text as long as possible.
    - If {detail_level} is low, make each point as brief as possible while maintaining clarity.
    - Use section titles to organize the points logically.
    - Each section should have 3-5 bullet points.
    - Ensure readability and coherence.    
    """
    print(detail_level)

    response = ollama.chat(model='deepseek-r1:1.5b', messages=[
        {'role': 'system', 'content': instruction},
        {'role': 'user', 'content': toReformat}
    ])

    output = response['message']['content']

    start_index = output.find("</think>")
    answer = output[start_index+len("</think>"):].strip()

    return answer

    
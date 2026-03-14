from health_care.util import config

def extract_response(stream):
    out, usage = [], None
    for chunk in stream:
        if chunk.choices and chunk.choices[0].delta and chunk.choices[0].delta.content:
            out.append(chunk.choices[0].delta.content)
        if getattr(chunk, "usage", None):  # some deployments send usage on the tail chunk
            usage = chunk.usage
    
    return "".join(out), usage

def get_llm_response(llm_type:str, prompt:str):
  if llm_type == 'ollama':
    import ollama

    LLM_MODEL = "llama3.2"
    llm_response = ollama.chat(
      model = LLM_MODEL, 
      messages = [
          {"role": "system", "content": "You are a helpful medical assistant."},
          {"role": "user", "content": prompt}
    ])
    llm_response_str = llm_response.message.content
    print("Got LLM Response: ", llm_response_str)
    
  else:
    from openai import OpenAI

    client = OpenAI(base_url=config.OCA_URL, api_key=config.OCA_TOKEN)

    stream = client.chat.completions.create(
        model=config.OCA_MODEL,
        messages = [
          {"role": "system", "content": "You are a helpful medical assistant."},
          {"role": "user", "content": prompt}
        ],
        stream=True,
    )
    
    llm_response_str, usage = extract_response(stream)

  return str(llm_response_str)
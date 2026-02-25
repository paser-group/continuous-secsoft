from transformers import pipeline
import torch

pipe     = pipeline("text-generation", model="google/gemma-3-1b-it", device="cpu", dtype=torch.bfloat16)
pdfFile  = "https://github.com/paser-group/continuous-secsoft/blob/master/ssp-spr26/project/cis-r1.pdf" 

messages = [
    [
        {
            "role": "system",
            "content": [{"type": "text", "text": "You are a helpful document analyzer."},]
        },
        {
            "role": "user",
            "content": [{"type": "text", "text": "Please summarize the PDF file here:" + pdfFile},]
        },
    ],
]

output = pipe(messages, max_new_tokens=50)
print("="*25)
print(output[0][0]['generated_text'][-1]['content'])
print("="*25)
print("Full output")
print(output)
print("="*25)
# model="google/gemma-3-1b-it",  
# device="cpu",  
# torch_dtype=torch.bfloat16  
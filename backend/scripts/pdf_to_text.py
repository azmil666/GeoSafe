import sys
import pdfminer.high_level

pdf_path = sys.argv[1]
output_path = pdf_path.replace(".pdf", ".txt")

text = pdfminer.high_level.extract_text(pdf_path)

with open(output_path, "w", encoding="utf-8") as f:
    f.write(text)

print(f"Converted → {output_path}")
